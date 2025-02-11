import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign Up Successful')),
      );
    }on  FirebaseAuthException catch(e){
      String message='';
      if(e.code == 'weak-password') {
        message='the passord is too weak';
      }else if(e.code == 'email-already-in-use'){
          message='the email already exist';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }catch (e) {
      _showError(context, e.toString());
    }

  }

  // Sign In Method
  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in successful')),
      );
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InitialView()),//put the home page or the class name f
       // of the home page
      );*/
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  // Sign Out Method
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign Out Successful')),
      );
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  // Private Method to Show Error Messages
  void _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  }
}
