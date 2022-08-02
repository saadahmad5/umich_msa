import 'package:firebase_auth/firebase_auth.dart';

enum SignIn { successful, invalidUsername, wrongPassword, error }
enum SignOut { success, error }
enum SignUp { successful, alreadyExists, invalidEmail, error }

Future<SignIn> signIn(String emailAddress, String password) async {
  try {
    final _ = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return SignIn.invalidUsername;
    } else if (e.code == 'wrong-password') {
      return SignIn.wrongPassword;
    } else {
      return SignIn.error;
    }
  }
  return SignIn.successful;
}

Future<SignOut> logOut() async {
  try {
    final _ = await FirebaseAuth.instance.signOut();
  } on FirebaseAuthException catch (e) {
    if (e.code.isNotEmpty) {
      return SignOut.error;
    }
  }
  return SignOut.success;
}

Future<bool> passwordResetThruEmail(String email) async {
  print('** password reset');
  try {
    final _ = await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
  } on Error catch (_) {
    return false;
  }
  return true;
}

Future<SignUp> signUp(String emailAddress, String password) async {
  print('** account sign up');
  try {
    final _ = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return SignUp.alreadyExists;
    } else if (e.code == 'invalid-email') {
      return SignUp.invalidEmail;
    } else {
      return SignUp.error;
    }
  }
  return SignUp.successful;
}
