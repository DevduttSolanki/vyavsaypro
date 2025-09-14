import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String? userProfileUrl;
  final String? userName;
  final String? email;
  final String? phone;
  final Timestamp createdAt;
  final bool profileCompleted;
  final String? preferredLang;

  UserModel({
    required this.userId,
    this.userProfileUrl,
    this.userName,
    this.email,
    this.phone,
    required this.createdAt,
    this.profileCompleted = false,
    this.preferredLang,
  });

  // Convert Dart object → Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_profile_url': userProfileUrl,
      'user_name': userName,
      'email': email,
      'phone': phone,
      'created_at': createdAt,
      'profile_completed': profileCompleted,
      'preferred_lang': preferredLang,
    };
  }

  // Convert Firestore Doc → Dart object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] ?? '',
      userProfileUrl: map['user_profile_url'],
      userName: map['user_name'],
      email: map['email'],
      phone: map['phone'],
      createdAt: map['created_at'] ?? Timestamp.now(),
      profileCompleted: map['profile_completed'] ?? false,
      preferredLang: map['preferred_lang'],
    );
  }
}
