import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/colors.dart';
import '../../Helper/fonts.dart';

class RegistrationTouchSuccessFully extends StatefulWidget {
  const RegistrationTouchSuccessFully({Key? key}) : super(key: key);

  @override
  State<RegistrationTouchSuccessFully> createState() =>
      _RegistrationTouchSuccessFullyState();
}

class _RegistrationTouchSuccessFullyState
    extends State<RegistrationTouchSuccessFully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.innerBackground),
                    fit: BoxFit.fill)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ))),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Text(
                  'Setting up',
                  style: TextStyle(
                      fontFamily: MyFont.myFont,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1.0,
                      color: MyColors.gray),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Text(
                  'Your Touch ID',
                  style: TextStyle(
                      fontFamily: MyFont.myFont,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 1.0,
                      color: MyColors.darkGray),
                ),
              ),
              Center(child: Image.asset(Assets.approve)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Center(
                  child: Text(
                    'Registration Successfully Completed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: MyFont.myFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        letterSpacing: 0.5,
                        color: MyColors.darkGray),
                  ),
                ),
              ),
              Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'You can now to use ',
                      style: TextStyle(
                          fontFamily: MyFont.myFont,
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                          color: MyColors.darkGray)),
                  TextSpan(
                      text: 'Touch ID ',
                      style: TextStyle(
                          fontFamily: MyFont.myFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: MyColors.darkGray)),
                  TextSpan(
                      text: 'to ',
                      style: TextStyle(
                          fontFamily: MyFont.myFont,
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                          color: MyColors.darkGray)),
                  TextSpan(
                      text: '\nlogin to ',
                      style: TextStyle(
                          fontFamily: MyFont.myFont,
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                          color: MyColors.darkGray)),
                  TextSpan(
                      text: 'Ajman Bank Mobile ',
                      style: TextStyle(
                          fontFamily: MyFont.myFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: MyColors.darkGray)),
                ])),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
          onPressed: () {
            Get.toNamed(AppRoute.login);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Proceed To Login',
              style: TextStyle(
                fontFamily: MyFont.myFont,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
