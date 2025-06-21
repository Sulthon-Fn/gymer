import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymer/service/database/database_service.dart';
import 'package:gymer/widget/loading/loadingwidget.dart';
import 'package:gymer/app/auth/login_screen.dart';
// --- 1. TAMBAHKAN IMPORT INI ---
import 'package:gymer/app/faq/faq_screen.dart';

class UserhomeScreen extends StatefulWidget {
  const UserhomeScreen({super.key});

  @override
  _UserhomeScreenState createState() => _UserhomeScreenState();
}

class _UserhomeScreenState extends State<UserhomeScreen> {
  final DatabaseService service = DatabaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _logout() async {
    // ... (fungsi logout Anda tidak berubah)
    await auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _recordAttendance(String email, String name) async {
    // ... (fungsi presensi Anda tidak berubah)
    try {
      LoadingDialog.show(context);
      await service.recordAttendance(email, name);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absen Berhasil')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      LoadingDialog.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2C384A);
    const Color backgroundColor = Color(0xFFE9E9E9);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        // --- 2. BUNGKUS DENGAN STACK ---
        child: Stack(
          children: [
            // Konten utama Anda (StreamBuilder) menjadi anak pertama dari Stack
            StreamBuilder<Map<String, String>?>(
              stream: service.getUserDetailsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userDetails = snapshot.data!;
                final email = userDetails['email'] ?? '-';
                final name = userDetails['name'] ?? '-';

                return Column(
                  children: [
                    const SizedBox(height: 100),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: backgroundColor,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: SingleChildScrollView(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              const SizedBox(height: 50),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 60, 24, 24),
                                child: Column(
                                  children: [
                                    _buildUserInfoCard(userDetails, email, name),
                                    const SizedBox(height: 24),
                                    _buildHistorySection(email),
                                  ],
                                ),
                              ),
                              _buildProfilePicture(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // --- 3. TAMBAHKAN TOMBOL FAQ DI SINI ---
            // Tombol ini akan berada di atas konten utama
            Positioned(
              top: 10,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.help_outline,
                    color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Semua widget helper (_buildProfilePicture, _buildUserInfoCard, dll) TIDAK BERUBAH
  Widget _buildProfilePicture() {
    // ...
    return Positioned(
      top: -30,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(
      Map<String, String> userDetails, String email, String name) {
    // ...
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C384A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tersisa ${userDetails['remainingDays'] ?? '-'} Hari",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C384A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () {
              _recordAttendance(email, name);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.task, color: Colors.white),
                SizedBox(width: 8),
                Text('Presensi',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 65, 65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () {
              _logout();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout, color: Colors.white),
                SizedBox(width: 8),
                Text('Logout',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(String email) {
    // ...
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Riwayat Kehadiran",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C384A),
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<Map<String, String>>>(
          stream: service.getUserAbsenceList(email),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            if (snapshot.data!.isEmpty) {
              return const Text("Belum ada riwayat absensi");
            }

            final absenceList = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: absenceList.length,
              itemBuilder: (context, index) {
                final item = absenceList[index];
                return _buildHistoryItem(
                    item['date'] ?? '-', item['remainingDays'] ?? '0');
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String date, String remainingDays) {
    // ...
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.fitness_center, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Terima kasih telah mengunjungi GYMGO!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('pada : $date',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Text(
            'Sisa Hari : $remainingDays',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
