import 'package:intl/intl.dart';

/// Enhanced DateTime parser with comprehensive static methods and extension functions
class DateParser {
  // Private constructor to prevent instantiation
  DateParser._();

  // Common date format patterns
  static const Map<String, String> _commonFormats = {
    'iso8601': "yyyy-MM-ddTHH:mm:ss.SSSZ",
    'date_only': "yyyy-MM-dd",
    'us_date': "MM/dd/yyyy",
    'eu_date': "dd/MM/yyyy",
    'readable': "MMMM dd, yyyy",
    'compact': "yyyyMMdd",
    'time_12h': "h:mm a",
    'time_24h': "HH:mm",
    'datetime_readable': "MMMM dd, yyyy 'at' h:mm a",
    'rfc2822': "EEE, dd MMM yyyy HH:mm:ss Z",
  };

  // === PARSING METHODS ===

  /// Parse string with automatic format detection
  static DateTime parse(String dateString) {
    // Remove extra whitespace
    dateString = dateString.trim();
    
    // Try common formats
    for (String format in _commonFormats.values) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        continue;
      }
    }
    
    // Try built-in DateTime.parse for ISO formats
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      // Try some additional common patterns
      final additionalFormats = [
        "yyyy-MM-dd HH:mm:ss",
        "dd-MM-yyyy",
        "MM-dd-yyyy",
        "yyyy/MM/dd",
        "dd/MM/yyyy HH:mm",
        "MM/dd/yyyy HH:mm",
        "dd.MM.yyyy",
        "MM.dd.yyyy",
      ];
      
      for (String format in additionalFormats) {
        try {
          return DateFormat(format).parse(dateString);
        } catch (e) {
          continue;
        }
      }
    }
    
    throw FormatException('Unable to parse date string: $dateString');
  }

  /// Parse string with specific format
  static DateTime parseFormat(String dateString, String format) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date format: $dateString does not match $format');
    }
  }

  /// Parse string with common format name
  static DateTime parseCommon(String dateString, String formatName) {
    if (!_commonFormats.containsKey(formatName)) {
      throw ArgumentError('Unknown format name: $formatName');
    }
    try {
      return DateFormat(_commonFormats[formatName]).parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date format: $dateString does not match $formatName format');
    }
  }

  // === VALIDATION METHODS ===

  /// Validate if a string can be parsed as a date
  static bool isValid(String dateString) {
    try {
      parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validate if a string matches a specific format
  static bool isValidFormat(String dateString, String format) {
    try {
      DateFormat(format).parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if a date is valid
  static bool isValidDate(DateTime dateTime) {
    try {
      // Check for reasonable bounds
      return dateTime.year >= 1 && dateTime.year <= 9999 &&
             dateTime.month >= 1 && dateTime.month <= 12 &&
             dateTime.day >= 1 && dateTime.day <= 31;
    } catch (e) {
      return false;
    }
  }

  /// Check if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  // === FORMATTING METHODS ===

  /// Format using common format names
  static String format(DateTime dateTime, [String? formatName]) {
    formatName ??= 'readable';
    if (_commonFormats.containsKey(formatName)) {
      return DateFormat(_commonFormats[formatName]).format(dateTime);
    }
    // Assume it's a custom format pattern
    return DateFormat(formatName).format(dateTime);
  }

  /// Format with custom pattern
  static String formatCustom(DateTime dateTime, String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  // === UTILITY METHODS ===

  /// Get relative time string (e.g., "2 hours ago", "in 3 days")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.isNegative) {
      return _formatPastTime(difference.abs());
    } else {
      return _formatFutureTime(difference);
    }
  }

  static String _formatPastTime(Duration difference) {
    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? '1 day ago' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  static String _formatFutureTime(Duration difference) {
    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return years == 1 ? 'in 1 year' : 'in $years years';
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return months == 1 ? 'in 1 month' : 'in $months months';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? 'in 1 day' : 'in ${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? 'in 1 hour' : 'in ${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? 'in 1 minute' : 'in ${difference.inMinutes} minutes';
    } else {
      return 'now';
    }
  }
}

// === EXTENSION METHODS FOR DateTime ===

extension DateTimeParser on DateTime {
  // === PARSING EXTENSIONS ===
  
  /// Parse from string with automatic format detection
  static DateTime parseString(String dateString) => DateParser.parse(dateString);
  
  /// Parse from string with specific format
  static DateTime parseWithFormat(String dateString, String format) => 
      DateParser.parseFormat(dateString, format);
  
  /// Parse from string with common format name
  static DateTime parseCommon(String dateString, String formatName) => 
      DateParser.parseCommon(dateString, formatName);

  // === ADDITION AND SUBTRACTION EXTENSIONS ===

  /// Add years
  DateTime addYears(int years) {
    return DateTime(year + years, month, day, hour, minute, second, millisecond, microsecond);
  }

  /// Subtract years
  DateTime subtractYears(int years) => addYears(-years);

  /// Add months with smart day overflow handling
  DateTime addMonths(int months) {
    int newMonth = month + months;
    int newYear = year;
    
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }
    
    // Handle day overflow (e.g., Jan 31 + 1 month should be Feb 28/29)
    int newDay = day;
    int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > daysInNewMonth) {
      newDay = daysInNewMonth;
    }
    
    return DateTime(newYear, newMonth, newDay, hour, minute, second, millisecond, microsecond);
  }

  /// Subtract months
  DateTime subtractMonths(int months) => addMonths(-months);

  /// Add days
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add hours
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Subtract hours
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));

  /// Add minutes
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Subtract minutes
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));

  /// Add seconds
  DateTime addSeconds(int seconds) => add(Duration(seconds: seconds));

  /// Subtract seconds
  DateTime subtractSeconds(int seconds) => subtract(Duration(seconds: seconds));

  // === COMPARISON EXTENSIONS ===

  /// Check if this date is the same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Check if this date is today
  bool get isToday => isSameDay(DateTime.now());

  /// Check if this date is yesterday
  bool get isYesterday => isSameDay(DateTime.now().subtractDays(1));

  /// Check if this date is tomorrow
  bool get isTomorrow => isSameDay(DateTime.now().addDays(1));

  /// Check if this date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if this date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if date is between two dates (inclusive)
  bool isBetween(DateTime start, DateTime end) {
    return (isAfter(start) || isAtSameMomentAs(start)) &&
           (isBefore(end) || isAtSameMomentAs(end));
  }

  /// Check if this date is a weekend
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Check if this date is a weekday
  bool get isWeekday => !isWeekend;

  /// Check if this is a leap year
  bool get isLeapYear => DateParser.isLeapYear(year);

  /// Check if this is a valid date
  bool get isValidDate => DateParser.isValidDate(this);

  // === RELATIVE TIME EXTENSIONS ===

  /// Get relative time string (e.g., "2 hours ago", "in 3 days")
  String get relativeTime => DateParser.getRelativeTime(this);

  /// Get time until this date
  Duration get timeUntil => difference(DateTime.now());

  /// Get time since this date
  Duration get timeSince => DateTime.now().difference(this);

  // === FORMATTING EXTENSIONS ===

  /// Format using common format names or custom patterns
  String format([String? formatName]) => DateParser.format(this, formatName);

  /// Format with custom pattern
  String formatCustom(String pattern) => DateParser.formatCustom(this, pattern);

  // === UTILITY EXTENSIONS ===

  /// Get start of day (00:00:00.000)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get start of year
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Get end of year
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    int daysFromMonday = weekday - 1;
    return subtractDays(daysFromMonday).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    int daysUntilSunday = 7 - weekday;
    return addDays(daysUntilSunday).endOfDay;
  }

  /// Get the number of days in this month
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// Get the day of year (1-366)
  int get dayOfYear => difference(DateTime(year, 1, 1)).inDays + 1;

  /// Get week of year
  int get weekOfYear {
    DateTime firstDayOfYear = DateTime(year, 1, 1);
    int daysSinceFirstDay = difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
  }

  /// Get quarter of year (1-4)
  int get quarter => ((month - 1) / 3).floor() + 1;

  /// Clone this DateTime
  DateTime clone() => DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: isUtc);
}

