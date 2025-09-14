import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockMovementList extends StatelessWidget {
  final String? businessId;

  const StockMovementList({Key? key, required this.businessId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (businessId == null) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.info, color: Colors.grey),
          title: Text("No Business Selected"),
          subtitle: Text("Please complete your business profile"),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('stock_movements')
          .where('business_id', isEqualTo: businessId)
          .orderBy('created_at', descending: true)
          .limit(3)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Stock movements error: ${snapshot.error}');
          return Text("Error loading stock movements");
        }

        final movements = snapshot.data?.docs ?? [];

        if (movements.isEmpty) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.info, color: Colors.grey),
              title: Text("No Recent Activities"),
              subtitle: Text("Stock movements will appear here"),
            ),
          );
        }

        return FutureBuilder<List<Widget>>(
          future: Future.wait(movements.map((doc) async {
            final data = doc.data() as Map<String, dynamic>;
            final type = data['type'] ?? '';
            final qty = data['qty'] ?? 0;
            final productId = data['product_id'] as String?;
            final timestamp = (data['created_at'] as Timestamp).toDate();

            // Get product name
            String productName = 'Unknown Product';
            if (productId != null) {
              final productDoc = await FirebaseFirestore.instance
                  .collection('products')
                  .doc(productId)
                  .get();
              if (productDoc.exists) {
                final productData = productDoc.data()!;
                productName = productData['name'] ?? 'Unknown Product';
              }
            }

            IconData icon;
            Color color;
            String title;
            String subtitle;

            switch (type.toLowerCase()) {
              case 'addition':
              case 'init':
              case 'purchase':
                icon = Icons.add_circle;
                color = Colors.green;
                title = "Stock Added";
                subtitle = "+$qty • $productName";
                break;
              case 'reduction':
              case 'sale':
                icon = Icons.remove_circle;
                color = Colors.red;
                title = "Stock Reduced";
                subtitle = "-$qty • $productName";
                break;
              default:
                icon = Icons.swap_horiz;
                color = Colors.blue;
                title = "Stock Adjusted";
                subtitle = "$qty • $productName";
            }

            return Card(
              child: ListTile(
                leading: Icon(icon, color: color),
                title: Text(title),
                subtitle: Text(subtitle),
                trailing: Text(_getTimeAgo(timestamp)),
              ),
            );
          })),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text("Error loading movement details");
            }

            return Column(children: snapshot.data ?? []);
          },
        );
      },
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}