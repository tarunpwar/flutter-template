import 'dart:math' as math;

extension NumExtensions on num {
  /// Converts number to currency format
  String toCurrency({
    String symbol = '\$',
    int decimalPlaces = 2,
    String thousandSeparator = ',',
    String decimalSeparator = '.',
  }) {
    String formatted = toStringAsFixed(decimalPlaces);
    List<String> parts = formatted.split('.');

    // Add thousand separators
    String integerPart = parts[0];
    String result = '';
    for (int i = integerPart.length - 1; i >= 0; i--) {
      result = integerPart[i] + result;
      if ((integerPart.length - i) % 3 == 0 && i != 0) {
        result = thousandSeparator + result;
      }
    }

    if (decimalPlaces > 0) {
      result += decimalSeparator + parts[1];
    }

    return symbol + result;
  }

  /// Converts bytes to human readable format
  String toFileSize({int decimals = 1}) {
    if (this == 0) return '0 B';

    const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    int unitIndex = (math.log(this) / math.log(1024)).floor();
    double size = this / math.pow(1024, unitIndex);

    return '${size.toStringAsFixed(decimals)} ${units[unitIndex]}';
  }

  /// Converts number to percentage
  String toPercentage({int decimalPlaces = 1}) {
    return '${(this * 100).toStringAsFixed(decimalPlaces)}%';
  }

  /// Formats number with thousand separators
  String toFormattedString({String separator = ','}) {
    String str = toString();
    if (str.length <= 3) return str;

    // Handle decimal part
    List<String> parts = str.split('.');
    String integerPart = parts[0];
    String result = '';

    for (int i = integerPart.length - 1; i >= 0; i--) {
      result = integerPart[i] + result;
      if ((integerPart.length - i) % 3 == 0 && i != 0) {
        result = separator + result;
      }
    }

    if (parts.length > 1) {
      result += '.${parts[1]}';
    }

    return result;
  }

  /// Converts seconds to duration string (e.g., "1h 23m 45s")
  String toDurationString({bool includeSeconds = true}) {
    int totalSeconds = toInt();

    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    List<String> parts = [];

    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (includeSeconds && seconds > 0) parts.add('${seconds}s');

    return parts.isEmpty ? '0s' : parts.join(' ');
  }

