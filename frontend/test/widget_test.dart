import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/app.dart';
import 'package:real_estate_app/core/di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('RealEstateApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    await configureDependencies(
      apiBaseUrl: 'http://localhost:8080',
      authBaseUrl: 'http://localhost:9090',
      locale: const Locale('en'),
    );

    await tester.pumpWidget(const RealEstateApp());
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
  });
}
