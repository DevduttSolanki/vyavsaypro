import 'package:cloud_firestore/cloud_firestore.dart';
import '../stock_movement_model.dart';

class StockAdjustmentDto {
  final String businessId;
  final String productId;
  final int qty; // positive for increase, negative for decrease
  final StockMovementType type;
  final String reason;
  final String? referenceId;
  final String userId;
  final String? location;
  final String? batchNumber;
  final DateTime? expiryDate;

  StockAdjustmentDto({
    required this.businessId,
    required this.productId,
    required this.qty,
    required this.type,
    required this.reason,
    this.referenceId,
    required this.userId,
    this.location,
    this.batchNumber,
    this.expiryDate,
  });

  // Convert to StockMovementModel
  Map<String, dynamic> toStockMovementMap(String movementId) {
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
      'expiry_date': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'created_at': Timestamp.now(),
    };
  }

  // Helper method to check if this adjustment would result in negative stock
  bool wouldResultInNegativeStock(int currentQuantity) {
    return (currentQuantity + qty) < 0;
  }

  // Helper method to get the new quantity after adjustment
  int getNewQuantity(int currentQuantity) {
    return currentQuantity + qty;
  }
}

class StockAdjustmentRequest {
  final String businessId;
  final String productId;
  final int qty;
  final String reason;
  final String? referenceId;
  final String userId;
  final String? location;

  StockAdjustmentRequest({
    required this.businessId,
    required this.productId,
    required this.qty,
    required this.reason,
    this.referenceId,
    required this.userId,
    this.location,
  });

  // Convert to StockAdjustmentDto
  StockAdjustmentDto toStockAdjustmentDto() {
    return StockAdjustmentDto(
      businessId: businessId,
      productId: productId,
      qty: qty,
      type: qty > 0 ? StockMovementType.adjustment : StockMovementType.adjustment,
      reason: reason,
      referenceId: referenceId,
      userId: userId,
      location: location,
    );
  }
}
