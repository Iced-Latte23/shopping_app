import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  final int maxDigits;

  PhoneNumberFormatter({this.maxDigits = 10});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters from the input
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Prvent input if the length is greater than the maxDigits
    if (text.length > maxDigits) {
      return oldValue;
    }

    // Format the phone number based on its length
    String formattedText = _formatPhoneNumber(text);

    return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length));
  }

  String _formatPhoneNumber(String phone) {
    if (phone.length <= 3) {
      return phone; // Return as is for short inputs
    } else if (phone.length <= 6) {
      return '${phone.substring(0, 3)}-${phone.substring(3)}';
    } else if (phone.length <= 10) {
      return '${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6)}';
    } else {
      return phone;
    }
  }
}
