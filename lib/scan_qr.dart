import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../widgets/qr_code_scan.dart';
import './utils.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  bool isScanning = false;
  bool isLoading = false;

  void toggleIsLoading(bool loading) {
    if (mounted) setState(() => isLoading = loading);
  }

  void toggleQRScanning(bool scan) {
    if (mounted) setState(() => isScanning = scan);
  }

  void verifyReceiptCode(String id) async {
    // 1-valid 2-invalid 3-already verified
    int status;
    String alertDialogTitle = "";
    var transaction;
    Uri shoppingsUrl =
        Uri.parse('${Utils.databaseEndPoint}/shoppings/$id.json');

    try {
      toggleIsLoading(true); // turn on loading
      http.Response response =
          await http.get(shoppingsUrl, headers: Utils.customHeaders);

      toggleIsLoading(false); // turn off loading

      if (response.statusCode == 200) transaction = json.decode(response.body);
      if (transaction == null) {
        // invalid receipt
        status = 2;
        alertDialogTitle = "Invalid Receipt";
      } else if (!transaction["receipt-checked"]) {
        // valid receipt
        status = 1;
        alertDialogTitle = "Valid Receipt";

        // update receipt-checked
        await http.patch(shoppingsUrl,
            headers: Utils.customHeaders,
            body: json.encode({"receipt-checked": true}));
      } else {
        // receipt already verified
        status = 3;
        alertDialogTitle = "Receipt Already Verified";
      }

      openDialogue(status, alertDialogTitle);
    } catch (e) {
      const snackBar = SnackBar(
        content: Text("Something went wrong. Please Check Netwerk"),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isScanning
        ? QRCodeScan(
            toggleQRScanning: toggleQRScanning,
            verifyReceiptCode: verifyReceiptCode)
        : Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(width: 250, "assets/qr_code.png"),
                ElevatedButton(
                  onPressed: () => setState(() => toggleQRScanning(true)),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.qr_code_scanner_sharp),
                    SizedBox(width: 4.0),
                    Text("Scan Receipt")
                  ]),
                )
              ],
            ));
  }

  Future openDialogue(int status, String title) => showDialog(
      // status = 1-valid 2-invalid 3-already verified
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: status == 1
                ? const Icon(
                    Icons.check_circle_outline,
                    size: 140,
                    color: Colors.lightGreen,
                  )
                : (status == 2
                    ? const Icon(
                        Icons.highlight_off_rounded,
                        size: 140,
                        color: Colors.redAccent,
                      )
                    : const Icon(
                        Icons.info_outline,
                        size: 140,
                        color: Colors.yellow,
                      )),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"))
            ],
          ));
}
