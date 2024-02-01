import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    
  }

  // Sign out
  Future signOut() async {
    await _auth.signOut();
  }

  // Check if the user is signed in
  Stream<User?> get user => _auth.authStateChanges();
}
