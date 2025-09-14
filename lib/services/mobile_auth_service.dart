import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service_interface.dart';

class MobileAuthService implements AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  void addAuthStateListener(Function(User?) listener) {
    _auth.authStateChanges().listen(listener);
  }

  @override
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

  @override
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

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}