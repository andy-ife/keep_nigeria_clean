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
    this.address = 'In School of ICT',
    this.region = 'Minna',
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

  Bin copyWith({
    Reading? lastReading,
    List<Gas>? gases,
    String? name,
    String? address,
    String? region,
    String? assetPath,
  }) => Bin(
    lastReading: lastReading ?? this.lastReading,
    gases: gases ?? this.gases,
    name: name ?? this.name,
    address: address ?? this.address,
    region: region ?? this.region,
    assetPath: assetPath ?? this.assetPath,
  );
}
