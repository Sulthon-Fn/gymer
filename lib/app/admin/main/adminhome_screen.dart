import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymer/app/admin/absencelist/absencelist_screen.dart';
import 'package:gymer/app/admin/addmember/addmember_screen.dart';
import 'package:gymer/app/admin/memberdata/memberlist_screen.dart';
import 'package:gymer/app/auth/login_screen.dart';
import 'package:gymer/service/database/database_service.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30.0);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AdminhomeScreen extends StatefulWidget {
  const AdminhomeScreen({super.key});

  @override
  _AdminhomeScreenState createState() => _AdminhomeScreenState();
}

class _AdminhomeScreenState extends State<AdminhomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseService service = DatabaseService();

  Future<void> _logout() async {
    await auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2C384A);
    const Color backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              color: primaryColor,
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HELLO,",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      "ADMIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildActionButton(
                    iconPath: 'assets/images/absen.png',
                    label: 'List Absensi',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AbsencelistScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    iconPath: 'assets/images/member.png',
                    label: 'Tambah Member',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddmemberScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    iconPath: 'assets/images/group.png',
                    label: 'Data Member',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MemberListScreen()),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({required String iconPath, required String label, required VoidCallback onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C384A),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        minimumSize: const Size(double.infinity, 70),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Image.asset(iconPath, height: 32, width: 32),
          const SizedBox(width: 20),
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
