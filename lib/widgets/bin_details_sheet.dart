import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:keep_nigeria_clean/constants/level.dart';
import 'package:keep_nigeria_clean/controllers/map_controller.dart';
import 'package:keep_nigeria_clean/models/bin.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/theme/styles.dart';
import 'package:keep_nigeria_clean/utils/helpers.dart';
import 'package:keep_nigeria_clean/widgets/flashing_widget.dart';
import 'package:keep_nigeria_clean/widgets/gas_status.dart';
import 'package:keep_nigeria_clean/widgets/icon_and_label.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BinDetailsSheet extends StatefulWidget {
  const BinDetailsSheet({super.key, required this.initialBin});

  final Bin initialBin;

  @override
  State<BinDetailsSheet> createState() => _BinDetailsSheetState();
}

class _BinDetailsSheetState extends State<BinDetailsSheet> {
  bool _routing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MapController>();
    final bin = controller.bins.firstWhere((bin) => bin == widget.initialBin);
    final toxics = bin.gases.where((gas) => gas.level == Level.high).toList();

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
                                bin.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                bin.address,
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
                              FlashingWidget(
                                child: Text(
                                  '${((bin.lastReading.fillLevel).toInt().toString())}% full',
                                ),
                              ),
                              IconAndLabel(
                                icon: Icon(
                                  Icons.timer_outlined,
                                  size: 16.0,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                label: FlashingWidget(
                                  child: Text(
                                    'Last Update ${Helper.formatTime24Hour(bin.lastReading.timestamp)}',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          LinearProgressIndicator(
                            value: bin.lastReading.fillLevel / 100.0,
                            minHeight: 16.0,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 28.0),
                      if (bin.gases.isNotEmpty) ...[
                        Text(
                          'Possible Gases Detected',
                          style: theme.textTheme.headlineSmall,
                        ),
                        //SizedBox(height: 16.0),
                        ...List.generate(
                          bin.gases.length,
                          (i) => ListTile(
                            horizontalTitleGap: 4.0,
                            contentPadding: EdgeInsets.all(0.0),
                            leading: SvgPicture.asset(
                              bin.gases[i].assetPath,
                              width: 40.0,
                            ),
                            title: IconAndLabel(
                              spacing: 6.0,
                              icon: Text(bin.gases[i].name),
                              label: GasStatusWidget(level: bin.gases[i].level),
                            ),
                            subtitle: Text(bin.gases[i].description),
                            trailing: IconAndLabel(
                              icon: Icon(
                                Icons.timer_outlined,
                                size: 20.0,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              label: Text(
                                Helper.formatTime24Hour(
                                  bin.lastReading.timestamp,
                                ),
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (bin.gases.isEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4.0,
                          children: [
                            Text('No harmful gases detected'),
                            Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primaryContainer,
                              size: 18.0,
                            ),
                          ],
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
                                  label: FlashingWidget(
                                    child: Text(
                                      '${bin.lastReading.temperature.toStringAsFixed(1)}\u00B0C',
                                      style: theme.textTheme.bodyLarge,
                                    ),
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
                                  label: FlashingWidget(
                                    child: Text(
                                      '${bin.lastReading.humidity.toStringAsFixed(1)}%',
                                      style: theme.textTheme.bodyLarge,
                                    ),
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
                                  label: FlashingWidget(
                                    child: Text(
                                      '${bin.lastReading.latitude}, ${bin.lastReading.longitude}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyLarge,
                                    ),
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
                                  label: FlashingWidget(
                                    child: Text(
                                      bin.region,
                                      style: theme.textTheme.bodyLarge,
                                    ),
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
                          onPressed: () async {
                            setState(() => _routing = true);

                            Position pos = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );
                            // Source - https://stackoverflow.com/a
                            // Posted by quim
                            // Retrieved 2026-01-21, License - CC BY-SA 4.0

                            setState(() => _routing = false);

                            String url =
                                'https://www.google.com/maps/dir/?api=1&origin=${pos.latitude},${pos.longitude}&destination=${widget.initialBin.lastReading.latitude},${widget.initialBin.lastReading.longitude}&travelmode=driving&dir_action=preview';

                            _launchURL(Uri.parse(url));
                          },
                          style: AppButtonStyles.filled,
                          child: _routing
                              ? SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text('Generate Route'),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await controller.reportBin(bin);
                          },
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

  // Source - https://stackoverflow.com/a
  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
