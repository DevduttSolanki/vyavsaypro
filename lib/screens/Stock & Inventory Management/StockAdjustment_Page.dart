import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/gradient_app_bar.dart';


class StockAdjustmentPage extends StatefulWidget {
  @override
  State<StockAdjustmentPage> createState() => _StockAdjustmentPageState();
}

class _StockAdjustmentPageState extends State<StockAdjustmentPage> {
  String? product;
  String action = "Add";
  final TextEditingController qtyController = TextEditingController();
  String? location;
  final TextEditingController notesController = TextEditingController();

  final List<String> products = ["Product A", "Product B"];
  final List<String> locations = ["Warehouse A", "Warehouse B"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: "Stock Adjustment",
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: product,
              items: products.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => product = val),
              decoration: InputDecoration(labelText: "Select Product"),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Add Stock"),
                    value: "Add",
                    groupValue: action,
                    onChanged: (val) => setState(() => action = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Remove Stock"),
                    value: "Remove",
                    groupValue: action,
                    onChanged: (val) => setState(() => action = val!),
                  ),
                ),
              ],
            ),
            CustomTextField(controller: qtyController, label: "Quantity", hint: "Enter quantity"),
            DropdownButtonFormField<String>(
              value: location,
              items: locations.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => location = val),
              decoration: InputDecoration(labelText: "Location"),
            ),
            CustomTextField(controller: notesController, label: "Notes", hint: "Reason for adjustment"),
            SizedBox(height: 16),
            CustomButton(text: "Save Adjustment", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
