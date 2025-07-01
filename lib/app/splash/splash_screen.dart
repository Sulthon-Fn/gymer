import 'dart:async'; // Import untuk Timer
import 'package:flutter/material.dart'; // Import widget Flutter
import 'package:gymer/app/auth/login_screen.dart'; // Import halaman login
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:gymer/app/user/home/userhome_screen.dart'; // Import halaman home user

// Widget SplashScreen sebagai halaman pembuka aplikasi
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Atur timer untuk pindah halaman setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return; // Cegah error jika widget sudah unmounted
      // Cek status login user
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Jika sudah login, langsung ke home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UserhomeScreen()),
        );
      } else {
        // Jika belum login, ke login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Atur warna latar belakang sesuai desain figma Anda
      // Ganti dengan kode warna yang tepat jika perlu
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan logo dari folder assets
            Image.asset(
              'assets/images/logo_gymer.png',
              width: 200, // Sesuaikan ukurannya jika perlu
            ),
            const SizedBox(height: 24),
            // Menampilkan loading indicator
            const CircularProgressIndicator(
              // Beri warna pada loading indicator
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
