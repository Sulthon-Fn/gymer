import 'package:flutter/widgets.dart';

class AdminloginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}