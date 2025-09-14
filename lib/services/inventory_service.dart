import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/stock_movement_model.dart';
import '../models/dto/product_dto.dart';
import '../models/dto/stock_adjustment_dto.dart';

class InventoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = Uuid();

  // ==================== CATEGORY MANAGEMENT ====================

  /// Create a new category
  Future<String?> createCategory({
    required String name,
    String? description,
  }) async {
    try {
      final categoryId = _uuid.v4();
      final category = CategoryModel(
        categoryId: categoryId,
        name: name,
        description: description,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await _firestore
          .collection('categories')
          .doc(categoryId)
          .set(category.toMap());

      return categoryId;
    } catch (e) {
      print('Error creating category: $e');
      return null;
    }
  }

  /// Get categories based on different scenarios
  Future<List<CategoryModel>> getCategories({bool onlyWithProducts = false, String? businessId}) async {
    try {
      print('DEBUG: Fetching categories (onlyWithProducts: $onlyWithProducts, businessId: $businessId)');
      
      if (!onlyWithProducts) {
        // For Add Product screen: return all categories
        final querySnapshot = await _firestore
            .collection('categories')
            .orderBy('name')
            .get();

        final categories = querySnapshot.docs
            .map((doc) {
              print('DEBUG: Category Document: ${doc.data()}');
              return CategoryModel.fromMap(doc.data());
            })
            .toList();
        
        print('DEBUG: Found ${categories.length} total categories');
        return categories;
      } else if (businessId != null) {
        // For view screens: get only categories that have products
        print('DEBUG: Fetching categories with products for business: $businessId');
        
        // Get all products for the business to find used categories
        final productsSnapshot = await _firestore
            .collection('products')
            .where('business_id', isEqualTo: businessId)
            .get();

        // Create a set of unique category IDs from products
        final Set<String> categoryIds = {};
        for (var doc in productsSnapshot.docs) {
          final categoryId = doc.data()['category_id'] as String?;
          if (categoryId != null && categoryId.isNotEmpty) {
            categoryIds.add(categoryId);
          }
        }

        print('DEBUG: Found categories IDs in products: $categoryIds');

        if (categoryIds.isEmpty) {
          print('DEBUG: No categories found in products');
          return [];
        }

        // Get categories in chunks of 10 (Firestore limitation for whereIn)
        List<CategoryModel> categories = [];
        for (var i = 0; i < categoryIds.length; i += 10) {
          final endIdx = (i + 10 < categoryIds.length) ? i + 10 : categoryIds.length;
          final chunk = categoryIds.toList().sublist(i, endIdx);
          
          print('DEBUG: Fetching categories chunk: $chunk');
          final categoriesSnapshot = await _firestore
              .collection('categories')
              .where('category_id', whereIn: chunk)
              .get();

          categories.addAll(
            categoriesSnapshot.docs.map((doc) => CategoryModel.fromMap(doc.data()))
          );
        }

        // Sort categories by name
        categories.sort((a, b) => a.name.compareTo(b.name));
        
        print('DEBUG: Returning ${categories.length} categories with products');
        categories.forEach((cat) => print('DEBUG: Category with products: ${cat.name} (${cat.categoryId})'));
        return categories;
      }

      return [];
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  /// Ensure default categories exist
  Future<void> ensureDefaultCategories() async {
    try {
      final existingCategories = await getCategories();
      final existingNames = existingCategories.map((c) => c.name.toLowerCase()).toSet();
      print('Found existing categories: $existingNames');

      print('Checking for missing categories...');
      final defaultCategories = [
        // Food & Agriculture
        {'name': 'Food & Beverages', 'description': 'Food items, drinks, and packaged foods'},
        {'name': 'Agricultural Products', 'description': 'Seeds, fertilizers, farm equipment'},
        {'name': 'Dairy Products', 'description': 'Milk, cheese, and dairy items'},
        
        // Retail & Consumer Goods
        {'name': 'Clothing & Apparel', 'description': 'Garments, accessories, and footwear'},
        {'name': 'Electronics', 'description': 'Electronic devices and accessories'},
        {'name': 'Home & Kitchen', 'description': 'Kitchenware, appliances, and home goods'},
        {'name': 'Personal Care', 'description': 'Cosmetics, hygiene products'},
        {'name': 'Stationery', 'description': 'Office supplies and school items'},
        
        // Industrial & Manufacturing
        {'name': 'Hardware', 'description': 'Tools, equipment, and construction materials'},
        {'name': 'Auto Parts', 'description': 'Vehicle parts and accessories'},
        {'name': 'Industrial Supplies', 'description': 'Manufacturing and industrial equipment'},
        {'name': 'Packaging Material', 'description': 'Boxes, containers, and packaging supplies'},
        
        // Healthcare & Wellness
        {'name': 'Pharmaceuticals', 'description': 'Medicines and medical supplies'},
        {'name': 'Medical Equipment', 'description': 'Healthcare devices and equipment'},
        {'name': 'Ayurvedic', 'description': 'Traditional Indian medicines and herbs'},
        
        // Textiles & Materials
        {'name': 'Fabrics & Textiles', 'description': 'Raw fabrics and textile materials'},
        {'name': 'Handicrafts', 'description': 'Handmade items and artisanal products'},
        {'name': 'Raw Materials', 'description': 'Industrial raw materials and supplies'},
        
        // Specialty
        {'name': 'Books & Media', 'description': 'Books, educational materials, and media'},
        {'name': 'Toys & Games', 'description': 'Children\'s toys and entertainment items'},
        {'name': 'Sports & Fitness', 'description': 'Sports equipment and fitness gear'},
        {'name': 'Gift Items', 'description': 'Decorative and gift articles'},
        
        // Others
        {'name': 'General', 'description': 'Miscellaneous items and general products'},
        {'name': 'Services', 'description': 'Service-related inventory items'},
      ];

      // Only create categories that don't exist
      for (final categoryData in defaultCategories) {
        final categoryName = categoryData['name']!.toLowerCase();
        if (!existingNames.contains(categoryName)) {
          print('Creating missing category: ${categoryData['name']}');
          await createCategory(
            name: categoryData['name']!,
            description: categoryData['description'],
          );
        }
      }
      print('Categories update completed successfully');
    } catch (e) {
      print('Error creating default categories: $e');
    }
  }

  // ==================== PRODUCT MANAGEMENT ====================

  /// Add a new product
  Future<String?> addProduct(ProductDto productDto) async {
    try {
      final productId = _uuid.v4();
      final productData = productDto.toMap();
      productData['product_id'] = productId;

      // Check for duplicate barcode within business
      if (productDto.barcode != null && productDto.barcode!.isNotEmpty) {
        final existingProduct = await _firestore
            .collection('products')
            .where('business_id', isEqualTo: productDto.businessId)
            .where('barcode', isEqualTo: productDto.barcode)
            .limit(1)
            .get();

        if (existingProduct.docs.isNotEmpty) {
          throw Exception('Barcode already exists for this business');
        }
      }

      // Create product document
      await _firestore
          .collection('products')
          .doc(productId)
          .set(productData);

      // Create initial stock movement if quantity > 0
      if (productDto.quantity > 0) {
        await _createStockMovement(
          businessId: productDto.businessId,
          productId: productId,
          qty: productDto.quantity,
          type: StockMovementType.init,
          reason: 'Initial stock',
          userId: _auth.currentUser?.uid ?? '',
        );
      }

      return productId;
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  /// Quick add product with minimal fields
  Future<String?> quickAddProduct(QuickAddProductDto quickAddDto) async {
    try {
      final productDto = quickAddDto.toProductDto();
      return await addProduct(productDto);
    } catch (e) {
      print('Error quick adding product: $e');
      rethrow;
    }
  }

  /// Update an existing product
  Future<bool> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      updates['updated_at'] = Timestamp.now();

      await _firestore
          .collection('products')
          .doc(productId)
          .update(updates);

      return true;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  /// Get a single product by ID
  Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();

      if (!doc.exists) return null;

      return ProductModel.fromMap(doc.data()! as Map<String, dynamic>);
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  /// Get products for a business with optional filters
  Future<List<ProductModel>> getProducts({
    required String businessId,
    String? categoryId,
    String? searchQuery,
    bool? lowStockOnly,
    int limit = 50,
  }) async {
    try {
      print('DEBUG: Starting product fetch');
      print('DEBUG: Business ID: $businessId');
      print('DEBUG: Category ID: $categoryId');
      
      // Start with base query
      Query query = _firestore.collection('products');
      
      // Apply business filter first
      query = query.where('business_id', isEqualTo: businessId);
      print('DEBUG: Business filter applied: $businessId');

      // Get all products for the business
      print('DEBUG: Executing initial query...');
      final QuerySnapshot initialQuery = await query.get();
      
      // Convert to list of products
      var allProducts = initialQuery.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      
      // Apply category filter in memory if provided
      if (categoryId != null && categoryId.isNotEmpty) {
        print('DEBUG: Filtering by category: $categoryId');
        allProducts = allProducts.where((product) => product.categoryId == categoryId).toList();
        print('DEBUG: Found ${allProducts.length} products in category');
      }

      // Apply low stock filter if requested
      if (lowStockOnly == true) {
        print('DEBUG: Filtering low stock items');
        allProducts = allProducts.where((product) => product.quantity <= product.lowStockThreshold).toList();
        print('DEBUG: Found ${allProducts.length} low stock products');
      }

      // Sort by name
      allProducts.sort((a, b) => a.name.compareTo(b.name));
      
      print('DEBUG: Returning ${allProducts.length} products');
      return allProducts;

      // Add limit
      query = query.limit(limit);

      print('Executing Firestore query...');
      final querySnapshot = await query.get();
      print('Query complete. Found ${querySnapshot.docs.length} products');

      // Convert to ProductModel objects
      List<ProductModel> products = querySnapshot.docs.map((doc) {
        try {
          return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing product document ${doc.id}: $e');
          return null;
        }
      }).whereType<ProductModel>().toList();

      // Apply search filter in memory if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final searchLower = searchQuery.toLowerCase();
        products = products.where((product) =>
          product.name.toLowerCase().contains(searchLower) ||
          (product.barcode?.toLowerCase().contains(searchLower) ?? false)
        ).toList();
        print('After search filter: ${products.length} products');
      }

      // Apply low stock filter in memory if needed
      if (lowStockOnly == true) {
        products = products.where((product) => product.isLowStock).toList();
        print('After low stock filter: ${products.length} products');
      }

      print('Returning ${products.length} products');
      return products;
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  /// Get low stock products for a business
  Future<List<ProductModel>> getLowStockProducts(String businessId) async {
    return await getProducts(
      businessId: businessId,
      lowStockOnly: true,
    );
  }

  /// Get count of low stock products
  Future<int> getLowStockCount(String businessId) async {
    try {
      final lowStockProducts = await getLowStockProducts(businessId);
      return lowStockProducts.length;
    } catch (e) {
      print('Error getting low stock count: $e');
      return 0;
    }
  }

  // ==================== STOCK MANAGEMENT ====================

  /// Increase stock for a product
  Future<bool> increaseStock({
    required String businessId,
    required String productId,
    required int qty,
    required String reason,
    String? referenceId,
    required String userId,
    String? location,
    String? batchNumber,
    DateTime? expiryDate,
  }) async {
    try {
      if (qty <= 0) {
        throw Exception('Quantity must be positive for stock increase');
      }

      return await _adjustStock(
        businessId: businessId,
        productId: productId,
        qty: qty,
        type: StockMovementType.adjustment,
        reason: reason,
        referenceId: referenceId,
        userId: userId,
        location: location,
        batchNumber: batchNumber,
        expiryDate: expiryDate,
      );
    } catch (e) {
      print('Error increasing stock: $e');
      rethrow;
    }
  }

  /// Decrease stock for a product
  Future<bool> decreaseStock({
    required String businessId,
    required String productId,
    required int qty,
    required String reason,
    String? referenceId,
    required String userId,
    String? location,
    bool allowNegativeStock = false,
  }) async {
    try {
      if (qty <= 0) {
        throw Exception('Quantity must be positive for stock decrease');
      }

      // Check current stock
      final product = await getProduct(productId);
      if (product == null) {
        throw Exception('Product not found');
      }

      if (!allowNegativeStock && (product.quantity - qty) < 0) {
        throw Exception('Insufficient stock. Current: ${product.quantity}, Requested: $qty');
      }

      return await _adjustStock(
        businessId: businessId,
        productId: productId,
        qty: -qty, // Negative for decrease
        type: StockMovementType.adjustment,
        reason: reason,
        referenceId: referenceId,
        userId: userId,
        location: location,
      );
    } catch (e) {
      print('Error decreasing stock: $e');
      rethrow;
    }
  }

  /// Adjust stock (internal method)
  Future<bool> _adjustStock({
    required String businessId,
    required String productId,
    required int qty,
    required StockMovementType type,
    required String reason,
    String? referenceId,
    required String userId,
    String? location,
    String? batchNumber,
    DateTime? expiryDate,
  }) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        // Get current product
        final productRef = _firestore.collection('products').doc(productId);
        final productDoc = await transaction.get(productRef);

        if (!productDoc.exists) {
          throw Exception('Product not found');
        }

        final currentProduct = ProductModel.fromMap(productDoc.data()! as Map<String, dynamic>);
        final newQuantity = currentProduct.quantity + qty;

        // Update product quantity
        transaction.update(productRef, {
          'quantity': newQuantity,
          'updated_at': Timestamp.now(),
        });

        // Create stock movement record
        final movementId = _uuid.v4();
        final movementRef = _firestore.collection('stock_movements').doc(movementId);
        
        final movementData = {
          'movement_id': movementId,
          'business_id': businessId,
          'product_id': productId,
          'type': type.name,
          'qty': qty,
          'reason': reason,
          'reference_id': referenceId,
          'user_id': userId,
          'location': location,
          'batch_number': batchNumber,
          'expiry_date': expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
          'created_at': Timestamp.now(),
        };

        transaction.set(movementRef, movementData);

        return true;
      });
    } catch (e) {
      print('Error adjusting stock: $e');
      rethrow;
    }
  }

  /// Create stock movement record (internal method)
  Future<String?> _createStockMovement({
    required String businessId,
    required String productId,
    required int qty,
    required StockMovementType type,
    required String reason,
    required String userId,
    String? referenceId,
    String? location,
    String? batchNumber,
    DateTime? expiryDate,
  }) async {
    try {
      final movementId = _uuid.v4();
      final movement = StockMovementModel(
        movementId: movementId,
        businessId: businessId,
        productId: productId,
        type: type,
        qty: qty,
        reason: reason,
        referenceId: referenceId,
        userId: userId,
        location: location,
        batchNumber: batchNumber,
        expiryDate: expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
        createdAt: Timestamp.now(),
      );

      await _firestore
          .collection('stock_movements')
          .doc(movementId)
          .set(movement.toMap());

      return movementId;
    } catch (e) {
      print('Error creating stock movement: $e');
      return null;
    }
  }

  /// Reconcile product quantity from stock movements
  Future<bool> reconcileProductQuantity(String productId) async {
    try {
      final movements = await _firestore
          .collection('stock_movements')
          .where('product_id', isEqualTo: productId)
          .orderBy('created_at')
          .get();

      int calculatedQuantity = 0;
      for (final doc in movements.docs) {
        final movement = StockMovementModel.fromMap(doc.data() as Map<String, dynamic>);
        calculatedQuantity += movement.qty;
      }

      await _firestore
          .collection('products')
          .doc(productId)
          .update({
        'quantity': calculatedQuantity,
        'updated_at': Timestamp.now(),
      });

      return true;
    } catch (e) {
      print('Error reconciling product quantity: $e');
      return false;
    }
  }

  /// Get stock movements for a product
  Future<List<StockMovementModel>> getStockMovements({
    required String productId,
    int limit = 50,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('stock_movements')
          .where('product_id', isEqualTo: productId)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => StockMovementModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting stock movements: $e');
      return [];
    }
  }

  // ==================== INTEGRATION HOOKS ====================

  /// Decrease stock for a sale (to be called by billing/orders module)
  Future<bool> decreaseStockForSale({
    required String businessId,
    required String productId,
    required int qty,
    required String invoiceId,
    required String userId,
    String? location,
    bool allowNegativeStock = false,
  }) async {
    return await decreaseStock(
      businessId: businessId,
      productId: productId,
      qty: qty,
      reason: 'Sale',
      referenceId: invoiceId,
      userId: userId,
      location: location,
      allowNegativeStock: allowNegativeStock,
    );
  }

  /// Increase stock for a purchase (to be called by billing/orders module)
  Future<bool> increaseStockForPurchase({
    required String businessId,
    required String productId,
    required int qty,
    required String purchaseOrderId,
    required String userId,
    String? location,
    String? batchNumber,
    DateTime? expiryDate,
  }) async {
    return await increaseStock(
      businessId: businessId,
      productId: productId,
      qty: qty,
      reason: 'Purchase',
      referenceId: purchaseOrderId,
      userId: userId,
      location: location,
      batchNumber: batchNumber,
      expiryDate: expiryDate,
    );
  }
}
