import 'package:flutter/material.dart';

class EquipmentScreen extends StatelessWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2C384A);
    const Color backgroundColor = Color(0xFFE9E9E9);

    // Data equipment/fasilitas gym
    final List<Map<String, String>> equipmentList = [
      {
        'name': 'Treadmill',
        'description': 'Cardio equipment untuk berlari atau berjalan',
        'image': 'assets/images/fasilitas.png',
      },
      {
        'name': 'Bench Press',
        'description': 'Equipment untuk latihan dada dan lengan',
        'image': 'assets/images/fasilitas.png',
      },
      {
        'name': 'Dumbbells',
        'description': 'Free weight untuk berbagai latihan',
        'image': 'assets/images/fasilitas.png',
      },
      {
        'name': 'Pull-up Bar',
        'description': 'Equipment untuk latihan punggung dan lengan',
        'image': 'assets/images/fasilitas.png',
      },
      {
        'name': 'Leg Press',
        'description': 'Equipment untuk latihan kaki',
        'image': 'assets/images/fasilitas.png',
      },
      {
        'name': 'Cable Machine',
        'description': 'Multi-purpose strength training equipment',
        'image': 'assets/images/fasilitas.png',
      },
    ];

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
                'Equipment & Fasilitas',
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
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fasilitas Gym Tersedia',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: equipmentList.length,
                          itemBuilder: (context, index) {
                            final equipment = equipmentList[index];
                            return _buildEquipmentCard(equipment);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentCard(Map<String, String> equipment) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              equipment['image']!,
              height: 60,
              width: 60,
              color: const Color(0xFF2C384A),
            ),
            const SizedBox(height: 12),
            Text(
              equipment['name']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C384A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              equipment['description']!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
