import 'dart:io';

class AppTheme {
  static const String reset = '\x1B[0m';
  static const String bold = '\x1B[1m';
  static const String cyan = '\x1B[36m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String red = '\x1B[31m';
  static const String blue = '\x1B[34m';

  static String divider() {
    int width = stdout.terminalColumns;
    if (width <= 0) width = 80;
    return '=' * width;
  }
}
