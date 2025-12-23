import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Notes app smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NotesApp());

    // Verify that the title 'My Notes' is present.
    expect(find.text('My Notes'), findsOneWidget);
    
    // Verify that the Floating Action Button is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
