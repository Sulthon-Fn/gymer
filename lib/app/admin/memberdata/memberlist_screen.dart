import 'package:flutter/material.dart';
import 'package:gymer/app/admin/memberdata/memberinfo_screen.dart';
import 'package:gymer/service/database/database_service.dart';

// Warna dari Figma atau desain modern
const Color primaryColor = Color(0xFF2C384A);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color accentColor = Color(0xFF4CAF50); // Bisa disesuaikan

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  final DatabaseService service = DatabaseService();

  void _deleteMember(String uid) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus member ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await service.deleteMember(uid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Member berhasil dihapus')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus member')),
          );
        }
      }
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
          'MEMBER LIST',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: service.getMemberList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Gagal memuat data member'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada data member'));
            } else {
              final members = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final membership = member['membership'] as Map<String, dynamic>;
                  final uid = member['uid'];
                  final name = member['nama'] ?? 'Tanpa Nama';
                  final email = member['email'] ?? 'No Email';
                  final phone = member['phone'] ?? 'No Phone'; // Ambil nomor telepon
                  final paket = membership['package'] ?? 'N/A';
                  final remainingDays = membership['remainingDays'] ?? 0;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberInfoScreen(member: member),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[200],
                            child: Icon(Icons.person, color: Colors.grey[400]),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('Email: $email',
                                    style: const TextStyle(fontSize: 13)),
                                Text('Phone: $phone',
                                    style: const TextStyle(fontSize: 13)),
                                Text('Paket: $paket',
                                    style: const TextStyle(fontSize: 13)),
                                Text('$remainingDays Hari Tersisa',
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteMember(uid),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
