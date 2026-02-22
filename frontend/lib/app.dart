import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_l10n.dart';
import 'core/refresh/auth_refresh_notifier.dart';
import 'modules/auth/domain/usecases/get_session.dart';
import 'modules/auth/presentation/bloc/auth_bloc.dart';
import 'modules/auth/presentation/pages/login_page.dart';
import 'modules/create_listing/presentation/pages/create_listing_page.dart';
import 'modules/exchange_rate/presentation/pages/exchange_rate_page.dart';
import 'modules/home_screen.dart';
import 'modules/listing/presentation/pages/listing_page.dart';

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = sl<Locale>();
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr is AuthAuthenticated || curr is AuthUnauthenticated,
        listener: (context, state) {
          sl<AuthRefreshNotifier>().refresh();
        },
        child: MaterialApp.router(
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
            visualDensity: VisualDensity.standard,
          ),
          routerConfig: _createRouter(),
        ),
      ),
    );
  }

  GoRouter _createRouter() {
    final authRefresh = sl<AuthRefreshNotifier>();
    return GoRouter(
      initialLocation: '/listings',
      refreshListenable: authRefresh,
      redirect: (context, state) async {
        final session = await sl<GetSession>()();
        final isAuth = session != null;
        final isLogin = state.uri.path == '/login';
        if (!isAuth && !isLogin) return '/login';
        if (isAuth && isLogin) return '/listings';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => const MaterialPage(
            child: LoginPage(),
          ),
        ),
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
                    child: ExchangeRatePage(),
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
