import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class Authservices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future register(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      Future.delayed(Duration(seconds: 5), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  Future login(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException {
      Future.delayed(Duration(seconds: 5), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Invalid login details. Please try again.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  Future signupwithgoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleuser = await googleSignIn.signIn();
      if (googleuser != null) {
        //obtain auth details from request
        final GoogleSignInAuthentication googleauth =
            await googleuser.authentication;
        //create a credential
        final credential = GoogleAuthProvider.credential(
            accessToken: googleauth.accessToken, idToken: googleauth.idToken);
        //return user data from the firebase
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      Future.delayed(Duration(seconds: 5), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'an error occured',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  Future signout() async {
    try {
      await firebaseAuth.signOut();
      await Firebase.initializeApp();
      await GoogleSignIn().signOut();
    } catch (e) {
      print(e);
    }
  }
}
