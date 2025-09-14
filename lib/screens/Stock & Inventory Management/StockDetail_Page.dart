import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';

class StockDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: "Product Name",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Category: Pharma"),
                    Text("Unit: kg"),
                    Text("Current Stock: 50 kg"),
                    Text("Location: Warehouse A"),
                    Text("Batch: B12345"),
                    Text("Expiry: 2025-12-31"),
                    Text("Barcode: 1234567890"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text("Stock History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5, // Replace with Firestore query
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.history),
                  title: Text("Action: Add"),
                  subtitle: Text("Qty: 10 • User: Admin • Location: Warehouse A"),
                  trailing: Text("2025-08-22"),
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, "/add_edit_product"),
                    child: Text("Edit Product")),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, "/stock_adjustment"),
                    child: Text("Adjust Stock")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
