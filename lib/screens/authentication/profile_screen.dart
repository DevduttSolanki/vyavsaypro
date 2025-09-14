// import 'package:flutter/material.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Controllers for each field
//     final TextEditingController userIdController =
//     TextEditingController(text: "12345");
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController emailController =
//     TextEditingController(text: "user@example.com");
//     final TextEditingController mobileController =
//     TextEditingController(text: "+91 9876543210");
//     final TextEditingController businessNameController =
//     TextEditingController();
//     final TextEditingController addressController = TextEditingController();
//     final TextEditingController contactInfoController = TextEditingController();
//     final TextEditingController taxTypeController = TextEditingController();
//     final TextEditingController logoUrlController = TextEditingController();
//     final TextEditingController gstinController = TextEditingController();
//     final TextEditingController footerMessageController =
//     TextEditingController();
//     final TextEditingController purchaseTermsController =
//     TextEditingController();
//     final TextEditingController salesTermsController = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Photo Section
//             Center(
//               child: Stack(
//                 children: [
//                   const CircleAvatar(
//                     radius: 60,
//                     backgroundImage:
//                     AssetImage("assets/user.png"), // Replace with network image if needed
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.blue,
//                       radius: 20,
//                       child: const Icon(Icons.camera_alt,
//                           color: Colors.white, size: 20),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // Personal Details Section
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey[300]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.person, color: Colors.blue[600], size: 24),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Personal Details",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // User ID
//                   CustomTextField(
//                     label: "User ID",
//                     hint: "12345",
//                     controller: userIdController,
//                   ),
//
//                   // Name
//                   CustomTextField(
//                     label: "User Name",
//                     hint: "Enter your name",
//                     controller: nameController,
//                   ),
//
//                   // Email (read-only)
//                   CustomTextField(
//                     label: "Email",
//                     hint: "user@example.com",
//                     controller: emailController,
//                   ),
//
//                   // Mobile No (read-only)
//                   CustomTextField(
//                     label: "Mobile Number",
//                     hint: "+91 9876543210",
//                     controller: mobileController,
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Business Details Section
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.blue[200]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.business, color: Colors.blue[600], size: 24),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Business Details",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Business Name
//                   CustomTextField(
//                     label: "Business Name",
//                     hint: "Your business name",
//                     controller: businessNameController,
//                   ),
//
//                   // Business Address
//                   CustomTextField(
//                     label: "Business Address",
//                     hint: "Enter business address",
//                     controller: addressController,
//                     maxLines: 2,
//                   ),
//
//                   // Contact Info
//                   CustomTextField(
//                     label: "Contact Info",
//                     hint: "Enter contact info",
//                     controller: contactInfoController,
//                   ),
//
//                   // Tax Type
//                   CustomTextField(
//                     label: "Tax Type",
//                     hint: "GST / VAT / None",
//                     controller: taxTypeController,
//                   ),
//
//                   // Logo URL
//                   CustomTextField(
//                     label: "Logo URL",
//                     hint: "http://example.com/logo.png",
//                     controller: logoUrlController,
//                   ),
//
//                   // GSTIN
//                   CustomTextField(
//                     label: "GSTIN",
//                     hint: "Enter GSTIN",
//                     controller: gstinController,
//                   ),
//
//                   // Footer Message
//                   CustomTextField(
//                     label: "Footer Message",
//                     hint: "Enter footer message",
//                     controller: footerMessageController,
//                   ),
//
//                   // Purchase Terms
//                   CustomTextField(
//                     label: "Purchase Terms",
//                     hint: "Enter Purchase terms",
//                     controller: purchaseTermsController,
//                     maxLines: 3,
//                   ),
//
//                   // Sales Terms
//                   CustomTextField(
//                     label: "Sales Terms",
//                     hint: "Enter Sales terms",
//                     controller: salesTermsController,
//                     maxLines: 3,
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Save Button
//             Center(
//               child: CustomButton(
//                 text: "Save Profile",
//                 onPressed: () {
//                   // TODO: Add save logic
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

