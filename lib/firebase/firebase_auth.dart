
// ignore_for_file: dead_code_catch_following_catch

import 'package:firebase_auth/firebase_auth.dart';

import '../global/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      return credential.user;
    } on FirebaseAuthException catch(e) { 
      if (e.code == "email-already-in-use") {
        showToast(message: "The email address is already in use");
      } else{
        showToast(message: "An error occurred: ${e.code}");
      }
    }
    return null;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch(e) {
      if (e.code == "user-not-found" || e.code == "wrong-password") {
        showToast(message: "Invalid email or password");
      } else {
        showToast(message: "An error occurred: ${e.code}");
      }
    }
    return null;
  }

  Future<void> changePassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      showToast(message: "Password reset email sent. Please check your email.");
    } catch(e){
      showToast(message: e.toString());
    } on FirebaseAuthException catch(e){
      showToast(message: e.toString());
    }
  }
}