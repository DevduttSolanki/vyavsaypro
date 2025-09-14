import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'package:vyavsaypro/services/inventory_service.dart';
import 'package:vyavsaypro/models/product_model.dart';
import 'package:vyavsaypro/models/category_model.dart';
import 'package:vyavsaypro/models/stock_movement_model.dart';
import 'package:vyavsaypro/models/dto/product_dto.dart';

import 'inventory_service_test.mocks.dart';

@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference, DocumentSnapshot, QuerySnapshot, QueryDocumentSnapshot, FirebaseAuth, User])
void main() {
  group('InventoryService Tests', () {
    late InventoryService inventoryService;
    late MockFirebaseFirestore mockFirestore;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      
      when(mockUser.uid).thenReturn('test_user_id');
      when(mockAuth.currentUser).thenReturn(mockUser);
      
      inventoryService = InventoryService();
    });

    group('Category Management', () {
      test('should create a category successfully', () async {
        // Arrange
        final categoryName = 'Test Category';
        final categoryDescription = 'Test Description';
        
        // Act
        final result = await inventoryService.createCategory(
          name: categoryName,
          description: categoryDescription,
        );
        
        // Assert
        expect(result, isNotNull);
        expect(result, isA<String>());
      });

      test('should get categories successfully', () async {
        // Act
        final result = await inventoryService.getCategories();
        
        // Assert
        expect(result, isA<List<CategoryModel>>());
      });
    });

    group('Product Management', () {
      test('should add a product successfully', () async {
        // Arrange
        final productDto = ProductDto(
          businessId: 'test_business_id',
          categoryId: 'test_category_id',
          name: 'Test Product',
          price: 100.0,
          quantity: 50,
          gstRate: 12.0,
          lowStockThreshold: 10,
        );

        // Act
        final result = await inventoryService.addProduct(productDto);
        
        // Assert
        expect(result, isNotNull);
        expect(result, isA<String>());
      });

      test('should quick add a product successfully', () async {
        // Arrange
        final quickAddDto = QuickAddProductDto(
          businessId: 'test_business_id',
          name: 'Quick Test Product',
          price: 50.0,
          quantity: 25,
        );

        // Act
        final result = await inventoryService.quickAddProduct(quickAddDto);
        
        // Assert
        expect(result, isNotNull);
        expect(result, isA<String>());
      });

      test('should get products for business', () async {
        // Arrange
        const businessId = 'test_business_id';

        // Act
        final result = await inventoryService.getProducts(businessId: businessId);
        
        // Assert
        expect(result, isA<List<ProductModel>>());
      });

      test('should get low stock products', () async {
        // Arrange
        const businessId = 'test_business_id';

        // Act
        final result = await inventoryService.getLowStockProducts(businessId);
        
        // Assert
        expect(result, isA<List<ProductModel>>());
      });

      test('should get low stock count', () async {
        // Arrange
        const businessId = 'test_business_id';

        // Act
        final result = await inventoryService.getLowStockCount(businessId);
        
        // Assert
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(0));
      });
    });

    group('Stock Management', () {
      test('should increase stock successfully', () async {
        // Arrange
        const businessId = 'test_business_id';
        const productId = 'test_product_id';
        const qty = 10;
        const reason = 'Stock adjustment';
        const userId = 'test_user_id';

        // Act
        final result = await inventoryService.increaseStock(
          businessId: businessId,
          productId: productId,
          qty: qty,
          reason: reason,
          userId: userId,
        );
        
        // Assert
        expect(result, isA<bool>());
      });

      test('should decrease stock successfully', () async {
        // Arrange
        const businessId = 'test_business_id';
        const productId = 'test_product_id';
        const qty = 5;
        const reason = 'Stock adjustment';
        const userId = 'test_user_id';

        // Act
        final result = await inventoryService.decreaseStock(
          businessId: businessId,
          productId: productId,
          qty: qty,
          reason: reason,
          userId: userId,
        );
        
        // Assert
        expect(result, isA<bool>());
      });

      test('should prevent negative stock when decreasing', () async {
        // Arrange
        const businessId = 'test_business_id';
        const productId = 'test_product_id';
        const qty = 1000; // More than available stock
        const reason = 'Stock adjustment';
        const userId = 'test_user_id';

        // Act & Assert
        expect(
          () => inventoryService.decreaseStock(
            businessId: businessId,
            productId: productId,
            qty: qty,
            reason: reason,
            userId: userId,
            allowNegativeStock: false,
          ),
          throwsException,
        );
      });

      test('should reconcile product quantity', () async {
        // Arrange
        const productId = 'test_product_id';

        // Act
        final result = await inventoryService.reconcileProductQuantity(productId);
        
        // Assert
        expect(result, isA<bool>());
      });
    });

    group('Integration Hooks', () {
      test('should decrease stock for sale', () async {
        // Arrange
        const businessId = 'test_business_id';
        const productId = 'test_product_id';
        const qty = 3;
        const invoiceId = 'INV001';
        const userId = 'test_user_id';

        // Act
        final result = await inventoryService.decreaseStockForSale(
          businessId: businessId,
          productId: productId,
          qty: qty,
          invoiceId: invoiceId,
          userId: userId,
        );
        
        // Assert
        expect(result, isA<bool>());
      });

      test('should increase stock for purchase', () async {
        // Arrange
        const businessId = 'test_business_id';
        const productId = 'test_product_id';
        const qty = 20;
        const purchaseOrderId = 'PO001';
        const userId = 'test_user_id';

        // Act
        final result = await inventoryService.increaseStockForPurchase(
          businessId: businessId,
          productId: productId,
          qty: qty,
          purchaseOrderId: purchaseOrderId,
          userId: userId,
        );
        
        // Assert
        expect(result, isA<bool>());
      });
    });
  });
}
