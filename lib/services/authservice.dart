
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proverbapp/services/translation.dart';

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
        SnackBar(content: Text( AppLocalizations.of(context)!.translate('sign up successful')!,)),
      );
    }on  FirebaseAuthException catch(e){
      String message='';
      if(e.code == 'weak-password') {
        message= AppLocalizations.of(context)!.translate('password_too_weak')!;
      }else if(e.code == 'email-already-in-use'){
        message= AppLocalizations.of(context)!.translate('email_already_exists')!;
      }else if(e.code =='network-request-failed'){
        message=AppLocalizations.of(context)!.translate('connect_to_internet')!;
      }else{
        message='error${e.code}';
      }
     /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );*/
    }catch (e) {
      _showError(context, e.toString());
    }

  }
  User? get currentUser {
    return _auth.currentUser;
  }
  Future<void> updateDisplayName(String displayName) async {
    final user = currentUser;

    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload(); // Refresh user data
    }
  }

  // Update profile picture
  Future<void> updateProfilePicture(String photoUrl) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoUrl);
      await user.reload(); // Refresh user data
    }
  }

  /*Future<void> changeProfilePicture(File imageFile) async {
    final store = StorageService();
    final user = currentUser;

    try {
      // Step 1: Upload image and get a persistent URL
      final downloadUrl = await store.uploadImage(imageFile,user);

      // Step 2: Update Firebase Auth with the new photo URL
      await updateProfilePicture(downloadUrl);
    } catch (e) {
      // Handle errors (upload failure, etc.)
      print('Error updating profile picture: $e');
    }
  }*/


  // Sign In Method
  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text( AppLocalizations.of(context)!.translate('sign in successful')!,
        )),
      );
      Navigator.pushNamed(context, '/HOME');

      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InitialView()),//put the home page or the class name f
       // of the home page
      );*/
    } on  FirebaseAuthException catch(e){
      String message='';
      if(e.code == 'invalid-email') {
        message=AppLocalizations.of(context)!.translate('email_password_mismatch')!;
      }else if(e.code == 'wrong password'){
        message=AppLocalizations.of(context)!.translate('email_password_mismatch')!;
      }else if(e.code == 'too-many-requests'){
        message=AppLocalizations.of(context)!.translate('try_again_later')!;
      }else if(e.code =='network-request-failed'){
        message=AppLocalizations.of(context)!.translate('connect_to_internet')!;
      }else if(e.code == 'INVALID_LOGIN_CREDENTIALS or invalid-credential'){
        message=AppLocalizations.of(context)!.translate('email_password_mismatch')!;
      }else{
        message='error${e.code}';
      }
     
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  // Sign Out Method
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text( AppLocalizations.of(context)!.translate('sign out successful')!,)),
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
