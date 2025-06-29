import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymer/app/auth/login_screen.dart';

// Helper function to pump the widget with necessary ancestors
Future<void> pumpLoginScreen(WidgetTester tester, {FirebaseAuth? auth}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: LoginScreen(),
      ),
    ),
  );
}

void main() {
  group('LoginScreen Forgot Password', () {
    late MockFirebaseAuth mockAuth;

    setUp(() {
      mockAuth = MockFirebaseAuth();
    });

    testWidgets('should show forgot password dialog and send reset email', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await pumpLoginScreen(tester, auth: mockAuth);

      // Verify that the "Forgot Password?" button exists.
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Tap the "Forgot Password?" button.
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle(); // Wait for the dialog to appear

      // Verify that the dialog is shown.
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);

      // Enter an email into the TextField.
      const testEmail = 'test@example.com';
      await tester.enterText(find.byType(TextField), testEmail);

      // Tap the "Send" button.
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle(); // Wait for the dialog to close and snackbar to appear

      // Verify that the dialog is closed.
      expect(find.byType(AlertDialog), findsNothing);

      // Verify that the success snackbar is shown.
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Password reset email sent to $testEmail'), findsOneWidget);

      // Verify that sendPasswordResetEmail was called.
      expect(mockAuth.sendPasswordResetEmailCalled, isTrue);
    });

     testWidgets('should show error when email is not found', (WidgetTester tester) async {
      // Arrange: Set up the mock to throw an error
      final email = 'not-found@example.com';
      mockAuth.sendPasswordResetEmailThrowsException = true;

      await pumpLoginScreen(tester, auth: mockAuth);

      // Act
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), email);
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('An error occurred'), findsOneWidget); // Or a more specific error message
    });

  });
}
