import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:visitManagement_Mobilee/Classes/StorageManager.dart';
import 'package:visitManagement_Mobilee/Classes/User.dart';
import 'package:visitManagement_Mobilee/Settings.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storageManager = StorageManager();
  dynamic storedUserJson;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    initilizeData();
  }

  Future<void> initilizeData() async {
    storedUserJson = await storageManager.getObject('user');

    if (storedUserJson != null) {
      setState(() {
        userData = json.decode(storedUserJson);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              ),
        ),
        title: const Text('Profile'),
        centerTitle: true,
        toolbarHeight: 56.0,
        backgroundColor: Color(0xFF3F51B5),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Icon(
                Icons.person,
                size: 75,
                color: Color(0xFF3F51B5),
              ),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              title: const Text('First Name'),
              subtitle: Text(userData['firstName'] ?? 'Loading...'),
            ),
            ListTile(
              title: const Text('Last Name'),
              subtitle: Text(userData['lastName'] ?? 'Loading...'),
            ),
            ListTile(
              title: const Text('Username'),
              subtitle: Text(userData['username'] ?? 'Loading...'),
            ),
          ],
        ),
      ),
    );
  }
}
