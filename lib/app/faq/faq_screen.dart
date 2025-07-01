import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan warna sesuai Figma
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
                'Butuh bantuan? Kami siap membantu!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Temukan jawaban atas pertanyaan Anda di sini atau hubungi tim dukungan kami untuk solusi cepat.',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 32),

              // --- Bagian Cara Registrasi ---
              _buildFaqSection(
                title: 'Bagaimana cara mendaftar dan masuk?',
                points: [
                  'Buka aplikasi Gymer dan pilih "Daftar".',
                  'Masukkan nama, email, dan kata sandi Anda.',
                  'Verifikasi akun Anda melalui email yang dikirim.',
                  'Jika Anda sudah memiliki akun, cukup pilih "Masuk" dan masukkan email dan kata sandi Anda.',
                ],
              ),
              const SizedBox(height: 24),

              // --- Bagian Lapor Masalah ---
              _buildFaqSection(
                title: 'Laporkan Masalah',
                description: 'Laporkan masalah teknis atau bug di aplikasi, kami akan segera memperbaikinya!',
                points: [
                  'Isi formulir laporan melalui aplikasi di bagian "hubungi kami".',
                  'Jelaskan masalah yang terjadi & lampirkan tangkapan layar jika perlu.',
                  'Tim teknis kami akan segera menindaklanjuti laporan Anda.',
                ],
              ),
              const SizedBox(height: 24),

              // --- Bagian Syarat & Ketentuan ---
              _buildFaqSection(
                title: 'Syarat & Ketentuan',
                description: 'Pelajari aturan penggunaan untuk pengalaman terbaik!',
                points: [
                  'Aplikasi ini hanya untuk pengguna terdaftar.',
                  'Dilarang berbagi akun dengan orang lain.',
                  'Keanggotaan tidak dapat dialihkan ke pengguna lain.',
                  'Pembatalan kelas harus dilakukan setidaknya 24 jam sebelum sesi dimulai.',
                ],
              ),
              const SizedBox(height: 24),

              // --- Bagian Kontak ---
              const Text(
                'Hubungi Kami',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Masih butuh bantuan? Hubungi tim dukungan kami:',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              _buildContactInfo(Icons.email_outlined, 'gymgofirebase@gmail.com'),
              _buildContactInfo(Icons.phone_outlined, '+62 813-9230-3981'),
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
