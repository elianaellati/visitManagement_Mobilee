import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:visitManagement_Mobilee/HomePage.dart';
import 'package:visitManagement_Mobilee/LoginPage.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isObscure = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _passwordsMatch = false;

  void _checkPasswordMatch() {
    setState(() {
      _passwordsMatch =
          newPasswordController.text == confirmPasswordController.text;
    });
  }

  void _showConfirm() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Changed'),
          content: Text(
            'Password has been changed successfully!',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.check_circle_sharp,
                color: Colors.green,
              ),
              label: Text(
                'Approve',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            )
          ],
        );
      },
    );
  }

  Future<bool> savePassword(
    String username,
    String password,
    String confirmPassword,
  ) async {
    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
    };

    final jsonData = json.encode(data);

    final response = await http.post(
      Uri.parse('http://10.10.33.91:8080/auth/reset_password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bisan Project'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3F51B5),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Text(
              'Forgot Password',
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 40.0),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: newPasswordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.password),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.password),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF3F51B5),
                minimumSize: const Size(850.0, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                if (usernameController.text.isEmpty ||
                    newPasswordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  _checkPasswordMatch();
                  if (_passwordsMatch) {
                    // ignore: unused_local_variable
                    bool success = await savePassword(
                      usernameController.text,
                      newPasswordController.text,
                      confirmPasswordController.text,
                    );
                    if (success = true) {
                      _showConfirm();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to save password.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: Text('Register New Password'),
            ),
            SizedBox(height: 20),
            if (!_passwordsMatch && newPasswordController.text.isNotEmpty)
              Text(
                'Passwords Don\'t Match!',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
