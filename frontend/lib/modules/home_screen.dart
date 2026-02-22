import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/app_l10n.dart';
import 'auth/presentation/bloc/auth_bloc.dart';

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
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
            tooltip: l10n.logout,
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTabTap(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list),
            label: l10n.listings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add),
            label: l10n.createListing,
          ),
          NavigationDestination(
            icon: const Icon(Icons.currency_exchange),
            label: l10n.exchangeRates,
          ),
        ],
      ),
    );
  }

  void _onTabTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
