import 'package:flutter/material.dart';

class AddmemberController {
  // Controllers for the text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Dispose controllers to free up resources when not needed
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
