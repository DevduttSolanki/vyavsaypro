import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/business_model.dart';
import '../models/user_business_map_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = Uuid();

  // Check if user profile is completed
  Future<bool> isProfileCompleted() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return false;

      final userData = UserModel.fromMap(userDoc.data()!);
      return userData.profileCompleted;
    } catch (e) {
      print('Error checking profile completion: $e');
      return false;
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return null;

      return UserModel.fromMap(userDoc.data()!);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<bool> saveProfile({
    required String userName,
    required String email,
    required String businessName,
    required String businessAddress,
    required String contactInfo,
    required String taxType,
    String? logoUrl,
    String? gstin,
    required String footerMessage,
    required String salesTerms,
    required String purchaseTerms,
    String? profileImageUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final batch = _firestore.batch();

      // ✅ Upsert user document
      final userDoc = _firestore.collection('users').doc(user.uid);
      batch.set(userDoc, {
        'user_name': userName,
        'email': email,
        'user_profile_url': profileImageUrl,
        'profile_completed': true,
      }, SetOptions(merge: true));

      // ✅ Create business document
      final businessId = _uuid.v4();
      final businessDoc = _firestore.collection('businesses').doc(businessId);

      final business = BusinessModel(
        userId: user.uid,
        businessId: businessId,
        businessName: businessName,
        address: businessAddress,
        contactInfo: contactInfo,
        gstRegistered: taxType.toLowerCase() == 'gst',
        defaultTaxType: taxType,
        logoUrl: logoUrl,
        gstin: gstin,
        defaultFooterMessage: footerMessage,
        salesTerms: salesTerms,
        purchaseTerms: purchaseTerms,
      );

      batch.set(businessDoc, business.toMap());

      // ✅ Create user-business mapping
      final mapId = _uuid.v4();
      final mapDoc = _firestore.collection('user_business_map').doc(mapId);

      final userBusinessMap = UserBusinessMapModel(
        userId: user.uid,
        businessId: businessId,
      );

      batch.set(mapDoc, userBusinessMap.toMap());

      await batch.commit();
      return true;
    } catch (e, st) {
      print('Error saving profile: $e');
      print(st);
      return false;
    }
  }


  // Get user's business details
  Future<BusinessModel?> getUserBusiness() async {
    try {
      final user = _auth.currentUser;
      print('Current user: ${user?.uid}');
      if (user == null) {
        print('No authenticated user found');
        return null;
      }

      // Find business through user_business_map
      print('Querying user_business_map for user: ${user.uid}');
      final mapQuery = await _firestore
          .collection('user_business_map')
          .where('user_id', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (mapQuery.docs.isEmpty) {
        print('No business mapping found for user');
        return null;
      }

      final businessId = mapQuery.docs.first.data()['business_id'];
      print('Found business ID: $businessId');

      final businessDoc = await _firestore
          .collection('businesses')
          .doc(businessId)
          .get();

      if (!businessDoc.exists) {
        print('Business document not found');
        return null;
      }

      print('Business document found. Converting to model...');
      return BusinessModel.fromMap(businessDoc.data()!);
    } catch (e) {
      print('Error getting user business: $e');
      return null;
    }
  }
}