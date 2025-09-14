import 'package:flutter/material.dart';
import '../../features/inventory/product_form.dart';
import '../../services/profile_service.dart';
import '../../services/inventory_service.dart';
import '../../models/category_model.dart';

class AddProductPage extends StatefulWidget {
  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ProfileService _profileService = ProfileService();
  final InventoryService _inventoryService = InventoryService();
  String? _businessId;
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final business = await _profileService.getUserBusiness();
      if (business != null) {
        // Ensure default categories exist
        await _inventoryService.ensureDefaultCategories();
        
        // Get all categories for add product
        final categories = await _inventoryService.getCategories(onlyWithProducts: false);
        print('Loaded ${categories.length} categories: ${categories.map((c) => c.name).toList()}');
        
        setState(() {
          _businessId = business.businessId;
          _categories = categories;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading data: $e');
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

    return ProductForm(
      businessId: _businessId!,
      categories: _categories,
    );
  }
}
