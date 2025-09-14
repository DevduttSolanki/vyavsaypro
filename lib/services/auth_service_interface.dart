import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServiceInterface {
  User? get currentUser;
  void addAuthStateListener(Function(User?) listener);
  
  Future<void> verifyPhone({
    required String phone,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(String error) onFailed,
    required Function() onAutoVerified,
    required Function(String verificationId) onTimeout,
  });
  
  Future<UserCredential> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  });
  
  Future<void> signOut();
}