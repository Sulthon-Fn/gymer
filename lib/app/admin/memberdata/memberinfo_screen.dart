import 'package:flutter/material.dart';
import 'package:gymer/service/database/database_service.dart';

class MemberInfoScreen extends StatefulWidget {
  final Map<String, dynamic> member;

  const MemberInfoScreen({super.key, required this.member});

  @override
  State<MemberInfoScreen> createState() => _MemberInfoScreenState();
}

class _MemberInfoScreenState extends State<MemberInfoScreen> {
  final DatabaseService _databaseService = DatabaseService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _remainingDaysController;
  String? _selectedPackage;

  final List<String> packages = ['2 Minggu', '1 Bulan', 'Tidak ada paket'];

  final Color primaryColor = const Color(0xFF2C384A);
  final Color hintColor = Colors.black38;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member['nama'] ?? '');
    _emailController = TextEditingController(text: widget.member['email'] ?? '');

    final membership = widget.member['membership'] as Map<String, dynamic>;
    _remainingDaysController = TextEditingController(
      text: membership['remainingDays'].toString(),
    );
    _selectedPackage = membership['package'];
  }

  Future<void> _updateMember() async {
    try {
      String uid = widget.member['uid'];

      final updatedData = {
        'nama': _nameController.text,
        'email': _emailController.text,
        'membership': {
          'package': _selectedPackage ?? '',
          'remainingDays': int.tryParse(_remainingDaysController.text) ?? 0,
        }
      };

      await _databaseService.updateMember(uid, updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data member berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'EDIT MEMBER',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _emailController,
              hintText: 'Email',
              icon: Icons.email_outlined,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              hintText: 'Nama',
              icon: Icons.person_outline,
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
                hintText: 'Pilih Paket',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.card_giftcard_outlined, color: hintColor),
              ),
              dropdownColor: Colors.white,
              style: TextStyle(color: primaryColor),
              items: packages.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPackage = newValue;
                  if (_selectedPackage == '2 Minggu') {
                    _remainingDaysController.text = '14';
                  } else if (_selectedPackage == '1 Bulan') {
                    _remainingDaysController.text = '30';
                  } else if (_selectedPackage == 'Tidak ada paket') {
                    _remainingDaysController.text = '0';
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _remainingDaysController,
              hintText: 'Hari Tersisa',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.number,
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
                onPressed: _updateMember,
                child: const Text(
                  'Update Member',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF2C384A)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        prefixIcon: Icon(icon, color: hintColor),
      ),
    );
  }
}
