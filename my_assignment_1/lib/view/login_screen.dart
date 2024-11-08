import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:my_assignment_1/myconfig.dart';
import 'package:my_assignment_1/view/main_screen.dart';
import 'package:my_assignment_1/view/register_screen.dart';
import 'package:my_assignment_1/view/reset_pass_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  bool obscurePassword = true;
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  FacebookAuth facebookAuth = FacebookAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => const MainScreen()));
      }
    });
    googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    onTap() {
      FocusScope.of(context).unfocus();
    } //close keyboard when clicked somewhere

    return Scaffold(
        backgroundColor: Colors.red[300],
        body: GestureDetector(
            onTap: onTap,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black), // Black when focused
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color:
                                      Colors.black), // Black when not focused
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
                          // obscureText: true,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black), // Black when focused
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color:
                                      Colors.black), // Black when not focused
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.red[300],
                            ),
                            labelText: 'Password',
                            hintText: 'Enter Password Here',
                            labelStyle: const TextStyle(color: Colors.black),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              child: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          obscureText: obscurePassword,
                        ),
                      ),
                      Row(children: [
                        const Text("Remember me"),
                        Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                fillColor:
                                    WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.black; // Black when checked
                                  }
                                  return Colors
                                      .white; // Default color when not checked
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
                                      if (email.isNotEmpty &&
                                          password.isNotEmpty) {
                                        storeSharedPrefs(
                                            value, email, password);
                                      } else {
                                        rememberme = false;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Please enter your credentials"),
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
                                })),
                        const Spacer(),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (content) => const ResetPasswordScreen()));
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ]),
                      MaterialButton(
                        elevation: 10,
                        color: Colors.red[300],
                        onPressed: onLogin,
                        minWidth: 250,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child:
                            const Text("Login", style: TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("---------",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 30)),
                            Text("Or Login With",
                                style: TextStyle(color: Colors.black54)),
                            Text("---------",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 30)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              SignInGoogle();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: Image.asset(
                                "assets/images/googlelogo.png",
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              loginWithFacebook();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: Image.asset(
                                "assets/images/facebooklogo.png",
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          const RegisterScreen()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.red[600],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
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
    http.post(Uri.parse("${Myconfig.servername}/membership/api/login_user.php"),
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

  Future<void> SignInGoogle() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print("Google sign-in failed: $error");
    }
  }

  Future loginWithFacebook() async {
    final result =
        await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData();
      return userData;
    }
    return null;
  }
}
