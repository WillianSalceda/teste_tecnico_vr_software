import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:real_estate_app/app.dart';
import 'package:real_estate_app/core/di/injection.dart';

void main() {
  testWidgets('RealEstateApp smoke test', (WidgetTester tester) async {
    await sl.reset();
    await configureDependencies(
      apiBaseUrl: 'http://localhost:8080',
      locale: const Locale('en'),
    );

    await tester.pumpWidget(const RealEstateApp());

    expect(find.text('Real Estate Ads'), findsOneWidget);
  });
}
