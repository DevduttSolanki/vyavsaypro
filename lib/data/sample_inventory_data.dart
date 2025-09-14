import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/stock_movement_model.dart';

/// Sample data for inventory system demo
class SampleInventoryData {
  static List<Map<String, dynamic>> getSampleCategories() {
    return [
      {
        'category_id': 'clothing-1',
        'name': 'Clothing',
        'description': 'Apparel and clothing items',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      {
        'category_id': 'pharma-1',
        'name': 'Pharma',
        'description': 'Pharmaceutical products',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      {
        'category_id': 'electronics-1',
        'name': 'Electronics',
        'description': 'Electronic devices and accessories',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      {
        'category_id': 'food-1',
        'name': 'Food & Beverages',
        'description': 'Food and beverage items',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
    ];
  }

  static List<Map<String, dynamic>> getSampleProducts(String businessId) {
    return [
      // Clothing products
      {
        'product_id': 'product-1',
        'business_id': businessId,
        'category_id': 'clothing-1',
        'name': 'Blue T-Shirt',
        'price': 299.0,
        'quantity': 50,
        'gst_rate': 12.0,
        'barcode': 'TSHIRT001',
        'batch_number': null,
        'expiry_date': null,
        'location': 'Warehouse A',
        'unit_of_measurement': 'pieces',
        'low_stock_threshold': 10,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      {
        'product_id': 'product-2',
        'business_id': businessId,
        'category_id': 'clothing-1',
        'name': 'Denim Jeans',
        'price': 1299.0,
        'quantity': 25,
        'gst_rate': 12.0,
        'barcode': 'JEANS001',
        'batch_number': null,
        'expiry_date': null,
        'location': 'Warehouse A',
        'unit_of_measurement': 'pieces',
        'low_stock_threshold': 5,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      
      // Pharma products
      {
        'product_id': 'product-3',
        'business_id': businessId,
        'category_id': 'pharma-1',
        'name': 'Paracetamol 500mg',
        'price': 40.0,
        'quantity': 200,
        'gst_rate': 12.0,
        'barcode': 'PARA500',
        'batch_number': 'BATCH001',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
        'location': 'Pharmacy Shelf',
        'unit_of_measurement': 'tablets',
        'low_stock_threshold': 50,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      {
        'product_id': 'product-4',
        'business_id': businessId,
        'category_id': 'pharma-1',
        'name': 'Vitamin D3',
        'price': 150.0,
        'quantity': 8, // Low stock
        'gst_rate': 12.0,
        'barcode': 'VITD3001',
        'batch_number': 'BATCH002',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 730))),
        'location': 'Pharmacy Shelf',
        'unit_of_measurement': 'tablets',
        'low_stock_threshold': 20,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      
      // Electronics products
      {
        'product_id': 'product-5',
        'business_id': businessId,
        'category_id': 'electronics-1',
        'name': 'Wireless Headphones',
        'price': 2999.0,
        'quantity': 15,
        'gst_rate': 18.0,
        'barcode': 'HEADPHONE001',
        'batch_number': null,
        'expiry_date': null,
        'location': 'Electronics Section',
        'unit_of_measurement': 'pieces',
        'low_stock_threshold': 5,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      {
        'product_id': 'product-6',
        'business_id': businessId,
        'category_id': 'electronics-1',
        'name': 'USB Cable',
        'price': 199.0,
        'quantity': 100,
        'gst_rate': 18.0,
        'barcode': 'USBCABLE001',
        'batch_number': null,
        'expiry_date': null,
        'location': 'Electronics Section',
        'unit_of_measurement': 'pieces',
        'low_stock_threshold': 20,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      
      // Food products
      {
        'product_id': 'product-7',
        'business_id': businessId,
        'category_id': 'food-1',
        'name': 'Rice 1kg',
        'price': 80.0,
        'quantity': 75,
        'gst_rate': 5.0,
        'barcode': 'RICE1KG001',
        'batch_number': 'FOOD001',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 180))),
        'location': 'Food Storage',
        'unit_of_measurement': 'kg',
        'low_stock_threshold': 15,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
      {
        'product_id': 'product-8',
        'business_id': businessId,
        'category_id': 'food-1',
        'name': 'Cooking Oil 1L',
        'price': 120.0,
        'quantity': 3, // Low stock
        'gst_rate': 5.0,
        'barcode': 'OIL1L001',
        'batch_number': 'FOOD002',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
        'location': 'Food Storage',
        'unit_of_measurement': 'liters',
        'low_stock_threshold': 10,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      },
    ];
  }

  static List<Map<String, dynamic>> getSampleStockMovements(String businessId) {
    return [
      // Initial stock movements
      {
        'movement_id': 'movement-1',
        'business_id': businessId,
        'product_id': 'product-1',
        'type': 'init',
        'qty': 50,
        'reason': 'Initial stock',
        'reference_id': null,
        'user_id': 'system',
        'location': 'Warehouse A',
        'batch_number': null,
        'expiry_date': null,
        'created_at': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 30))),
      },
      {
        'movement_id': 'movement-2',
        'business_id': businessId,
        'product_id': 'product-3',
        'type': 'init',
        'qty': 200,
        'reason': 'Initial stock',
        'reference_id': null,
        'user_id': 'system',
        'location': 'Pharmacy Shelf',
        'batch_number': 'BATCH001',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
        'created_at': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 30))),
      },
      
      // Purchase movements
      {
        'movement_id': 'movement-3',
        'business_id': businessId,
        'product_id': 'product-1',
        'type': 'purchase',
        'qty': 20,
        'reason': 'Purchase order #PO001',
        'reference_id': 'PO001',
        'user_id': 'user1',
        'location': 'Warehouse A',
        'batch_number': null,
        'expiry_date': null,
        'created_at': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 15))),
      },
      {
        'movement_id': 'movement-4',
        'business_id': businessId,
        'product_id': 'product-5',
        'type': 'purchase',
        'qty': 15,
        'reason': 'Purchase order #PO002',
        'reference_id': 'PO002',
        'user_id': 'user1',
        'location': 'Electronics Section',
        'batch_number': null,
        'expiry_date': null,
        'created_at': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 10))),
      },
      
      // Sale movements
      {
        'movement_id': 'movement-5',
        'business_id': businessId,
        'product_id': 'product-1',
        'type': 'sale',
        'qty': -10,
        'reason': 'Sale invoice #INV001',
        'reference_id': 'INV001',
        'user_id': 'user2',
        'location': 'Warehouse A',
        'batch_number': null,
        'expiry_date': null,
        'created_at': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7))),
      },
      {
        'movement_id': 'movement-6',
        'business_id': businessId,
        'product_id': 'product-3',
        'type': 'sale',
        'qty': -25,
        'reason': 'Sale invoice #INV002',
        'reference_id': 'INV002',
        'user_id': 'user2',
        'location': 'Pharmacy Shelf',
        'batch_number': 'BATCH001',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
        'created_at': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
      },
      
      // Adjustment movements
      {
        'movement_id': 'movement-7',
        'business_id': businessId,
        'product_id': 'product-4',
        'type': 'adjustment',
        'qty': -2,
        'reason': 'Damaged goods',
        'reference_id': null,
        'user_id': 'user1',
        'location': 'Pharmacy Shelf',
        'batch_number': 'BATCH002',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 730))),
        'created_at': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3))),
      },
      {
        'movement_id': 'movement-8',
        'business_id': businessId,
        'product_id': 'product-8',
        'type': 'adjustment',
        'qty': -7,
        'reason': 'Expired products',
        'reference_id': null,
        'user_id': 'user1',
        'location': 'Food Storage',
        'batch_number': 'FOOD002',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
        'created_at': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      },
    ];
  }

  /// Get sample data summary for documentation
  static Map<String, dynamic> getSampleDataSummary() {
    return {
      'categories': {
        'count': 4,
        'names': ['Clothing', 'Pharma', 'Electronics', 'Food & Beverages'],
      },
      'products': {
        'count': 8,
        'low_stock_count': 2, // Vitamin D3 and Cooking Oil
        'total_value': 299.0 + 1299.0 + 40.0 + 150.0 + 2999.0 + 199.0 + 80.0 + 120.0,
      },
      'stock_movements': {
        'count': 8,
        'types': ['init', 'purchase', 'sale', 'adjustment'],
      },
      'business_scenarios': [
        'Initial stock setup',
        'Purchase order processing',
        'Sales transactions',
        'Stock adjustments',
        'Low stock alerts',
        'Product search and filtering',
      ],
    };
  }
}
