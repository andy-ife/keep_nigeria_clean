import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_nigeria_clean/constants/filter.dart';
import 'package:keep_nigeria_clean/models/bin.dart';
import 'package:keep_nigeria_clean/models/reading.dart';
import 'package:keep_nigeria_clean/services/bin_data_service.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapController extends ChangeNotifier {
  final _service = BinDataService();

  Bin bin1 = Bin(name: 'Bin A');
  Bin bin2 = Bin(name: 'Bin B');
  List<Bin> get bins => [bin1, bin2];
  set bins(List<Bin> newBins) => bins = newBins;

  late MapboxMap map;
  late PointAnnotationManager _pointAnnotationManager;
  final _points = <PointAnnotation>[];

  final filters = ['Nearest bins', 'Emptiest bins', 'Low odor bins'];
  bool _showLegend = false;
  bool get showLegend => _showLegend;
  set showLegend(bool value) {
    _showLegend = value;
    notifyListeners();
  }

  Bin? selectedBin;
  bool showBinSheet = false;

  MapController() {
    _listen();
  }

  void _listen() {
    _service.bin1Stream().listen((data) async {
      final reading = data ?? Reading();

      final gases = _service.calculateGases(reading.gasPpm);
      final assetPath = _service.calculateAssetPath(reading.fillLevel);
      final point = _points.firstWhere((p) => p.textField == bin1.name);

      bin1 = bin1.copyWith(
        lastReading: reading,
        gases: gases,
        assetPath: assetPath,
      );

      point.geometry = Point(
        coordinates: Position(
          bin1.lastReading.longitude,
          bin1.lastReading.latitude,
        ),
      );
      await _pointAnnotationManager.update(point);
      notifyListeners();
    });

    _service.bin2Stream().listen((data) async {
      final reading = data ?? Reading();

      final gases = _service.calculateGases(reading.gasPpm);
      final assetPath = _service.calculateAssetPath(reading.fillLevel);
      final point = _points.firstWhere((p) => p.textField == bin2.name);

      bin2 = bin2.copyWith(
        lastReading: reading,
        gases: gases,
        assetPath: assetPath,
      );

      point.geometry = Point(
        coordinates: Position(
          bin2.lastReading.longitude,
          bin2.lastReading.latitude,
        ),
      );

      await _pointAnnotationManager.update(point);
      notifyListeners();
    });
  }

  void filterBy(FilterType filter) {
    switch (filter) {
      case FilterType.nearest:
        bins = bins;
        break;
      case FilterType.emptiest:
        bins = bins.where((bin) => bin.lastReading.fillLevel < 20).toList();
        break;
      case FilterType.lowOdor:
        bins = bins.where((bin) => bin.lastReading.gasPpm < 100).toList();
        break;
    }
    notifyListeners();
  }

  // Mapbox-related code

  Future<void> centerCamera() async {
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await map.style.getLayer("mapbox-location-indicator-layer");
    } else {
      layer = await map.style.getLayer("puck");
    }

    var location = (layer as LocationIndicatorLayer).location;
    final position = Position(
      location?[1] ?? 6.450693,
      location?[0] ?? 9.534526,
    );

    map.easeTo(
      CameraOptions(
        zoom: 14.0,
        center: Point(coordinates: position),
        bearing: 0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  void initMap(BuildContext context, MapboxMap controller) async {
    // init controller and point annotation manager
    map = controller;
    _pointAnnotationManager = await map.annotations
        .createPointAnnotationManager();

    // enable location puck
    await map.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        accuracyRingColor: AppColors.accuracyColor.toARGB32(),
        showAccuracyRing: true,
        puckBearingEnabled: true,
      ),
    );

    // load initial bin markers
    for (Bin bin in bins) {
      final bytes = await rootBundle.load(bin.assetPath);
      final imgData = bytes.buffer.asUint8List();

      final options = PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            bin.lastReading.longitude,
            bin.lastReading.latitude,
          ),
        ),
        image: imgData,
        iconSize: 0.8,
        textField: bin.name,
        textOpacity: 0,
      );

      final p = await _pointAnnotationManager.create(options);
      _points.add(p);

      if (context.mounted) {
        _pointAnnotationManager.addOnPointAnnotationClickListener(
          _OnBinClickListener(controller: this, notify: notifyListeners),
        );
      }
    }

    // improve compass and scale bar positioning
    map.compass.updateSettings(
      CompassSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 20.0,
        marginBottom: 80.0,
      ),
    );

    map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    // center on puck
    await centerCamera();
  }
}

class _OnBinClickListener extends OnPointAnnotationClickListener {
  final MapController controller;
  final VoidCallback notify;

  _OnBinClickListener({required this.controller, required this.notify});

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final lat = annotation.geometry.coordinates.lat - 0.0016;
    final long = annotation.geometry.coordinates.lng;
    final bin = controller.bins.firstWhere(
      (bin) => bin.name == annotation.textField!,
    );

    controller.map.easeTo(
      CameraOptions(
        center: Point(coordinates: Position(long, lat)),
        zoom: 16.0,
      ),
      MapAnimationOptions(duration: 1000),
    );

    controller.selectedBin = bin;
    controller.showBinSheet = true;
    notify();
  }
}
