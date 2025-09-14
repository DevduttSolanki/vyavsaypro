import 'package:flutter/material.dart';
import '../../features/inventory/product_list.dart';
import '../../services/profile_service.dart';

class InventoryListPage extends StatefulWidget {
  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
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
      print('Loading business information...');
      final business = await _profileService.getUserBusiness();
      print('Business loaded: ${business?.businessId}');
      
      if (business != null) {
        print('Setting business ID: ${business.businessId}');
        setState(() {
          _businessId = business.businessId;
          _isLoading = false;
        });
      } else {
        print('No business found');
        setState(() => _isLoading = false);
      }
    } catch (e, stackTrace) {
      print('Error loading business: $e');
      print('Stack trace: $stackTrace');
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

    return ProductList(businessId: _businessId!);
  }
}
