import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/widgets/button_group.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ['Nearest bins', 'Emptiest bins', 'Low odor bins'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    offset: Offset(0, 4.0),
                    color: theme.colorScheme.surfaceDim,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 16.0),
                    child: KNCButtonGroup(
                      values: filters,
                      onSelectionChange: (newValues) {},
                      enableMultiSelection: false,
                    ),
                  ),
                  Row(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
