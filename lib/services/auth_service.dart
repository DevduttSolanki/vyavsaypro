import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  void addAuthStateListener(Function(User?) listener) {
    _auth.authStateChanges().listen(listener);
  }

  Future<void> verifyPhone({
    required String phone,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(String error) onFailed,
    required Function() onAutoVerified,
    required Function(String verificationId) onTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          onAutoVerified();
        },
        verificationFailed: (FirebaseAuthException e) {
          onFailed(e.message ?? 'Phone verification failed');
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: onTimeout,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      onFailed(e.toString());
    }
  }

  Future<UserCredential> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception("Failed to verify SMS code: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}