import 'package:flutter/material.dart';
import '../../services/inventory_service.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../widgets/gradient_app_bar.dart';
import 'product_form.dart';
import 'stock_adjustment_dialog.dart';

class ProductList extends StatefulWidget {
  final String businessId;
  final bool showLowStockOnly;
  final String? categoryId;

  const ProductList({
    Key? key,
    required this.businessId,
    this.showLowStockOnly = false,
    this.categoryId,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final InventoryService _inventoryService = InventoryService();
  final TextEditingController _searchController = TextEditingController();
  
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategoryId;
  String _sortBy = 'name'; // 'name', 'quantity', 'price'
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      
      // Load only categories that have products for this business
      final categories = await _inventoryService.getCategories(
        onlyWithProducts: true,
        businessId: widget.businessId,
      );
      
      // Load products
      final products = await _inventoryService.getProducts(
        businessId: widget.businessId,
        categoryId: _selectedCategoryId,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
        lowStockOnly: widget.showLowStockOnly,
      );
      
      setState(() {
        _categories = categories;
        _products = _sortProducts(products);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() => _isLoading = false);
    }
  }

  List<ProductModel> _sortProducts(List<ProductModel> products) {
    products.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'quantity':
          comparison = a.quantity.compareTo(b.quantity);
          break;
        case 'price':
          comparison = a.price.compareTo(b.price);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });
    return products;
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    _loadData();
  }

  void _onCategoryChanged(String? categoryId) {
    print('DEBUG UI: Category changed to: $categoryId');
    setState(() => _selectedCategoryId = categoryId);
    _loadData();
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortBy;
        _sortAscending = true;
      }
      _products = _sortProducts(_products);
    });
  }

  Future<void> _showStockAdjustmentDialog(ProductModel product) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StockAdjustmentDialog(
        product: product,
        businessId: widget.businessId,
      ),
    );
    
    if (result == true) {
      _loadData(); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: widget.showLowStockOnly ? 'Low Stock Items' : 'Inventory',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Field
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 32, // Account for padding
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Category Filter and Sort
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Categories', overflow: TextOverflow.ellipsis),
                          ),
                          ..._categories.map((category) {
                            print('DEBUG UI: Creating dropdown item for category: ${category.name} (${category.categoryId})');
                            return DropdownMenuItem(
                              value: category.categoryId,
                              child: Text(category.name, overflow: TextOverflow.ellipsis),
                            );
                          }),
                        ],
                        onChanged: _onCategoryChanged,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: const InputDecoration(
                          labelText: 'Sort By',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'name', child: Text('Name')),
                          DropdownMenuItem(value: 'quantity', child: Text('Quantity')),
                          DropdownMenuItem(value: 'price', child: Text('Price')),
                        ],
                        onChanged: (value) {
                          if (value != null) _onSortChanged(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
                      onPressed: () => _onSortChanged(_sortBy),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Products List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return _buildProductCard(product);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductForm(
                businessId: widget.businessId,
                categories: _categories,
              ),
            ),
          ).then((_) => _loadData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final isLowStock = product.isLowStock;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductForm(
                businessId: widget.businessId,
                categories: _categories,
                product: product,
              ),
            ),
          ).then((_) => _loadData());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isLowStock ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory,
                  color: isLowStock ? Colors.red : Colors.blue,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.formattedQuantity} • ${product.formattedPrice}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.barcode != null && product.barcode!.isNotEmpty)
                      Text(
                        'Barcode: ${product.barcode}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              
              // Stock Status and Actions
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 80, // Fixed width for actions column
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'LOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () => _showStockAdjustmentDialog(product),
                      tooltip: 'Adjust Stock',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
