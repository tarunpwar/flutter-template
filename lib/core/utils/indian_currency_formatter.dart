import 'package:flutter/services.dart';

/// Indian Currency Formatter that handles INR symbol, precision, and positive/negative amounts
class IndianCurrencyFormatter {
  static const String _rupeeSymbol = '₹';

  /// Formats amount as Indian currency with customizable precision
  ///
  /// [amount] - The numeric amount to format
  /// [precision] - Number of decimal places (default: 2)
  /// [showSymbol] - Whether to show ₹ symbol (default: true)
  /// [showCommas] - Whether to use Indian number system commas (default: true)
  /// [negativeFormat] - How to display negative amounts ('parentheses', 'minus', 'brackets')
  static String format(
    double amount, {
    int precision = 2,
    bool showSymbol = true,
    bool showCommas = true,
    String negativeFormat = 'minus', // 'parentheses', 'minus', 'brackets'
  }) {
    // Handle the sign
    bool isNegative = amount < 0;
    double absAmount = amount.abs();

    // Format the number with precision
    String formattedAmount = absAmount.toStringAsFixed(precision);

    if (showCommas) {
      formattedAmount = _addIndianCommas(formattedAmount);
    }

    // Add currency symbol
    if (showSymbol) {
      formattedAmount = '$_rupeeSymbol$formattedAmount';
    }

    // Handle negative formatting
    if (isNegative) {
      switch (negativeFormat.toLowerCase()) {
        case 'parentheses':
          formattedAmount = '($formattedAmount)';
          break;
        case 'brackets':
          formattedAmount = '[$formattedAmount]';
          break;
        case 'minus':
        default:
          formattedAmount = '-$formattedAmount';
          break;
      }
    }

    return formattedAmount;
  }

  /// Adds Indian number system commas (lakhs, crores)
  /// Example: 1234567.89 -> 12,34,567.89
  static String _addIndianCommas(String amount) {
    List<String> parts = amount.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    if (integerPart.length <= 3) {
      return amount;
    }

    String result = '';
    int length = integerPart.length;

    // Add commas in Indian format
    for (int i = 0; i < length; i++) {
      result += integerPart[i];
      int remainingDigits = length - i - 1;

      if (remainingDigits > 0) {
        if (remainingDigits % 2 == 0 && remainingDigits != 2) {
          result += ',';
        } else if (remainingDigits == 3) {
          result += ',';
        }
      }
    }

    return result + decimalPart;
  }

  /// Formats amount as compact Indian currency (with K, L, Cr suffixes)
  /// Example: 150000 -> ₹1.5L, 10000000 -> ₹1Cr
  static String formatCompact(
    double amount, {
    int precision = 1,
    bool showSymbol = true,
  }) {
    bool isNegative = amount < 0;
    double absAmount = amount.abs();

    String suffix = '';
    double displayAmount = absAmount;

    if (absAmount >= 10000000) {
      // 1 Crore
      displayAmount = absAmount / 10000000;
      suffix = 'Cr';
    } else if (absAmount >= 100000) {
      // 1 Lakh
      displayAmount = absAmount / 100000;
      suffix = 'L';
    } else if (absAmount >= 1000) {
      // 1 Thousand
      displayAmount = absAmount / 1000;
      suffix = 'K';
    }

    String formattedAmount = displayAmount.toStringAsFixed(precision);

    // Remove trailing zeros
    if (formattedAmount.contains('.')) {
      formattedAmount = formattedAmount.replaceAll(RegExp(r'0*$'), '');
      formattedAmount = formattedAmount.replaceAll(RegExp(r'\.$'), '');
    }

    String result = '$formattedAmount$suffix';

    if (showSymbol) {
      result = '$_rupeeSymbol$result';
    }

    if (isNegative) {
      result = '-$result';
    }

    return result;
  }

  /// Parses formatted currency string back to double
  static double parse(String formattedAmount) {
    // Remove currency symbol and whitespace
    String cleaned = formattedAmount
        .replaceAll(_rupeeSymbol, '')
        .replaceAll(',', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .trim();

    // Handle negative
    bool isNegative = formattedAmount.contains('-') ||
        formattedAmount.contains('(') ||
        formattedAmount.contains('[');

    double amount = double.tryParse(cleaned) ?? 0.0;
    return isNegative ? -amount : amount;
  }
}

/// TextInputFormatter for Indian currency input fields
class IndianCurrencyInputFormatter extends TextInputFormatter {
  final int precision;
  final bool showSymbol;
  final bool allowNegative;

  IndianCurrencyInputFormatter({
    this.precision = 2,
    this.showSymbol = true,
    this.allowNegative = true,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Extract numeric value
    String numericText = newValue.text.replaceAll(RegExp(r'[^0-9.-]'), '');

    if (numericText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Handle negative sign
    bool isNegative = numericText.startsWith('-') && allowNegative;
    if (isNegative) {
      numericText = numericText.substring(1);
    }

    // Parse and format
    double? amount = double.tryParse(numericText);
    if (amount == null) {
      return oldValue;
    }

    if (isNegative) {
      amount = -amount;
    }

    String formatted = IndianCurrencyFormatter.format(
      amount,
      precision: precision,
      showSymbol: showSymbol,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Extension methods for easier currency formatting
extension CurrencyExtension on double {
  /// Format as Indian currency
  String toINR({
    int precision = 2,
    bool showSymbol = true,
    bool showCommas = true,
    String negativeFormat = 'minus',
  }) {
    return IndianCurrencyFormatter.format(
      this,
      precision: precision,
      showSymbol: showSymbol,
      showCommas: showCommas,
      negativeFormat: negativeFormat,
    );
  }

  /// Format as compact Indian currency
  String toCompactINR({
    int precision = 1,
    bool showSymbol = true,
  }) {
    return IndianCurrencyFormatter.formatCompact(
      this,
      precision: precision,
      showSymbol: showSymbol,
    );
  }
}

// Example usage in a Flutter widget
/*
class CurrencyExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Indian Currency Formatter')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Standard Format:'),
            Text('${1234567.89.toINR()}'), // ₹12,34,567.89
            Text('${(-1234567.89).toINR(negativeFormat: 'parentheses')}'), // (₹12,34,567.89)
            
            SizedBox(height: 16),
            
            Text('Compact Format:'),
            Text('${1500000.0.toCompactINR()}'), // ₹1.5L
            Text('${25000000.0.toCompactINR()}'), // ₹2.5Cr
            
            SizedBox(height: 16),
            
            Text('Input Field:'),
            TextField(
              inputFormatters: [IndianCurrencyInputFormatter()],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
