import 'package:cloud_firestore/cloud_firestore.dart';

class UserBusinessMapModel {
  final String userId;
  final String businessId;
  final Timestamp? createdAt;

  UserBusinessMapModel({
    required this.userId,
    required this.businessId,
    this.createdAt,
  });

  // Convert Dart object → Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'business_id': businessId,
      'created_at': createdAt ?? Timestamp.now(),
    };
  }

  // Convert Firestore Doc → Dart object
  factory UserBusinessMapModel.fromMap(Map<String, dynamic> map) {
    return UserBusinessMapModel(
      userId: map['user_id'] ?? '',
      businessId: map['business_id'] ?? '',
      createdAt: map['created_at'],
    );
  }
}