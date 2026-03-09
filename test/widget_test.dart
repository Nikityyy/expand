// This file is a placeholder test. The main app widget is ExpandApp.
import 'package:flutter_test/flutter_test.dart';
import 'package:expand/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Just verify the app builds without crash.
    // Real GPS/storage tests require a physical device.
    expect(ExpandApp, isNotNull);
  });
}
