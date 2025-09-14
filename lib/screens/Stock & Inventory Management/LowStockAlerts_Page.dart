import 'package:flutter/material.dart';
import '../../features/inventory/product_list.dart';
import '../../services/profile_service.dart';

class LowStockAlertsPage extends StatefulWidget {
  @override
  State<LowStockAlertsPage> createState() => _LowStockAlertsPageState();
}

class _LowStockAlertsPageState extends State<LowStockAlertsPage> {
  final ProfileService _profileService = ProfileService();
  String? _businessId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusiness();
  }

  Future<void> _loadBusiness() async {
    try {
      final business = await _profileService.getUserBusiness();
      if (business != null) {
        setState(() {
          _businessId = business.businessId;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading business: $e');
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

    if (_businessId == null) {
      return const Scaffold(
        body: Center(
          child: Text('No business found. Please complete your profile.'),
        ),
      );
    }

    return ProductList(
      businessId: _businessId!,
      showLowStockOnly: true,
    );
  }
}
