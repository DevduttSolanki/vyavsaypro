// // screens/otp_screen.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../services/auth_service.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../models/user_model.dart';
//
// class OTPScreen extends StatefulWidget {
//   final String verificationId;
//   final String phone;
//   OTPScreen({required this.verificationId, required this.phone});
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }
//
// class _OTPScreenState extends State<OTPScreen> {
//   final _codeController = TextEditingController();
//   bool _loading = false;
//
//   Future<void> _onVerify() async {
//     setState(() => _loading = true);
//     try {
//       final auth = Provider.of<AuthService>(context, listen: false);
//       final cred = await auth.signInWithSmsCode(
//         verificationId: widget.verificationId,
//         smsCode: _codeController.text.trim(),
//       );
//       final user = cred.user;
//
//       if (user != null) {
//         final uid = user.uid;
//         final usersRef = FirebaseFirestore.instance.collection('users').doc(uid);
//
//         final snapshot = await usersRef.get();
//         if (!snapshot.exists) {
//           // ✅ Create UserModel instance
//           final newUser = UserModel(
//             userId: uid,
//             phone: widget.phone,
//             userProfileUrl: null,
//             userName: null,
//             email: null,
//             createdAt: Timestamp.now(),
//             profileCompleted: false,
//             preferredLang: null,
//           );
//
//           await usersRef.set(newUser.toMap());
//         } else {
//           // ✅ If user already exists, update phone (optional)
//           await usersRef.update({'phone': widget.phone});
//         }
//
//         if (!mounted) return;
//         Navigator.pushReplacementNamed(context, '/home');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('OTP verify failed: $e')),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(
//           "Verify OTP",
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // 🔒 Lock icon for OTP
//                   Icon(Icons.lock, size: size.width * 0.25, color: Colors.white),
//                   const SizedBox(height: 20),
//                   Text(
//                     "Enter the 6-digit OTP sent to",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.phone,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.yellowAccent,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 40),
//
//                   // 📌 OTP Input
//                   Theme(
//                     data: Theme.of(context).copyWith(
//                       inputDecorationTheme: InputDecorationTheme(
//                         labelStyle: TextStyle(color: Colors.white),
//                         hintStyle: TextStyle(color: Colors.white70),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.white),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.white, width: 2),
//                         ),
//                       ),
//                     ),
//                     child: CustomTextField(
//                       label: "OTP Code",
//                       hint: "6-digit code",
//                       controller: _codeController,
//                       keyboardType: TextInputType.number,
//                       suffixIcon: Icon(Icons.sms, color: Colors.white),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // 📌 Verify Button
//                   _loading
//                       ? CircularProgressIndicator(color: Colors.white)
//                       : CustomButton(
//                     text: "Verify",
//                     onPressed: _onVerify,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//===========================================================================

// screens/otp_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ For input formatters
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../models/user_model.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  OTPScreen({required this.verificationId, required this.phone});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _codeController = TextEditingController();
  bool _loading = false;

  Future<void> _onVerify() async {
    final code = _codeController.text.trim();

    // ✅ Validation checks
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP cannot be empty')),
      );
      return;
    }
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP must be exactly 6 digits')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final cred = await auth.signInWithSmsCode(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      final user = cred.user;

      if (user != null) {
        final uid = user.uid;
        final usersRef = FirebaseFirestore.instance.collection('users').doc(uid);

        final snapshot = await usersRef.get();
        if (!snapshot.exists) {
          final newUser = UserModel(
            userId: uid,
            phone: widget.phone,
            userProfileUrl: null,
            userName: null,
            email: null,
            createdAt: Timestamp.now(),
            profileCompleted: false,
            preferredLang: null,
          );
          await usersRef.set(newUser.toMap());
        } else {
          await usersRef.update({'phone': widget.phone});
        }

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verify failed: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Verify OTP",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: size.width * 0.25, color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    "Enter the 6-digit OTP sent to",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.phone,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // 📌 OTP Input with restrictions
                  Theme(
                    data: Theme.of(context).copyWith(
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      textTheme: TextTheme(
                        bodyMedium: TextStyle(color: Colors.white), // This affects the input text color
                      ),
                    ),
                    child: CustomTextField(
                      label: "OTP Code",
                      hint: "6-digit code",
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,           // ✅ Only numbers
                        LengthLimitingTextInputFormatter(6),              // ✅ Limit to 6 digits
                      ],
                      suffixIcon: Icon(Icons.sms, color: Colors.white),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : CustomButton(
                    text: "Verify",
                    onPressed: _onVerify,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

