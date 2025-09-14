import 'package:flutter/material.dart';
import '../services/profile_service.dart';

mixin ProfileCheckMixin<T extends StatefulWidget> on State<T> {
  final ProfileService _profileService = ProfileService();

  Future<void> checkProfileAndNavigate(String routeName, {Object? arguments}) async {
    final isCompleted = await _profileService.isProfileCompleted();

    if (!isCompleted) {
      // Show toast message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please complete your profile details to access this feature",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: "Go to Profile",
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
      );
      return;
    }

    // Profile is completed, navigate to the requested route
    if (arguments != null) {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    } else {
      Navigator.pushNamed(context, routeName);
    }
  }

  Future<void> checkProfileAndExecute(VoidCallback onSuccess) async {
    final isCompleted = await _profileService.isProfileCompleted();

    if (!isCompleted) {
      // Show toast message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please complete your profile details to access this feature",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: "Go to Profile",
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
      );
      return;
    }

    // Profile is completed, execute the callback
    onSuccess();
  }
}