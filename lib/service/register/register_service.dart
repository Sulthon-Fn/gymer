import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Explicitly use the database URL since it's missing in FirebaseOptions
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://gymer-8b429-default-rtdb.firebaseio.com/',
  );

  // Register a new user with email and password
  Future<void> registerUser(String name, String email, String password,
      String package, int remainingDays, String phone) async {
    try {
      // Create a new user with the provided email and password
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firebaseDatabase
            .ref()
            .child('users')
            .child(user.uid)
            .set({
              'nama': name, 
              'email': email, 
              'phone': phone, // Tambahkan nomor telepon
              'role': 'user'
            });

        await _firebaseDatabase
            .ref()
            .child('users')
            .child(user.uid)
            .child('membership')
            .set({
          'package': package,
          'remainingDays': remainingDays,
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email sudah terdaftar.');
      } else {
        throw Exception('Terjadi kesalahan: ${e.message}');
      }
    } catch (e) {
      // Handle any other errors that occur during registration
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
