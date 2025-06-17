import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:gymer/service/database/database_service.dart';

class AbsencelistScreen extends StatefulWidget {
  const AbsencelistScreen({super.key});

  @override
  _AbsencelistScreenState createState() => _AbsencelistScreenState();
}

class _AbsencelistScreenState extends State<AbsencelistScreen> {
  final DatabaseService service = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Absen'),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: service.getAbsenceList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading absence list'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No absence data available'));
          } else {
            var absences = snapshot.data!;

            // Sort absences by date and time
            absences.sort((a, b) {
              var dateTimeA = DateFormat('yyyy-MM-dd HH:mm')
                  .parse('${a['date']} ${a['time']}');
              var dateTimeB = DateFormat('yyyy-MM-dd HH:mm')
                  .parse('${b['date']} ${b['time']}');
              return dateTimeB.compareTo(dateTimeA);
            });

            return ListView.builder(
              itemCount: absences.length,
              itemBuilder: (context, index) {
                var absence = absences[index];
                var formattedDate = DateFormat('dd MMMM yyyy')
                    .format(DateFormat('yyyy-MM-dd').parse(absence['date']!));
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${absence['name']}'),
                        Text(
                            'Tanggal Absen: $formattedDate, ${absence['time']}'),
                        Text('Email: ${absence['email']}'),
                        Text('Hari Tersisa: ${absence['remainingDays']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
