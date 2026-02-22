import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:real_estate_app/app.dart';

void main() {
  testWidgets('RealEstateApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      RealEstateApp(
        apiBaseUrl: 'http://localhost:8080',
        locale: const Locale('en'),
      ),
    );

    expect(find.text('Real Estate Ads'), findsOneWidget);
  });
}
