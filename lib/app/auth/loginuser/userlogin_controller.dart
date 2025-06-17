import 'package:flutter/widgets.dart';

class LoginController{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose(){
    emailController.dispose();
    passwordController.dispose();
  }

}