import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymer/app/auth/login_screen.dart';

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
      // Pindah ke LoginScreen dan hapus SplashScreen dari tumpukan navigasi
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
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
