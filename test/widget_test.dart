// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jordan/main.dart';
import 'package:jordan/services/app_state.dart';

void main() {
  testWidgets('Shop Flow dashboard loads', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(MyApp(appState: AppState()));
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Search for product...'), findsOneWidget);
    expect(find.text('Nike Air Max'), findsOneWidget);
  });
}
