import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    StringBuffer formatted = StringBuffer("+7");
    if (digits.length > 1) {
      formatted.write(" ");
      formatted.write(digits.substring(1, min(digits.length, 4)));
    }

    if (digits.length > 4) {
      formatted.write(" ");
      formatted.write(digits.substring(4, min(digits.length, 7)));
    }

    if (digits.length > 7) {
      formatted.write("-");
      formatted.write(digits.substring(7, min(digits.length, 9)));
    }

    if (digits.length > 9) {
      formatted.write("-");
      formatted.write(digits.substring(9, min(digits.length, 11)));
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
