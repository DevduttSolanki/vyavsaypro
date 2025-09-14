import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/stock_movement_model.dart';
import 'inventory_service.dart';

/// Service to seed sample data for demo purposes
class InventorySeederService {
  final InventoryService _inventoryService = InventoryService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  /// Seed sample categories
  Future<void> seedCategories() async {
    try {
      final categories = [
        {'name': 'Clothing', 'description': 'Apparel and clothing items'},
        {'name': 'Pharma', 'description': 'Pharmaceutical products'},
        {'name': 'Electronics', 'description': 'Electronic devices and accessories'},
        {'name': 'Food & Beverages', 'description': 'Food and beverage items'},
        {'name': 'Home & Garden', 'description': 'Home improvement and garden supplies'},
      ];

      for (final categoryData in categories) {
        await _inventoryService.createCategory(
          name: categoryData['name']!,
          description: categoryData['description'],
        );
      }
      
      print('Categories seeded successfully');
    } catch (e) {
      print('Error seeding categories: $e');
    }
  }

  /// Seed sample products
  Future<void> seedProducts(String businessId) async {
    try {
      // Get categories first
      final categories = await _inventoryService.getCategories();
      if (categories.isEmpty) {
        await seedCategories();
        // Re-fetch categories
        final updatedCategories = await _inventoryService.getCategories();
        await _seedProductsWithCategories(businessId, updatedCategories);
      } else {
        await _seedProductsWithCategories(businessId, categories);
      }
      
      print('Products seeded successfully');
    } catch (e) {
      print('Error seeding products: $e');
    }
  }

  Future<void> _seedProductsWithCategories(String businessId, List<CategoryModel> categories) async {
    final clothingCategory = categories.firstWhere((c) => c.name == 'Clothing');
    final pharmaCategory = categories.firstWhere((c) => c.name == 'Pharma');
    final electronicsCategory = categories.firstWhere((c) => c.name == 'Electronics');

    final products = [
      // Clothing products
      {
        'name': 'Blue T-Shirt',
        'categoryId': clothingCategory.categoryId,
        'price': 299.0,
        'quantity': 50,
        'gstRate': 12.0,
        'barcode': 'TSHIRT001',
        'unitOfMeasurement': 'pieces',
        'lowStockThreshold': 10,
        'location': 'Warehouse A',
      },
      {
        'name': 'Denim Jeans',
        'categoryId': clothingCategory.categoryId,
        'price': 1299.0,
        'quantity': 25,
        'gstRate': 12.0,
        'barcode': 'JEANS001',
        'unitOfMeasurement': 'pieces',
        'lowStockThreshold': 5,
        'location': 'Warehouse A',
      },
      
      // Pharma products
      {
        'name': 'Paracetamol 500mg',
        'categoryId': pharmaCategory.categoryId,
        'price': 40.0,
        'quantity': 200,
        'gstRate': 12.0,
        'barcode': 'PARA500',
        'batchNumber': 'BATCH001',
        'expiryDate': DateTime.now().add(const Duration(days: 365)),
        'unitOfMeasurement': 'tablets',
        'lowStockThreshold': 50,
        'location': 'Pharmacy Shelf',
      },
      {
        'name': 'Vitamin D3',
        'categoryId': pharmaCategory.categoryId,
        'price': 150.0,
        'quantity': 8, // Low stock
        'gstRate': 12.0,
        'barcode': 'VITD3001',
        'batchNumber': 'BATCH002',
        'expiryDate': DateTime.now().add(const Duration(days: 730)),
        'unitOfMeasurement': 'tablets',
        'lowStockThreshold': 20,
        'location': 'Pharmacy Shelf',
      },
      
      // Electronics products
      {
        'name': 'Wireless Headphones',
        'categoryId': electronicsCategory.categoryId,
        'price': 2999.0,
        'quantity': 15,
        'gstRate': 18.0,
        'barcode': 'HEADPHONE001',
        'unitOfMeasurement': 'pieces',
        'lowStockThreshold': 5,
        'location': 'Electronics Section',
      },
      {
        'name': 'USB Cable',
        'categoryId': electronicsCategory.categoryId,
        'price': 199.0,
        'quantity': 100,
        'gstRate': 18.0,
        'barcode': 'USBCABLE001',
        'unitOfMeasurement': 'pieces',
        'lowStockThreshold': 20,
        'location': 'Electronics Section',
      },
    ];

    for (final productData in products) {
      final productDto = ProductDto(
        businessId: businessId,
        categoryId: productData['categoryId'] as String,
        name: productData['name'] as String,
        price: productData['price'] as double,
        quantity: productData['quantity'] as int,
        gstRate: productData['gstRate'] as double,
        barcode: productData['barcode'] as String?,
        batchNumber: productData['batchNumber'] as String?,
        expiryDate: productData['expiryDate'] as DateTime?,
        location: productData['location'] as String?,
        unitOfMeasurement: productData['unitOfMeasurement'] as String?,
        lowStockThreshold: productData['lowStockThreshold'] as int,
      );

      await _inventoryService.addProduct(productDto);
    }
  }

