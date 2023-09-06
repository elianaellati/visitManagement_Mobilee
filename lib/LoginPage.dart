import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitManagement_Mobilee/Forget_pw.dart';
import 'checkUser.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _usernameController = TextEditingController();
  final CheckUser _userChecker = CheckUser();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    _usernameController.text = 'chrishosh';
    return Scaffold(
      appBar: AppBar(
<<<<<<<<< Temporary merge branch 1
        title: const Text('Login'),
          backgroundColor:const Color(0xFF3F51B5)

      ),
=========
          title: const Text('Login'), backgroundColor: const Color(0xFF3F51B5)),
>>>>>>>>> Temporary merge branch 2
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              Text("Welcome back",
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 10),
              Text("Login to your account",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                // Add horizontal padding
                child: Column(children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Icon(Icons.password),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: (

                            //   userCheck(username);
                            ) {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      if (await _userChecker.fetchUser(username)) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF3F51B5),
                        minimumSize: const Size(
                          850.0, // Set the desired width
                          50.0, // Set the desired height using Size.fromHeight
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: const Text("Login",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),
              ),
              SizedBox(height: 10.0),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                  },
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                        color: Color(0xFF3F51B5), fontWeight: FontWeight.bold),
                  )),
            ]),
      ),
    );
  }
}