// === EXTENSION METHODS FOR String ===

extension StringDateParser on String {
  /// Parse this string as a DateTime with automatic format detection
  DateTime toDateTime() => DateParser.parse(this);

  /// Parse this string as a DateTime with specific format
  DateTime toDateTimeFormat(String format) => DateParser.parseFormat(this, format);

  /// Parse this string as a DateTime with common format name
  DateTime toDateTimeCommon(String formatName) => DateParser.parseCommon(this, formatName);

  /// Check if this string is a valid date
  bool get isValidDate => DateParser.isValid(this);

  /// Check if this string matches a specific date format
  bool isValidDateFormat(String format) => DateParser.isValidFormat(this, format);
}

// === USAGE EXAMPLES ===
// void main() {
//   // Using static methods
//   debugPrint('=== Static Methods ===');
//   var parsedDate = DateParser.parse('2024-03-15');
//   debugPrint('Parsed: ${DateParser.format(parsedDate, 'readable')}');
//   debugPrint('Is valid: ${DateParser.isValid('2024-02-30')}');
//   debugPrint('Relative time: ${DateParser.getRelativeTime(parsedDate)}');

//   // Using DateTime extensions
//   debugPrint('\n=== DateTime Extensions ===');
//   var now = DateTime.now();
//   debugPrint('Now: ${now.format('datetime_readable')}');
//   debugPrint('Tomorrow: ${now.addDays(1).format('readable')}');
//   debugPrint('Next month: ${now.addMonths(1).format('readable')}');
//   debugPrint('Is today: ${now.isToday}');
//   debugPrint('Is weekend: ${now.isWeekend}');
//   debugPrint('Start of day: ${now.startOfDay}');
//   debugPrint('End of month: ${now.endOfMonth.format('datetime_readable')}');
//   debugPrint('Quarter: ${now.quarter}');
//   debugPrint('Week of year: ${now.weekOfYear}');

//   // Using String extensions
//   debugPrint('\n=== String Extensions ===');
//   var dateString = '2024-12-25';
//   debugPrint('String: $dateString');
//   debugPrint('To DateTime: ${dateString.toDateTime().format('readable')}');
//   debugPrint('Is valid: ${dateString.isValidDate}');
//   debugPrint('Is Christmas weekend: ${dateString.toDateTime().isWeekend}');

//   // Chaining operations
//   debugPrint('\n=== Chaining Operations ===');
//   var christmas = '2024-12-25'.toDateTime();
//   var newYear = christmas.addDays(7).startOfDay;
//   debugPrint('Christmas: ${christmas.format('readable')}');
//   debugPrint('New Year: ${newYear.format('datetime_readable')}');
//   debugPrint('Days between: ${newYear.difference(christmas).inDays}');
  
//   // Comparisons and validations
//   debugPrint('\n=== Comparisons ===');
//   var date1 = DateTime.now();
//   var date2 = date1.addMonths(3);
//   debugPrint('Date1: ${date1.format()}');
//   debugPrint('Date2: ${date2.format()}');
//   debugPrint('Date2 is after Date1: ${date2.isAfter(date1)}');
//   debugPrint('Same day: ${date1.isSameDay(date2)}');
//   debugPrint('Date2 relative time: ${date2.relativeTime}');
// }