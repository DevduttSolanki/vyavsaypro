import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vyavsaypro/models/product_model.dart';

void main() {
  group('ProductModel Tests', () {
    late ProductModel product;
    late Map<String, dynamic> productMap;

    setUp(() {
      productMap = {
        'product_id': 'test_product_id',
        'business_id': 'test_business_id',
        'category_id': 'test_category_id',
        'name': 'Test Product',
        'price': 100.0,
        'quantity': 50,
        'gst_rate': 12.0,
        'barcode': 'TEST123',
        'batch_number': 'BATCH001',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
        'location': 'Warehouse A',
        'unit_of_measurement': 'pieces',
        'low_stock_threshold': 10,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      };

      product = ProductModel.fromMap(productMap);
    });

    test('should create ProductModel from map correctly', () {
      expect(product.productId, equals('test_product_id'));
      expect(product.businessId, equals('test_business_id'));
      expect(product.categoryId, equals('test_category_id'));
      expect(product.name, equals('Test Product'));
      expect(product.price, equals(100.0));
      expect(product.quantity, equals(50));
      expect(product.gstRate, equals(12.0));
      expect(product.barcode, equals('TEST123'));
      expect(product.batchNumber, equals('BATCH001'));
      expect(product.location, equals('Warehouse A'));
      expect(product.unitOfMeasurement, equals('pieces'));
      expect(product.lowStockThreshold, equals(10));
    });

    test('should convert ProductModel to map correctly', () {
      final map = product.toMap();
      
      expect(map['product_id'], equals('test_product_id'));
      expect(map['business_id'], equals('test_business_id'));
      expect(map['category_id'], equals('test_category_id'));
      expect(map['name'], equals('Test Product'));
      expect(map['price'], equals(100.0));
      expect(map['quantity'], equals(50));
      expect(map['gst_rate'], equals(12.0));
      expect(map['barcode'], equals('TEST123'));
      expect(map['batch_number'], equals('BATCH001'));
      expect(map['location'], equals('Warehouse A'));
      expect(map['unit_of_measurement'], equals('pieces'));
      expect(map['low_stock_threshold'], equals(10));
    });

    test('should create copy with updated fields', () {
      final updatedProduct = product.copyWith(
        name: 'Updated Product',
        price: 150.0,
        quantity: 75,
      );

      expect(updatedProduct.name, equals('Updated Product'));
      expect(updatedProduct.price, equals(150.0));
      expect(updatedProduct.quantity, equals(75));
      
      // Other fields should remain unchanged
      expect(updatedProduct.productId, equals(product.productId));
      expect(updatedProduct.businessId, equals(product.businessId));
      expect(updatedProduct.categoryId, equals(product.categoryId));
    });

    test('should correctly identify low stock', () {
      // Product with quantity 50 and threshold 10 should not be low stock
      expect(product.isLowStock, isFalse);

      // Create a product with low stock
      final lowStockProduct = product.copyWith(quantity: 5);
      expect(lowStockProduct.isLowStock, isTrue);
    });

    test('should format price correctly', () {
      expect(product.formattedPrice, equals('₹100.00'));
    });

    test('should format quantity with unit correctly', () {
      expect(product.formattedQuantity, equals('50 pieces'));
    });

    test('should format quantity without unit correctly', () {
      final productWithoutUnit = product.copyWith(unitOfMeasurement: null);
      expect(productWithoutUnit.formattedQuantity, equals('50'));
    });

    test('should handle null optional fields', () {
      final productMapWithNulls = {
        'product_id': 'test_product_id',
        'business_id': 'test_business_id',
        'category_id': 'test_category_id',
        'name': 'Test Product',
        'price': 100.0,
        'quantity': 50,
        'gst_rate': 12.0,
        'barcode': null,
        'batch_number': null,
        'expiry_date': null,
        'location': null,
        'unit_of_measurement': null,
        'low_stock_threshold': 10,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      };

      final productWithNulls = ProductModel.fromMap(productMapWithNulls);
      
      expect(productWithNulls.barcode, isNull);
      expect(productWithNulls.batchNumber, isNull);
      expect(productWithNulls.expiryDate, isNull);
      expect(productWithNulls.location, isNull);
      expect(productWithNulls.unitOfMeasurement, isNull);
    });
  });
}
