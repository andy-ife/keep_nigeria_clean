import 'package:keep_nigeria_clean/utils/helpers.dart';

class Reading {
  final double latitude;
  final double longitude;
  final double fillLevel;
  final double temperature;
  final double humidity;
  final double gasPpm;
  final int id;
  final String timestamp;

  const Reading({
    this.latitude = 9.0820,
    this.longitude = 8.6753,
    this.fillLevel = 0,
    this.temperature = 0,
    this.humidity = 0,
    this.gasPpm = 0,
    this.id = 0,
    this.timestamp = '1999-01-01T00:00',
  });

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

  factory Reading.fromJson(Map<String, dynamic> json) => Reading(
    latitude: Helper.doubleFromJson(json['latitude']),
    longitude: Helper.doubleFromJson(json['longitude']),
    fillLevel: Helper.doubleFromJson(json['fill_level']) % 100 == 0
        ? 100
        : Helper.doubleFromJson(json['fill_level']),
    temperature: Helper.doubleFromJson(json['temperature']),
    humidity: Helper.doubleFromJson(json['humidity']),
    timestamp: json['timestamp'],
    id: json['id'] ?? 0,
    gasPpm: Helper.doubleFromJson(json['gas_ppm']),
  );
}
