import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitManagement_Mobilee/Assignments.dart';
import 'Classes/User.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';
import 'Settings.dart';
import 'Classes/StorageManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    // return const Text("test");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bisan"),
        backgroundColor: const Color(0xFF3F51B5),
      ),
      drawer: const NavigatorDrawer(),
    );
  }
}

class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenu(context),
        ],
      ));

  Widget buildHeader(BuildContext context) => Container(
      color: const Color(0xFF3F51B5),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          bottom: MediaQuery.of(context).padding.bottom + 20),
      child: const Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 50,
            child: Icon(
              Icons.person,
              size: 75,
              color: const Color(0xFF3F51B5),
            ),
            // backgroundImage: NetworkImage(
            //     "https://static-00.iconduck.com/assets.00/user-icon-2048x2048-ihoxz4vq.png"),
          ),
          SizedBox(height: 12),
          Text(
            "halamon",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ));

  Widget buildMenu(BuildContext context) => Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.route),
            title: const Text('Assignments'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Assignments()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.summarize),
            title: const Text('Workflow'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Sign out'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      );
}
