import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';

class AddEditOrderPage extends StatefulWidget {
  const AddEditOrderPage({super.key});

  @override
  State<AddEditOrderPage> createState() => _AddEditOrderPageState();
}

class _AddEditOrderPageState extends State<AddEditOrderPage> {
  String orderType = "Sales";
  String? customer;
  String? supplier;
  DateTime? orderDate;
  List<Map<String, dynamic>> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: "Add/Edit Order",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Type
            Row(
              children: [
                Radio<String>(
                  value: "Sales",
                  groupValue: orderType,
                  onChanged: (val) => setState(() => orderType = val!),
                ),
                const Text("Sales"),
                Radio<String>(
                  value: "Purchase",
                  groupValue: orderType,
                  onChanged: (val) => setState(() => orderType = val!),
                ),
                const Text("Purchase"),
              ],
            ),
            const SizedBox(height: 10),
            if (orderType == "Sales")
              DropdownButtonFormField<String>(
                hint: const Text("Select Customer"),
                items: ["Customer A", "Customer B"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => customer = val,
              ),
            if (orderType == "Purchase")
              DropdownButtonFormField<String>(
                hint: const Text("Select Supplier"),
                items: ["Supplier X", "Supplier Y"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => supplier = val,
              ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(orderDate == null
                  ? "Select Order Date"
                  : orderDate.toString().substring(0, 10)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => orderDate = picked);
              },
            ),
            const SizedBox(height: 10),
            // Items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(items[index]['product'] ?? "Product"),
                    subtitle: Text(
                        "Qty: ${items[index]['qty']}, Price: ${items[index]['price']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() => items.removeAt(index));
                      },
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Add new item
                setState(() => items.add({'product': 'New Product'}));
              },
              child: const Text("Add Item"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save Order
              },
              child: const Text("Save Order"),
            ),
          ],
        ),
      ),
    );
  }
}
