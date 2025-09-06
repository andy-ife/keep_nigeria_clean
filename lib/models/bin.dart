import 'package:keep_nigeria_clean/models/gas.dart';
import 'package:keep_nigeria_clean/models/reading.dart';

class Bin {
  final Reading lastReading;
  final List<Gas> gases;
  final String name;
  final String address;
  final String region;
  final String assetPath;

  Bin({
    Reading? lastReading,
    List<Gas>? gases,
    this.name = '',
    this.address = '',
    this.region = '',
    this.assetPath = '',
  }) : lastReading = lastReading ?? Reading(),
       gases = gases ?? [];

  factory Bin.fromJson(Map<String, dynamic> json) => Bin(
    lastReading: json['last_reading'] != null
        ? Reading.fromJson(json['last_reading'])
        : Reading(),
    gases:
        (json['gases'] as List<dynamic>?)
            ?.map((e) => Gas.fromJson(e))
            .toList() ??
        [],
    name: json['name'] ?? '',
    address: json['address'] ?? '',
    region: json['region'] ?? '',
    assetPath: json['asset_path'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'last_reading': lastReading.toJson(),
    'gases': gases.map((e) => e.toJson()).toList(),
    'name': name,
    'address': address,
    'region': region,
    'asset_path': assetPath,
  };
}
