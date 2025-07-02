import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymer/service/database/database_service.dart';
import 'package:gymer/app/auth/login_screen.dart';
import 'package:gymer/app/user/profile/edit_profile_screen.dart';
import 'package:gymer/app/faq/faq_screen.dart';

/// ProfileScreen - Screen untuk menampilkan profil user
/// 
/// Fitur:
/// - Menampilkan informasi user (nama, nomor telepon, email, paket membership)
/// - Menu navigasi ke edit profile, pengaturan, bantuan
/// - Tombol logout
/// - Real-time data dari Firebase melalui Stream
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2C384A);
    const Color backgroundColor = Color(0xFFE9E9E9);
    
    final DatabaseService databaseService = DatabaseService();
    final FirebaseAuth auth = FirebaseAuth.instance;

    Future<void> logout() async {
      await auth.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: const Text(
                'Profile Saya',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: StreamBuilder<Map<String, String>?>(
                  stream: databaseService.getUserDetailsStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final userDetails = snapshot.data!;
                    
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            // Profile Picture
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // User Info Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _buildInfoRow('Nama', userDetails['name'] ?? '-'),
                                  const Divider(height: 32),
                                  _buildInfoRow('Nomor Telepon', userDetails['phone'] ?? '-'),
                                  const Divider(height: 32),
                                  _buildInfoRow('Email', userDetails['email'] ?? '-'),
                                  const Divider(height: 32),
                                  _buildInfoRow('Paket', userDetails['package'] ?? '-'),
                                  const Divider(height: 32),
                                  _buildInfoRow('Sisa Hari', '${userDetails['remainingDays'] ?? '0'} Hari'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Menu Options
                            _buildMenuOption(
                              icon: Icons.edit,
                              title: 'Edit Profile',
                              onTap: () async {
                                // Navigate ke EditProfileScreen dengan data current
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                      currentPhone: userDetails['phone'] ?? '-',
                                      userName: userDetails['name'] ?? '-',
                                    ),
                                  ),
                                );
                                
                                // Refresh data jika ada perubahan
                                if (result == true && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Profile berhasil diperbarui'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildMenuOption(
                              icon: Icons.settings,
                              title: 'Pengaturan',
                              onTap: () {
                                // TODO: Navigate to settings
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Fitur pengaturan akan segera hadir')),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildMenuOption(
                              icon: Icons.help,
                              title: 'Bantuan',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const FaqScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildMenuOption(
                              icon: Icons.logout,
                              title: 'Logout',
                              onTap: logout,
                              isDestructive: true,
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2C384A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFF2C384A),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : const Color(0xFF2C384A),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDestructive ? Colors.red : Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}