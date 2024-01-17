import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRepo {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleAuthProvider authProvider = GoogleAuthProvider();
  Future<User> logginWithGoogle() async {
    try {
      if (kIsWeb) {
        UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        if (userCredential.user == null) {
          throw "user not found";
        }
        return userCredential.user!;
      }
      throw "Only Authorized for web";
    } catch (e) {
      print("error - ${e.toString()}");
      throw e.toString();
    }
  }

  Future<User?> isUserLoggedIn() async {
    return auth.currentUser;
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw e.toString();
    }
  }
}
