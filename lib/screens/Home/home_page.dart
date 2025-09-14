import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../mixins/profile_check_mixin.dart';
import '../../services/profile_service.dart';
import '../../models/business_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ProfileCheckMixin {
  int _selectedIndex = 0;
  String? _businessId;
  bool _isLoading = true;
  final ProfileService _profileService = ProfileService();
  BusinessModel? _businessData;

  @override
  void initState() {
    super.initState();
    _loadBusinessData();
  }

  Future<void> _loadBusinessData() async {
    try {
      setState(() => _isLoading = true);
      final business = await _profileService.getUserBusiness();
      
      setState(() {
        _businessData = business;
        _businessId = business?.businessId;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading business data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        checkProfileAndNavigate('/inventory');
        break;
      case 1:
        checkProfileAndNavigate('/staff_list');
        break;
      case 2:
        checkProfileAndNavigate('/ledger_list');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Widget _buildBusinessInfo() {
    String businessName = "Loading...";
    String businessInfo = "Loading business information...";
    
    if (!_isLoading && _businessData != null) {
      businessName = _businessData!.businessName;
      businessInfo = _businessData!.defaultTaxType == 'GST'
        ? "GST Registered\nGSTIN: ${_businessData!.gstin ?? 'Not provided'}"
        : _businessData!.defaultTaxType;
    } else if (!_isLoading) {
      businessName = "Business Profile Required";
      businessInfo = "Please complete your business profile";
    }
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          radius: 30,
          child: Icon(Icons.business, color: Theme.of(context).primaryColor),
        ),
        title: Text(businessName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(businessInfo),
      ),
    );
  }

  Widget _buildInventoryStats() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_businessId == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Unable to load inventory data", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadBusinessData,
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('business_id', isEqualTo: _businessId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text("Error loading inventory data");
        }

        final products = snapshot.data?.docs ?? [];
        int totalProducts = products.length;
        int lowStockItems = products.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final quantity = data['quantity'] as int? ?? 0;
          final threshold = data['low_stock_threshold'] as int? ?? 0;
          return threshold > 0 && quantity <= threshold;
        }).length;

        double totalValue = products.fold(0.0, (sum, doc) {
          final data = doc.data() as Map<String, dynamic>;
          final quantity = data['quantity'] as int? ?? 0;
          final price = (data['price'] as num?)?.toDouble() ?? 0.0;
          return sum + (quantity * price);
        });

        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard("Total Products", "$totalProducts", Icons.category, Colors.blue),
            _buildStatCard("Low Stock Items", "$lowStockItems", Icons.warning_amber, Colors.orange),
            _buildStatCard("Stock Value", "${totalValue.toStringAsFixed(2)}", Icons.monetization_on, Colors.green),
            FutureBuilder<int>(
              future: _getCategoryCount(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return _buildStatCard("Categories", "$count", Icons.folder, Colors.purple);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 10),
            if (title == "Stock Value") ...[
              Text("₹", 
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: color
                )
              ),
              SizedBox(height: 4),
              Text(value.replaceAll("₹", ""), // Remove the ₹ from the value since we're showing it above
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ] else
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Future<int> _getCategoryCount() async {
    if (_businessId == null) return 0;
    
    try {
      final productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('business_id', isEqualTo: _businessId)
          .get();
      
      final Set<String> uniqueCategoryIds = productsSnapshot.docs
          .map((doc) {
            final categoryId = (doc.data()['category_id'] as String?) ?? '';
            return categoryId;
          })
          .where((id) => id.isNotEmpty)
          .toSet();
      
      return uniqueCategoryIds.length;
    } catch (e) {
      print('Error getting category count: $e');
      return 0;
    }
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionButton(Icons.add, "Create Invoice", Colors.blue, 
          () => checkProfileAndNavigate('/create_invoice')),
        _buildActionButton(Icons.inventory_2, "Add Product", Colors.orange, 
          () => checkProfileAndNavigate('/add_edit_product')),
        _buildActionButton(Icons.money, "Add Income", Colors.greenAccent, 
          () => checkProfileAndNavigate('/income')),
        _buildActionButton(Icons.money, "Add Expense", Colors.red, 
          () => checkProfileAndNavigate('/expenses')),
        _buildActionButton(Icons.chat, "Chatbot", Colors.purple, 
          () => Navigator.pushNamed(context, '/chatbot')),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: "Vyavsay Pro",
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => checkProfileAndNavigate('/notify'),
          )
        ],
      ),
      drawer: AppDrawer(
        businessName: _isLoading 
          ? "Loading..." 
          : (_businessData?.businessName ?? "Complete your profile"),
        ownerImageUrl: "https://via.placeholder.com/150",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBusinessInfo(),
            SizedBox(height: 20),

            Text("Inventory Overview", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildInventoryStats(),
            SizedBox(height: 20),

            Text("Quick Actions", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildQuickActions(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.transparent,
          elevation: 0,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Ledger',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    ),
    );
  }
}