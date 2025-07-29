import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/widgets/icon_and_label.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
        toolbarHeight: 64.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.surfaceVariant,
              child: Icon(
                Icons.account_circle,
                size: 36.0,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Earn rewards for proper waste disposal and reporting',
                style: theme.textTheme.titleMedium!.copyWith(
                  //fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(),
              Text('You', style: theme.textTheme.headlineSmall),
              _ProgressCard(),
              SizedBox(),
              Wrap(
                runSpacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Community Leaderboard',
                    style: theme.textTheme.headlineSmall,
                  ),
                  IconAndLabel(
                    icon: Icon(
                      Icons.people_outline,
                      size: 20.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    label: Text(
                      'This week',
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: constraints.height * 0.52,
                child: ListView.separated(
                  //shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (ctx, i) => Card(
                    color: AppColors.white,
                    child: ListTile(
                      leading: SvgPicture.asset('assets/bin.svg', width: 36.0),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'School of Engineering',
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: AppColors.accuracyColor,
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Text(
                                'Frequent bin use',
                                style: theme.textTheme.labelMedium!.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconAndLabel(
                            icon: Icon(Icons.star, color: AppColors.amber),
                            label: Text(
                              '1200',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Text('Rank #7'),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (ctx, i) => SizedBox(height: 8.0),
                ),
              ),
              SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How are rewards calculated\nand distributed?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24.0),
      ),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              leading: SvgPicture.asset('assets/bin.svg', width: 40.0),
              title: Text('School of ICT', style: theme.textTheme.titleMedium),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: AppColors.accuracyColor,
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Text(
                        'Your zone',
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconAndLabel(
                    icon: Icon(Icons.star, color: AppColors.amber),
                    label: Text('1200', style: theme.textTheme.bodyMedium),
                  ),
                  Text('Rank #7'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconAndLabel(
                    icon: Text(
                      '24',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.colorScheme.primaryFixedDim,
                      ),
                    ),
                    label: Text(
                      'Reports\nmade',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: AppColors.darkGrey,
                      ),
                    ),
                    isHorizontal: false,
                  ),
                  IconAndLabel(
                    icon: Text(
                      '156',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                    label: Text(
                      'Times bins\nused',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: AppColors.darkGrey,
                      ),
                    ),
                    isHorizontal: false,
                  ),
                  IconAndLabel(
                    icon: Text(
                      '5',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                    label: Text(
                      'Hazards\ndetected',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: AppColors.darkGrey,
                      ),
                    ),
                    isHorizontal: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
