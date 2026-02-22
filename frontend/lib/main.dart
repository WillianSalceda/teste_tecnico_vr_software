import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final localeCode = const String.fromEnvironment(
    'FLUTTER_LOCALE',
    defaultValue: 'en',
  );

  final locale = localeCode == 'pt' ? const Locale('pt') : const Locale('en');

  final apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';
  final authBaseUrl =
      dotenv.env['AUTH_API_BASE_URL'] ?? 'http://localhost:9090';

  await configureDependencies(
    apiBaseUrl: apiBaseUrl,
    authBaseUrl: authBaseUrl,
    locale: locale,
  );

  runApp(const RealEstateApp());
}
