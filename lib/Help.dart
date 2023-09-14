import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visitManagement_Mobilee/Classes/StorageManager.dart';

import 'Settings.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Help(),
    );
  }
}

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {

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


  // Function to open the phone dialer
  Future<void> _launchPhone() async {
    const phoneNumber = 'tel:(123)456-7890';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  // Function to launch website
  Future<void> _launchWebsite() async {
    const websiteUrl = 'https://www.bisan.com/contactUs';
    if (await canLaunch(websiteUrl)) {
      await launch(websiteUrl);
    } else {
      throw 'Could not launch $websiteUrl';
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
        title: Text('Contact Us'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3F51B5),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/309/309235.png'),
            radius: 50,
          ),
          Text(
            "Welcome to our Customer Support",
              style: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 40))
          ),
          Text(userData['firstName']+" Please Contact Us:",
              style:
              GoogleFonts.roboto(textStyle:  const TextStyle(
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
            child: InkWell(
              onTap: _launchPhone,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3F51B5), Colors.blue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Phone Numbers:',
                    style:GoogleFonts.roboto( textStyle: const TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18),)
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'General Inquiries: (123) 456-7890',
                          style:GoogleFonts.roboto( textStyle: const TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18),)
                      ),
                      Text(
                        'Customer Support: (987) 654-3210',
                          style:GoogleFonts.roboto( textStyle: const TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18),)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: InkWell(
              onTap: _launchWebsite,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3F51B5), Colors.blue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Website:',
                      style:GoogleFonts.roboto( textStyle: const TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18),)
                  ),
                  subtitle: Text(
                    'https://www.bisan.com/contactUs',
                      style:GoogleFonts.roboto( textStyle: const TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 18),)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
