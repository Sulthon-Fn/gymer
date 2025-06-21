import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymer/app/admin/main/adminhome_screen.dart';
import 'package:gymer/app/auth/register_page.dart';
import 'package:gymer/app/user/home/userhome_screen.dart';
import 'package:gymer/service/login/login_service.dart';
import 'package:gymer/widget/loading/loadingwidget.dart';

import 'package:flutter/widgets.dart';

class LoginController{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose(){
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = LoginController();
  final LoginService service = LoginService();
  bool _obscureText = true;

  // Logika login tetap sama seperti sebelumnya
  void _handleLogin() async {
    String email = controller.emailController.text.trim();
    String password = controller.passwordController.text.trim();

    const String adminEmail = 'admin@gmail.com';
    const String adminPassword = 'passwordadmin';

    LoadingDialog.show(context);

    try {
      if (email == adminEmail && password == adminPassword) {
        User? admin = await service.adminLogin(email, password);
        if (mounted) LoadingDialog.hide(context);

        if (admin != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminhomeScreen()),
          );
        } else {
          _showErrorSnackbar('Login Admin Gagal.');
        }
      } else {
        User? user = await service.userLogin(email, password);
        if (mounted) LoadingDialog.hide(context);

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserhomeScreen()),
          );
        } else {
          _showErrorSnackbar(
              'Login Gagal. Periksa kembali email dan password Anda.');
        }
      }
    } catch (e) {
      if (mounted) LoadingDialog.hide(context);
      _showErrorSnackbar('Terjadi kesalahan: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    controller.dispose();
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
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Welcome back!",
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
                      hintText: 'Password',
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
                  const SizedBox(height: 32),
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
                      onPressed: _handleLogin,
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
                        "You don't have an account yet? ",
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
                          "Register",
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
