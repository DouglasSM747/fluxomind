import 'package:firebase_auth/firebase_auth.dart';

class ServiceConnection {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  userLogged() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  String getUserEmail() {
    return _firebaseAuth.currentUser.email;
  }

  // Email & Password Sign In
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      return (await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      ))
          .user
          .uid;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return null;
    }
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final createdUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Update the username
      await createdUser.user.reload();
      return createdUser.user.uid;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return null;
    }
  }
}
