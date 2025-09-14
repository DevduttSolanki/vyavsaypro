import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId;
  final String businessId;
  final String categoryId;
  final String name;
  final double price;
  final int quantity; // denormalized current stock
  final double gstRate;
  final String? barcode;
  final String? batchNumber;
  final Timestamp? expiryDate;
  final String? location;
  final String? unitOfMeasurement;
  final int lowStockThreshold;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  ProductModel({
    required this.productId,
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
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Dart object → Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'business_id': businessId,
      'category_id': categoryId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'gst_rate': gstRate,
      'barcode': barcode,
      'batch_number': batchNumber,
      'expiry_date': expiryDate,
      'location': location,
      'unit_of_measurement': unitOfMeasurement,
      'low_stock_threshold': lowStockThreshold,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Convert Firestore Doc → Dart object
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['product_id'] ?? '',
      businessId: map['business_id'] ?? '',
      categoryId: map['category_id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      gstRate: (map['gst_rate'] ?? 0.0).toDouble(),
      barcode: map['barcode'],
      batchNumber: map['batch_number'],
      expiryDate: map['expiry_date'],
      location: map['location'],
      unitOfMeasurement: map['unit_of_measurement'],
      lowStockThreshold: map['low_stock_threshold'] ?? 0,
      createdAt: map['created_at'] ?? Timestamp.now(),
      updatedAt: map['updated_at'] ?? Timestamp.now(),
    );
  }

  // Create a copy with updated fields
  ProductModel copyWith({
    String? productId,
    String? businessId,
    String? categoryId,
    String? name,
    double? price,
    int? quantity,
    double? gstRate,
    String? barcode,
    String? batchNumber,
    Timestamp? expiryDate,
    String? location,
    String? unitOfMeasurement,
    int? lowStockThreshold,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ProductModel(
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to check if product is low on stock
  bool get isLowStock => quantity <= lowStockThreshold;

  // Helper method to get formatted price
  String get formattedPrice => '₹${price.toStringAsFixed(2)}';

  // Helper method to get formatted quantity with unit
  String get formattedQuantity {
    if (unitOfMeasurement != null && unitOfMeasurement!.isNotEmpty) {
      return '$quantity $unitOfMeasurement';
    }
    return quantity.toString();
  }
}
