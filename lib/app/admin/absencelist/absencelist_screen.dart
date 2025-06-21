import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gymer/service/database/database_service.dart';

class AbsencelistScreen extends StatefulWidget {
  const AbsencelistScreen({super.key});

  @override
  _AbsencelistScreenState createState() => _AbsencelistScreenState();
}

class _AbsencelistScreenState extends State<AbsencelistScreen> {
  final DatabaseService service = DatabaseService();

  // Definisikan palet warna sesuai Figma
  final Color primaryColor = const Color(0xFF2C384A);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color accentColor = const Color(0xFF4A90E2); // Warna biru untuk teks "Days Remaining"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Warna latar belakang untuk area atas (Notch)
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Warna untuk ikon back dan judul
        elevation: 0, // Hilangkan bayangan
        title: const Text(
          'ATTENDANCE LIST',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        // Kontainer utama dengan sudut melengkung di atas
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: service.getAbsenceList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada data absensi.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            var absences = snapshot.data!;

            // Logika sorting Anda sudah bagus, kita pertahankan
            absences.sort((a, b) {
              var dateTimeA = DateFormat('yyyy-MM-dd HH:mm').parse('${a['date']} ${a['time']}');
              var dateTimeB = DateFormat('yyyy-MM-dd HH:mm').parse('${b['date']} ${b['time']}');
              return dateTimeB.compareTo(dateTimeA);
            });

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              itemCount: absences.length,
              itemBuilder: (context, index) {
                var absence = absences[index];
                // Format tanggal sesuai desain Figma: "April 09, 2025"
                var formattedDate = DateFormat('MMMM dd, yyyy').format(DateFormat('yyyy-MM-dd').parse(absence['date']!));
                
                // Panggil widget helper untuk membuat item list
                return _buildAbsenceListItem(
                  name: absence['name'] ?? 'N/A',
                  date: formattedDate,
                  remainingDays: absence['remainingDays'] ?? 'N/A'
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Widget helper untuk membuat satu item di daftar absensi
  Widget _buildAbsenceListItem({required String name, required String date, required String remainingDays}) {
    return Container(
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
        children: [
          // Placeholder untuk foto profil
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.task,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 16),
          // Kolom untuk Nama dan Tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Teks untuk sisa hari
          Text(
            '$remainingDays Hari Tersisa',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
