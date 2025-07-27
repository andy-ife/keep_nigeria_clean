import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keep_nigeria_clean/constants/priority.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/widgets/button_group.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.only(top: 8.0, bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              Text(
                'AI powered insights and waste management trends',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              KNCButtonGroup(
                values: const ['Today', 'Past Week', 'Past Month', 'All'],
                onSelectionChange: (_) {},
                enableMultiSelection: false,
                initialSelection: {'Today'},
              ),
              SizedBox(),
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
              Text('Waste Generation Rate', style: theme.textTheme.titleMedium),
              Column(
                children: [
                  SizedBox(
                    height: constraints.height * 0.36,
                    child: BarChart(BarChartData()),
                  ),
                  Row(
                    children: [
                      Text(
                        'See AI prediction for tomorrow\'s rate',
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Icon(Icons.arrow_right, color: theme.colorScheme.primary),
                    ],
                  ),
                ],
              ),
              SizedBox(),
              Text(
                'No. of Times Gases Were Detected',
                style: theme.textTheme.titleMedium,
              ),
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
              Row(
                children: [
                  Icon(Icons.warning_amber, size: 20.0),
                  SizedBox(width: 8.0),
                  Text(
                    'Alerts and Recommendations',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              _AlertCard(
                title: 'High Priority',
                subtitle:
                    'Bin C requires immediate collection - 95% full with high hazard level',
                priority: Priority.high,
              ),
              _AlertCard(
                title: 'Low Priority',
                subtitle:
                    'Consider reporting Bin A - Trace amounts of alcohol detected.',
                priority: Priority.low,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
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
    super.key,
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
    super.key,
  });

  final String title;
  final String subtitle;
  final Priority priority;

  @override
  Widget build(BuildContext context) {
    final color = priority == Priority.high
        ? AppColors.red
        : priority == Priority.medium
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
      trailing: ElevatedButton.icon(
        onPressed: () {},
        label: Text('To bin'),
        icon: Icon(Icons.open_in_new),
      ),
    );
  }
}
