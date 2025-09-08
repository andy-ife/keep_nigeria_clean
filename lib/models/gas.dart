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

  factory Gas.fromJson(Map<String, dynamic> json) => Gas(
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    assetPath: json['asset_path'] ?? '',
    level: Level.values.firstWhere(
      (e) => e.toString() == 'Level.${json['level']}',
      orElse: () => Level.nil,
    ),
    lastUpdate: json['last_update'] != null
        ? DateTime.tryParse(json['last_update'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'asset_path': assetPath,
    'level': level.name,
    'last_update': lastUpdate?.toIso8601String(),
  };

  Gas copyWith({
    String? name,
    String? description,
    String? assetPath,
    Level? level,
    DateTime? lastUpdate,
  }) {
    return Gas(
      name: name ?? this.name,
      description: description ?? this.description,
      assetPath: assetPath ?? this.assetPath,
      level: level ?? this.level,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