  /// Seed sample stock movements
  Future<void> seedStockMovements(String businessId) async {
    try {
      final products = await _inventoryService.getProducts(businessId: businessId);
      
      for (final product in products) {
        // Create some sample stock movements
        final movements = [
          {
            'qty': product.quantity,
            'type': StockMovementType.init,
            'reason': 'Initial stock',
            'createdAt': DateTime.now().subtract(const Duration(days: 30)),
          },
          {
            'qty': 10,
            'type': StockMovementType.purchase,
            'reason': 'Purchase order #PO001',
            'referenceId': 'PO001',
            'createdAt': DateTime.now().subtract(const Duration(days: 15)),
          },
          {
            'qty': -5,
            'type': StockMovementType.sale,
            'reason': 'Sale invoice #INV001',
            'referenceId': 'INV001',
            'createdAt': DateTime.now().subtract(const Duration(days: 7)),
          },
        ];

        for (final movementData in movements) {
          final movementId = _uuid.v4();
          final movement = StockMovementModel(
            movementId: movementId,
            businessId: businessId,
            productId: product.productId,
            type: movementData['type'] as StockMovementType,
            qty: movementData['qty'] as int,
            reason: movementData['reason'] as String,
            referenceId: movementData['referenceId'] as String?,
            userId: 'seeder_user',
            createdAt: Timestamp.fromDate(movementData['createdAt'] as DateTime),
          );

          await _firestore
              .collection('stock_movements')
              .doc(movementId)
              .set(movement.toMap());
        }
      }
      
      print('Stock movements seeded successfully');
    } catch (e) {
      print('Error seeding stock movements: $e');
    }
  }

  /// Complete seeding process
  Future<void> seedAll(String businessId) async {
    try {
      print('Starting inventory seeding...');
      
      await seedCategories();
      await seedProducts(businessId);
      await seedStockMovements(businessId);
      
      print('Inventory seeding completed successfully!');
    } catch (e) {
      print('Error during seeding: $e');
    }
  }

  /// Clear all seeded data (for testing)
  Future<void> clearSeededData(String businessId) async {
    try {
      // Delete products
      final products = await _inventoryService.getProducts(businessId: businessId);
      for (final product in products) {
        await _firestore.collection('products').doc(product.productId).delete();
      }

      // Delete stock movements
      final movementsQuery = await _firestore
          .collection('stock_movements')
          .where('business_id', isEqualTo: businessId)
          .get();
      
      for (final doc in movementsQuery.docs) {
        await doc.reference.delete();
      }

      // Delete categories (be careful with this in production)
      final categoriesQuery = await _firestore.collection('categories').get();
      for (final doc in categoriesQuery.docs) {
        await doc.reference.delete();
      }
      
      print('Seeded data cleared successfully');
    } catch (e) {
      print('Error clearing seeded data: $e');
    }
  }
}
