import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_assignment_1/myconfig.dart';
import 'package:my_assignment_1/view/login_screen.dart';
import 'package:my_assignment_1/view/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isEmailValid = false;
  bool obscurePassword = true;
  bool obscureComfirmPassword = true;
  bool termsAndConditions = false;
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  FacebookAuth facebookAuth = FacebookAuth.instance;

  final commonDecoration = InputDecoration(
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
    labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkEmailExists(emailController.text);
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

    return TextSelectionTheme(
        data: TextSelectionThemeData(
          selectionColor: Colors.black.withOpacity(0.2),
          selectionHandleColor: Colors.black87,
        ),
        child: Scaffold(
          backgroundColor: Colors.red[300],
          body: GestureDetector(
            onTap: onTap,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  padding: const EdgeInsets.all(
                      20.0), // Padding inside the white container
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // White background color for the container
                    borderRadius:
                        BorderRadius.circular(15.0), // Rounded corners
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26, // Shadow color
                        blurRadius: 10, // Shadow blur
                        offset: Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Let's create your account!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // TextSelectionTheme(
                      //   data: TextSelectionThemeData(
                      //     selectionColor: Colors.black.withOpacity(0.2),
                      //     selectionHandleColor: Colors.black87,
                      //   ),
                      //   child: 
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: firstNameController,
                                keyboardType: TextInputType.name,
                                cursorColor: Colors.black,
                                decoration: commonDecoration.copyWith(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.red[300],
                                  ),
                                  labelText: 'First Name',
                                  hintText: 'First Name',
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Space between the text fields
                            Expanded(
                              child: TextField(
                                controller: lastNameController,
                                keyboardType: TextInputType.name,
                                cursorColor: Colors.black,
                                decoration: commonDecoration.copyWith(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.red[300],
                                  ),
                                  labelText: 'Last Name',
                                  hintText: 'Last Name',
                                ),
                              ),
                            ),
                          ],
                        ),
                      // ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black,
                        decoration: commonDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.red[300],
                          ),
                          labelText: 'Email Address',
                          hintText: 'Enter Email Here',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.black,
                        decoration: commonDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.red[300],
                          ),
                          labelText: 'Phone Number',
                          hintText: 'Enter Phone Number',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.black,
                        decoration: commonDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.red[300],
                          ),
                          labelText: 'Password',
                          hintText: 'Enter Password',
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
                      const SizedBox(height: 10),
                      TextField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.black,
                        decoration: commonDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.red[300],
                          ),
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter Password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureComfirmPassword =
                                    !obscureComfirmPassword;
                              });
                            },
                            child: Icon(
                              obscureComfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        obscureText: obscureComfirmPassword,
                      ),
                      Row(children: [
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
                            value: termsAndConditions,
                            onChanged: (bool? value) {
                              setState(() {
                                termsAndConditions = value ?? false;
                                storeSharedPrefs(termsAndConditions);
                              });
                            },
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: "I agree to ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: " and ",
                              ),
                              TextSpan(
                                text: "Terms of Use",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ".",
                              ),
                            ],
                          ),
                        )
                      ]),
                      MaterialButton(
                        elevation: 10,
                        color: Colors.red[300],
                        onPressed: onRegister,
                        minWidth: 250,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Text("Create Account",
                            style: TextStyle(fontSize: 18)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("------",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 30)),
                            Text("Or Sign Up With",
                                style: TextStyle(color: Colors.black54)),
                            Text("------",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 30)),
                          ],
                        ),
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
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100]),
                              child: Image.asset("assets/images/googlelogo.png",
                                  width: 35, height: 35),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              loginWithFacebook();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100]),
                              child: Image.asset(
                                  "assets/images/facebooklogo.png",
                                  width: 35,
                                  height: 35),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          const LoginScreen()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> onRegister() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    setState(() {
      isEmailValid = EmailValidator.validate(email);
    });
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please complete all fields"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email is not valid"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    bool emailExists = await checkEmailExists(email);
    if (emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email already exists"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!RegExp(r'^\d{3}-\d{8,12}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please use this format: xxx-xxxxxxxx"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password does not match"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password must be at least 6 characters"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password must contain both letters and numbers"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!termsAndConditions) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You need to accept the terms and conditions"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register New Account?",
              style: TextStyle(),
            ),
            content: const Text(
              "Are you sure?",
              style: TextStyle(),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  userRegistration();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  userRegistration() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    http.post(
        Uri.parse("${Myconfig.servername}/membership/api/register_user.php"),
        body: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "phone": phone,
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Register Successful"),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Register failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  Future<void> storeSharedPrefs(bool termsAndConditions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('termsAndConditions', termsAndConditions);
  }

  Future<bool> checkEmailExists(String email) async {
    final response = await http.post(
      Uri.parse("${Myconfig.servername}/membership/api/check_email.php"),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == "exists") {
        return true;
      }
    }
    return false;
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
