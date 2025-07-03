import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymer/service/database/database_service.dart';
import 'package:gymer/widget/loading/loadingwidget.dart';
import 'package:url_launcher/url_launcher.dart';

class UserhomeScreen extends StatefulWidget {
  const UserhomeScreen({super.key});

  @override
  _UserhomeScreenState createState() => _UserhomeScreenState();
}

class _UserhomeScreenState extends State<UserhomeScreen> {
  final DatabaseService service = DatabaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;

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

  /// Fungsi untuk membuka WhatsApp admin
  Future<void> _openWhatsApp() async {
    const phoneNumber = '+6281392303981';
    const message = 'Halo Admin Gymer, saya tertarik untuk menjadi member. Bisa bantu saya?';
    
    final whatsappUrl = Uri.parse(
      'https://wa.me/${phoneNumber.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}'
    );
    
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  /// Cek apakah user memiliki membership aktif
  bool _isActiveMember(Map<String, String> userDetails) {
    final remainingDays = int.tryParse(userDetails['remainingDays'] ?? '0') ?? 0;
    final package = userDetails['package'] ?? '';
    
    // User dianggap member aktif jika punya sisa hari > 0 dan paket tidak kosong
    return remainingDays > 0 && package.isNotEmpty && package != '-';
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2C384A);
    const Color backgroundColor = Color(0xFFE9E9E9);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Konten utama Anda (StreamBuilder)
            Expanded(
              child: StreamBuilder<Map<String, String>?>(
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
                      // Header tanpa logo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: const Text(
                          'Selamat Datang di Gymer',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                                      // Tampilkan promosi membership jika user bukan member aktif
                                      if (!_isActiveMember(userDetails))
                                        _buildMembershipPromoCard(),
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
    bool isActiveMember = _isActiveMember(userDetails);
    
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
            isActiveMember 
                ? "Tersisa ${userDetails['remainingDays'] ?? '-'} Hari"
                : "Belum menjadi member",
            style: TextStyle(
              fontSize: 16, 
              color: isActiveMember ? Colors.grey[600] : Colors.orange[600],
              fontWeight: isActiveMember ? FontWeight.normal : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          // Tombol presensi hanya untuk member aktif
          if (isActiveMember)
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
          // Pesan untuk non-member
          if (!isActiveMember)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[600]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Untuk menggunakan fasilitas gym, Anda perlu menjadi member terlebih dahulu.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2C384A),
                      ),
                    ),
                  ),
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

  /// Widget untuk promosi membership
  Widget _buildMembershipPromoCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C384A),
            Color(0xFF3A4B5C),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon dan judul
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tertarik Jadi Member?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Deskripsi
          const Text(
            'Dapatkan akses unlimited ke semua fasilitas gym dan nikmati pengalaman fitness terbaik!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Tombol WhatsApp
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openWhatsApp,
              icon: const Icon(
                Icons.chat,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Hubungi Admin via WhatsApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366), // WhatsApp green
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Info kontak
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone,
                size: 16,
                color: Colors.white60,
              ),
              const SizedBox(width: 6),
              const Text(
                '+62 813-9230-3981',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
