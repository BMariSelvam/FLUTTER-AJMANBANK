import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;


class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    required this.decimalRange,
    required this.maxDigitsBeforeDecimal,
  })  : assert(decimalRange > 0),
        assert(maxDigitsBeforeDecimal >= 0 && maxDigitsBeforeDecimal <= 5);

  final int decimalRange;
  final int maxDigitsBeforeDecimal;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    } else if (value.contains(".")) {
      String tempValue = value.substring(value.indexOf(".") + 1);
      if (tempValue.contains(".")) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
      if (value.indexOf(".") == 0) {
        truncated = "0" + truncated;
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
    }
    if (value.contains(" ") || value.contains("-")) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }

    // Check the number of digits before the decimal point
    int digitsBeforeDecimal = value.split('.').first.length;
    if (digitsBeforeDecimal > maxDigitsBeforeDecimal) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}



//
// class DecimalTextInputFormatter extends TextInputFormatter {
//   DecimalTextInputFormatter({required this.decimalRange})
//       : assert(decimalRange > 0);
//
//   final int decimalRange;
//
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue,
//       TextEditingValue newValue,
//       ) {
//     TextSelection newSelection = newValue.selection;
//     String truncated = newValue.text;
//
//     String value = newValue.text;
//
//     if (value.contains(".") &&
//         value.substring(value.indexOf(".") + 1).length > decimalRange) {
//       truncated = oldValue.text;
//       newSelection = oldValue.selection;
//     } else if (value == ".") {
//       truncated = "0.";
//
//       newSelection = newValue.selection.copyWith(
//         baseOffset: math.min(truncated.length, truncated.length + 1),
//         extentOffset: math.min(truncated.length, truncated.length + 1),
//       );
//     } else if (value.contains(".")) {
//       String tempValue = value.substring(value.indexOf(".") + 1);
//       if (tempValue.contains(".")) {
//         truncated = oldValue.text;
//         newSelection = oldValue.selection;
//       }
//       if (value.indexOf(".") == 0) {
//         truncated = "0" + truncated;
//         newSelection = newValue.selection.copyWith(
//           baseOffset: math.min(truncated.length, truncated.length + 1),
//           extentOffset: math.min(truncated.length, truncated.length + 1),
//         );
//       }
//     }
//     if (value.contains(" ") || value.contains("-")) {
//       truncated = oldValue.text;
//       newSelection = oldValue.selection;
//     }
//
//     return TextEditingValue(
//       text: truncated,
//       selection: newSelection,
//       composing: TextRange.empty,
//     );
//   }
// }