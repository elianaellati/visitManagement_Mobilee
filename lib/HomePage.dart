import 'package:flutter/material.dart';
import 'package:visitManagement_Mobilee/Assignments.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;
import 'Settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
   // return const Text("test");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bisan"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const NavigatorDrawer(),
    );
  }
}
class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.stretch,
        children:<Widget> [
          buildHeader(context),
          buildMenu(context),
        ],

      )
  );

  Widget buildHeader(BuildContext context) =>
      Container(
          color: Colors.blue,
          padding: EdgeInsets.only(
              top: MediaQuery
                  .of(context)
                  .padding
                  .top + 20,
              bottom: MediaQuery
                  .of(context)
                  .padding
                  .bottom + 20
          ),
          child: const Column(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 75,
                  color: Colors.white,
                ),
                // backgroundImage: NetworkImage(
                //     "https://static-00.iconduck.com/assets.00/user-icon-2048x2048-ihoxz4vq.png"),
              ),
            ],
          ));

  Widget buildMenu(BuildContext context) =>
      Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.route),
            title: const Text('Assignments'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Assignments()),);

            },
          ),
          ListTile(
            leading: const Icon(Icons.summarize),
            title: const Text('Workflow'),
            onTap: () {

            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>  Settings()),
              );
            },
          ),
        ],
      );






}



