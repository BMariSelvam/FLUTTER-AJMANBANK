import 'package:ajmanbank/Helper/size.dart';
import 'package:flutter/material.dart';

import 'fonts.dart';



class SubmitButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final Function onTap;
  const SubmitButton({Key? key, required this.isLoading, required this.onTap, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
        onTap();
      },
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.transparent,

        minimumSize:Size(width(context), 45),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          :  Text(
        title,
        style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: MyFont.myFont,
      ),
      ),
    );
  }
}
