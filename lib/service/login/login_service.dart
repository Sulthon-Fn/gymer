import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> userLogin(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } catch (e) {
      print('error during login : $e');
      return null;
    }
  }

  Future<User?> adminLogin(String email, String password) async {
    try {
      String adminemail = 'admin@gmail.com';
      String adminpassword = 'passwordadmin';
      if (email == adminemail && password == adminpassword) {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        return userCredential.user;
      }
    } catch (e) {
      print('error during login : $e');
      return null;
    }
    return null;
  }
}
