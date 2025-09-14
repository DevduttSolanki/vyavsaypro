// screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'otp_screen.dart';
import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  bool _loading = false;

  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Register with Phone",
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
                  // 📱 Illustration / Icon
                  Icon(Icons.phone_android,
                      size: size.width * 0.25, color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    "Enter your phone number to continue",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // 📌 Mobile input row with +91 prefix
                  Row(
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "+91",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Theme(
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
                                borderSide:
                                BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // ✅ digits only
                              LengthLimitingTextInputFormatter(10), // ✅ max 10 digits
                            ],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Mobile Number",
                              hintText: "9876543210",
                              suffixIcon: Icon(Icons.phone, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 📌 Custom Button
                  _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : CustomButton(
                    text: "Send OTP",
                    onPressed: () async {
                      final phone = _phoneController.text.trim();

                      if (phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Please enter mobile number")),
                        );
                        return;
                      }

                      if (phone.length != 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                              Text("Mobile number must be 10 digits")),
                        );
                        return;
                      }

                      setState(() => _loading = true);

                      await auth.verifyPhone(
                        phone: "+91$phone", // ✅ prepend +91
                        codeSent: (verificationId, resendToken) {
                          setState(() => _loading = false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OTPScreen(
                                verificationId: verificationId,
                                phone: "+91$phone",
                              ),
                            ),
                          );
                        },
                        onFailed: (err) {
                          setState(() => _loading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $err")),
                          );
                        },
                        onAutoVerified: () {
                          setState(() => _loading = false);
                        },
                        onTimeout: (verificationId) {
                          setState(() => _loading = false);
                        },
                      );
                    },
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
