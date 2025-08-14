extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime get endOfWeek {
    return add(Duration(days: 7 - weekday));
  }

  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  DateTime get startOfYear => DateTime(year, 1, 1);
  DateTime get endOfYear => DateTime(year, 12, 31);

  int get daysInMonth => DateTime(year, month + 1, 0).day;

  bool get isLeapYear {
    return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  String formatRelative() {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isTomorrow) return 'Tomorrow';
    
    final difference = DateTime.now().difference(this).inDays;
    if (difference > 0 && difference <= 7) {
      return '$difference day${difference == 1 ? '' : 's'} ago';
    } else if (difference < 0 && difference >= -7) {
      return 'In ${difference.abs()} day${difference.abs() == 1 ? '' : 's'}';
    }
    
    return timeAgo;
  }

  String format(String pattern) {
    return pattern
        .replaceAll('yyyy', year.toString())
        .replaceAll('yy', (year % 100).toString().padLeft(2, '0'))
        .replaceAll('MM', month.toString().padLeft(2, '0'))
        .replaceAll('M', month.toString())
        .replaceAll('dd', day.toString().padLeft(2, '0'))
        .replaceAll('d', day.toString())
        .replaceAll('HH', hour.toString().padLeft(2, '0'))
        .replaceAll('H', hour.toString())
        .replaceAll('mm', minute.toString().padLeft(2, '0'))
        .replaceAll('m', minute.toString())
        .replaceAll('ss', second.toString().padLeft(2, '0'))
        .replaceAll('s', second.toString());
  }

  DateTime addDays(int days) => add(Duration(days: days));
  DateTime addHours(int hours) => add(Duration(hours: hours));
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));
  DateTime addSeconds(int seconds) => add(Duration(seconds: seconds));

  DateTime subtractDays(int days) => subtract(Duration(days: days));
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));
  DateTime subtractSeconds(int seconds) => subtract(Duration(seconds: seconds));

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  String get monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String get shortMonthName {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String get weekdayName {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  String get shortWeekdayName {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}