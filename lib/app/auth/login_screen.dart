import 'package:firebase_auth/firebase_auth.dart'; // Import untuk autentikasi Firebase
import 'package:flutter/material.dart'; // Import widget Flutter
import 'package:gymer/app/admin/main/adminhome_screen.dart'; // Import halaman admin
import 'package:gymer/app/auth/forgot_password_screen.dart'; // Import halaman lupa password
import 'package:gymer/app/auth/register_page.dart'; // Import halaman register
import 'package:gymer/app/user/main_navigation.dart'; // Import halaman main navigation
import 'package:gymer/service/login/login_service.dart'; // Import service login
import 'package:gymer/widget/loading/loadingwidget.dart'; // Import widget loading

import 'package:flutter/widgets.dart'; // Import widget dasar Flutter

// Controller untuk mengelola input email dan password
class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

// Kelas untuk membuat bentuk lengkung pada header
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50); // Titik awal lengkungan
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 4), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Halaman Login
class LoginScreen extends StatefulWidget {
  final FirebaseAuth? firebaseAuth;
  const LoginScreen({super.key, this.firebaseAuth});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = LoginController(); // Controller input
  late final LoginService service; // Service untuk login
  bool _obscureText = true; // State untuk show/hide password
  bool _isLoading = false; // State untuk loading

  @override
  void initState() {
    super.initState();
    // Inisialisasi service login dengan FirebaseAuth
    service = LoginService(auth: widget.firebaseAuth);
  }

  // Fungsi untuk menangani proses login
  void _handleLogin() async {
    String email = controller.emailController.text.trim();
    String password = controller.passwordController.text.trim();

    const String adminEmail = 'admin@gmail.com';
    const String adminPassword = 'passwordadmin';

    LoadingDialog.show(context); // Tampilkan loading

    try {
      // Jika login sebagai admin
      if (email == adminEmail && password == adminPassword) {
        User? admin = await service.adminLogin(email, password);
        if (mounted) LoadingDialog.hide(context);

        if (admin != null) {
          // Jika berhasil, arahkan ke halaman admin
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminhomeScreen()),
          );
        } else {
          _showErrorSnackbar('Login Admin Gagal.');
        }
      } else {
        // Jika login sebagai user biasa
        User? user = await service.userLogin(email, password);
        if (mounted) LoadingDialog.hide(context);

        if (user != null) {
          // Jika berhasil, arahkan ke halaman user
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          );
        } else {
          _showErrorSnackbar(
              'Login Gagal. Periksa kembali email dan kata sandi Anda.');
        }
      }
    } catch (e) {
      if (mounted) LoadingDialog.hide(context);
      _showErrorSnackbar('Terjadi kesalahan: e.toString()}');
    }
  }

  // Fungsi untuk menampilkan pesan error
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definisikan warna dari Figma
    const Color primaryColor = Color(0xFF2C384A);
    const Color backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Header melengkung
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                width: double.infinity,
                height: 250,
                color: primaryColor,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hallo!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Selamat datang kembali!",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Login
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  // Email Textfield
                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon:
                          const Icon(Icons.person_outline, color: primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password Textfield
                  TextField(
                    controller: controller.passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Kata Sandi',
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: primaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen()));
                      },
                      child: const Text(
                        'Lupa Kata Sandi?',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      onPressed:
                          _isLoading ? null : _handleLogin, // Disable button when loading
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Masuk',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Logo di bawah
                  Image.asset('assets/images/logo_gymer.png', height: 40),
                  const SizedBox(height: 16),
                  // Link Register (opsional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Anda belum punya akun? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: const Text(
                          "Daftar",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
