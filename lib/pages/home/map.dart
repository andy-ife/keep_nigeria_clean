import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_nigeria_clean/widgets/button_group.dart';
import 'package:keep_nigeria_clean/widgets/icon_and_label.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _showLegend = true;

  final _camera = CameraOptions(
    center: Point(coordinates: Position(-98.0, 39.5)),
    zoom: 2,
    bearing: 0,
    pitch: 0,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ['Nearest bins', 'Emptiest bins', 'Low odor bins'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MapWidget(cameraOptions: _camera),
          Positioned(
            bottom: 32.0,
            left: 16.0,
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
          spacing: 4.0,
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
