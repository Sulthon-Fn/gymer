import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymer/app/auth/loginconfirmation.dart';
import 'package:gymer/service/database/database_service.dart';
import 'package:gymer/widget/dateslider/dateslider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserhomeScreen extends StatefulWidget {
  const UserhomeScreen({super.key});

  @override
  _UserhomeScreenState createState() => _UserhomeScreenState();
}

class _UserhomeScreenState extends State<UserhomeScreen> {
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? userName;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _getUserName() async {
    Map<String, String>? fetchedUserName = await service.getUserName();
    setState(() {
      if (fetchedUserName != null) {
        userName = fetchedUserName['name'];
      }
    });
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
                      'Halo, $userName',
                      style: const TextStyle(color: Colors.white),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Column(
                      children: [
                        StreamBuilder<Map<String, String>?>(
                          stream: service.getUserDetailsStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading data'));
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return const Center(
                                  child: Text('No data available'));
                            } else {
                              var userDetails = snapshot.data!;
                              String qrData = "Nama: ${userDetails['name']}\n"
                                  "Email: ${userDetails['email']}\n"
                                  "Paket: ${userDetails['package']}\n"
                                  "Hari Tersisa: ${userDetails['remainingDays']}";

                              return Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Kartu Member',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 28,
                                            backgroundColor: Colors.grey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Nama : ${userDetails['name']}'),
                                                Text(
                                                    'Email : ${userDetails['email']}'),
                                                Text(
                                                    'Paket : ${userDetails['package']}'),
                                                Text(
                                                    'Hari tersisa : ${userDetails['remainingDays']} Hari'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'Absen GYM',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Scan QR code dilakukan oleh admin untuk absen GYM hari ini',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        StreamBuilder<Map<String, String>?>(
                          stream: service.getUserDetailsStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading QR data'));
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return const Center(
                                  child: Text('No QR data available'));
                            } else {
                              var userDetails = snapshot.data!;
                              String qrData = "Nama: ${userDetails['name']}\n"
                                  "Email: ${userDetails['email']}\n"
                                  "Paket: ${userDetails['package']}\n"
                                  "Hari Tersisa: ${userDetails['remainingDays']}";

                              return QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 200.0,
                              );
                            }
                          },
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
                                      builder: (context) => const Login(),
                                    ),
                                  );
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
