import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/l10n/app_l10n.dart';
import '../core/refresh/listing_refresh_notifier.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n(locale: Localizations.localeOf(context));
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => _onTabTap(context, index),
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.list),
                label: Text(l10n.listings),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.add),
                label: Text(l10n.createListing),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.currency_exchange),
                label: Text(l10n.exchangeRates),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  void _onTabTap(BuildContext context, int index) {
    if (index == 0) {
      sl<ListingRefreshNotifier>().refresh();
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
