import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitManagement_Mobilee/Assignments.dart';
import 'package:visitManagement_Mobilee/Forget_pw.dart';
import 'checkUser.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  final CheckUser _userChecker = CheckUser();
  bool _isObscure = true;

  Future<bool> LoginVal(String username, String password) async {
    final Map<String, dynamic> data = {
      'username': username,
      'password': password
    };

    final jsonData = json.encode(data);

    final response = await http.post(
      Uri.parse('http://10.10.33.91:8080/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 202) {
      _userChecker.fetchUser( _usernameController.text);
      return true;
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'] ?? 'Invalid credentials';
      print('Error Message: $errorMessage');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Login'), centerTitle: true, backgroundColor: const Color(0xFF3F51B5)),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text("Welcome back",
                  style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: 10),
              Text("Login to your account",
                  style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Username',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length < 3 || value.length > 30) {
                          return 'Username must be between 3 and 30 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: _isObscure,//test
                      controller: _PasswordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Icon(Icons.password),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8 || value.length > 30) {
                          return 'Password must be between 8 and 30 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        // Capture the context before the asynchronous call
                        BuildContext? currentContext = context;

                        if (_formKey.currentState!.validate()) {
                          String username = _usernameController.text;
                          String password = _PasswordController.text;
                          bool loginSuccess = await LoginVal(username, password);

                          // Use the captured context for showing SnackBar
                          if (loginSuccess == true) {
                            Navigator.push(
                              currentContext,
                              MaterialPageRoute(builder: (context) => const Assignments()),
                            );
                          } else {
                            ScaffoldMessenger.of(currentContext!).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid Name or Password'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF3F51B5),
                          minimumSize: const Size(
                            850.0,
                            50.0,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text("Login",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                  },
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(
                        color: Color(0xFF3F51B5), fontWeight: FontWeight.bold),
                  )),
            ]),
      ),
    );
  }
}
