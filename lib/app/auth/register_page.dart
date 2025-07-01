import 'package:firebase_auth/firebase_auth.dart'; // Import untuk autentikasi Firebase
import 'package:flutter/material.dart'; // Import widget Flutter
import 'package:gymer/app/admin/addmember/addmember_controller.dart'; // Import controller member
import 'package:gymer/app/auth/login_screen.dart'; // Import halaman login
import 'package:gymer/service/register/register_service.dart'; // Import service register
import 'package:gymer/widget/loading/loadingwidget.dart'; // Import widget loading

// Kelas untuk membuat header melengkung di atas
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
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

// Halaman Register
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterService service = RegisterService(); // Service untuk register
  AddmemberController controller = AddmemberController(); // Controller input
  FirebaseAuth auth = FirebaseAuth.instance; // Instance Firebase Auth

  int? remainingDays = 0; // Sisa hari membership
  String? _selectedPackage = 'Tidak ada paket'; // Paket yang dipilih

  // Fungsi untuk proses registrasi user
  Future<void> _registerUser() async {
    // Atur sisa hari berdasarkan paket
    if (_selectedPackage == '2 Minggu') {
      remainingDays = 14;
    } else if (_selectedPackage == '1 Bulan') {
      remainingDays = 30;
    }

    try {
      LoadingDialog.show(context); // Tampilkan loading

      String memberName = controller.nameController.text;
      String memberEmail = controller.emailController.text;
      String memberPassword = controller.passwordController.text;
      String memberPhone = controller.phoneController.text; // Ambil nomor telepon

      // Panggil service untuk register user baru dengan nomor telepon
      await service.registerUser(memberName, memberEmail, memberPassword,
          _selectedPackage!, remainingDays!, memberPhone);

      if (mounted) {
        // Jika berhasil, tampilkan pesan dan arahkan ke login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      // Jika gagal, tampilkan pesan error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      LoadingDialog.hide(context); // Sembunyikan loading
    }
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
            // Header
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
                      "Daftar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Buat akun barumu di Aplikasi Gym",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Register
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  // Input Email
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Input Nama Lengkap
                  TextFormField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      hintText: 'Nama Lengkap',
                      prefixIcon: const Icon(Icons.person, color: primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Input Nomor Telepon
                  TextFormField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Nomor Telepon',
                      prefixIcon: const Icon(Icons.phone, color: primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Input Password
                  TextFormField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Kata Sandi',
                      prefixIcon: const Icon(Icons.lock, color: primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tombol Daftar
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
                      onPressed: _registerUser,
                      child: const Text(
                        'Daftar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Logo aplikasi
                  Image.asset('assets/images/logo_gymer.png', height: 40),
                  const SizedBox(height: 16),
                  // Link ke halaman login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? ",
                          style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