//===============================================================Task 2

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../services/profile_service.dart';
import '../../models/user_model.dart';
import '../../models/business_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  final ImagePicker _imagePicker = ImagePicker();

  // Controllers for each field
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController taxTypeController = TextEditingController(text: "Non-GST");
  final TextEditingController logoUrlController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  final TextEditingController footerMessageController = TextEditingController();
  final TextEditingController purchaseTermsController = TextEditingController();
  final TextEditingController salesTermsController = TextEditingController();

  bool _isLoading = false;
  bool _isProfileCompleted = false;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Set user ID and phone
        userIdController.text = user.uid;
        mobileController.text = user.phoneNumber ?? '';

        // Load user profile data
        final userData = await _profileService.getCurrentUser();
        if (userData != null) {
          nameController.text = userData.userName ?? '';
          emailController.text = userData.email ?? '';
          _isProfileCompleted = userData.profileCompleted;

          // Load business data if profile is completed
          if (_isProfileCompleted) {
            final businessData = await _profileService.getUserBusiness();
            if (businessData != null) {
              businessNameController.text = businessData.businessName;
              addressController.text = businessData.address;
              contactInfoController.text = businessData.contactInfo;
              taxTypeController.text = businessData.defaultTaxType;
              logoUrlController.text = businessData.logoUrl ?? '';
              gstinController.text = businessData.gstin ?? '';
              footerMessageController.text = businessData.defaultFooterMessage;
              purchaseTermsController.text = businessData.purchaseTerms;
              salesTermsController.text = businessData.salesTerms;
            }
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    // Validate required fields
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        businessNameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        contactInfoController.text.trim().isEmpty ||
        footerMessageController.text.trim().isEmpty ||
        salesTermsController.text.trim().isEmpty ||
        purchaseTermsController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate GSTIN if GST is selected
    if (taxTypeController.text.toLowerCase() == 'gst' &&
        gstinController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GSTIN is required for GST registered businesses'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _profileService.saveProfile(
        userName: nameController.text.trim(),
        email: emailController.text.trim(),
        businessName: businessNameController.text.trim(),
        businessAddress: addressController.text.trim(),
        contactInfo: contactInfoController.text.trim(),
        taxType: taxTypeController.text.trim(),
        logoUrl: logoUrlController.text.trim().isEmpty ? null : logoUrlController.text.trim(),
        gstin: gstinController.text.trim().isEmpty ? null : gstinController.text.trim(),
        footerMessage: footerMessageController.text.trim(),
        salesTerms: salesTermsController.text.trim(),
        purchaseTerms: purchaseTermsController.text.trim(),
        profileImageUrl: _profileImagePath, // In real app, upload to Firebase Storage first
      );

      if (success) {
        setState(() => _isProfileCompleted = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully! You can now access all features.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: GradientAppBar(
        title: "Profile",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile completion status
            if (!_isProfileCompleted) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Complete your profile to access all features",
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Profile Photo Section
            Center(
              child: GestureDetector(
                onTap: _pickProfileImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImagePath != null
                          ? NetworkImage(_profileImagePath!) // In real app, use proper image handling
                          : const AssetImage("assets/user.png") as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20,
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Personal Details Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue[600], size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "Personal Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // User ID (read-only)
                  CustomTextField(
                    label: "User ID",
                    hint: "Auto-generated",
                    controller: userIdController,
                    enabled: false,
                  ),

                  // Name (required)
                  CustomTextField(
                    label: "User Name *",
                    hint: "Enter your name",
                    controller: nameController,
                  ),

                  // Email (required)
                  CustomTextField(
                    label: "Email *",
                    hint: "user@example.com",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // Mobile No (read-only)
                  CustomTextField(
                    label: "Mobile Number",
                    hint: "From registration",
                    controller: mobileController,
                    enabled: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Business Details Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.business, color: Colors.blue[600], size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "Business Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Business Name (required)
                  CustomTextField(
                    label: "Business Name *",
                    hint: "Your business name",
                    controller: businessNameController,
                  ),

                  // Business Address (required)
                  CustomTextField(
                    label: "Business Address *",
                    hint: "Enter business address",
                    controller: addressController,
                    maxLines: 2,
                  ),

                  // Contact Info (required)
                  CustomTextField(
                    label: "Contact Info *",
                    hint: "Enter contact info",
                    controller: contactInfoController,
                  ),

                  // Tax Type (required)
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Tax Type *",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: taxTypeController.text.isEmpty ? "Non-GST" : taxTypeController.text,
                    items: ["GST", "Non-GST"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        taxTypeController.text = newValue;
                        setState(() {});
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Logo URL (optional)
                  CustomTextField(
                    label: "Logo URL",
                    hint: "http://example.com/logo.png (Optional)",
                    controller: logoUrlController,
                  ),

                  // GSTIN (required only for GST)
                  if (taxTypeController.text.toLowerCase() == 'gst') ...[
                    CustomTextField(
                      label: "GSTIN *",
                      hint: "Enter GSTIN",
                      controller: gstinController,
                    ),
                  ],

                  // Footer Message (required)
                  CustomTextField(
                    label: "Footer Message *",
                    hint: "Enter footer message",
                    controller: footerMessageController,
                    maxLines: 2,
                  ),

                  // Purchase Terms (required)
                  CustomTextField(
                    label: "Purchase Terms *",
                    hint: "Enter purchase terms",
                    controller: purchaseTermsController,
                    maxLines: 3,
                  ),

                  // Sales Terms (required)
                  CustomTextField(
                    label: "Sales Terms *",
                    hint: "Enter sales terms",
                    controller: salesTermsController,
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                text: _isProfileCompleted ? "Update Profile" : "Save Profile",
                onPressed: _saveProfile,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    userIdController.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    businessNameController.dispose();
    addressController.dispose();
    contactInfoController.dispose();
    taxTypeController.dispose();
    logoUrlController.dispose();
    gstinController.dispose();
    footerMessageController.dispose();
    purchaseTermsController.dispose();
    salesTermsController.dispose();
    super.dispose();
  }
}