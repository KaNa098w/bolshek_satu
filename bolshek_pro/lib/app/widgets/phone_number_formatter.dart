import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Обновлённый PhoneNumberFormatter, который гарантирует, что номер всегда начинается с "+7"
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    // Если пользователь случайно удалил или изменил префикс, принудительно добавляем "+7"
    if (!text.startsWith('+7')) {
      // Удаляем все символы, кроме цифр, и добавляем префикс
      text = '+7' + text.replaceAll(RegExp(r'[^\d]'), '');
    }

    // Извлекаем только цифры (без плюса)
    String digits = text.replaceAll(RegExp(r'[^\d]'), '');

    // Начинаем форматировать с "+7"
    StringBuffer formatted = StringBuffer('+7');
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
      selection: TextSelection.collapsed(offset: formatted.toString().length),
    );
  }
}
