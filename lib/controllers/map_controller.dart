import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_nigeria_clean/constants/filter.dart';
import 'package:keep_nigeria_clean/models/bin.dart';
import 'package:keep_nigeria_clean/models/reading.dart';
import 'package:keep_nigeria_clean/services/bin_data_service.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/utils/helpers.dart';
import 'package:keep_nigeria_clean/widgets/bin_details_sheet.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapController extends ChangeNotifier {
  final _service = BinDataService();
  Bin bin1 = Bin(name: 'Bin A');
  Bin bin2 = Bin(name: 'Bin B');
  List<Bin> get bins => [bin1, bin2];
  set bins(List<Bin> newBins) => bins = newBins;
  late MapboxMap map;
  final filters = ['Nearest bins', 'Emptiest bins', 'Low odor bins'];
  bool _showLegend = false;
  bool get showLegend => _showLegend;
  set showLegend(bool value) {
    _showLegend = value;
    notifyListeners();
  }

  MapController() {
    _listen();
  }

  void _listen() {
    _service.bin1Stream().listen((data) {
      final reading = data ?? Reading();

      final gases = _service.calculateGases(reading.gasPpm);
      final assetPath = _service.calculateAssetPath(reading.fillLevel);

      bin1 = bin1.copyWith(
        lastReading: reading,
        gases: gases,
        assetPath: assetPath,
      );
      notifyListeners();
    });

    _service.bin2Stream().listen((data) {
      final reading = data ?? Reading();

      final gases = _service.calculateGases(reading.gasPpm);
      final assetPath = _service.calculateAssetPath(reading.fillLevel);

      bin2 = bin2.copyWith(
        lastReading: reading,
        gases: gases,
        assetPath: assetPath,
      );
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
    final pointAnnotationManager = await map.annotations
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
    bins.forEach((bin) async {
      final bytes = await rootBundle.load(bin.assetPath);
      final imgData = bytes.buffer.asUint8List();

      final options = PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            Helper.formatLngLat(bin.lastReading.longitude),
            Helper.formatLngLat(bin.lastReading.latitude),
          ),
        ),
        image: imgData,
        iconSize: 0.8,
        textField: bin.name,
        textOpacity: 0,
      );

      pointAnnotationManager.create(options);

      if (context.mounted) {
        pointAnnotationManager.addOnPointAnnotationClickListener(
          _OnBinClickListener(context: context, mapboxMap: map, bins: bins),
        );
      }
    });

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
  final BuildContext context;
  final MapboxMap mapboxMap;
  final List<Bin> bins;

  _OnBinClickListener({
    required this.context,
    required this.mapboxMap,
    required this.bins,
  });

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final lat = annotation.geometry.coordinates.lat - 0.0016;
    final long = annotation.geometry.coordinates.lng;
    final bin = bins.firstWhere((bin) => bin.name == annotation.textField!);

    mapboxMap.easeTo(
      CameraOptions(
        center: Point(coordinates: Position(long, lat)),
        zoom: 16.0,
      ),
      MapAnimationOptions(duration: 1000),
    );

    if (context.mounted) {
      showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) => BinDetailsSheet(initialBin: bin),
      );
    }
  }
}
