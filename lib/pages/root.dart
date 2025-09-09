import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/pages/analytics.dart';
import 'package:keep_nigeria_clean/pages/learn.dart';
import 'package:keep_nigeria_clean/pages/map.dart';
import 'package:keep_nigeria_clean/widgets/upload_interval_dialog.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int _selectedIndex = 0;
  final _pages = [
    MapScreen(),
    //RewardsScreen(),
    AnalyticsScreen(),
    LearnScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(top: false, child: _pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.colorScheme.surface,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (newIndex) {
          if (newIndex == 3) {
            showDialog(
              context: context,
              builder: (ctx) => UploadIntervalDialog(),
            );
            return;
          }
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: theme.colorScheme.primary),
            label: "Map",
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.emoji_events_outlined),
          //   selectedIcon: Icon(
          //     Icons.emoji_events,
          //     color: theme.colorScheme.primary,
          //   ),
          //   label: "Rewards",
          // ),
          NavigationDestination(
            icon: Icon(Icons.insights),
            selectedIcon: Icon(
              Icons.insights_rounded,
              color: theme.colorScheme.primary,
            ),
            label: "Analytics",
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(
              Icons.lightbulb_rounded,
              color: theme.colorScheme.primary,
            ),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(
              Icons.settings,
              color: theme.colorScheme.primary,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
