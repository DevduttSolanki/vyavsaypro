import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: "Order #001"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text("Type: Sales"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Customer: ABC Pvt Ltd"),
                    Text("Date: 2025-08-22"),
                    Text("Total: ₹5000"),
                    Text("Status: Open"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Items", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: List.generate(
                  5,
                      (index) => ListTile(
                    title: Text("Product $index"),
                    subtitle: Text("Qty: 10, Price: 500"),
                    trailing: Text("₹5000"),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Convert to Invoice")),
                ElevatedButton(onPressed: () {}, child: const Text("Edit Order")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
