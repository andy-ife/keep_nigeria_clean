import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keep_nigeria_clean/constants/level.dart';
import 'package:keep_nigeria_clean/controllers/analytics_controller.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/widgets/button_group.dart';
import 'package:keep_nigeria_clean/widgets/error_widget.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;

    final controller = context.watch<AnalyticsController>();
    final state = controller.state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        actions: [Icon(Icons.notifications)],
        actionsPadding: EdgeInsets.only(right: 16.0),
        bottom: PreferredSize(
          preferredSize: Size(constraints.width, 64.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: KNCButtonGroup(
              values: controller.tabs,
              onSelectionChange: (newValues) {
                controller.switchTimeframe(newValues.first);
              },
              enableMultiSelection: false,
              initialSelection: {controller.tabs.first},
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.refresh(),
        child: state.loading
            ? Center(child: CircularProgressIndicator())
            : state.error.isNotEmpty
            ? KNCErrorWidget(
                message: state.error,
                onRetry: () => controller.refresh(),
              )
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.0,
                  children: [
                    Text(
                      'AI powered insights and trends',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: constraints.width * 0.44,
                          child: _StatisticCard(
                            title: 'Avg Fill Level',
                            value: '${state.avgFillLevel}%',
                          ),
                        ),
                        SizedBox(
                          width: constraints.width * 0.44,
                          child: _StatisticCard(
                            title: 'Avg Temp',
                            value: '${state.avgTemp}°C',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Waste Trend',
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          label: Text('AI Predict'),
                          icon: Icon(Icons.star),
                        ),
                      ],
                    ),
                    SizedBox(),
                    SizedBox(
                      height: constraints.height * 0.36,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: state.data
                                  .map(
                                    (r) => FlSpot(
                                      state.data.indexOf(r).toDouble(),
                                      r.fillLevel,
                                    ),
                                  )
                                  .toList(),
                              color: AppColors.primary,
                              barWidth: 4.0,
                              isCurved: true,
                              preventCurveOverShooting: true,
                              isStrokeCapRound: true,
                              isStrokeJoinRound: true,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Fill Level',
                                style: theme.textTheme.labelMedium,
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) =>
                                    SideTitleWidget(
                                      meta: meta,
                                      child: Text(
                                        "${value.toInt()}",
                                        style: theme.textTheme.labelSmall,
                                      ),
                                    ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Time',
                                style: theme.textTheme.labelMedium,
                              ),
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          minY: 0,
                          maxY: 100,
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: false,
                            getDrawingVerticalLine: (e) => FlLine(
                              color: AppColors.lightGrey.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(),
                    if (state.gasCounts.entries.toList().isNotEmpty) ...[
                      Text(
                        'Gas Detections',
                        style: theme.textTheme.headlineSmall,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          final entries = state.gasCounts.entries.toList();
                          final gas = entries[i].key;
                          final count = entries[i].value;

                          return _GasDetectionCard(
                            icon: SvgPicture.asset(gas.assetPath, width: 24.0),
                            label: Text(gas.name),
                            value: count,
                            maxValue: count + 2,
                          );
                        },
                        separatorBuilder: (ctx, i) => SizedBox(height: 8.0),
                        itemCount: state.gasCounts.entries.length,
                      ),
                    ] else
                      Center(
                        child: Text(
                          'No harmful gases have been detected from this bin ✅',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    SizedBox(),
                    Text(
                      'Alerts & Recommendations',
                      style: theme.textTheme.headlineSmall,
                    ),
                    // TODO: Use AI for recommendations
                    _AlertCard(
                      title: 'High Priority',
                      subtitle:
                          'Bin C requires immediate collection - 95% full with high hazard level',
                      priority: Level.high,
                    ),
                    _AlertCard(
                      title: 'Low Priority',
                      subtitle:
                          'Consider reporting Bin A - Trace amounts of alcohol detected.',
                      priority: Level.low,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: AppColors.white,
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
        titleTextStyle: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        subtitleTextStyle: theme.textTheme.titleLarge,
      ),
    );
  }
}

class _GasDetectionCard extends StatelessWidget {
  const _GasDetectionCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.maxValue,
  });

  final Widget icon;
  final Widget label;
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(width: 4.0),
        label,
        SizedBox(width: 16.0),
        SizedBox(
          width: 100.0,
          child: LinearProgressIndicator(
            value: value / maxValue,
            minHeight: 8.0,
            borderRadius: BorderRadiusGeometry.circular(12.0),
          ),
        ),
        SizedBox(width: 16.0),
        Text(value.toString()),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.title,
    required this.subtitle,
    required this.priority,
  });

  final String title;
  final String subtitle;
  final Level priority;

  @override
  Widget build(BuildContext context) {
    final color = priority == Level.high
        ? AppColors.red
        : priority == Level.medium
        ? AppColors.amber
        : AppColors.green;

    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Container(
        width: 8.0,
        height: 8.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.open_in_new)),
    );
  }
}
