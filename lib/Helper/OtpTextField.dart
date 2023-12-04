// import 'package:flutter/material.dart';
//
// class OtpInput extends StatelessWidget {
//   final TextEditingController controller;
//   final bool autoFocus;
//   final String? Function(String?)? validator;
//   const OtpInput(this.controller,  {required this.autoFocus,required this.validator,Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       width: 48,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3), // Set the shadow color and opacity
//             spreadRadius: 2, // Adjust the spread radius of the shadow
//             blurRadius: 4, // Adjust the blur radius of the shadow
//             offset: Offset(0, 2), // Adjust the shadow offset
//           ),
//         ],
//         borderRadius: BorderRadius.circular(12), // Set the same borderRadius as the commented out border property in InputDecoration
//         color: Colors.white, // Set the background color of the container to match the filled color in InputDecoration
//       ),
//       child: TextFormField(
//         validator: validator,
//         autofocus: autoFocus,
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         controller: controller,
//         maxLength: 1,
//         cursorColor: Theme.of(context).primaryColor,
//         decoration: const InputDecoration(
//             // border: InputBorder.none,
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)),borderSide: BorderSide.none),
//             counterText: '',
//             hintStyle: TextStyle(color: Colors.grey, fontSize: 20.0)),
//         onChanged: (value) {
//           if (value.length == 1) {
//             FocusScope.of(context).nextFocus();
//           }
//           if (value.length == 0) {
//               FocusScope.of(context).previousFocus();
//           }
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

class OtpBox extends StatefulWidget {
  final int length;
  final void Function(String) onOtpEntered;

  OtpBox({required this.length, required this.onOtpEntered});

  @override
  _OtpBoxState createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> {
  List<String> otpDigits = List.filled(6, '');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.length,
              (index) => buildDigitField(index),
        ),
      ),
    );
  }

  Widget buildDigitField(int index) {
    return SizedBox(
      width: 40,
      child: TextFormField(
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        onChanged: (value) {
          setState(() {
            otpDigits[index] = value;
            if (index < widget.length - 1 && value.isNotEmpty) {
              FocusScope.of(context).nextFocus();
            }
          });
          if (value.isNotEmpty && index == widget.length - 1) {
            FocusScope.of(context).unfocus();
            _formKey.currentState!.validate();
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the OTP';
          }
          if (value.length != 1) {
            return 'Invalid OTP';
          }
          return null;
        },
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
