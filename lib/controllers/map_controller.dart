import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/models/bin.dart';
import 'package:keep_nigeria_clean/models/reading.dart';
import 'package:keep_nigeria_clean/services/bin_data_service.dart';

class MapController extends ChangeNotifier {
  final _binDataService = BinDataService();

  Bin _bin1 = Bin(name: 'Bin A');
  Bin _bin2 = Bin(name: 'Bin B');

  Bin get bin1 => _bin1;
  Bin get bin2 => _bin2;

  MapController() {
    _listen();
  }

  void _listen() {
    _binDataService.bin1Stream().listen((data) {
      final reading = data ?? Reading();

      final gases = _binDataService.calculateGases(reading.gasPpm);
      final assetPath = _binDataService.calculateAssetPath(reading.fillLevel);

      _bin1 = _bin1.copyWith(
        lastReading: reading,
        gases: gases,
        assetPath: assetPath,
      );
      notifyListeners();
    });

    _binDataService.bin2Stream().listen((data) {
      final reading = data ?? Reading();

      final gases = _binDataService.calculateGases(reading.gasPpm);
      final assetPath = _binDataService.calculateAssetPath(reading.fillLevel);

      _bin2 = _bin2.copyWith(
        lastReading: reading,
        gases: gases,
        assetPath: assetPath,
      );
      notifyListeners();
    });
  }
}
