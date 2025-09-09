import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/constants/mapbox.dart';
import 'package:keep_nigeria_clean/controllers/map_controller.dart';
import 'package:keep_nigeria_clean/widgets/bin_details_sheet.dart';
import 'package:keep_nigeria_clean/widgets/button_group.dart';
import 'package:keep_nigeria_clean/widgets/legend.dart';
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
                    child: LegendWidget(),
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
                  values: controller.filters.map((f) => f.name).toList(),
                  onSelectionChange: (newValues) {
                    if(newValues.isEmpty){
                      controller.filterBy(null);
                      return;
                    }
                    controller.filterBy(
                      controller.filters.firstWhere(
                        (f) => f.name == newValues.first,
                      ),
                    );
                  },
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
