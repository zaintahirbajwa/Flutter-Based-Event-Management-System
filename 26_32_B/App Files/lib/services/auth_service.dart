import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:event_management_system/models/user_model.dart';
import 'package:event_management_system/views/auth/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to handle user login with Firebase Authentication
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentReference userRef =
          _firestore.collection('users').doc(userCredential.user?.uid);

      // Using merge to avoid overwriting user data
      await userRef.set({
        'isLoggedIn': true,
        'username': email,
      }, SetOptions(merge: true));

      return userCredential;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          return userData['isLoggedIn'] ?? false;
        }
      }

      return false;
    } catch (e) {
      print("Error checking login status: $e");
      return false;
    }
  }

  // Method to get the logged-in user's username
  Future<String?> getUsername() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          return userData['username'];
        }
      }

      return null;
    } catch (e) {
      print("Error getting username: $e");
      return null;
    }
  }

  // Method to fetch the current user's ID
  Future<String?> getCurrentUserId() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      print("Error fetching current user ID: $e");
      return null;
    }
  }

  // Method to handle user logout and navigate to login screen
  Future<void> logout(BuildContext context) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference userRef =
            _firestore.collection('users').doc(user.uid);
        await userRef.update({
          'isLoggedIn': false,
        });

        await _auth.signOut();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  // Method for Google Sign-In
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null; // User canceled the Google Sign-In
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      DocumentReference userRef =
          _firestore.collection('users').doc(userCredential.user?.uid);
      await userRef.set({
        'username': userCredential.user?.displayName,
        'email': userCredential.user?.email,
        'isLoggedIn': true,
      }, SetOptions(merge: true));

      // Navigate based on role (example: admin check)
      if (userCredential.user?.email == 'admin@example.com') {
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/user_dashboard');
      }

      return userCredential;
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  // Method to simulate user registration (Improved)
  Future<bool> register(UserModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.name,
        password: user.password,
      );

      DocumentReference userRef =
          _firestore.collection('users').doc(userCredential.user?.uid);

      await userRef.set({
        'username': user.name,
        'isLoggedIn': false,
      });

      return true;
    } catch (e) {
      print("Registration error: $e");
      return false;
    }
  }

  // Method to reset the user's password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("Error resetting password: $e");
      return false;
    }
  }
}
