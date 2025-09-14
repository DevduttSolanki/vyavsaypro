import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final String businessName;
  final String? logoUrl;

  DashboardPage({required this.businessName, this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Business Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: logoUrl != null
                        ? NetworkImage(logoUrl!)
                        : null,
                    child: logoUrl == null
                        ? Icon(Icons.business, size: 30, color: Colors.white)
                        : null,
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      businessName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Financial Summary
            Text("Financial Summary", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              children: [
                _dashboardCard("Invoices", "₹ 1,20,000", Icons.receipt, Colors.blue),
                _dashboardCard("Expenses", "₹ 45,000", Icons.money_off, Colors.red),
                _dashboardCard("Income", "₹ 75,000", Icons.attach_money, Colors.green),
                _dashboardCard("Outstanding", "₹ 30,000", Icons.warning, Colors.orange),
              ],
            ),

            SizedBox(height: 20),

            // Inventory Snapshot
            Text("Inventory", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _smallCard("Products", "120", Icons.inventory)),
                SizedBox(width: 10),
                Expanded(child: _smallCard("Low Stock", "8", Icons.warning)),
                SizedBox(width: 10),
                Expanded(child: _smallCard("Expiring", "3", Icons.event_busy)),
              ],
            ),

            SizedBox(height: 20),

            // Customers & Suppliers
            Text("Network", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _smallCard("Customers", "45", Icons.people)),
                SizedBox(width: 10),
                Expanded(child: _smallCard("Suppliers", "12", Icons.local_shipping)),
              ],
            ),

            SizedBox(height: 20),

            // Quick Actions
            // Text("Quick Actions", style: Theme.of(context).textTheme.titleLarge),
            // SizedBox(height: 10),
            // Wrap(
            //   spacing: 12,
            //   runSpacing: 12,
            //   children: [
            //     _actionChip(Icons.receipt, "New Invoice"),
            //     _actionChip(Icons.shopping_cart, "New Order"),
            //     _actionChip(Icons.money, "Add Expense"),
            //     _actionChip(Icons.group, "Add Customer"),
            //   ],
            // ),

          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            Spacer(),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(title, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _smallCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24, color: Colors.deepPurple),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

}
