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

  List<Bin> bins = [Bin(name: 'Bin A', id: 1), Bin(name: 'Bin B', id: 2)];

  late MapboxMap map;
  late PointAnnotationManager _pointAnnotationManager;

  ///p.$1 is warning sign. p.$2 is bin marker.
  final _points = <(PointAnnotation?, PointAnnotation)>[];

  final filters = [FilterType.nearest, FilterType.emptiest, FilterType.lowOdor];
  bool _showLegend = false;
  Bin? selectedBin;
  bool showBinSheet = false;
  bool sheetVisible = false;

  bool get showLegend => _showLegend;
  set showLegend(bool value) {
    _showLegend = value;
    notifyListeners();
  }

  MapController() {
    _listen();
  }

  void _listen() {
    for (Stream<Reading?> stream in _service.streams) {
      stream.listen((data) async {
        final reading = data ?? Reading();
        Bin bin = bins.firstWhere((bin) => bin.id == reading.id);
        int index = bins.indexWhere((bin) => bin.id == reading.id);

        final gases = _service.calculateGases(reading.gasPpm);
        final assetPath = _service.calculateAssetPath(reading.fillLevel);
        final warnPath = _service.calculateWarningAssetPath(gases);
        final point = _points.firstWhere((p) => p.$2.textField == bin.name);

        bin = bin.copyWith(
          lastReading: reading,
          gases: gases,
          assetPath: assetPath,
          warningAssetPath: warnPath,
        );

        this.bins[index] = bin;

        await _updateMarker(point, bin);

        notifyListeners();
      });
    }
  }

  void filterBy(FilterType? filter) {
    switch (filter) {
      case FilterType.nearest:
        break;
      case FilterType.emptiest:
        //bins = bins.where((bin) => bin.lastReading.fillLevel < 20).toList();
        break;
      case FilterType.lowOdor:
        //bins = bins.where((bin) => bin.lastReading.gasPpm < 100).toList();
        break;
      case null:
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

  void initMap(MapboxMap controller) async {
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
      _updateMarker(null, bin);
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

  Future<void> _updateMarker(
    (PointAnnotation?, PointAnnotation)? point,
    Bin bin,
  ) async {
    if (point != null && _points.contains(point)) {
      await _pointAnnotationManager.delete(point.$2);
      if (point.$1 != null) await _pointAnnotationManager.delete(point.$1!);
      _points.remove(point);
    }

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

    final binMarker = await _pointAnnotationManager.create(options);
    PointAnnotation? warningMarker;

    if (bin.warningAssetPath != null) {
      final bytes = await rootBundle.load(bin.warningAssetPath!);
      final imgData = bytes.buffer.asUint8List();

      final options = PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            bin.lastReading.longitude,
            bin.lastReading.latitude + 0.001,
          ),
        ),
        image: imgData,
        iconSize: 0.8,
      );
      warningMarker = await _pointAnnotationManager.create(options);
    }

    _points.add((warningMarker, binMarker));

    _pointAnnotationManager.addOnPointAnnotationClickListener(
      _OnBinClickListener(controller: this, notify: notifyListeners),
    );
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