  /// Checks if number is between two values (inclusive)
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  /// Clamps number between min and max values
  num clamp(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Converts number to ordinal string (1st, 2nd, 3rd, etc.)
  String toOrdinal() {
    int n = toInt();
    if (n <= 0) return n.toString();

    if (n % 100 >= 11 && n % 100 <= 13) {
      return '${n}th';
    }

    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  /// Converts number to Roman numeral
  String toRoman() {
    int n = toInt();
    if (n <= 0 || n > 3999) return n.toString();

    const List<int> values = [
      1000,
      900,
      500,
      400,
      100,
      90,
      50,
      40,
      10,
      9,
      5,
      4,
      1,
    ];
    const List<String> numerals = [
      'M',
      'CM',
      'D',
      'CD',
      'C',
      'XC',
      'L',
      'XL',
      'X',
      'IX',
      'V',
      'IV',
      'I',
    ];

    String result = '';
    for (int i = 0; i < values.length; i++) {
      while (n >= values[i]) {
        result += numerals[i];
        n -= values[i];
      }
    }
    return result;
  }

  /// Checks if number is positive
  bool get isPositive => this > 0;

  /// Checks if number is negative
  bool get isNegative => this < 0;

  /// Checks if number is zero
  bool get isZero => this == 0;

  /// Checks if number is even (for integers)
  bool get isEven => this % 2 == 0;

  /// Checks if number is odd (for integers)
  bool get isOdd => this % 2 != 0;

  /// Returns absolute value
  num get abs => this < 0 ? -this : this;

  /// Returns square of the number
  num get squared => this * this;

  /// Returns cube of the number
  num get cubed => this * this * this;

  /// Returns square root
  double get sqrt => math.sqrt(this);

  /// Converts degrees to radians
  double get toRadians => this * (math.pi / 180);

  /// Converts radians to degrees
  double get toDegrees => this * (180 / math.pi);

  /// Rounds to specified decimal places
  double roundToDecimalPlaces(int decimalPlaces) {
    double factor = math.pow(10, decimalPlaces).toDouble();
    return (this * factor).round() / factor;
  }

  /// Converts to abbreviated format (1K, 1M, 1B, etc.)
  String toAbbreviated({int decimalPlaces = 1}) {
    if (abs < 1000) return toString();

    const List<String> units = ['', 'K', 'M', 'B', 'T'];
    int unitIndex = 0;
    double value = abs.toDouble();

    while (value >= 1000 && unitIndex < units.length - 1) {
      value /= 1000;
      unitIndex++;
    }

    String result = value.toStringAsFixed(decimalPlaces);
    if (result.endsWith('.0')) {
      result = result.substring(0, result.length - 2);
    }

    return (isNegative ? '-' : '') + result + units[unitIndex];
  }

  /// Converts milliseconds to time format (HH:MM:SS)
  String millisecondsToTime() {
    int totalSeconds = (this / 1000).floor();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Calculates percentage of another number
  double percentageOf(num total) {
    if (total == 0) return 0;
    return (this / total) * 100;
  }

  /// Calculates what percentage this number represents of a total
  double asPercentageOf(num total) {
    if (total == 0) return 0;
    return (this / total) * 100;
  }

  /// Maps number from one range to another
  double mapToRange(num fromMin, num fromMax, num toMin, num toMax) {
    return (this - fromMin) * (toMax - toMin) / (fromMax - fromMin) + toMin;
  }

  /// Linear interpolation between two values
  double lerp(num target, double t) {
    return this + (target - this) * t;
  }

  /// Checks if number is prime (for positive integers)
  bool get isPrime {
    int n = toInt();
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;

    for (int i = 3; i * i <= n; i += 2) {
      if (n % i == 0) return false;
    }
    return true;
  }

  /// Factorial of the number (for non-negative integers)
  int get factorial {
    int n = toInt();
    if (n < 0) {
      throw ArgumentError('Factorial is not defined for negative numbers');
    }
    if (n <= 1) return 1;

    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  /// Greatest Common Divisor with another number
  int gcd(num other) {
    int a = abs.toInt();
    int b = other.abs().toInt();

    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Least Common Multiple with another number
  int lcm(num other) {
    return (abs * other.abs()) ~/ gcd(other);
  }

  /// Converts number to words (English)
  String toWords() {
    int n = toInt();
    if (n == 0) return 'zero';

    const List<String> ones = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
    ];
    const List<String> teens = [
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen',
    ];
    const List<String> tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety',
    ];

    String convertHundreds(int num) {
      String result = '';

      if (num >= 100) {
        result += '${ones[num ~/ 100]} hundred';
        num %= 100;
        if (num > 0) result += ' ';
      }

      if (num >= 20) {
        result += tens[num ~/ 10];
        num %= 10;
        if (num > 0) result += '-';
      } else if (num >= 10) {
        result += teens[num - 10];
        return result;
      }

      if (num > 0) {
        result += ones[num];
      }

      return result;
    }

    if (n < 0) {
      return 'negative ${(-n).toWords()}';
    }

    if (n < 1000) {
      return convertHundreds(n);
    }

    // For larger numbers, this is a simplified version
    return n.toString();
  }
}


// Usage example
// double price = 1234.56;
// print(price.toCurrency()); // "$1,234.56"

// // File size
// int bytes = 1536000;
// print(bytes.toFileSize()); // "1.5 MB"

// // Duration
// int seconds = 3665;
// print(seconds.toDurationString()); // "1h 1m 5s"

// // Percentage
// double score = 0.856;
// print(score.toPercentage()); // "85.6%"

// // Abbreviated numbers
// int views = 1500000;
// print(views.toAbbreviated()); // "1.5M"

// // Ordinal numbers
// int position = 23;
// print(position.toOrdinal()); // "23rd"

// // Roman numerals
// int year = 2024;
// print(year.toRoman()); // "MMXXIV"

// // Math operations
// int num = 16;
// print(num.sqrt); // 4.0
// print(num.isPrime); // false

// // Range mapping
// double value = 50;
// double mapped = value.mapToRange(0, 100, 0, 255); // Maps 50% to 127.5

// // Validation
// int age = 25;
// print(age.isBetween(18, 65)); // true