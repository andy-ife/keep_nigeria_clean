import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/widgets/button_group.dart';
import 'package:keep_nigeria_clean/widgets/icon_and_label.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMap _mapboxMap;

  final _defaultCamera = CameraOptions(
    center: Point(coordinates: Position(6.450693, 9.534526)),
    zoom: 14.0,
    pitch: 0,
    bearing: 0,
  );

  bool _showLegend = false;

  final _binPoints = [
    Point(coordinates: Position(6.447606, 9.526681)),
    Point(coordinates: Position(6.449491, 9.536165)),
    Point(coordinates: Position(6.454233, 9.530442)),
  ];

  Future<void> _centerCamera() async {
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await _mapboxMap.style.getLayer(
        "mapbox-location-indicator-layer",
      );
    } else {
      layer = await _mapboxMap.style.getLayer("puck");
    }

    var location = (layer as LocationIndicatorLayer).location;
    final position = Position(
      location?[1] ?? 6.450693,
      location?[0] ?? 9.534526,
    );

    _mapboxMap.easeTo(
      CameraOptions(
        zoom: 14.0,
        center: Point(coordinates: position),
        bearing: 0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ['Nearest bins', 'Emptiest bins', 'Low odor bins'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _centerCamera(),
        shape: CircleBorder(),
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.my_location_outlined),
      ),
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey('mapWidget'),
            onMapCreated: (controller) async {
              _mapboxMap = controller;
              final pointAnnotationManager = await _mapboxMap.annotations
                  .createPointAnnotationManager();

              final bytes = await rootBundle.load('assets/bin-50.png');
              final imgData = bytes.buffer.asUint8List();

              for (Point p in _binPoints) {
                final options = PointAnnotationOptions(
                  geometry: p,
                  image: imgData,
                  iconSize: 0.8,
                );

                pointAnnotationManager.create(options);
              }

              pointAnnotationManager.addOnPointAnnotationClickListener(
                _OnBinClickListener(context: context, mapboxMap: _mapboxMap),
              );

              await _mapboxMap.location.updateSettings(
                LocationComponentSettings(
                  enabled: true,
                  accuracyRingColor: AppColors.accuracyColor.toARGB32(),
                  showAccuracyRing: true,
                  puckBearingEnabled: true,
                ),
              );

              await _centerCamera();
            },
            cameraOptions: _defaultCamera,
          ),
          Positioned(
            bottom: 28.0,
            left: 8.0,
            child: _showLegend
                ? GestureDetector(
                    onTap: () => setState(() => _showLegend = false),
                    child: _Legend(),
                  )
                : GestureDetector(
                    onTap: () => setState(() => _showLegend = true),
                    child: Card(
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.visibility_outlined,
                          size: 16.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: KNCButtonGroup(
                  values: filters,
                  onSelectionChange: (newValues) {},
                  floating: true,
                  enableMultiSelection: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconAndLabel(
              icon: SvgPicture.asset('assets/bin.svg', width: 16.0),
              label: Text('Smart bin', style: theme.textTheme.labelMedium),
            ),
            IconAndLabel(
              icon: SvgPicture.asset('assets/bar.svg', width: 16.0),
              label: Text('Fill level', style: theme.textTheme.labelMedium),
            ),
            IconAndLabel(
              icon: SvgPicture.asset('assets/yellow-warning.svg', width: 16.0),
              label: Text('Hazard', style: theme.textTheme.labelMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnBinClickListener extends OnPointAnnotationClickListener {
  final BuildContext context;
  final MapboxMap mapboxMap;

  _OnBinClickListener({required this.context, required this.mapboxMap});

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final lat = annotation.geometry.coordinates.lat - 0.001;
    final long = annotation.geometry.coordinates.lng;

    mapboxMap.easeTo(
      CameraOptions(
        center: Point(coordinates: Position(long, lat)),
        zoom: 16.0,
      ),
      MapAnimationOptions(duration: 1000),
    );

    if (context.mounted) {
      showBottomSheet(
        context: context,
        builder: (_) => LayoutBuilder(
          builder: (context, constraints) => Container(
            height: constraints.maxHeight * 0.5,
            color: AppColors.white,
          ),
        ),
      );
    }
  }
}
