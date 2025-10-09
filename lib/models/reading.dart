import 'package:keep_nigeria_clean/utils/helpers.dart';

class Reading {
  final double latitude;
  final double longitude;
  final double fillLevel;
  final double temperature;
  final double humidity;
  final double gasPpm;
  final int id;
  final DateTime timestamp;

  Reading({
    this.latitude = 9.0820,
    this.longitude = 8.6753,
    this.fillLevel = 0,
    this.temperature = 0,
    this.humidity = 0,
    this.gasPpm = 0,
    this.id = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'fill_level': fillLevel,
    'temperature': temperature,
    'humidity': humidity,
    'id': id,
    'timestamp': timestamp,
    'gas_ppm': gasPpm,
  };

  factory Reading.fromJson(Map<String, dynamic> json, {int? id}) => Reading(
    latitude: Helper.doubleFromJson(json['latitude']),
    longitude: Helper.doubleFromJson(json['longitude']),
    fillLevel: Helper.doubleFromJson(json['fill_level']) % 100 == 0
        ? 100
        : Helper.doubleFromJson(json['fill_level']),
    temperature: Helper.doubleFromJson(json['temperature']),
    humidity: Helper.doubleFromJson(json['humidity']),
    timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
    id: json['id'] ?? id ?? 0,
    gasPpm: Helper.doubleFromJson(json['gas_ppm']),
  );
}
