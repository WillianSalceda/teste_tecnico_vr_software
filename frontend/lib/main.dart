import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  final localeCode = String.fromEnvironment(
    'FLUTTER_LOCALE',
    defaultValue: 'en',
  );
  final locale = localeCode == 'pt' ? const Locale('pt') : const Locale('en');
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  const authApiBaseUrl = String.fromEnvironment(
    'AUTH_API_BASE_URL',
    defaultValue: 'http://localhost:9090',
  );
  runApp(
    RealEstateApp(
      apiBaseUrl: apiBaseUrl,
      locale: locale,
      authApiBaseUrl: authApiBaseUrl,
    ),
  );
}
