import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vyavsaypro/models/stock_movement_model.dart';

void main() {
  group('StockMovementModel Tests', () {
    late StockMovementModel stockMovement;
    late Map<String, dynamic> movementMap;

    setUp(() {
      movementMap = {
        'movement_id': 'test_movement_id',
        'business_id': 'test_business_id',
        'product_id': 'test_product_id',
        'type': 'purchase',
        'qty': 50,
        'reason': 'Purchase order #PO001',
        'reference_id': 'PO001',
        'user_id': 'test_user_id',
        'location': 'Warehouse A',
        'batch_number': 'BATCH001',
        'expiry_date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
        'created_at': Timestamp.now(),
      };

      stockMovement = StockMovementModel.fromMap(movementMap);
    });

    test('should create StockMovementModel from map correctly', () {
      expect(stockMovement.movementId, equals('test_movement_id'));
      expect(stockMovement.businessId, equals('test_business_id'));
      expect(stockMovement.productId, equals('test_product_id'));
      expect(stockMovement.type, equals(StockMovementType.purchase));
      expect(stockMovement.qty, equals(50));
      expect(stockMovement.reason, equals('Purchase order #PO001'));
      expect(stockMovement.referenceId, equals('PO001'));
      expect(stockMovement.userId, equals('test_user_id'));
      expect(stockMovement.location, equals('Warehouse A'));
      expect(stockMovement.batchNumber, equals('BATCH001'));
    });

    test('should convert StockMovementModel to map correctly', () {
      final map = stockMovement.toMap();
      
      expect(map['movement_id'], equals('test_movement_id'));
      expect(map['business_id'], equals('test_business_id'));
      expect(map['product_id'], equals('test_product_id'));
      expect(map['type'], equals('purchase'));
      expect(map['qty'], equals(50));
      expect(map['reason'], equals('Purchase order #PO001'));
      expect(map['reference_id'], equals('PO001'));
      expect(map['user_id'], equals('test_user_id'));
      expect(map['location'], equals('Warehouse A'));
      expect(map['batch_number'], equals('BATCH001'));
    });

    test('should create copy with updated fields', () {
      final updatedMovement = stockMovement.copyWith(
        qty: 100,
        reason: 'Updated reason',
      );

      expect(updatedMovement.qty, equals(100));
      expect(updatedMovement.reason, equals('Updated reason'));
      
      // Other fields should remain unchanged
      expect(updatedMovement.movementId, equals(stockMovement.movementId));
      expect(updatedMovement.businessId, equals(stockMovement.businessId));
      expect(updatedMovement.productId, equals(stockMovement.productId));
    });

    test('should correctly identify incoming stock', () {
      // Positive quantity should be incoming
      expect(stockMovement.isIncoming, isTrue);
      expect(stockMovement.isOutgoing, isFalse);

      // Negative quantity should be outgoing
      final outgoingMovement = stockMovement.copyWith(qty: -20);
      expect(outgoingMovement.isIncoming, isFalse);
      expect(outgoingMovement.isOutgoing, isTrue);
    });

    test('should get absolute quantity correctly', () {
      expect(stockMovement.absoluteQty, equals(50));
      
      final negativeMovement = stockMovement.copyWith(qty: -30);
      expect(negativeMovement.absoluteQty, equals(30));
    });

    test('should format quantity with sign correctly', () {
      expect(stockMovement.formattedQty, equals('+50'));
      
      final negativeMovement = stockMovement.copyWith(qty: -20);
      expect(negativeMovement.formattedQty, equals('-20'));
      
      final zeroMovement = stockMovement.copyWith(qty: 0);
      expect(zeroMovement.formattedQty, equals('0'));
    });

    test('should get correct type display name', () {
      expect(stockMovement.typeDisplayName, equals('Purchase'));
      
      final saleMovement = stockMovement.copyWith(type: StockMovementType.sale);
      expect(saleMovement.typeDisplayName, equals('Sale'));
      
      final adjustmentMovement = stockMovement.copyWith(type: StockMovementType.adjustment);
      expect(adjustmentMovement.typeDisplayName, equals('Adjustment'));
      
      final initMovement = stockMovement.copyWith(type: StockMovementType.init);
      expect(initMovement.typeDisplayName, equals('Initial Stock'));
      
      final transferInMovement = stockMovement.copyWith(type: StockMovementType.transferIn);
      expect(transferInMovement.typeDisplayName, equals('Transfer In'));
      
      final transferOutMovement = stockMovement.copyWith(type: StockMovementType.transferOut);
      expect(transferOutMovement.typeDisplayName, equals('Transfer Out'));
    });

    test('should handle all stock movement types', () {
      final types = [
        StockMovementType.init,
        StockMovementType.purchase,
        StockMovementType.sale,
        StockMovementType.adjustment,
        StockMovementType.transferIn,
        StockMovementType.transferOut,
      ];

      for (final type in types) {
        final movement = stockMovement.copyWith(type: type);
        expect(movement.type, equals(type));
        expect(movement.typeDisplayName, isNotEmpty);
      }
    });

    test('should handle null optional fields', () {
      final movementMapWithNulls = {
        'movement_id': 'test_movement_id',
        'business_id': 'test_business_id',
        'product_id': 'test_product_id',
        'type': 'adjustment',
        'qty': 10,
        'reason': 'Manual adjustment',
        'reference_id': null,
        'user_id': 'test_user_id',
        'location': null,
        'batch_number': null,
        'expiry_date': null,
        'created_at': Timestamp.now(),
      };

      final movementWithNulls = StockMovementModel.fromMap(movementMapWithNulls);
      
      expect(movementWithNulls.referenceId, isNull);
      expect(movementWithNulls.location, isNull);
      expect(movementWithNulls.batchNumber, isNull);
      expect(movementWithNulls.expiryDate, isNull);
    });
  });
}
