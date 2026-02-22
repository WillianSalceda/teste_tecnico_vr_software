import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeCode = const String.fromEnvironment(
    'FLUTTER_LOCALE',
    defaultValue: 'en',
  );

  final locale = localeCode == 'pt' ? const Locale('pt') : const Locale('en');

  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  const authBaseUrl = String.fromEnvironment(
    'AUTH_API_BASE_URL',
    defaultValue: 'http://localhost:9090',
  );

  await configureDependencies(
    apiBaseUrl: apiBaseUrl,
    authBaseUrl: authBaseUrl,
    locale: locale,
  );

  runApp(const RealEstateApp());
}
