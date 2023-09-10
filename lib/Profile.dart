import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:visitManagement_Mobilee/Settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    final userData = {
      'firstName': 'John',
      'lastName': 'Doe',
      'username': 'johndoe123',
    };

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()))),
        title: Text('Profile'),
        centerTitle: true,
        toolbarHeight: 56.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Icon(
                Icons.person,
                size: 75,
                color: const Color(0xFF3F51B5),
              ),
            ),
            SizedBox(height: 20.0),
            ListTile(
              title: Text('First Name'),
              subtitle: Text(userData['firstName']!),
            ),
            ListTile(
              title: Text('Last Name'),
              subtitle: Text(userData['lastName']!),
            ),
            ListTile(
              title: Text('Username'),
              subtitle: Text(userData['username']!),
            ),
          ],
        ),
      ),
    );
  }
}
