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
  RegisterService service = RegisterService();
  AddmemberController controller = AddmemberController();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<String>> packageList() async {
    return ['2 Minggu', '1 Bulan'];
  }

  int? remainingDays;
  String? _selectedPackage;

  Future<void> _addMember() async {
    if (_selectedPackage == '2 Minggu') {
      remainingDays = 14;
    } else if (_selectedPackage == '1 Bulan') {
      remainingDays = 30;
    }

    try {
      LoadingDialog.show(context);

      String memberName = controller.nameController.text;
      String memberEmail = controller.emailController.text;
      String memberPassword = controller.passwordController.text;

      await service.registerUser(memberName, memberEmail, memberPassword,
          _selectedPackage!, remainingDays!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil menambahkan atas nama $memberName')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      LoadingDialog.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Member'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  hintText: 'Nama',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<String>>(
                future: packageList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final packages = snapshot.data ?? [];
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.card_giftcard),
                        hintText: 'Pilih Paket',
                      ),
                      items: packages
                          .map<DropdownMenuItem<String>>((String value) {
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
                      value: _selectedPackage,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _addMember();
                      },
                      child: const Text('Tambah Member'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
