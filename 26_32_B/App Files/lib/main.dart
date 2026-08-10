import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In
import 'package:event_management_system/routes.dart'; // Ensure routes.dart is correctly imported
import 'package:event_management_system/utils/theme.dart';
import 'package:event_management_system/utils/theme_provider.dart'; // Import the theme provider
import 'package:provider/provider.dart'; // Import Provider package for state management

// Initialize Firebase for web or mobile platforms
Future<void> initializeFirebase() async {
  if (kIsWeb) {
    // Web-specific Firebase initialization
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBtX1nqKWEu61EKCCt8bCqD0J7_CRzu1S0",
        authDomain: "emsapp-d816d.firebaseapp.com",
        projectId: "emsapp-d816d",
        storageBucket: "emsapp-d816d.firebasestorage.app",
        messagingSenderId: "202505745613",
        appId: "1:202505745613:web:9202d1674a0b808e256584",
      ),
    );
  } else {
    // Default initialization for mobile platforms
    await Firebase.initializeApp();
  }
}

void main() async {
  // Ensure widgets binding is initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await initializeFirebase();

  // Initialize the theme preference, defaulting to System mode (ThemeMode.system)
  ThemeMode initialThemeMode = ThemeMode.system; // Default to system mode

  // Now run the app
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(currentTheme: initialThemeMode), // Provide the theme provider
      child: EventManagementSystemApp(),
    ),
  );
}

class EventManagementSystemApp extends StatelessWidget {
  const EventManagementSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to get the current theme from ThemeProvider
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return MaterialApp(
        title: 'Event Management System',
        themeMode: themeProvider.currentTheme, // Set the theme mode dynamically
        theme: AppTheme.getAppTheme(false), // Light theme settings
        darkTheme: AppTheme.getAppTheme(true), // Dark theme settings
        initialRoute: Routes.login, // Set the initial route (login screen)
        onGenerateRoute: Routes.generateRoute, // Custom route generation logic from routes.dart
        debugShowCheckedModeBanner: false, // Hides the debug banner in the app
      );
    });
  }
}

// Google Sign-In integration
Future<User?> signInWithGoogle() async {
  // Create a GoogleSignIn instance
  final GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    // Trigger Google Sign-In
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return null; // User canceled the sign-in
    }

    // Get the authentication details
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a credential with the Google user data
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credentials
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    return user; // Return the Firebase user object
  } catch (e) {
    print("Google sign-in failed: $e");
    return null;
  }
}
