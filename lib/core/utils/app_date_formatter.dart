import 'package:intl/intl.dart';

class AppDateFormatter {
  /// Example: 2m ago, Yesterday, Monday
  static String relative(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    final now = DateTime.now();
    final difference = now.difference(convertedDateTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    }

    if (difference.inHours < 24 && now.day == convertedDateTime.day) {
      return "${difference.inHours}h ago";
    }

    final yesterday = now.subtract(const Duration(days: 1));

    if (yesterday.day == convertedDateTime.day &&
        yesterday.month == convertedDateTime.month &&
        yesterday.year == convertedDateTime.year) {
      return "Yesterday";
    }

    if (difference.inDays < 7) {
      return DateFormat('EEEE').format(convertedDateTime);
    }

    if (now.year == convertedDateTime.year) {
      return DateFormat('MMM d').format(convertedDateTime);
    }

    return DateFormat('MMM d, yyyy').format(convertedDateTime);
  }

  /// Example: May 23, 2026
  static String fullDate(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('MMMM d, yyyy').format(convertedDateTime);
  }

  /// Example: 23 May 2026
  static String shortDate(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('d MMM yyyy').format(convertedDateTime);
  }

  /// Example: May 23
  static String monthDay(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('MMM d').format(convertedDateTime);
  }

  /// Example: Saturday, May 23, 2026
  static String dayDate(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('EEEE, MMMM d, yyyy').format(convertedDateTime);
  }

  /// Example: 10:30 AM
  static String time(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('hh:mm a').format(convertedDateTime);
  }

  /// Example: 10:30
  static String time24(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('HH:mm').format(convertedDateTime);
  }

  /// Example: May 23, 2026 • 10:30 AM
  static String dateTimeFormat(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('MMM d, yyyy • hh:mm a').format(convertedDateTime);
  }

  /// Example: 2026-05-23
  static String apiDate(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('yyyy-MM-dd').format(convertedDateTime);
  }

  /// Example: 2026-05-23T10:30:00
  static String apiDateTime(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat("yyyy-MM-ddTHH:mm:ss").format(convertedDateTime);
  }

  /// Example: 05/23/2026
  static String slashDate(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('MM/dd/yyyy').format(convertedDateTime);
  }

  /// Example: 23/05/2026
  static String europeanDate(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('dd/MM/yyyy').format(convertedDateTime);
  }

  /// Example: Sat, May 23
  static String compact(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    return DateFormat('EEE, MMM d').format(convertedDateTime);
  }

  /// Example: 2 days ago
  static String timeAgo(String dateTime) {
    DateTime convertedDateTime = DateTime.parse(dateTime);

    final difference = DateTime.now().difference(convertedDateTime);

    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()} years ago";
    }

    if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()} months ago";
    }

    if (difference.inDays > 0) {
      return "${difference.inDays} days ago";
    }

    if (difference.inHours > 0) {
      return "${difference.inHours} hours ago";
    }

    if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes ago";
    }

    return "Just now";
  }
}
