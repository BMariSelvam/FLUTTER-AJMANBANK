
import 'package:flutter/material.dart';

class CheckInternetScreen extends StatefulWidget {
  const CheckInternetScreen({Key? key}) : super(key: key);

  @override
  State<CheckInternetScreen> createState() => _CheckInternetScreenState();
}

class _CheckInternetScreenState extends State<CheckInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        "Check Your Internet COnnection"
      ),
    );
  }
}
