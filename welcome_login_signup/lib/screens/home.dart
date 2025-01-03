import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:welcome_login_signup/screens/signin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("LogOut"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((calue){
              print("Signed Out");
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
            });
            
          },
        ),
      ),
    );
  }
}
