import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymer/app/auth/loginuser/userlogin_controller.dart';
import 'package:gymer/app/user/home/userhome_screen.dart';
import 'package:gymer/service/login/login_service.dart';
import 'package:gymer/widget/loading/loadingwidget.dart';

class UserloginScreen extends StatefulWidget {
  const UserloginScreen({super.key});

  @override
  _UserloginScreenState createState() => _UserloginScreenState();
}

class _UserloginScreenState extends State<UserloginScreen> {
  final LoginController controller = LoginController();
  final LoginService service = LoginService();

  bool _loading = false;

  void _userlogin() async {
    String email = controller.emailController.text;
    String password = controller.passwordController.text;

    if (email == 'admin@gmail.com') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau password salah')));
    } else {
      try {
        setState(() {
          _loading = true;
        });
        // Show loading dialog
        LoadingDialog.show(context);

        User? user = await service.userLogin(email, password);

        // Dismiss loading dialog
        Navigator.of(context, rootNavigator: true).pop();

        if (user != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login Berhasil')));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const UserhomeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Login gagal, silahkan coba lagi.')));
        }
      } catch (e) {
        print('Error: $e');
        // Dismiss loading dialog on error
        Navigator.of(context, rootNavigator: true).pop();
      } finally {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Login\nUser.',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _loading ? null : _userlogin,
                        child: _loading ? null : const Text('Masuk'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
