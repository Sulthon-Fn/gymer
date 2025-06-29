import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymer/app/auth/forgot_password_screen.dart';

void main() {
  testWidgets('Forgot Password Screen UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: ForgotPasswordScreen(),
    ));

    // Verify that the title is rendered.
    expect(find.text('Atur Ulang Kata Sandi'), findsOneWidget);

    // Verify that the email text field is rendered.
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the send reset email button is rendered.
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Kirim Email Pengaturan Ulang'), findsOneWidget);
  });
}
