import 'package:firebase_auth/firebase_auth.dart';

enum Login { successful, invalidUsername, wrongPassword, error }

Future<Login> signIn(String emailAddress, String password) async {
  try {
    final _ = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return Login.invalidUsername;
    } else if (e.code == 'wrong-password') {
      return Login.wrongPassword;
    } else {
      return Login.error;
    }
  }
  return Login.successful;
}
