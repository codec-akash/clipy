import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleAuthProvider authProvider = GoogleAuthProvider();
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<User> logginWithGoogle() async {
    try {
      if (kIsWeb) {
        UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        if (userCredential.user == null) {
          throw "user not found";
        }
        return userCredential.user!;
      } else {
        GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
        if (googleAccount == null) {
          throw "user not found";
        }
        GoogleSignInAuthentication authentication =
            await googleAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken,
        );
        UserCredential userCredential =
            await auth.signInWithCredential(authCredential);
        if (userCredential.user == null) {
          throw "user not found";
        }
        return userCredential.user!;
      }
    } catch (e) {
      debugPrint("error - ${e.toString()}");
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
