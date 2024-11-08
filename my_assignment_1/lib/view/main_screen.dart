import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_assignment_1/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyMemberLink"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              signOutGoogle(context);
              //signOutFacebook(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to the Main Screen!"),
      ),
    );
  }

  Future<void> signOutGoogle(BuildContext context) async {
    
    
    // Sign out from Google
    await googleSignIn.signOut();
    Navigator.pop(context);
    // Navigate back to login page
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginScreen()),
    //   (route) => false,
    // );
  }

  // Future<void> signOutFacebook(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   await FacebookAuth.instance.logOut();
  //   Navigator.pop(context);
  // }
}
