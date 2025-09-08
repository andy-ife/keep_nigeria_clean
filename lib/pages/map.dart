import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_nigeria_clean/constants/level.dart';
import 'package:keep_nigeria_clean/models/gas.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/theme/styles.dart';
import 'package:keep_nigeria_clean/utils/helpers.dart';
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
              // init controller and point annotation manager
              _mapboxMap = controller;
              final pointAnnotationManager = await _mapboxMap.annotations
                  .createPointAnnotationManager();

              // enable location puck
              await _mapboxMap.location.updateSettings(
                LocationComponentSettings(
                  enabled: true,
                  accuracyRingColor: AppColors.accuracyColor.toARGB32(),
                  showAccuracyRing: true,
                  puckBearingEnabled: true,
                ),
              );

              // load dummy bin markers
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

              // improve compass and scale bar positioning
              _mapboxMap.compass.updateSettings(
                CompassSettings(
                  position: OrnamentPosition.BOTTOM_RIGHT,
                  marginRight: 20.0,
                  marginBottom: 80.0,
                ),
              );

              _mapboxMap.scaleBar.updateSettings(
                ScaleBarSettings(enabled: false),
              );

              // center on puck
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
    final lat = annotation.geometry.coordinates.lat - 0.0016;
    final long = annotation.geometry.coordinates.lng;

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
        builder: (_) => _BinDetailsSheet(
          name: 'Bin C',
          location: 'School of ICT',
          lastUsed: DateTime(2025, 0, 0, 18, 06),
          city: 'Minna',
          gases: [
            Gas(
              name: 'Methane',
              description: 'Toxic & flammable',
              assetPath: 'assets/methane.svg',
              level: Level.high,
              lastUpdate: DateTime(2025),
            ),
            Gas(
              name: 'Smoke',
              description: 'Could mean fire',
              assetPath: 'assets/smoke.svg',
              level: Level.low,
              lastUpdate: DateTime(2025),
            ),
          ],
          humidity: '68%',
          lat: '6.5244 N',
          long: '3.3792 E',
          temp: '32 C',
          fillLevel: 0.45,
        ),
      );
    }
  }
}

class _BinDetailsSheet extends StatelessWidget {
  const _BinDetailsSheet({
    required this.name,
    required this.location,
    required this.lastUsed,
    required this.city,
    required this.gases,
    required this.humidity,
    required this.lat,
    required this.long,
    required this.temp,
    required this.fillLevel,
  });

  final String name;
  final String location;
  final DateTime lastUsed;
  final List<Gas> gases;
  final String temp;
  final String humidity;
  final String city;
  final String lat;
  final String long;
  final double fillLevel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final toxics = gases.where((gas) => gas.level == Level.high).toList();

    return _makeDismissible(
      context: context,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, dragScrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: dragScrollController,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0.0),
                              horizontalTitleGap: 4.0,
                              leading: SvgPicture.asset('assets/bin.svg'),
                              title: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'In $location',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_back),
                              ),
                              SizedBox(width: 4.0),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      if (toxics.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: Colors.red[300]!,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconAndLabel(
                                spacing: 8.0,
                                icon: SvgPicture.asset(
                                  'assets/yellow-warning.svg',
                                  width: 24.0,
                                ),
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'High level of ${toxics[0].name} detected.',
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                      ),
                                      TextSpan(
                                        text: '\nReport?',
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (toxics.isNotEmpty) SizedBox(height: 16.0),
                      Column(
                        spacing: 4.0,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${((fillLevel * 100).toInt().toString())}% full',
                              ),
                              IconAndLabel(
                                icon: Icon(
                                  Icons.timer_outlined,
                                  size: 16.0,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                label: Text(
                                  'Last Used ${Helper.formatTime24Hour(lastUsed)}',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          LinearProgressIndicator(
                            value: fillLevel,
                            minHeight: 16.0,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 28.0),
                      Text(
                        'Detected Gases',
                        style: theme.textTheme.headlineSmall,
                      ),
                      //SizedBox(height: 16.0),
                      ...List.generate(
                        gases.length,
                        (i) => ListTile(
                          horizontalTitleGap: 4.0,
                          contentPadding: EdgeInsets.all(0.0),
                          leading: SvgPicture.asset(
                            gases[i].assetPath,
                            width: 40.0,
                          ),
                          title: IconAndLabel(
                            spacing: 6.0,
                            icon: Text(gases[i].name),
                            label: _GasStatus(level: gases[i].level),
                          ),
                          subtitle: Text(gases[i].description),
                          trailing: IconAndLabel(
                            icon: Icon(
                              Icons.timer_outlined,
                              size: 20.0,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            label: Text(
                              Helper.formatTime24Hour(
                                gases[i].lastUpdate ?? DateTime.now(),
                              ),
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.0),

                      Row(
                        spacing: 16.0,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconAndLabel(
                                  icon: Text(
                                    'Temperature',
                                    style: theme.textTheme.labelMedium!
                                        .copyWith(
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  label: Text(
                                    temp,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  isHorizontal: false,
                                  align: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconAndLabel(
                                  icon: Text(
                                    'Humidity',
                                    style: theme.textTheme.labelMedium!
                                        .copyWith(
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  label: Text(
                                    humidity,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  isHorizontal: false,
                                  align: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        spacing: 16.0,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconAndLabel(
                                  icon: Text(
                                    'Coordinates',
                                    style: theme.textTheme.labelMedium!
                                        .copyWith(
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  label: Text(
                                    '$lat, $long',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  isHorizontal: false,
                                  align: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconAndLabel(
                                  icon: Text(
                                    'Region',
                                    style: theme.textTheme.labelMedium!
                                        .copyWith(
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  label: Text(
                                    city,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  isHorizontal: false,
                                  align: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),
              Container(
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    spacing: 16.0,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: AppButtonStyles.filled,
                          child: Text('Generate Route'),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: AppButtonStyles.outlined.copyWith(
                            foregroundColor: WidgetStateProperty.all(
                              AppColors.red,
                            ),
                          ),
                          child: Text('Report this bin'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _makeDismissible({
    required BuildContext context,
    required Widget child,
  }) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context, rootNavigator: true).pop(),
    child: GestureDetector(onTap: () {}, child: child),
  );
}

class _GasStatus extends StatelessWidget {
  const _GasStatus({required this.level});

  final Level level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (color, text) = level == Level.high
        ? (AppColors.red, 'High')
        : level == Level.medium
        ? (AppColors.amber, 'Medium')
        : (AppColors.green, 'Low');

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2.0,
      children: [
        Container(
          height: 4.0,
          width: 4.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        Text(text, style: theme.textTheme.labelSmall!.copyWith(color: color)),
      ],
    );
  }
}
