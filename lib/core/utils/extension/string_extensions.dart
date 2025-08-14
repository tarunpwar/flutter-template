extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Capitalizes the first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Checks if string is a valid phone number (basic check)
  bool get isValidPhoneNumber {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(this);
  }

  /// Checks if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Removes all whitespaces
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncates string to specified length with ellipsis
  String truncate(int maxLength, [String ellipsis = '...']) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Converts string to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Converts string to camelCase
  String get toCamelCase {
    List<String> words = toLowerCase().split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;

    String result = words.first;
    for (int i = 1; i < words.length; i++) {
      result += words[i].capitalize();
    }
    return result;
  }

  /// Converts string to kebab-case
  String get toKebabCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^-'), '').toLowerCase();
  }

  /// Reverses the string
  String get reversed {
    return split('').reversed.join('');
  }

  /// Checks if string is palindrome
  bool get isPalindrome {
    String cleaned = toLowerCase().removeWhitespace;
    return cleaned == cleaned.reversed;
  }

  /// Counts occurrences of a substring
  int countOccurrences(String substring) {
    if (substring.isEmpty) return 0;
    int count = 0;
    int index = 0;
    while ((index = indexOf(substring, index)) != -1) {
      count++;
      index += substring.length;
    }
    return count;
  }

  /// Masks the string (useful for sensitive data)
  String mask({
    int visibleStart = 0,
    int visibleEnd = 0,
    String maskChar = '*',
  }) {
    if (length <= visibleStart + visibleEnd) return this;

    String start = visibleStart > 0 ? substring(0, visibleStart) : '';
    String end = visibleEnd > 0 ? substring(length - visibleEnd) : '';
    String middle = maskChar * (length - visibleStart - visibleEnd);

    return start + middle + end;
  }

  /// Extracts numbers from string
  String get extractNumbers {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Extracts letters from string
  String get extractLetters {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// Checks if string contains only alphabets
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Checks if string contains only alphanumeric characters
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Wraps text to specified width
  String wrapText(int width) {
    if (length <= width) return this;

    List<String> lines = [];
    List<String> words = split(' ');
    String currentLine = '';

    for (String word in words) {
      if ('$currentLine $word'.trim().length <= width) {
        currentLine = '$currentLine $word'.trim();
      } else {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
          currentLine = word;
        } else {
          lines.add(word);
        }
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines.join('\n');
  }

  /// Converts string to title case
  String get toTitleCase {
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  /// Removes HTML tags from string
  String get removeHtmlTags {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Pluralizes the string (basic English rules)
  String pluralize([int count = 2]) {
    if (count == 1) return this;

    if (endsWith('y')) {
      return '${substring(0, length - 1)}ies';
    } else if (endsWith('s') ||
        endsWith('sh') ||
        endsWith('ch') ||
        endsWith('x') ||
        endsWith('z')) {
      return '${this}es';
    } else {
      return '${this}s';
    }
  }

  /// Converts first character to lowercase
  String get uncapitalize {
    if (isEmpty) return this;
    return this[0].toLowerCase() + substring(1);
  }
}

// Usage example
// String email = "john@example.com";
// print(email.isValidEmail); // true

// String name = "john doe";
// print(name.capitalizeWords()); // "John Doe"

// String text = "This is a very long text that needs truncation";
// print(text.truncate(20)); // "This is a very long..."

// String phone = "1234567890";
// print(phone.mask(visibleStart: 3, visibleEnd: 2)); // "123*****90"