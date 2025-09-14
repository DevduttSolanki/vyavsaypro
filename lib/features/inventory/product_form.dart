import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/inventory_service.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../models/dto/product_dto.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/gradient_app_bar.dart';

class ProductForm extends StatefulWidget {
  final String businessId;
  final List<CategoryModel> categories;
  final ProductModel? product; // null for new product

  const ProductForm({
    Key? key,
    required this.businessId,
    required this.categories,
    this.product,
  }) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final InventoryService _inventoryService = InventoryService();
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _gstRateController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _batchNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _lowStockThresholdController = TextEditingController();
  
  // Form state
  String? _selectedCategoryId;
  DateTime? _expiryDate;
  bool _isLoading = false;
  bool _isQuickAdd = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void didUpdateWidget(ProductForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If categories were loaded after the widget was created
    if (oldWidget.categories.isEmpty && widget.categories.isNotEmpty) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    if (widget.product != null) {
      // Edit mode
      final product = widget.product!;
      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _quantityController.text = product.quantity.toString();
      _gstRateController.text = product.gstRate.toString();
      _barcodeController.text = product.barcode ?? '';
      _batchNumberController.text = product.batchNumber ?? '';
      _locationController.text = product.location ?? '';
      _unitController.text = product.unitOfMeasurement ?? '';
      _lowStockThresholdController.text = product.lowStockThreshold.toString();
      _selectedCategoryId = product.categoryId;
      _expiryDate = product.expiryDate?.toDate();
    } else {
      // New product mode
      _gstRateController.text = '0';
      _lowStockThresholdController.text = '10';
      if (widget.categories.isNotEmpty) {
        _selectedCategoryId = widget.categories.first.categoryId;
      } else {
        _selectedCategoryId = null; // Will be set when categories load
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _gstRateController.dispose();
    _barcodeController.dispose();
    _batchNumberController.dispose();
    _locationController.dispose();
    _unitController.dispose();
    _lowStockThresholdController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      // Handle fallback category
      String categoryId = _selectedCategoryId ?? '';
      if (categoryId == 'general' && widget.categories.isNotEmpty) {
        // Use the first available category as fallback
        categoryId = widget.categories.first.categoryId;
      }

      final productDto = ProductDto(
        productId: widget.product?.productId,
        businessId: widget.businessId,
        categoryId: categoryId,
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        gstRate: double.parse(_gstRateController.text),
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        batchNumber: _batchNumberController.text.trim().isEmpty ? null : _batchNumberController.text.trim(),
        expiryDate: _expiryDate,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        unitOfMeasurement: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
        lowStockThreshold: int.parse(_lowStockThresholdController.text),
      );

      String? productId;
      if (widget.product != null) {
        // Update existing product
        final updates = productDto.toMap();
        updates.remove('product_id'); // Don't update the ID
        updates.remove('created_at'); // Don't update creation date
        
        final success = await _inventoryService.updateProduct(
          widget.product!.productId,
          updates,
        );
        
        if (success) {
          productId = widget.product!.productId;
        } else {
          throw Exception('Failed to update product');
        }
      } else {
        // Create new product
        productId = await _inventoryService.addProduct(productDto);
        if (productId == null) {
          throw Exception('Failed to create product');
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product != null 
                ? 'Product updated successfully' 
                : 'Product created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _quickAddProduct() async {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in name, price, and quantity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Handle fallback category for quick add
      String categoryId = _selectedCategoryId ?? '';
      if (categoryId == 'general' && widget.categories.isNotEmpty) {
        categoryId = widget.categories.first.categoryId;
      } else if (categoryId.isEmpty && widget.categories.isNotEmpty) {
        categoryId = widget.categories.first.categoryId;
      }

      final quickAddDto = QuickAddProductDto(
        businessId: widget.businessId,
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        categoryId: categoryId,
      );

      final productId = await _inventoryService.quickAddProduct(quickAddDto);
      if (productId != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: widget.product != null ? 'Edit Product' : 'Add Product',
        actions: [
          if (widget.product == null) // Only show for new products
            TextButton(
              onPressed: () {
                setState(() => _isQuickAdd = !_isQuickAdd);
              },
              child: Text(
                _isQuickAdd ? 'Full Form' : 'Quick Add',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Product Name (Required)
              CustomTextField(
                controller: _nameController,
                label: 'Product Name',
                hint: 'Enter product name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Category (Required)
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: widget.categories.isEmpty 
                  ? [
                      const DropdownMenuItem(
                        value: 'loading',
                        child: Text('Loading categories...'),
                      ),
                      const DropdownMenuItem(
                        value: 'general',
                        child: Text('General (Fallback)'),
                      ),
                    ]
                  : widget.categories.map((category) {
                      print('Category: ${category.name} (${category.categoryId})');
                      return DropdownMenuItem(
                        value: category.categoryId,
                        child: Text(category.name),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != 'loading') {
                    setState(() => _selectedCategoryId = value);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value == 'loading') {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Price (Required)
              CustomTextField(
                controller: _priceController,
                label: 'Price',
                hint: 'Enter price',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price < 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Quantity (Required)
              CustomTextField(
                controller: _quantityController,
                label: 'Quantity',
                hint: 'Enter quantity',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity is required';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity < 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // GST Rate (Required)
              CustomTextField(
                controller: _gstRateController,
                label: 'GST Rate (%)',
                hint: 'Enter GST rate',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'GST rate is required';
                  }
                  final gstRate = double.tryParse(value);
                  if (gstRate == null || gstRate < 0) {
                    return 'Please enter a valid GST rate';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Low Stock Threshold (Required)
              CustomTextField(
                controller: _lowStockThresholdController,
                label: 'Low Stock Threshold',
                hint: 'Enter threshold',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Low stock threshold is required';
                  }
                  final threshold = int.tryParse(value);
                  if (threshold == null || threshold < 0) {
                    return 'Please enter a valid threshold';
                  }
                  return null;
                },
              ),
              
              // Only show optional fields if not in quick add mode
              if (!_isQuickAdd) ...[
                const SizedBox(height: 16),
                
                // Barcode (Optional)
                CustomTextField(
                  controller: _barcodeController,
                  label: 'Barcode',
                  hint: 'Enter or scan barcode',
                ),
                
                const SizedBox(height: 16),
                
                // Unit of Measurement (Optional)
                CustomTextField(
                  controller: _unitController,
                  label: 'Unit of Measurement',
                  hint: 'e.g., kg, pieces, liters',
                ),
                
                const SizedBox(height: 16),
                
                // Location (Optional)
                CustomTextField(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'e.g., Warehouse A, Shelf 1',
                ),
                
                const SizedBox(height: 16),
                
                // Batch Number (Optional)
                CustomTextField(
                  controller: _batchNumberController,
                  label: 'Batch Number',
                  hint: 'Enter batch number',
                ),
                
                const SizedBox(height: 16),
                
                // Expiry Date (Optional)
                ListTile(
                  title: Text(_expiryDate == null 
                    ? 'Select Expiry Date (Optional)' 
                    : 'Expiry Date: ${_expiryDate!.toString().substring(0, 10)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _expiryDate = picked);
                    }
                  },
                ),
                
                if (_expiryDate != null)
                  TextButton(
                    onPressed: () {
                      setState(() => _expiryDate = null);
                    },
                    child: const Text('Clear Expiry Date'),
                  ),
              ],
              
              const SizedBox(height: 24),
              
              // Save Button
              CustomButton(
                text: widget.product != null ? 'Update Product' : 'Save Product',
                onPressed: _isLoading ? null : _saveProduct,
                isLoading: _isLoading,
              ),
              
              // Quick Add Button (only for new products)
              if (widget.product == null && _isQuickAdd) ...[
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Quick Add',
                  onPressed: _isLoading ? null : _quickAddProduct,
                  isLoading: _isLoading,
                  backgroundColor: Colors.green,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
