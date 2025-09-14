// Only import this file in web builds
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service_interface.dart';

class WebAuthService implements AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ConfirmationResult? _webConfirmationResult;

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
      _webConfirmationResult = await _auth.signInWithPhoneNumber(phone);
      codeSent("web", null);
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
      if (_webConfirmationResult == null) {
        throw Exception("No confirmation result found. Call verifyPhone first.");
      }
      return await _webConfirmationResult!.confirm(smsCode);
    } catch (e) {
      throw Exception("Failed to verify SMS code: $e");
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}