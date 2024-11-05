import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_assignment_1/view/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_any_logo/flutter_logo.dart';
import 'package:flutter_any_logo/gen/assets.gen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberme = false;
  bool isEmailValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    //onTap(){FocusScope.of(context).requestFocus(FocusNode());}; //close keyboard when clicked somewhere
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/logo2.png",
              fit: BoxFit.fitWidth,
              width: 200,
              height: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            TextSelectionTheme(
              data: TextSelectionThemeData(
                selectionColor: Colors.black
                    .withOpacity(0.2), // Set the selection color here
                selectionHandleColor: Colors.black87,
              ),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.black), // Black when focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.black), // Black when not focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.red[300],
                  ),
                  labelText: 'Email Address',
                  hintText: 'Enter Email Here',
                  labelStyle: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextSelectionTheme(
              data: TextSelectionThemeData(
                selectionColor: Colors.black.withOpacity(0.2),
                selectionHandleColor:
                    Colors.black87, // Set the selection color here
              ),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.black), // Black when focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.black), // Black when not focused
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.red[300],
                  ),
                  labelText: 'Password',
                  hintText: 'Enter Password Here',
                  labelStyle: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            Row(children: [
              const Text("Remember me"),
              Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.black; // Black when checked
                        }
                        return Colors.white; // Default color when not checked
                      }),
                    ),
                  ),
                  child: Checkbox(
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
                      }))
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
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Center(
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        width: 130,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2), // Add padding around the Google logo for the outline effect
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   border: Border.all(
                        //       color: Colors.black54, width: 1), // Black outline
                        // ),
                        child: ClipOval(
                          child:
                              AnyLogo.tech.google.image(width: 35, height: 35),
                        ),
                      ),
                      const SizedBox(
                        width: 20
                      ), 
                      ClipOval(
                        child:
                            AnyLogo.media.facebook.image(width: 35, height: 35),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  void onLogin() {
    String email = emailController.text;
    String password = passwordController.text;
    setState(() {
      isEmailValid = EmailValidator.validate(email);
    });
    if (!isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email is not valid"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    http.post(Uri.parse("http://10.113.1.207/membership/api/login_user.php"),
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
          Navigator.push(context,
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
