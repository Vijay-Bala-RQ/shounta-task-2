import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

class WidgetTestHelper {
  static FutureOr<void> widgetPresenceTestByKey({
    required WidgetTester tester,
    required Widget testWidget,
    required Key widgetKey,
  }) async {
    await tester.pumpWidget(
      TestApp(
        testWidget: testWidget,
      ),
    );
    await tester.pump();
    final Finder widgetFinder = find.byKey(widgetKey);
    expect(widgetFinder, findsOneWidget);
  }

  static FutureOr<void> widgetPresenceTestByText({
    required WidgetTester tester,
    required Widget testWidget,
    required String text,
    Type? parentOfText,
  }) async {
    await tester.pumpWidget(
      TestApp(
        testWidget: testWidget,
      ),
    );
    await tester.pump();
    final Finder widgetFinder = (parentOfText != null)
        ? find.widgetWithText(parentOfText, text)
        : find.text(text);
    expect(widgetFinder, findsOneWidget);
  }

  static FutureOr<void> enterTextTestByKey({
    required WidgetTester tester,
    required Widget testWidget,
    required Key widgetKey,
    required String text,
  }) async {
    await tester.pumpWidget(
      TestApp(
        testWidget: testWidget,
      ),
    );
    await tester.pump();
    final Finder widgetFinder = find.byKey(widgetKey);
    await tester.enterText(widgetFinder, text);
    await tester.pump();
    expect(
      find.descendant(
        of: widgetFinder,
        matching: find.text(text),
      ),
      findsOneWidget,
    );
  }

  static FutureOr<void> validationTextPresenceTestByKey({
    required WidgetTester tester,
    required Widget testWidget,
    required Key widgetKey,
    required String validationText,
    String enteredText='',
  }) async {
    await tester.pumpWidget(
      TestApp(
        testWidget: testWidget,
      ),
    );
    await tester.pump();
    final Finder widgetFinder = find.byKey(widgetKey);
    await tester.enterText(widgetFinder, enteredText);
    await tester.pump();
    expect(
      find.descendant(
        of: widgetFinder,
        matching: find.text(validationText),
      ),
      findsOneWidget,
    );
  }
}
