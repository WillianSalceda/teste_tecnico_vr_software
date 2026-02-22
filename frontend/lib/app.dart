import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_l10n.dart';
import 'modules/create_listing/presentation/pages/create_listing_page.dart';
import 'modules/home_screen.dart';
import 'modules/listing/presentation/pages/listing_page.dart';

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = sl<Locale>();
    return MaterialApp.router(
      title: AppL10n(locale: locale).appTitle,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('pt')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: _createRouter(),
    );
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/listings',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => HomeScreen(
            navigationShell: navigationShell,
          ),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/listings',
                  pageBuilder: (context, state) => const MaterialPage(
                    child: ListingPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/create-listing',
                  pageBuilder: (context, state) => const MaterialPage(
                    child: CreateListingPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/exchange-rate',
                  pageBuilder: (context, state) => const MaterialPage(
                    child: _PlaceholderPage(label: 'Exchange Rate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label));
  }
}
