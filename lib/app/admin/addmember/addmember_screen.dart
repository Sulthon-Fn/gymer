import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymer/app/admin/addmember/addmember_controller.dart';
import 'package:gymer/service/register/register_service.dart';
import 'package:gymer/widget/loading/loadingwidget.dart';

class AddmemberScreen extends StatefulWidget {
  const AddmemberScreen({super.key});

  @override
  _AddmemberScreenState createState() => _AddmemberScreenState();
}

class _AddmemberScreenState extends State<AddmemberScreen> {
  final RegisterService service = RegisterService();
  final AddmemberController controller = AddmemberController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _obscureText = true;
  String? _selectedPackage;
  final List<String> packageList = ['2 Minggu', '1 Bulan'];

  Future<void> _addMember() async {
    int remainingDays = 0;

    if (_selectedPackage == '2 Minggu') {
      remainingDays = 14;
    } else if (_selectedPackage == '1 Bulan') {
      remainingDays = 30;
    }

    try {
      LoadingDialog.show(context);

      final name = controller.nameController.text;
      final email = controller.emailController.text;
      final password = controller.passwordController.text;
      final phone = controller.phoneController.text;

      await service.registerUser(
        name,
        email,
        password,
        _selectedPackage ?? '',
        remainingDays,
        phone, // Tambahkan parameter phone
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil menambahkan atas nama $name')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      LoadingDialog.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Warna dari Figma
    const Color primaryColor = Color(0xFF2C384A);
    const Color hintColor = Colors.black38;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'NEW MEMBER',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              _buildTextField(
                controller: controller.emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.nameController,
                hintText: 'Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.phoneController,
                hintText: 'Phone Number',
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.passwordController,
                obscureText: _obscureText,
                style: const TextStyle(color: primaryColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: hintColor),
                  prefixIcon: const Icon(Icons.lock_outline, color: hintColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: hintColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPackage,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Choose Package',
                  hintStyle: const TextStyle(color: hintColor),
                  prefixIcon: const Icon(Icons.card_giftcard_outlined, color: hintColor),
                ),
                dropdownColor: Colors.white,
                style: const TextStyle(color: primaryColor),
                items: packageList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPackage = newValue;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _addMember,
                  child: const Text(
                    'Create Member',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF2C384A)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38),
        prefixIcon: Icon(icon, color: Colors.black38),
      ),
    );
  }
}
