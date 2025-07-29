import 'package:keep_nigeria_clean/constants/level.dart';

class Gas {
  final String name;
  final String description;
  final String assetPath;
  final Level level;
  final DateTime? lastUpdate;

  const Gas({
    this.name = '',
    this.description = '',
    this.assetPath = '',
    this.level = Level.nil,
    this.lastUpdate,
  });
}
