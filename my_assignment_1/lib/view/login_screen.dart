import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_assignment_1/view/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberme = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                prefixIcon: Icon(Icons.email),
                labelText: 'Email Address',
                hintText: 'Your Email',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                hintText: 'Your Password',
              ),
            ),
            Row(children: [
              const Text("Remember me"),
              Checkbox(
                  value: rememberme,
                  onChanged: (bool? value) {
                    setState(() {
                      String email = emailController.text;
                      String password = passwordController.text;
                      if (value!) {
                        if (email.isNotEmpty && password.isNotEmpty) {
                          storeSharedPrefs(value, email, password);
                        } else {
                          rememberme = false;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Please enter your credentials"),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                      } else {
                        email = "";
                        password = "";
                        storeSharedPrefs(value, email, password);
                      }
                      rememberme = value ?? false;
                      setState(() {});
                    });
                  })
            ]),
            MaterialButton(
              elevation: 10,
              color: Colors.red[300],
              onPressed: onLogin,
              minWidth: 300,
              height: 50,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: const Text("Login"),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void onLogin() {
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    http.post(Uri.parse("http://10.113.1.117/membership/api/login_user.php"),
        body: {"email": email, "password": password}).then((response) {
          //print(response.body);
          //print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (content) => const MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  /// Store the email and password in shared preferences if [value] is true.
  /// Otherwise, erase the stored email and password.
  ///
  /// [value] is the value of the "remember me" checkbox.
  /// [email] is the email entered by the user.
  /// [password] is the password entered by the user.
  Future<void> storeSharedPrefs(
      bool value, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString("email", email);
      prefs.setString("password", password);
      prefs.setBool("rememberme", value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Remembered credentials"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.setString("email", email);
      prefs.setString("password", password);
      prefs.setBool("rememberme", value);
      emailController.text = "";
      passwordController.text = "";
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Erased credentials"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    emailController.text = prefs.getString("email") ?? "";
    passwordController.text = prefs.getString("password") ?? "";
    rememberme = prefs.getBool("rememberme") ?? false;
    setState(() {});
  }
}
