// import 'package:flutter/material.dart';
// import 'core/routes/routes.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/login',
//       routes: AppRoutes.routes,
//     );
//   }
// }
//
//


//==================================================================================================

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
//
// import 'core/routes/routes.dart';
// import 'services/auth_service.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Provider<AuthService>(
//       create: (_) => AuthService(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'MSME Business Tool',
//         theme: ThemeData(primarySwatch: Colors.indigo),
//         initialRoute: '/auth-gate',
//         routes: {
//           ...AppRoutes.routes, // merge your existing routes
//           '/auth-gate': (context) => const AuthGate(),
//         },
//       ),
//     );
//   }
// }
//
// /// Simple auth gate: if signed in show Home, else show Register
// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});
//
//   @override
//   _AuthGateState createState() => _AuthGateState();
// }
//
// class _AuthGateState extends State<AuthGate> {
//   @override
//   void initState() {
//     super.initState();
//     final auth = Provider.of<AuthService>(context, listen: false);
//     auth.addAuthStateListener((user) {
//       setState(() {}); // rebuild when user signs in/out
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthService>(context, listen: false);
//     final current = auth.currentUser;
//     if (current != null) {
//       return AppRoutes.routes['/home']!(context); // navigate to home
//     } else {
//       return AppRoutes.routes['/register']!(context); // navigate to register
//     }
//   }
// }


//=========================================================================================================
//
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
//
// import 'core/routes/routes.dart';
// import 'services/auth_service.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Only init if not already initialized
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyBNNQtoNAuOK7OknmFgf20Ia85TwtmbugU",
//         authDomain: "vyavsaypro-database.firebaseapp.com",
//         projectId: "vyavsaypro-database",
//         storageBucket: "vyavsaypro-database.appspot.com",
//         messagingSenderId: "777188366729",
//         appId: "1:777188366729:web:9dd9636eb57e08ed442958",
//         measurementId: "G-9ZJYBZR4Q8",
//       ),
//     );
//   }
//
//   runApp(const MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Provider<AuthService>(
//       create: (_) => AuthService(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'MSME Business Tool',
//         theme: ThemeData(primarySwatch: Colors.indigo),
//         initialRoute: '/auth-gate',
//         routes: {
//           ...AppRoutes.routes,
//           '/auth-gate': (context) => const AuthGate(),
//         },
//       ),
//     );
//   }
// }
//
// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});
//
//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }
//
// class _AuthGateState extends State<AuthGate> {
//   @override
//   void initState() {
//     super.initState();
//     final auth = Provider.of<AuthService>(context, listen: false);
//
//     // listen to auth state changes
//     auth.addAuthStateListener((user) {
//       setState(() {}); // rebuild UI on login/logout
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthService>(context, listen: false);
//     final currentUser = auth.currentUser;
//
//     if (currentUser != null) {
//       return AppRoutes.routes['/home']!(context);
//     } else {
//       return AppRoutes.routes['/register']!(context);
//     }
//   }
// }


//======================================================================================================
//
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
//
// import 'firebase_options.dart';
// import 'screens/authentication/auth_gate.dart';
// import 'core/routes/routes.dart';
// import 'services/auth_service.dart'; // 👈 import your AuthService
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<AuthService>(create: (_) => AuthService()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'MSME Business Tool',
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       home: const AuthGate(),
//       routes: {
//         ...AppRoutes.routes,
//       },
//     );
//   }
// }

//===================================== Latest by Claude

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/routes/routes.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with platform-specific options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MSME Business Tool',
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: '/register', // RegisterScreen as landing screen
        routes: {
          ...AppRoutes.routes,
          '/auth-gate': (context) => const AuthGate(),
        },
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);

    // Listen to auth state changes
    auth.addAuthStateListener((user) {
      if (mounted) {
        setState(() {}); // Rebuild UI on login/logout
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final currentUser = auth.currentUser;

    if (currentUser != null) {
      // User is authenticated, go to home
      return AppRoutes.routes['/home']!(context);
    } else {
      // User not authenticated, go to register
      return AppRoutes.routes['/register']!(context);
    }
  }
}

