import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirstLetterUpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;

    // Capitalize the first character only if it's lowercase
    if (text.length == 1) {
      return newValue.copyWith(
        text: text[0].toUpperCase(),
        selection: newValue.selection,
      );
    }

    // If already capitalized, keep it
    if (oldValue.text.isEmpty && text.length > 1) {
      final firstChar = text[0].toUpperCase();
      final rest = text.substring(1);
      return newValue.copyWith(
        text: '$firstChar$rest',
        selection: newValue.selection,
      );
    }

    return newValue;
  }
}
