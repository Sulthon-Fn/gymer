import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan palet warna sesuai Figma
    const Color primaryColor = Color(0xFF2C384A);
    const Color backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        // AppBar ini akan secara otomatis menampilkan tombol kembali
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'FAQ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Header ---
              const Text(
                'Need help? We\'re here to help!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find answers to your questions here or contact our support team for a quick solution.',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 32),

              // --- Bagian Cara Registrasi ---
              _buildFaqSection(
                title: 'How to register and login?',
                points: [
                  'Open the Gymer app and select "Register".',
                  'Enter your name, email, and password.',
                  'Verify your account via the email sent.',
                  'If you already have an account, simply select "Login" and enter your email and password.',
                ],
              ),
              const SizedBox(height: 24),

              // --- Bagian Lapor Masalah ---
              _buildFaqSection(
                title: 'Report Issues',
                description: 'Report technical issues or bugs in the app, we will fix them immediately!',
                points: [
                  'Fill in the report form via the app in the "contact us" section.',
                  'Explain the issues that occurred & attach screenshots if necessary.',
                  'Our technical team will follow up on your report immediately.',
                ],
              ),
              const SizedBox(height: 24),

              // --- Bagian Syarat & Ketentuan ---
              _buildFaqSection(
                title: 'Terms & Conditions',
                description: 'Learn the rules of use for the best experience!',
                points: [
                  'The application is for registered users only.',
                  'Sharing accounts with others is prohibited.',
                  'Membership cannot be transferred to another user.',
                  'Class cancellations must be made at least 24 hours before the session starts.',
                ],
              ),
              const SizedBox(height: 24),

              // --- Bagian Kontak ---
              const Text(
                'Contact Us',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Still need help? Contact our support team:',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              _buildContactInfo(Icons.email_outlined, 'gymgo@gmail.com'),
              _buildContactInfo(Icons.phone_outlined, '+62 812-3456-7890'),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk setiap seksi FAQ
  Widget _buildFaqSection({
    required String title,
    String? description,
    required List<String> points,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C384A)),
        ),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
        ],
        const SizedBox(height: 12),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 15)),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget helper untuk info kontak
  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
