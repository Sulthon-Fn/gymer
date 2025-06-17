import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymer/app/admin/main/adminhome_screen.dart';
import 'package:gymer/app/auth/adminlogin/adminlogin_controller.dart';
import 'package:gymer/service/login/login_service.dart';
import 'package:gymer/widget/loading/loadingwidget.dart';

class AdminloginScreen extends StatefulWidget {
  const AdminloginScreen({super.key});

  @override
  _AdminloginScreenState createState() => _AdminloginScreenState();
}

class _AdminloginScreenState extends State<AdminloginScreen> {
  final AdminloginController controller = AdminloginController();
  final LoginService service = LoginService();

  void _adminLogin() async {
    String adminemail = 'admin@gmail.com';
    String adminpassword = 'passwordadmin';
    String email = controller.emailController.text;
    String password = controller.passwordController.text;

    if (email == adminemail && password == adminpassword) {
      try {
        LoadingDialog.show(context);
        User? user = await service.adminLogin(email, password);

        if (user != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login Berhasil')));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminhomeScreen()));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Gagal, silahkan coba lagi.')));
      } finally {}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau Password salah.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login\nAdmin.',
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email', prefixIcon: Icon(Icons.email)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password', prefixIcon: Icon(Icons.lock)),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                _adminLogin();
                              },
                              child: const Text('Masuk')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
      )
    ]));
  }
}
