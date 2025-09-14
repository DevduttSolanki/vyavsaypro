import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/inventory_service.dart';
import '../../models/product_model.dart';
import '../../models/dto/stock_adjustment_dto.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class StockAdjustmentDialog extends StatefulWidget {
  final ProductModel product;
  final String businessId;

  const StockAdjustmentDialog({
    Key? key,
    required this.product,
    required this.businessId,
  }) : super(key: key);

  @override
  State<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends State<StockAdjustmentDialog> {
  final InventoryService _inventoryService = InventoryService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  String _adjustmentType = 'increase'; // 'increase' or 'decrease'
  bool _isLoading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _performAdjustment() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final quantity = int.parse(_quantityController.text);
      final reason = _reasonController.text.trim();
      final location = _locationController.text.trim().isEmpty 
          ? null 
          : _locationController.text.trim();

      bool success;
      if (_adjustmentType == 'increase') {
        success = await _inventoryService.increaseStock(
          businessId: widget.businessId,
          productId: widget.product.productId,
          qty: quantity,
          reason: reason,
          userId: 'current_user', // TODO: Get from auth service
          location: location,
        );
      } else {
        success = await _inventoryService.decreaseStock(
          businessId: widget.businessId,
          productId: widget.product.productId,
          qty: quantity,
          reason: reason,
          userId: 'current_user', // TODO: Get from auth service
          location: location,
          allowNegativeStock: false,
        );
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stock ${_adjustmentType}d successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        throw Exception('Failed to adjust stock');
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
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stock Adjustment',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.product.name,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Current Stock Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Stock',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.product.formattedQuantity,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.product.isLowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'LOW STOCK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Adjustment Type
              const Text(
                'Adjustment Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Increase'),
                      subtitle: const Text('Add stock'),
                      value: 'increase',
                      groupValue: _adjustmentType,
                      onChanged: (value) {
                        setState(() => _adjustmentType = value!);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Decrease'),
                      subtitle: const Text('Remove stock'),
                      value: 'decrease',
                      groupValue: _adjustmentType,
                      onChanged: (value) {
                        setState(() => _adjustmentType = value!);
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Quantity
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
                  if (quantity == null || quantity <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  
                  // Check if decrease would result in negative stock
                  if (_adjustmentType == 'decrease') {
                    final newQuantity = widget.product.quantity - quantity;
                    if (newQuantity < 0) {
                      return 'Insufficient stock. Available: ${widget.product.quantity}';
                    }
                  }
                  
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Reason
              CustomTextField(
                controller: _reasonController,
                label: 'Reason',
                hint: 'Enter reason for adjustment',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Reason is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Location (Optional)
              CustomTextField(
                controller: _locationController,
                label: 'Location (Optional)',
                hint: 'Enter location',
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: _adjustmentType == 'increase' ? 'Increase Stock' : 'Decrease Stock',
                      onPressed: _isLoading ? null : _performAdjustment,
                      isLoading: _isLoading,
                      backgroundColor: _adjustmentType == 'increase' ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
