import 'package:flutter/material.dart';

import 'assets.dart';

class MyLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.pageLoadergif, // Replace 'your_loader.gif' with the actual filename of your GIF
          width: 100.0, // Set the width of the loader
          height: 100.0, // Set the height of the loader
        ),
      ),
    );
  }
}