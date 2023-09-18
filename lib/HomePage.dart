import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:visitManagement_Mobilee/Assignments.dart';
import 'package:visitManagement_Mobilee/workflow.dart';
import 'Classes/User.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';
import 'Settings.dart';
import 'package:visitManagement_Mobilee/Classes/StorageManager.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
        String? name = storedUserJson['name'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    // return const Text("test");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bisan"),
        backgroundColor: const Color(0xFF3F51B5),
      ),
     // drawer: const NavigatorDrawer(),
      drawer: NavigatorDrawer(storageManager),

    );
  }
}



class NavigatorDrawer extends StatelessWidget {
  final StorageManager storageManager;
  //const NavigatorDrawer({super.key});
  const NavigatorDrawer(this.storageManager);
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
            // child: Icon(
            //   Icons.person,
            //   size: 75,
            //   color: const Color(0xFF3F51B5),
            // ),
             backgroundImage: NetworkImage(
                "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
          ),
          SizedBox(height:8),
          Text("ghjh                                                                                                                                                                                      ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )

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
          SizedBox(height:10),
          ListTile(
            leading: const Icon(Icons.summarize),
            title: const Text('Workflow'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => workflow()),
              );
            },
          ),
          SizedBox(height:10),
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
          SizedBox(height:10),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Sign out'),
            onTap: () async{
              await storageManager.deleteAll();
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      );

}

