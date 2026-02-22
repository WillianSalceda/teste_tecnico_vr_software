import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_l10n.dart';
import 'core/refresh/auth_refresh_notifier.dart';
import 'core/session/session_expired_handler.dart';
import 'core/theme/app_theme.dart';
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
    final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
      child: SessionExpiredHandler(
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (prev, curr) =>
              curr is AuthAuthenticated || curr is AuthUnauthenticated,
          listener: (context, state) {
            sl<AuthRefreshNotifier>().refresh();
            if (state is AuthUnauthenticated &&
                state.sessionExpiredMessage != null) {
              scaffoldKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.sessionExpiredMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          child: MaterialApp.router(
            scaffoldMessengerKey: scaffoldKey,
            debugShowCheckedModeBanner: false,
            title: AppL10n(locale: locale).appTitle,
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('pt')],
            localizationsDelegates: const [
              ...GlobalMaterialLocalizations.delegates,
              GlobalWidgetsLocalizations.delegate,
            ],
            theme: AppTheme.light,
            routerConfig: _createRouter(),
          ),
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
