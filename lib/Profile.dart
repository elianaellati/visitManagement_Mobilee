import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        backgroundColor: const Color(0xFF3F51B5),
      ),
        backgroundColor: Colors.white,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
            radius: 50,
          ),
           Text(
            "Welcome "+userData['firstName']?? 'Loading...',
            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 40))
          ),
       Text(userData['username']+' Profile',style:
        GoogleFonts.roboto(textStyle:  TextStyle(
          color: Colors.black ,
          letterSpacing: 3,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),)
       ),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
            thickness: 1,
            color: Colors.black,
          ),

          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3F51B5),
                    Colors.blue,],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child:  ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title:Text('First Name: ' + userData['firstName']?? 'Loading...',style:GoogleFonts.roboto( textStyle: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18),)),
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3F51B5),
                    Colors.blue,],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child:  ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title:Text('Last Name: '+userData['lastName'] ?? 'Loading...',style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18)),),
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3F51B5),
                    Colors.blue,],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child:  ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title:Text('Username: '+userData['username'] ?? 'Loading...',style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18)),),
              ),
            ),
          ),




        ],
      ) ,
      // body: Padding(
      //   padding: EdgeInsets.all(20.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const CircleAvatar(
      //         backgroundColor: Colors.white,
      //         radius: 50,
      //         child: Icon(
      //           Icons.person,
      //           size: 75,
      //           color: Color(0xFF3F51B5),
      //         ),
      //       ),
      //       const SizedBox(height: 20.0),
      //       ListTile(
      //         title: const Text('First Name'),
      //         subtitle: Text(userData['firstName'] ?? 'Loading...'),
      //       ),
      //       ListTile(
      //         title: const Text('Last Name'),
      //         subtitle: Text(userData['lastName'] ?? 'Loading...'),
      //       ),
      //       ListTile(
      //         title: const Text('Username'),
      //         subtitle: Text(userData['username'] ?? 'Loading...'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
