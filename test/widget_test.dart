// MSME Pathways - Basic App Smoke Test
//
// Verifies the app can launch without errors.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/presentation/views/onboarding_view.dart';

void main() {
  testWidgets('Onboarding view renders without error', (WidgetTester tester) async {
    // Build the onboarding view with provider
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingView(),
      ),
    );

    // Give time for async operations
    await tester.pump();

    // Verify the view is rendered (loading state or content)
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
