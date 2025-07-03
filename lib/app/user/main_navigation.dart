import 'package:flutter/material.dart';
import 'package:gymer/app/user/home/userhome_screen.dart';
import 'package:gymer/app/user/profile/profile_screen.dart';
import 'package:gymer/app/user/equipment/equipment_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  // List screen yang akan ditampilkan
  final List<Widget> _screens = [
    const UserhomeScreen(),
    const EquipmentScreen(),
    const ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2C384A);
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey[500],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Image.asset(
                  'assets/images/absen.png',
                  width: 28,
                  height: 28,
                  color: _currentIndex == 0 ? primaryColor : Colors.grey[500],
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Image.asset(
                  'assets/images/fasilitas.png',
                  width: 28,
                  height: 28,
                  color: _currentIndex == 1 ? primaryColor : Colors.grey[500],
                ),
              ),
              label: 'Equipment',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Image.asset(
                  'assets/images/profil.png',
                  width: 28,
                  height: 28,
                  color: _currentIndex == 2 ? primaryColor : Colors.grey[500],
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
