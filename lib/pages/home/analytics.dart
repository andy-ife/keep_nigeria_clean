import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keep_nigeria_clean/constants/level.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/widgets/button_group.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;

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
              values: const ['Today', 'Past Week', 'Past Month', 'All'],
              onSelectionChange: (_) {},
              enableMultiSelection: false,
              initialSelection: {'Today'},
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0, vertical: 8.0),
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

            //SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: constraints.width * 0.44,
                  child: _StatisticCard(title: 'Avg Fill Level'),
                ),
                SizedBox(
                  width: constraints.width * 0.44,
                  child: _StatisticCard(title: 'Avg Temp'),
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
              child: BarChart(BarChartData()),
            ),
            SizedBox(),
            Text('Gas Detections', style: theme.textTheme.headlineSmall),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (ctx, i) => _GasDetectionCard(
                icon: SvgPicture.asset('assets/methane.svg', width: 24.0),
                label: Text('Methane'),
                value: 6,
                maxValue: 10,
              ),
              separatorBuilder: (ctx, i) => SizedBox(height: 8.0),
              itemCount: 5,
            ),
            SizedBox(),

            Text(
              'Alerts & Recommendations',
              style: theme.textTheme.headlineSmall,
            ),
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
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: AppColors.white,
      child: ListTile(
        title: Text(title),
        subtitle: Text('67%'),
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
