import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymer/app/auth/login_screen.dart';

// Helper function to pump the widget with necessary ancestors
Future<void> pumpLoginScreen(WidgetTester tester, MockFirebaseAuth mockAuth) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LoginScreen(firebaseAuth: mockAuth),
    ),
  );
}

void main() {
  group('LoginScreen Forgot Password', () {
    late MockFirebaseAuth mockAuth;

    setUp(() {
      mockAuth = MockFirebaseAuth();
    });
    testWidgets('should navigate to forgot password screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await pumpLoginScreen(tester, mockAuth);

      // Verify that the "Forgot Password?" button exists.
      expect(find.text('Lupa Kata Sandi?'), findsOneWidget);

      // Tap the "Forgot Password?" button.
      await tester.tap(find.text('Lupa Kata Sandi?'));
      await tester.pumpAndSettle(); // Wait for the navigation to complete

      // Verify that the forgot password screen is shown.
      expect(find.text('Atur Ulang Kata Sandi'), findsOneWidget);
    });
  });
}
