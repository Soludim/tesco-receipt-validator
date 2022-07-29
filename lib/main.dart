import 'package:flutter/material.dart';
import './utils.dart';
import './home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Utils.buildMaterialColor(const Color(0xff00539F)),
            primaryColor: const Color(0xffEE1C2E)),
        home: const Home());
  }
}
