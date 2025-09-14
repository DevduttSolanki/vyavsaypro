import 'package:firebase_auth/firebase_auth.dart';
import 'inventory_service.dart';

/// Integration service that provides hooks for other modules (Billing/Orders) 
/// to interact with the inventory system
class InventoryIntegrationService {
  final InventoryService _inventoryService = InventoryService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Decrease stock when a sale is finalized
  /// This should be called by the billing/orders module when an invoice is created
  Future<bool> decreaseStockForSale({
    required String businessId,
    required String productId,
    required int qty,
    required String invoiceId,
    String? location,
    bool allowNegativeStock = false,
  }) async {
    try {
      final userId = _auth.currentUser?.uid ?? 'system';
      
      return await _inventoryService.decreaseStockForSale(
        businessId: businessId,
        productId: productId,
        qty: qty,
        invoiceId: invoiceId,
        userId: userId,
        location: location,
        allowNegativeStock: allowNegativeStock,
      );
    } catch (e) {
      print('Error decreasing stock for sale: $e');
      return false;
    }
  }

  /// Increase stock when a purchase is received
  /// This should be called by the billing/orders module when a purchase order is received
  Future<bool> increaseStockForPurchase({
    required String businessId,
    required String productId,
    required int qty,
    required String purchaseOrderId,
    String? location,
    String? batchNumber,
    DateTime? expiryDate,
  }) async {
    try {
      final userId = _auth.currentUser?.uid ?? 'system';
      
      return await _inventoryService.increaseStockForPurchase(
        businessId: businessId,
        productId: productId,
        qty: qty,
        purchaseOrderId: purchaseOrderId,
        userId: userId,
        location: location,
        batchNumber: batchNumber,
        expiryDate: expiryDate,
      );
    } catch (e) {
      print('Error increasing stock for purchase: $e');
      return false;
    }
  }

  /// Check if sufficient stock is available for a sale
  /// This should be called before finalizing a sale to prevent overselling
  Future<bool> checkStockAvailability({
    required String businessId,
    required String productId,
    required int qty,
  }) async {
    try {
      final product = await _inventoryService.getProduct(productId);
      if (product == null) return false;
      
      return product.quantity >= qty;
    } catch (e) {
      print('Error checking stock availability: $e');
      return false;
    }
  }

  /// Get current stock quantity for a product
  /// This can be used by other modules to display stock information
  Future<int?> getCurrentStock({
    required String businessId,
    required String productId,
  }) async {
    try {
      final product = await _inventoryService.getProduct(productId);
      return product?.quantity;
    } catch (e) {
      print('Error getting current stock: $e');
      return null;
    }
  }

  /// Get product information for display in other modules
  /// This can be used by billing/orders to show product details
  Future<Map<String, dynamic>?> getProductInfo({
    required String businessId,
    required String productId,
  }) async {
    try {
      final product = await _inventoryService.getProduct(productId);
      if (product == null) return null;
      
      return {
        'productId': product.productId,
        'name': product.name,
        'price': product.price,
        'quantity': product.quantity,
        'gstRate': product.gstRate,
        'barcode': product.barcode,
        'unitOfMeasurement': product.unitOfMeasurement,
        'isLowStock': product.isLowStock,
        'lowStockThreshold': product.lowStockThreshold,
      };
    } catch (e) {
      print('Error getting product info: $e');
      return null;
    }
  }

  /// Batch decrease stock for multiple products in a single sale
  /// This is useful when processing an invoice with multiple line items
  Future<Map<String, bool>> batchDecreaseStockForSale({
    required String businessId,
    required String invoiceId,
    required List<Map<String, dynamic>> lineItems, // [{productId, qty, location?}]
    bool allowNegativeStock = false,
  }) async {
    final results = <String, bool>{};
    
    for (final item in lineItems) {
      final productId = item['productId'] as String;
      final qty = item['qty'] as int;
      final location = item['location'] as String?;
      
      try {
        final success = await decreaseStockForSale(
          businessId: businessId,
          productId: productId,
          qty: qty,
          invoiceId: invoiceId,
          location: location,
          allowNegativeStock: allowNegativeStock,
        );
        results[productId] = success;
      } catch (e) {
        print('Error decreasing stock for product $productId: $e');
        results[productId] = false;
      }
    }
    
    return results;
  }

  /// Batch increase stock for multiple products in a single purchase
  /// This is useful when processing a purchase order with multiple line items
  Future<Map<String, bool>> batchIncreaseStockForPurchase({
    required String businessId,
    required String purchaseOrderId,
    required List<Map<String, dynamic>> lineItems, // [{productId, qty, location?, batchNumber?, expiryDate?}]
  }) async {
    final results = <String, bool>{};
    
    for (final item in lineItems) {
      final productId = item['productId'] as String;
      final qty = item['qty'] as int;
      final location = item['location'] as String?;
      final batchNumber = item['batchNumber'] as String?;
      final expiryDate = item['expiryDate'] as DateTime?;
      
      try {
        final success = await increaseStockForPurchase(
          businessId: businessId,
          productId: productId,
          qty: qty,
          purchaseOrderId: purchaseOrderId,
          location: location,
          batchNumber: batchNumber,
          expiryDate: expiryDate,
        );
        results[productId] = success;
      } catch (e) {
        print('Error increasing stock for product $productId: $e');
        results[productId] = false;
      }
    }
    
    return results;
  }

  /// Validate stock availability for multiple products before processing a sale
  /// This should be called before finalizing a sale to ensure all items are available
  Future<Map<String, bool>> validateStockAvailability({
    required String businessId,
    required List<Map<String, dynamic>> lineItems, // [{productId, qty}]
  }) async {
    final results = <String, bool>{};
    
    for (final item in lineItems) {
      final productId = item['productId'] as String;
      final qty = item['qty'] as int;
      
      try {
        final available = await checkStockAvailability(
          businessId: businessId,
          productId: productId,
          qty: qty,
        );
        results[productId] = available;
      } catch (e) {
        print('Error validating stock for product $productId: $e');
        results[productId] = false;
      }
    }
    
    return results;
  }
}
