import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';

class DeliveryChallanPage extends StatelessWidget {
  const DeliveryChallanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: "Delivery Challans",
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text("Order #00$index"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Customer: ABC Pvt Ltd"),
                Text("Date: 2025-08-22"),
                Text("Status: Pending"),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () {},
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload_file),
        onPressed: () {},
      ),
    );
  }
}
