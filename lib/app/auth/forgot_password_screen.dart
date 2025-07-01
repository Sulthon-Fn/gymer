import 'package:firebase_auth/firebase_auth.dart'; // Import untuk autentikasi Firebase
import 'package:flutter/material.dart'; // Import widget Flutter
import 'package:gymer/widget/loading/loadingwidget.dart'; // Import widget loading

// Halaman untuk reset password
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController(); // Controller input email
  bool _isLoading = false; // State loading

  // Fungsi untuk mengirim email reset password
  void _sendResetEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showErrorSnackbar('Email tidak boleh kosong');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    LoadingDialog.show(context); // Tampilkan loading

    try {
      // Kirim email reset password melalui Firebase
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        LoadingDialog.hide(context);
        _showSuccessSnackbar('Email pengaturan ulang kata sandi telah dikirim ke $email');
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        LoadingDialog.hide(context);
        _showErrorSnackbar(e.message ?? 'Terjadi kesalahan');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fungsi untuk menampilkan pesan error
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Fungsi untuk menampilkan pesan sukses
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    emailController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definisikan warna dari Figma
    const Color primaryColor = Color(0xFF2C384A);
    const Color backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Atur Ulang Kata Sandi'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Judul dan icon jadi putih
        iconTheme: const IconThemeData(color: Colors.white), // Icon back putih
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo aplikasi dengan sudut membulat
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/logo_gymer.png',
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),
            // Judul dan deskripsi
            const Text(
              'Lupa Kata Sandi?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan email Anda untuk menerima\nlink reset kata sandi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            // Input email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Masukkan email Anda',
                prefixIcon: const Icon(Icons.email_outlined, color: primaryColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            // Tombol kirim email reset
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _sendResetEmail,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Kirim Email',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            // Link kembali ke login
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Kembali ke Login',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
