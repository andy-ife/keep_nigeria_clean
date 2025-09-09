import 'package:keep_nigeria_clean/constants/level.dart';
import 'package:keep_nigeria_clean/models/gas.dart';

class Helper {
  static String formatTime24Hour(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static void sortGasesByLevel(List<Gas> gases) {
    gases.sort((a, b) {
      int levelValue(Level level) {
        if (level == Level.high) return 3;
        if (level == Level.medium) return 2;
        if (level == Level.low) return 1;
        return 0; // For Level.nil or others
      }

      return levelValue(b.level).compareTo(levelValue(a.level));
    });
  }

  static String formatInterval(int milliseconds) {
    if (milliseconds >= 60000) {
      final minutes = milliseconds / 60000;
      return '${minutes.toStringAsFixed(1)} minute${minutes != 1 ? 's' : ''}';
    } else if (milliseconds >= 1000) {
      final seconds = milliseconds / 1000;
      return '${seconds.toStringAsFixed(1)} second${seconds != 1 ? 's' : ''}';
    } else {
      return '$milliseconds millisecond${milliseconds != 1 ? 's' : ''}';
    }
  }

  static double doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
