// Import package firebase_core untuk inisialisasi Firebase
import 'package:firebase_core/firebase_core.dart';
// Import package flutter/material untuk widget dasar aplikasi Flutter
import 'package:flutter/material.dart';
// Import halaman login
import 'package:gymer/app/auth/login_screen.dart';
// Import halaman register
import 'package:gymer/app/auth/register_page.dart';
// Import halaman splash screen
import 'package:gymer/app/splash/splash_screen.dart';
// Import halaman utama user
import 'package:gymer/app/user/main_navigation.dart';
// Import konfigurasi Firebase
import 'package:gymer/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // Pastikan binding Flutter sudah terinisialisasi sebelum menjalankan async code
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dengan konfigurasi sesuai platform (Android/iOS/Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Jalankan aplikasi utama
  runApp(const MyApp());
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Build method untuk mendeskripsikan tampilan aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hilangkan banner debug di pojok kanan atas
      debugShowCheckedModeBanner: false,
      // Judul aplikasi
      title: 'Gymer',
      // Tema aplikasi (menggunakan Material 3 dan seed color ungu)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Menggunakan StreamBuilder untuk memantau status autentikasi user
      home: StreamBuilder<User?>(
        // Stream dari FirebaseAuth untuk mendeteksi perubahan login/logout
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Jika masih menunggu status autentikasi, tampilkan splash screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // Tampilkan splash screen saat menunggu
          }
          // Jika user sudah login, arahkan ke halaman utama user
          if (snapshot.hasData) {
            return const MainNavigationScreen(); // Pengguna sudah login, arahkan ke home screen
          }
          // Jika user belum login, arahkan ke halaman login
          return const LoginScreen(); // Pengguna belum login, arahkan ke login screen
        },
      ),
    );
  }
}
