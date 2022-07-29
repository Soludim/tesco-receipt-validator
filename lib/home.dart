import 'package:flutter/material.dart';
import './scan_qr.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  final title = "Tesco Pay";
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(right: 6.0),
                    child: Image.asset(
                      "assets/logo.png",
                      scale: 14,
                    )),
                const Text("Receipt Validator")
              ],
            ),
          ),
          body: ScanQR()
        );
  }
}
