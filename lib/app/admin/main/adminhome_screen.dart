import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymer/app/admin/absencelist/absencelist_screen.dart';
import 'package:gymer/app/admin/addmember/addmember_screen.dart';
import 'package:gymer/app/auth/loginconfirmation.dart';
import 'package:gymer/service/database/database_service.dart';
import 'package:gymer/widget/dateslider/dateslider.dart';
import 'package:gymer/widget/loading/loadingwidget.dart';
import 'package:gymer/widget/qrscanner/qr_scanner.dart';

class AdminhomeScreen extends StatefulWidget {
  const AdminhomeScreen({super.key});

  @override
  _AdminhomeScreenState createState() => _AdminhomeScreenState();
}

class _AdminhomeScreenState extends State<AdminhomeScreen> {
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? userName;
  String? userEmail;
  String? userPackage;
  String? userRemainingDays;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  Future<void> _scanQRCode() async {
    // Navigate to the QR code scanner screen and get the result back
    final scanResult = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRViewExample()),
    );

    if (scanResult != null) {
      String? email = getEmailFromQrData(scanResult);
      String? name = getNameFromQrData(scanResult);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data Absensi'),
          content: Text('$scanResult'),
          actions: [
            TextButton(
              onPressed: () {
                _recordAttendance(email!, name!);
              },
              child: const Text('Konfirmasi Absen'),
            ),
          ],
        ),
      );
    }
  }

  String? getEmailFromQrData(String qrData) {
    String searchKey = 'Email: ';
    int startIndex = qrData.indexOf(searchKey);
    if (startIndex != -1) {
      startIndex += searchKey.length;
      int endIndex = qrData.indexOf('\n', startIndex);
      if (endIndex == -1) {
        endIndex = qrData.length;
      }
      return qrData.substring(startIndex, endIndex).trim();
    }

    return null;
  }

  String? getNameFromQrData(String qrData) {
    // Define the search key
    String searchKey = 'Nama: ';

    // Find the start index of the email key
    int startIndex = qrData.indexOf(searchKey);

    // If the key is found in the QR data
    if (startIndex != -1) {
      // Move the start index to the end of the 'Email: ' key
      startIndex += searchKey.length;

      // Find the end index of the email (next newline or end of string)
      int endIndex = qrData.indexOf('\n', startIndex);

      // If endIndex is -1, it means the email is the last part of the string
      if (endIndex == -1) {
        endIndex = qrData.length;
      }

      // Extract and return the email substring, trimmed of any extra spaces
      return qrData.substring(startIndex, endIndex).trim();
    }

    // Return null if 'Email: ' key is not found
    return null;
  }

  Future<void> _recordAttendance(String email, String name) async {
    try {
      LoadingDialog.show(context);

      await service.recordAttendance(email, name);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Absen Berhasil')));
    } catch (e) {
      print('Error: $e');
    } finally {
      LoadingDialog.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue,
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: top <= 56 ? 16 : 0,
                    bottom: 16,
                    right: top <= 56 ? 16 : 0,
                  ),
                  centerTitle: top > 56,
                  title: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      'Halo, Admin',
                      style: TextStyle(
                          color: top <= 56 ? Colors.black : Colors.white),
                    ),
                  ),
                  background: Container(
                    color: Colors.blue,
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                DateSlider(onDateChanged: _onDateChanged),
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Absen GYM',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                const Text(
                                  'Silahkan Scan QR code untuk absensi member GYM',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _scanQRCode,
                                        child: const Text('Scan QR Code'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AbsencelistScreen()));
                          },
                          child: const Card(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('List Absensi'),
                                  Icon(Icons.arrow_right)
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddmemberScreen()));
                          },
                          child: const Card(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tambah Member'),
                                  Icon(Icons.arrow_right)
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  auth.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()));
                                },
                                child: const Text('Log Out'),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
