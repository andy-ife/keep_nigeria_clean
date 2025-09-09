import 'package:keep_nigeria_clean/constants/assets.dart';
import 'package:keep_nigeria_clean/models/gas.dart';
import 'package:keep_nigeria_clean/models/reading.dart';

class Bin {
  final Reading lastReading;
  final List<Gas> gases;
  final String name;
  final String address;
  final String region;
  final String assetPath;
  final String? warningAssetPath;
  final int id;

  Bin({
    Reading? lastReading,
    this.gases = const [],
    this.name = '',
    this.address = 'In School of ICT',
    this.region = 'Minna',
    this.assetPath = AssetConstants.bin0,
    this.warningAssetPath,
    this.id = 0,
  }) : this.lastReading = lastReading ?? Reading();

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
    id: json['id'],
    warningAssetPath: json['warning_asset_path'],
  );

  Map<String, dynamic> toJson() => {
    'last_reading': lastReading.toJson(),
    'gases': gases.map((e) => e.toJson()).toList(),
    'name': name,
    'address': address,
    'region': region,
    'asset_path': assetPath,
    'id': id,
    'warning_asset_path': warningAssetPath,
  };

  Bin copyWith({
    Reading? lastReading,
    List<Gas>? gases,
    String? name,
    String? address,
    String? region,
    String? assetPath,
    int? id,
    String? warningAssetPath,
  }) => Bin(
    lastReading: lastReading ?? this.lastReading,
    gases: gases ?? this.gases,
    name: name ?? this.name,
    address: address ?? this.address,
    region: region ?? this.region,
    assetPath: assetPath ?? this.assetPath,
    id: id ?? this.id,
    warningAssetPath: warningAssetPath ?? this.warningAssetPath,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bin && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
