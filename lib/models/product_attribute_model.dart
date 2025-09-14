import 'package:cloud_firestore/cloud_firestore.dart';

class ProductAttributeModel {
  final String attributesId;
  final String productId;
  final String attributeName;
  final String attributeValue;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  ProductAttributeModel({
    required this.attributesId,
    required this.productId,
    required this.attributeName,
    required this.attributeValue,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Dart object → Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'attributes_id': attributesId,
      'product_id': productId,
      'attribute_name': attributeName,
      'attribute_value': attributeValue,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Convert Firestore Doc → Dart object
  factory ProductAttributeModel.fromMap(Map<String, dynamic> map) {
    return ProductAttributeModel(
      attributesId: map['attributes_id'] ?? '',
      productId: map['product_id'] ?? '',
      attributeName: map['attribute_name'] ?? '',
      attributeValue: map['attribute_value'] ?? '',
      createdAt: map['created_at'] ?? Timestamp.now(),
      updatedAt: map['updated_at'] ?? Timestamp.now(),
    );
  }

  // Create a copy with updated fields
  ProductAttributeModel copyWith({
    String? attributesId,
    String? productId,
    String? attributeName,
    String? attributeValue,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ProductAttributeModel(
      attributesId: attributesId ?? this.attributesId,
      productId: productId ?? this.productId,
      attributeName: attributeName ?? this.attributeName,
      attributeValue: attributeValue ?? this.attributeValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
