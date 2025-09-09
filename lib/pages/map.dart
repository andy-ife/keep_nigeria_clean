import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_nigeria_clean/constants/mapbox.dart';
import 'package:keep_nigeria_clean/controllers/map_controller.dart';
import 'package:keep_nigeria_clean/widgets/bin_details_sheet.dart';
import 'package:keep_nigeria_clean/widgets/button_group.dart';
import 'package:keep_nigeria_clean/widgets/icon_and_label.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MapController>();

    if (controller.showBinSheet && !controller.sheetVisible) {
      controller.sheetVisible = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) =>
            showModalBottomSheet(
              isScrollControlled: true,
              useRootNavigator: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) =>
                  BinDetailsSheet(initialBin: controller.selectedBin!),
            ).then((_) {
              controller.showBinSheet = false;
              controller.sheetVisible = false;
            }),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await controller.centerCamera(),
        shape: CircleBorder(),
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.my_location_outlined),
      ),
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey('mapWidget'),
            onMapCreated: (map) => controller.initMap(context, map),
            cameraOptions: MapboxConstants.defaultCamera,
          ),
          Positioned(
            bottom: 28.0,
            left: 8.0,
            child: controller.showLegend
                ? GestureDetector(
                    onTap: () =>
                        () => controller.showLegend = false,
                    child: _Legend(),
                  )
                : GestureDetector(
                    onTap: () =>
                        () => controller.showLegend = true,
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
                  values: controller.filters,
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
