import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Classes/StorageManager.dart';
import 'package:visitManagement_Mobilee/Change_Password.dart';
import 'package:visitManagement_Mobilee/Profile.dart';

import 'Help.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsPage2State();
}

class _SettingsPage2State extends State<Settings> {
  bool _isDark = false;

  final storageManager = StorageManager();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Set the default light theme
      darkTheme: ThemeData.dark(), // Set the dark theme
      themeMode: _isDark
          ? ThemeMode.dark
          : ThemeMode.light, // Set the current theme mode
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: const Color(0xFF3F51B5),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
      //  drawer: const NavigatorDrawer(),
        drawer: NavigatorDrawer(storageManager),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                      title: "Dark Mode",
                      icon: Icons.dark_mode_outlined,
                      trailing: Switch(
                        value: _isDark,
                        onChanged: (value) {
                          setState(() {
                            _isDark = value;
                            // Toggle between dark and light themes
                            if (_isDark) {
                              ThemeMode.dark;
                            } else {
                              ThemeMode.light;
                            }
                          });
                        },
                      ),
                    ),

                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Organization",
                  children: [
                    _CustomListTile(
                      title: "Profile",
                      icon: Icons.person_outline_rounded,
                    ),
                    _CustomListTile(
                      title: 'Change Password',
                      icon: Icons.lock,
                    ),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  children: [
                    _CustomListTile(
                      title: "Contact Us",
                      icon: Icons.phone,
                    ),
                    _CustomListTile(
                      title: "Sign out",
                      icon: Icons.exit_to_app_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;


  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storageManager = StorageManager();
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: ()  async {
        if (title == "Sign out") {
           await storageManager.deleteAll();

          // Navigate to the home page
          Navigator.of(context).pop(); // Close the settings screen
          // Replace the following line with your home page widget
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => HomePage()),  (Route<dynamic> route) => false);
        }

        if (title == "Change Password") {
          Navigator.of(context).pop();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangePassword()));
        }

        if (title == "Profile") {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Profile()));
        }

        if (title=="Contact Us"){
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Help()));
        }

      },
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
