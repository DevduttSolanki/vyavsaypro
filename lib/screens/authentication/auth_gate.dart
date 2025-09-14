import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vyavsaypro/screens/authentication/register_screen.dart';

import '../Home/home_page.dart';


/// AuthGate is a wrapper widget that decides whether to show
/// the logged-in HomePage or the LoginPage based on FirebaseAuth state.
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🔄 Still checking Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ User is logged in → go to Home
        if (snapshot.hasData) {
          return HomePage();
        }

        // ❌ Not logged in → go to Login
        return RegisterScreen();
      },
    );
  }
}











