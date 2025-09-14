import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
//import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: "Barcode Scanner"),
      // body: MobileScanner(
      //   onDetect: (barcode, args) {
      //     final String code = barcode.rawValue ?? "";
      //     if (code.isNotEmpty) {
      //       showModalBottomSheet(
      //         context: context,
      //         builder: (_) => Container(
      //           padding: EdgeInsets.all(16),
      //           height: 200,
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text("Product Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //               Text("Name: Product A"),
      //               Text("Stock: 50 kg"),
      //               Text("Price: ₹120"),
      //               Text("Expiry: 2025-12-31"),
      //               SizedBox(height: 16),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   ElevatedButton(onPressed: () {}, child: Text("Sell")),
      //                   ElevatedButton(onPressed: () {}, child: Text("Adjust Stock")),
      //                   ElevatedButton(onPressed: () {}, child: Text("Add to Order")),
      //                 ],
      //               )
      //             ],
      //           ),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
