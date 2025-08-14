class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  static String? password(String? value, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
  }) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }

    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (requireNumbers && !value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (requireSpecialChars && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Phone number validation (supports various formats)
  static String? phoneNumber(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Phone number is required' : null;
    }

    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check for common phone number lengths
    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    // Basic phone number pattern (supports international formats)
    final phoneRegex = RegExp(r'^[\+]?[0-9\s\-\(\)]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Name validation
  static String? name(String? value, {
    int minLength = 2,
    int maxLength = 50,
    bool allowNumbers = false,
    bool isRequired = true,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Name is required' : null;
    }

    if (value.trim().length < minLength) {
      return 'Name must be at least $minLength characters long';
    }

    if (value.length > maxLength) {
      return 'Name must not exceed $maxLength characters';
    }

    if (!allowNumbers && value.contains(RegExp(r'[0-9]'))) {
      return 'Name cannot contain numbers';
    }

    // Check for valid name characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Minimum length validation
  static String? minLength(String? value, int length, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return null; // Let required validator handle empty values
    }

    if (value.length < length) {
      return '$fieldName must be at least $length characters long';
    }

    return null;
  }

  // Maximum length validation
  static String? maxLength(String? value, int length, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > length) {
      return '$fieldName must not exceed $length characters';
    }

    return null;
  }

  // Numeric validation
  static String? numeric(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'This field is required' : null;
    }

    final numericRegex = RegExp(r'^-?[0-9]+\.?[0-9]*$');
    if (!numericRegex.hasMatch(value)) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Integer validation
  static String? integer(String? value, {
    bool isRequired = true,
    int? min,
    int? max,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'This field is required' : null;
    }

    final intValue = int.tryParse(value);
    if (intValue == null) {
      return 'Please enter a valid integer';
    }

    if (min != null && intValue < min) {
      return 'Value must be at least $min';
    }

    if (max != null && intValue > max) {
      return 'Value must not exceed $max';
    }

    return null;
  }

  // URL validation
  static String? url(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'URL is required' : null;
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Date validation (DD/MM/YYYY or MM/DD/YYYY)
  static String? date(String? value, {
    bool isRequired = true,
    String format = 'DD/MM/YYYY',
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Date is required' : null;
    }

    try {
      final parts = value.split('/');
      if (parts.length != 3) {
        return 'Please enter date in $format format';
      }

      int day, month, year;
      
      if (format == 'DD/MM/YYYY') {
        day = int.parse(parts[0]);
        month = int.parse(parts[1]);
        year = int.parse(parts[2]);
      } else {
        month = int.parse(parts[0]);
        day = int.parse(parts[1]);
        year = int.parse(parts[2]);
      }

      final date = DateTime(year, month, day);
      
      // Check if the date is valid
      if (date.year != year || date.month != month || date.day != day) {
        return 'Please enter a valid date';
      }

      return null;
    } catch (e) {
      return 'Please enter a valid date in $format format';
    }
  }

  // Age validation
  static String? age(String? value, {
    int minAge = 0,
    int maxAge = 150,
    bool isRequired = true,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Age is required' : null;
    }

    final ageValue = int.tryParse(value);
    if (ageValue == null) {
      return 'Please enter a valid age';
    }

    if (ageValue < minAge) {
      return 'Age must be at least $minAge';
    }

    if (ageValue > maxAge) {
      return 'Age must not exceed $maxAge';
    }

    return null;
  }

  // Credit card validation (basic Luhn algorithm)
  static String? creditCard(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Credit card number is required' : null;
    }

    // Remove spaces and dashes
    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cardNumber)) {
      return 'Credit card number can only contain digits';
    }

    // Check length (most cards are 13-19 digits)
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Please enter a valid credit card number';
    }

    // Luhn algorithm validation
    if (!_isValidLuhn(cardNumber)) {
      return 'Please enter a valid credit card number';
    }

    return null;
  }

  // Helper method for Luhn algorithm
  static bool _isValidLuhn(String cardNumber) {
    int sum = 0;
    bool isEven = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit = digit ~/ 10 + digit % 10;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }

  // Combine multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }

  // Custom regex validation
  static String? regex(String? value, RegExp pattern, String errorMessage, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'This field is required' : null;
    }

    if (!pattern.hasMatch(value)) {
      return errorMessage;
    }

    return null;
  }
}

// Example usage of combining validators
// In your TextFormField
// TextFormField(
//   validator: Validators.email,
//   decoration: InputDecoration(labelText: 'Email'),
// )

// Password with custom requirements
// TextFormField(
//   validator: (value) => Validators.password(
//     value,
//     minLength: 6,
//     requireSpecialChars: false,
//   ),
//   obscureText: true,
//   decoration: InputDecoration(labelText: 'Password'),
// )

// // Combining multiple validators
// TextFormField(
//   validator: Validators.combine([
//     Validators.required,
//     (value) => Validators.minLength(value, 3),
//     (value) => Validators.maxLength(value, 20),
//   ]),
//   decoration: InputDecoration(labelText: 'Username'),
// )

// // Custom validation with regex
// TextFormField(
//   validator: (value) => Validators.regex(
//     value,
//     RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{2}$'),
//     'Please enter a valid format (e.g., AB12CD)',
//   ),
// )