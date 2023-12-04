import 'dart:async';

import 'package:ajmanbank/Helper/approute.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Helper/assets.dart';
import 'SplashScreenController.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late SplashScreenController _controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = Get.put(SplashScreenController());
    // Timer(
    //   const Duration(seconds: 2),
    //       () =>   Get.toNamed(AppRoute.registrationFirstScreen),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Assets.logo),
      ),
    );
  }
}
