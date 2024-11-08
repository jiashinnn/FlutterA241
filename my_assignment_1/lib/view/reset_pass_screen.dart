import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_assignment_1/myconfig.dart';
import 'package:my_assignment_1/view/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isEmailVerified = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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
  Widget build(BuildContext context) {
    onTap() {
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.red[300],
      ),
      backgroundColor: Colors.red[300],
      body: GestureDetector(
        onTap: onTap,
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
                      offset: Offset(0, 4)),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/logo2.png",
                  fit: BoxFit.fitWidth,
                  width: 150,
                  height: 70,
                ),
                const Text(
                  "Change Password",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: commonDecoration.copyWith(
                    prefixIcon: Icon(Icons.email, color: Colors.red[300]),
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.verified,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Verify Email",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    bool emailExists =
                        await checkEmailExists(emailController.text);
                    setState(() {
                      isEmailVerified = emailExists;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          emailExists ? "Email Verified" : "Email not found",
                        ),
                        backgroundColor:
                            emailExists ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300]),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: newPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: obscurePassword,
                  enabled: isEmailVerified,
                  decoration: commonDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock, color: Colors.red[300]),
                    labelText: 'New Password',
                    hintText: 'Enter new password',
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
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: obscureConfirmPassword,
                  enabled: isEmailVerified,
                  decoration: commonDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock, color: Colors.red[300]),
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter new password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      child: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isEmailVerified ? resetPassword : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text("Reset Password",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<void> resetPassword() async {
    String email = emailController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;
    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill in all fields"),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (newPassword == confirmPassword) {
      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]').hasMatch(newPassword)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password must contain both letters and numbers"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      // Send a POST request to the PHP server
      final response = await http.post(
        Uri.parse("${Myconfig.servername}/membership/api/reset_password.php"),
        body: {
          'email': email,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      // Handle the response from the server
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Password Reset Successful"),
                backgroundColor: Colors.green),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(data['message'] ?? "Password reset failed"),
                backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Server error, please try again later"),
              backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.red),
      );
    }
  }
}
