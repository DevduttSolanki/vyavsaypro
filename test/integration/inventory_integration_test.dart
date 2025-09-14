import 'package:flutter_test/flutter_test.dart';
import 'package:vyavsaypro/services/inventory_service.dart';
import 'package:vyavsaypro/services/inventory_integration_service.dart';
import 'package:vyavsaypro/models/dto/product_dto.dart';

void main() {
  group('Inventory Integration Tests', () {
    late InventoryService inventoryService;
    late InventoryIntegrationService integrationService;

    setUp(() {
      inventoryService = InventoryService();
      integrationService = InventoryIntegrationService();
    });

    group('End-to-End Stock Management', () {
      test('should complete full stock management workflow', () async {
        const businessId = 'test_business_id';
        const categoryId = 'test_category_id';
        
        // 1. Add a product
        final productDto = ProductDto(
          businessId: businessId,
          categoryId: categoryId,
          name: 'Integration Test Product',
          price: 100.0,
          quantity: 100, // Initial stock
          gstRate: 12.0,
          lowStockThreshold: 10,
        );

        final productId = await inventoryService.addProduct(productDto);
        expect(productId, isNotNull);

        // 2. Verify initial stock
        final product = await inventoryService.getProduct(productId!);
        expect(product, isNotNull);
        expect(product!.quantity, equals(100));

        // 3. Decrease stock for a sale
        final saleSuccess = await integrationService.decreaseStockForSale(
          businessId: businessId,
          productId: productId,
          qty: 20,
          invoiceId: 'INV001',
        );
        expect(saleSuccess, isTrue);

        // 4. Verify stock after sale
        final productAfterSale = await inventoryService.getProduct(productId);
        expect(productAfterSale!.quantity, equals(80));

        // 5. Increase stock for a purchase
        final purchaseSuccess = await integrationService.increaseStockForPurchase(
          businessId: businessId,
          productId: productId,
          qty: 30,
          purchaseOrderId: 'PO001',
        );
        expect(purchaseSuccess, isTrue);

        // 6. Verify final stock
        final finalProduct = await inventoryService.getProduct(productId);
        expect(finalProduct!.quantity, equals(110));

        // 7. Check stock movements were created
        final movements = await inventoryService.getStockMovements(productId: productId);
        expect(movements.length, greaterThanOrEqualTo(3)); // init, sale, purchase
      });

      test('should handle batch stock operations', () async {
        const businessId = 'test_business_id';
        const categoryId = 'test_category_id';
        
        // Create multiple products
        final productIds = <String>[];
        for (int i = 0; i < 3; i++) {
          final productDto = ProductDto(
            businessId: businessId,
            categoryId: categoryId,
            name: 'Batch Test Product $i',
            price: 50.0 + (i * 10),
            quantity: 50,
            gstRate: 12.0,
            lowStockThreshold: 10,
          );

          final productId = await inventoryService.addProduct(productDto);
          expect(productId, isNotNull);
          productIds.add(productId!);
        }

        // Batch decrease stock for sale
        final lineItems = productIds.map((id) => {
          'productId': id,
          'qty': 10,
        }).toList();

        final batchSaleResults = await integrationService.batchDecreaseStockForSale(
          businessId: businessId,
          invoiceId: 'BATCH_INV001',
          lineItems: lineItems,
        );

        // All should succeed
        for (final productId in productIds) {
          expect(batchSaleResults[productId], isTrue);
        }

        // Verify stock was decreased for all products
        for (final productId in productIds) {
          final product = await inventoryService.getProduct(productId);
          expect(product!.quantity, equals(40)); // 50 - 10
        }
      });

      test('should validate stock availability before sale', () async {
        const businessId = 'test_business_id';
        const categoryId = 'test_category_id';
        
        // Create a product with limited stock
        final productDto = ProductDto(
          businessId: businessId,
          categoryId: categoryId,
          name: 'Limited Stock Product',
          price: 100.0,
          quantity: 5, // Low stock
          gstRate: 12.0,
          lowStockThreshold: 10,
        );

        final productId = await inventoryService.addProduct(productDto);
        expect(productId, isNotNull);

        // Check availability for valid quantity
        final availableForValidQty = await integrationService.checkStockAvailability(
          businessId: businessId,
          productId: productId!,
          qty: 3,
        );
        expect(availableForValidQty, isTrue);

        // Check availability for invalid quantity
        final availableForInvalidQty = await integrationService.checkStockAvailability(
          businessId: businessId,
          productId: productId,
          qty: 10,
        );
        expect(availableForInvalidQty, isFalse);

        // Validate multiple products
        final lineItems = [
          {'productId': productId, 'qty': 3}, // Valid
          {'productId': productId, 'qty': 10}, // Invalid
        ];

        final validationResults = await integrationService.validateStockAvailability(
          businessId: businessId,
          lineItems: lineItems,
        );

        expect(validationResults[productId], isFalse); // Should fail due to second item
      });

      test('should prevent negative stock when not allowed', () async {
        const businessId = 'test_business_id';
        const categoryId = 'test_category_id';
        
        // Create a product with limited stock
        final productDto = ProductDto(
          businessId: businessId,
          categoryId: categoryId,
          name: 'Limited Stock Product',
          price: 100.0,
          quantity: 5,
          gstRate: 12.0,
          lowStockThreshold: 10,
        );

        final productId = await inventoryService.addProduct(productDto);
        expect(productId, isNotNull);

        // Try to sell more than available (should fail)
        final saleResult = await integrationService.decreaseStockForSale(
          businessId: businessId,
          productId: productId!,
          qty: 10, // More than available
          invoiceId: 'INV002',
          allowNegativeStock: false,
        );
        expect(saleResult, isFalse);

        // Stock should remain unchanged
        final product = await inventoryService.getProduct(productId);
        expect(product!.quantity, equals(5));
      });

      test('should allow negative stock when explicitly allowed', () async {
        const businessId = 'test_business_id';
        const categoryId = 'test_category_id';
        
        // Create a product with limited stock
        final productDto = ProductDto(
          businessId: businessId,
          categoryId: categoryId,
          name: 'Limited Stock Product',
          price: 100.0,
          quantity: 5,
          gstRate: 12.0,
          lowStockThreshold: 10,
        );

        final productId = await inventoryService.addProduct(productDto);
        expect(productId, isNotNull);

        // Try to sell more than available (should succeed with allowNegativeStock: true)
        final saleResult = await integrationService.decreaseStockForSale(
          businessId: businessId,
          productId: productId!,
          qty: 10, // More than available
          invoiceId: 'INV003',
          allowNegativeStock: true,
        );
        expect(saleResult, isTrue);

        // Stock should be negative
        final product = await inventoryService.getProduct(productId);
        expect(product!.quantity, equals(-5));
      });

      test('should reconcile stock from movements', () async {
        const businessId = 'test_business_id';
        const categoryId = 'test_category_id';
        
        // Create a product
        final productDto = ProductDto(
          businessId: businessId,
          categoryId: categoryId,
          name: 'Reconciliation Test Product',
          price: 100.0,
          quantity: 50,
          gstRate: 12.0,
          lowStockThreshold: 10,
        );

        final productId = await inventoryService.addProduct(productDto);
        expect(productId, isNotNull);

        // Perform some stock movements
        await inventoryService.increaseStock(
          businessId: businessId,
          productId: productId!,
          qty: 20,
          reason: 'Purchase',
          userId: 'test_user',
        );

        await inventoryService.decreaseStock(
          businessId: businessId,
          productId: productId,
          qty: 10,
          reason: 'Sale',
          userId: 'test_user',
        );

        // Manually corrupt the product quantity (simulate data inconsistency)
        await inventoryService.updateProduct(productId, {'quantity': 999});

        // Reconcile from movements
        final reconcileResult = await inventoryService.reconcileProductQuantity(productId);
        expect(reconcileResult, isTrue);

        // Verify quantity is corrected
        final product = await inventoryService.getProduct(productId);
        expect(product!.quantity, equals(60)); // 50 + 20 - 10
      });
    });
  });
}
