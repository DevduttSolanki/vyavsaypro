import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDto {
  final String? productId;
  final String businessId;
  final String categoryId;
  final String name;
  final double price;
  final int quantity;
  final double gstRate;
  final String? barcode;
  final String? batchNumber;
  final DateTime? expiryDate;
  final String? location;
  final String? unitOfMeasurement;
  final int lowStockThreshold;

  ProductDto({
    this.productId,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.gstRate,
    this.barcode,
    this.batchNumber,
    this.expiryDate,
    this.location,
    this.unitOfMeasurement,
    required this.lowStockThreshold,
  });

  // Convert to ProductModel
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId ?? '',
      'business_id': businessId,
      'category_id': categoryId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'gst_rate': gstRate,
      'barcode': barcode,
      'batch_number': batchNumber,
      'expiry_date': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'location': location,
      'unit_of_measurement': unitOfMeasurement,
      'low_stock_threshold': lowStockThreshold,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    };
  }

  // Create a copy with updated fields
  ProductDto copyWith({
    String? productId,
    String? businessId,
    String? categoryId,
    String? name,
    double? price,
    int? quantity,
    double? gstRate,
    String? barcode,
    String? batchNumber,
    DateTime? expiryDate,
    String? location,
    String? unitOfMeasurement,
    int? lowStockThreshold,
  }) {
    return ProductDto(
      productId: productId ?? this.productId,
      businessId: businessId ?? this.businessId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      gstRate: gstRate ?? this.gstRate,
      barcode: barcode ?? this.barcode,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      location: location ?? this.location,
      unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    );
  }
}

class QuickAddProductDto {
  final String businessId;
  final String name;
  final double price;
  final int quantity;
  final String? categoryId;

  QuickAddProductDto({
    required this.businessId,
    required this.name,
    required this.price,
    required this.quantity,
    this.categoryId,
  });

  // Convert to ProductDto with default values
  ProductDto toProductDto() {
    return ProductDto(
      businessId: businessId,
      categoryId: categoryId ?? 'default', // Use provided category or default
      name: name,
      price: price,
      quantity: quantity,
      gstRate: 0.0, // Default GST rate
      lowStockThreshold: 10, // Default threshold
    );
  }
}
