import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/pages/analytics.dart';
import 'package:keep_nigeria_clean/pages/learn.dart';
import 'package:keep_nigeria_clean/pages/map.dart';

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
            icon: Icon(Icons.insert_chart_outlined),
            selectedIcon: Icon(
              Icons.insert_chart,
              color: theme.colorScheme.primary,
            ),
            label: "Analytics",
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(
              Icons.menu_book,
              color: theme.colorScheme.primary,
            ),
            label: 'Learn',
          ),
        ],
      ),
    );
  }
}
