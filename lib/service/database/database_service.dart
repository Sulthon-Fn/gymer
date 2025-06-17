import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> recordAttendance(String email, String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users');
      DatabaseReference attendanceRef = FirebaseDatabase.instance.ref().child('attendance/');

      try {
        // Query to find user with matching email
        var query = userRef.orderByChild('email').equalTo(email);
        DatabaseEvent event = await query.once();
        DataSnapshot snapshot = event.snapshot;

        // Check if any user matches the email
        if (snapshot.value != null) {
          Map<dynamic, dynamic>? users = snapshot.value as Map<dynamic, dynamic>?;

          String? userId;
          users?.forEach((key, value) {
            if (value['email'] == email) {
              userId = key;
            }
          });

          if (userId != null) {
            // Proceed with the attendance process
            var userData = users?[userId];
            var membership = userData?['membership'];
            var remainingDays = membership?['remainingDays'];

            var now = DateTime.now();
            var todayString = "${now.year}-${now.month}-${now.day}";
            var timeString = "${now.hour}:${now.minute}";

            // Check today's attendance
            var attendanceSnapshot = await attendanceRef
                .orderByChild('email')
                .equalTo(email)
                .get();

            bool alreadyMarkedToday = false;

            if (attendanceSnapshot.value != null) {
              Map<dynamic, dynamic>? attendanceRecords = attendanceSnapshot.value as Map<dynamic, dynamic>?;
              attendanceRecords?.forEach((key, value) {
                if (value['date'] == todayString) {
                  alreadyMarkedToday = true;
                }
              });
            }

            // Check if there are remaining days and no attendance marked today
            if (!alreadyMarkedToday && remainingDays != null && remainingDays > 0) {
              // Decrement the remaining days
              remainingDays -= 1;
              await userRef.child(userId!).child('membership').update({'remainingDays': remainingDays});
            }

            // Record the attendance with updated remainingDays
            await attendanceRef.push().set({
              'date': todayString,
              'time': timeString,
              'email': email,
              'name': name,
              'remainingDays': remainingDays
            });

          } else {
            print('Email $email not found in the database.');
          }
        } else {
          print('Email $email not found in the database.');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<Map<String, String>?> getUserName() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        final ref = database.ref();
        DataSnapshot snapshot = await ref.child('users/${user.uid}/').get();
        if (snapshot.exists) {
          String name = snapshot.child('nama').value.toString();
          return {
            'name': name,
          };
        } else {
          print('No data available');
          return null;
        }
      }
    } catch (e) {
      print('Error getting userName: $e');
      return null;
    }
    return null;
  }

  Stream<List<Map<String, String>>> getAbsenceList() {
    final ref = database.ref().child('attendance/');

    return ref.onValue.map((event) {
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        List<Map<String, String>> absences = [];
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          absences.add({
            'date': value['date'].toString(),
            'email': value['email'].toString(),
            'name': value['name'].toString(),
            'remainingDays': value['remainingDays'].toString(),
            'time': value['time'].toString()
          });
        });

        return absences;
      } else {
        print('No absence data available');
        return [];
      }
    });
  }

  Stream<Map<String, String>?> getUserDetailsStream() {
    User? user = auth.currentUser;
    if (user != null) {
      final ref = database.ref().child('users/${user.uid}');
      return ref.onValue.map((event) {
        final snapshot = event.snapshot;
        if (snapshot.exists) {
          String name = snapshot.child('nama').value.toString();
          String email = snapshot.child('email').value.toString();
          String package =
              snapshot.child('membership/package').value.toString();
          String remainingDays =
              snapshot.child('membership/remainingDays').value.toString();

          return {
            'name': name,
            'email': email,
            'package': package,
            'remainingDays': remainingDays,
          };
        } else {
          print('No data available');
          return null;
        }
      });
    } else {
      print('User not logged in');
      return Stream.value(
          null); // Mengembalikan stream dengan nilai null jika user tidak login
    }
  }
}
