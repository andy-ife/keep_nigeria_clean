class Reading {
  final double latitude;
  final double longitude;
  final double fillLevel;
  final double temperature;
  final double humidity;
  final double gasPpm;
  final String id;
  final String timestamp;

  const Reading({
    this.latitude = 9.0820,
    this.longitude = 8.6753,
    this.fillLevel = 0,
    this.temperature = 0,
    this.humidity = 0,
    this.gasPpm = 0,
    this.id = 'knc_smart_bin',
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
    latitude: json['latitude'],
    longitude: json['longitude'],
    fillLevel: json['fill_level'],
    temperature: json['temperature'],
    humidity: json['humidity'],
    timestamp: json['timestamp'],
    gasPpm: (json['gas_ppm'] as int).toDouble(),
  );
}
