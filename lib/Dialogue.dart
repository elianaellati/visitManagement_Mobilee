import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:visitManagement_Mobilee/Classes/StorageManager.dart';
import 'Classes/contact.dart';
import 'Classes/surveyQuestion.dart';

import 'Classes/forms.dart';
import 'Survey.dart';
import 'openMap.dart';

import 'Classes/StorageManager.dart';

class Dialogue extends StatefulWidget {
  final forms form;
  Dialogue(this.form);

  @override
  State<StatefulWidget> createState() {
    return AssignmentDetailsState();
  }
}

class AssignmentDetailsState extends State<Dialogue> {

  TextEditingController textarea = TextEditingController();
  final storageManager=StorageManager();
  dynamic storedIdJson;

  late Future<List<contact>> futureAssignment;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "";
  String lat = "";
  bool isStarted = false;
  String statusText = '';
  late surveyQuestion questionData; // Add questionData here

  @override
  void initState() {
    super.initState();
    statusText = widget.form.status.toString();
    futureAssignment = fetchContacts(widget.form.id);

    initilizeData();
  }

  Future<void> initilizeData() async{
    storedIdJson=await storageManager.getObject('assignmentId');

  //  question = fetchQuestion(widget.form.id);


  }

  @override
  Widget build(BuildContext context) {
   // final bool showStartButton = widget.form.status == 'Not Started';
    TextEditingController textarea = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Information'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customer Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                buildInfoRow('Name', widget.form.customerName),
                const SizedBox(height: 8),
                buildInfoRow('Location',
                    '${widget.form.customerAddress}, ${widget.form.customerCity}'),
                const SizedBox(height: 8),
                // Set statusText to customerCity
                buildInfoRow('Status', statusText), // Update the status here
        if (statusText == "Not Started")
     Visibility(
      visible: true,
      child: Row(
        children: <Widget>[
          // Show the "Start" button when isStarted is false
          ElevatedButton(
            onPressed: () {
              String request = 'http://10.10.33.91:8080/visit_forms/${widget
                  .form.id}/start';
              requestServer(request);
              setState(() {
                isStarted = true;
                // Update the isStarted state to true when "Start" is clicked
              });
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(150, 30),// Set the desired width and height
              primary: Color(0xFF3F51B5), // Change the button's background color
            ),
            child: Text('Start'),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              _showAlertDialog();
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(150, 30),// Set the desired width and height
              primary: Color(0xFF3F51B5), // Change the button's background color
            ),
            child: Text('Cancelled'),
          ),
        ],
      ),
    ),


                if(statusText=="Undergoing")
                  Visibility(
                    visible: true,
                    child: Row(
                      children: <Widget>[
                        // Show the "Start" button when isStarted is false
                         ElevatedButton(
                          onPressed: () async {
                            _showNote();
                          },
                           style: ElevatedButton.styleFrom(
                             fixedSize: Size(150, 30), // Set the desired width and height
                             primary: Color(0xFF3F51B5), // Change the button's background color
                           ),
                          child: Text('Completed'),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            _showAlertDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(150, 30), // Set the desired width and height
                            primary: Color(0xFF3F51B5), // Change the button's background color
                          ),
                          child: Text('Cancelled'),
                        ),
                      ],
                    ),
                  ),





















              /*  Visibility(
                  visible: true, // Show the "Completed" button when isStarted is true
                  child: ElevatedButton(
                    onPressed: () async {
                      String request = 'http://10.10.33.91:8080/visit_forms/${widget.form.id}/complete/survey';
                      requestServer(request);
                    },
                    child: Text('Completed'),
                  ),
                ),*/
                ElevatedButton(
                  onPressed: () {
                    checkGps();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => openMap(widget.form.latitude,
                            widget.form.longitude, lat, long),
                      ),
                    );
                  },
                  child: Text("Show Route"),
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<contact>>(
              future: futureAssignment,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No Assignment Details available.'));
                } else {
                  final assignmentDetails = snapshot.data!;

                  return ListView.builder(
                    itemCount: assignmentDetails.length,
                    itemBuilder: (context, index) {
                      final assignment = assignmentDetails[index];
                      return buildAssignmentTile(assignment);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),

    );

  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label: $value'),
      ],
    );
  }

  Widget buildAssignmentTile(contact assignment) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          '${assignment.firstName} ${assignment.lastName}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final phoneNumber = assignment.phoneNumber;
                final url = 'tel:$phoneNumber';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch $url');
                }
              },
              child: Text(
                ' ${assignment.phoneNumber}',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final email = assignment.email;
                final url = 'mailto:$email';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch $url');
                }
              },
              child: Text(
                ' ${assignment.email}',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<contact>> fetchContacts(int assignmentId) async {
    final response = await http.get(
      Uri.parse('http://10.10.33.91:8080/visit_forms/$assignmentId/contacts'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) {
        final id = userJson['id'] ?? 'Unknown id';
        final firstName = userJson['firstName'] ?? 'Unknown firstName';
        final lastName = userJson['lastName'] ?? 'Unknown lastName';
        final email = userJson['email'] ?? 'Unknown email';
        final phoneNumber = userJson['phoneNumber'] ?? 'Unknown phoneNumber';

        return contact(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          id: id,
        );
      }).toList();
    } else {
      print('API Request Failed: ${response.statusCode}');
      throw Exception('Failed to load assignment details');
    }
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (!servicestatus) {
      print("GPS Service is not enabled, turn on GPS location");
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("REQUESTING LOCATION PERMISSION");
    }

    if (permission == LocationPermission.whileInUse) {
      haspermission = true;
    }

    if (haspermission) {
      setState(() {
        // Refresh the UI
      });

      await getLocation();
    } else {
      setState(() {
        // Refresh the UI
      });
    }
  }
  Future<void> _showAlertDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title:const Text("Cancel Form",
                style: TextStyle(
                  color: Color(0xFF3F51B5), // Change the color to your desired color
                )),
          content:const Text("Are you sure you want to cancel form?", style: TextStyle(
            color: Color(0xFF3F51B5), // Change the color to your desired color
          )),
          actions: <Widget>[
          TextButton(
          child: const Text('No', style: TextStyle(
            color: Color(0xFF3F51B5), // Change the color to your desired color
          )),
          onPressed: () {
          Navigator.of(context).pop();
          },
          ),
          TextButton(
          child: const Text('Yes', style: TextStyle(
          color:Color(0xFF3F51B5), // Change the color to your desired color
          )),
          onPressed: () {
            String request = 'http://10.10.33.91:8080/visit_forms/${widget
                .form.id}/cancel';
            requestServer(request);
            Navigator.of(context).pop();
          },
          ),
          ],
          elevation:24.0,
            backgroundColor: Colors.white ,

          );
        },
    );
  }
  Future<void> _showNote() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text("FeedBack",
              style: TextStyle(
                color: Color(0xFF3F51B5), // Change the color to your desired color
              )),
          content:
          TextField(
              controller: textarea,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "Suggest us what went wrong",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.redAccent)
                  )
              ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('cancel', style: TextStyle(
                color: Color(0xFF3F51B5), // Change the color to your desired color
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('submit', style: TextStyle(
                color:Color(0xFF3F51B5), // Change the color to your desired color
              )),
              onPressed: () {
                String request = 'http://10.10.33.91:8080/visit_forms/${widget.form.id}/complete/survey';
                requestServer(request);
              },
            ),
          ],
          elevation:24.0,
          backgroundColor: Colors.white ,

        );
      },
    );
  }


  getLocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(position.longitude);
    print(position.latitude);

    long = position.longitude.toString();
    lat = position.latitude.toString();

    print("Longitude:  $long ");
    print("Latitude: $lat");
    print("Request successful");

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude);
      print(position.latitude);
      long = position.longitude.toString();
      lat = position.latitude.toString();
    });
  }

  Future<void> requestServer(String request) async {
    try {
      await checkGps();
      String note="";
      if(request.contains("complete")){
         note=textarea.text;
      }
      Map<String, dynamic> data = {
        "latitude": lat,
        "longitude": long,
        "note":note,
      };

      String requestBody = json.encode(data);

      final response = await http.put(
        Uri.parse(request),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      print(requestBody);
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("Request successful");
        print(jsonData['status']);
        setState(() {
          statusText = jsonData['status'];
        });
      } else {
        print("Your Location is Far : ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
}

