import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitManagement_Mobilee/Settings.dart';


class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Team'),
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings())),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Meet our Team',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Eliana Ellati',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                   ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Hala AbdElhaliem',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Eyass Mashaqi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Chris Hosh',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
            ],
          ),
        ));
  }
}
