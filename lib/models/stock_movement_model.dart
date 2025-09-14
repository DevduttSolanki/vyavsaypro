import 'package:cloud_firestore/cloud_firestore.dart';

enum StockMovementType {
  init,
  purchase,
  sale,
  adjustment,
  transferIn,
  transferOut,
}

class StockMovementModel {
  final String movementId;
  final String businessId;
  final String productId;
  final StockMovementType type;
  final int qty; // positive for IN, negative for OUT
  final String reason;
  final String? referenceId; // invoice_id / purchase_order_id / user_action_id
  final String userId;
  final String? location;
  final String? batchNumber;
  final Timestamp? expiryDate;
  final Timestamp createdAt;

  StockMovementModel({
    required this.movementId,
    required this.businessId,
    required this.productId,
    required this.type,
    required this.qty,
    required this.reason,
    this.referenceId,
    required this.userId,
    this.location,
    this.batchNumber,
    this.expiryDate,
    required this.createdAt,
  });

  // Convert Dart object → Firestore Map
  Map<String, dynamic> toMap() {
    return {
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
      'expiry_date': expiryDate,
      'created_at': createdAt,
    };
  }

  // Convert Firestore Doc → Dart object
  factory StockMovementModel.fromMap(Map<String, dynamic> map) {
    return StockMovementModel(
      movementId: map['movement_id'] ?? '',
      businessId: map['business_id'] ?? '',
      productId: map['product_id'] ?? '',
      type: StockMovementType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => StockMovementType.adjustment,
      ),
      qty: map['qty'] ?? 0,
      reason: map['reason'] ?? '',
      referenceId: map['reference_id'],
      userId: map['user_id'] ?? '',
      location: map['location'],
      batchNumber: map['batch_number'],
      expiryDate: map['expiry_date'],
      createdAt: map['created_at'] ?? Timestamp.now(),
    );
  }

  // Create a copy with updated fields
  StockMovementModel copyWith({
    String? movementId,
    String? businessId,
    String? productId,
    StockMovementType? type,
    int? qty,
    String? reason,
    String? referenceId,
    String? userId,
    String? location,
    String? batchNumber,
    Timestamp? expiryDate,
    Timestamp? createdAt,
  }) {
    return StockMovementModel(
      movementId: movementId ?? this.movementId,
      businessId: businessId ?? this.businessId,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      qty: qty ?? this.qty,
      reason: reason ?? this.reason,
      referenceId: referenceId ?? this.referenceId,
      userId: userId ?? this.userId,
      location: location ?? this.location,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper method to check if movement is incoming stock
  bool get isIncoming => qty > 0;

  // Helper method to check if movement is outgoing stock
  bool get isOutgoing => qty < 0;

  // Helper method to get absolute quantity
  int get absoluteQty => qty.abs();

  // Helper method to get formatted quantity with sign
  String get formattedQty {
    if (qty > 0) {
      return '+$qty';
    } else if (qty < 0) {
      return '$qty';
    }
    return '0';
  }

  // Helper method to get movement type display name
  String get typeDisplayName {
    switch (type) {
      case StockMovementType.init:
        return 'Initial Stock';
      case StockMovementType.purchase:
        return 'Purchase';
      case StockMovementType.sale:
        return 'Sale';
      case StockMovementType.adjustment:
        return 'Adjustment';
      case StockMovementType.transferIn:
        return 'Transfer In';
      case StockMovementType.transferOut:
        return 'Transfer Out';
    }
  }
}
