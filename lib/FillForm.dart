import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:visitManagement_Mobilee/Classes/Assignment.dart';
import 'package:visitManagement_Mobilee/Classes/StorageManager.dart';
import 'Classes/contact.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Classes/forms.dart';
import 'Survey.dart';
import 'openMap.dart';

import 'Classes/StorageManager.dart';

class FillForm extends StatefulWidget {
  final forms form;
  final Function refreshCallback; // Change the type to Function
  FillForm(this.form, {Key? key, required this.refreshCallback});

  @override
  State<StatefulWidget> createState() {
    return FillFormState();
  }
}

class FillFormState extends State<FillForm> {
  TextEditingController textarea = TextEditingController();
  final storageManager = StorageManager();
  late Assignment storedAssignment;

  late Future<List<contact>> futureAssignment;
  late Future<List<String>> futureQuestions;
  bool serviceStatus = false;
  bool hasPermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "";
  String lat = "";
  bool isStarted = false;
  String statusText = ''; // Add questionData here

  @override
  void initState() {
    super.initState();

    statusText = widget.form.status.toString();
    futureAssignment = fetchContacts(widget.form.id);
    initData();
  }

  Future<void> initData() async {
    storedAssignment = storageManager.getObject('assignment') as Assignment;
  }

  @override
  Widget build(BuildContext context) {
    // final bool showStartButton = widget.form.status == 'Not Started';
    TextEditingController textarea = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Information'),
        backgroundColor: const Color(0xFF3F51B5),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 21),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    blurRadius: 5.0, color: Colors.grey, offset: Offset(0, 5)),
              ],
              borderRadius: BorderRadius.circular(12.0),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3F51B5),
                  Colors.blue,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*    Container(

              child: Image.asset(
                "assets/imgs/chip.png",
                width: 51,
                height: 51,
              ),
            ),*/
                  buildInfoRow(widget.form.customerName, 22.0, Colors.white),
                  // Replace 20.0 with your desired font size

                  const SizedBox(
                    height: 11,
                  ),
                  /*   Row(
                     children:[
                      const Icon(
                        Icons.location_on_outlined,
                        size: 24, // Adjust the size as needed
                        color: Colors.white, // Adjust the color as needed
                      ),
                     const SizedBox(
                        width: 11,
                      ),
                      buildInfoRow(
                          '${widget.form.customerAddress}, ${widget.form.customerCity}',
                          16.0 ,
                          Colors.white),
                       const SizedBox(
                         width: 600
                       ),
                       Row(
                           children:[

                             buildInfoRow( statusText, 16.0, Colors.white),
                             const SizedBox(
                               width:6,
                             ),
                             _buildStatusIcon(statusText),
                           ]
                       ),

                    ]
                    ),*/
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    // Add padding to the container
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // Align children to the start and end
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 24,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 11,
                            ),
                            Text(
                              '${widget.form.customerAddress}, ${widget.form.customerCity}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            buildInfoRow(statusText, 16.0, Colors.white),
                            const SizedBox(
                              width: 6,
                            ),
                            _buildStatusIcon(statusText),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (statusText == "Not Started" || statusText == "Undergoing")
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 21),
              height: 150, // Adjust the height as needed
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5.0,
                    color: Colors.grey,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(15.0),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3F51B5),
                    Colors.blue,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (statusText == "Not Started")
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              //Questions();
                              _showQuestions();
                              String request =
                                  'http://10.10.33.91:8080/visit_forms/${widget.form.id}/start';
                              requestServer(request);
                              setState(() {
                                isStarted = true;
                                widget.refreshCallback();
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 35,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Start',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    if (statusText == "Not Started")
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _showAlertDialog();
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.cancel,
                                  size: 35,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    if (statusText == "Not Started")
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              checkGps();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => openMap(
                                    widget.form.latitude,
                                    widget.form.longitude,
                                    lat,
                                    long,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.location_on,
                                  size: 35,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                    // Add a similar section for "Undergoing" status
                    if (statusText == "Undergoing")
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              _showQuestions();
                            /*  String request =
                                  'http://10.10.33.91:8080/visit_forms/${widget.form.id}/complete/question';
                              _showNote(request);*/
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  size: 35,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Complete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    if (statusText == "Undergoing")
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                           //   await _showQuestions();
                          //    _showAlertDialog();
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.cancel,
                                  size: 35,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    if (statusText == "Undergoing")
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              checkGps();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => openMap(
                                    widget.form.latitude,
                                    widget.form.longitude,
                                    lat,
                                    long,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.map,
                                  size: 35,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Map',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          const Divider(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 21),
            height: 300,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5.0,
                  color: Colors.grey,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(15.0),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3F51B5),
                  Colors.blue,
                ],
              ),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(13.0), // Add padding to the left
                  child: Align(
                    alignment: Alignment.centerLeft,
                    // Align the text to the left
                    child: Text(
                      'Contacts :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 21),
                    height: 200,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Colors.white60,
                          offset: Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.white,
                        // Change this color to your desired border color
                        width: 1.0, // Adjust the border width as needed
                      ),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3F51B5),
                          Colors.blue,
                        ],
                      ),
                    ),
                    child: FutureBuilder<List<contact>>(
                      future: futureAssignment,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No Assignment Details available.'),
                          );
                        } else {
                          final assignmentDetails = snapshot.data!;

                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: assignmentDetails.length,
                            itemBuilder: (context, index) {
                              final assignment = assignmentDetails[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.supervised_user_circle,
                                    color: Color(0xFF3F51B5),
                                  ),
                                ),
                                title: Text(
                                  assignment.firstName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  assignment.email,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: Text(
                                  assignment.phoneNumber,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildInfoRow(String value, double fontSize, Color textColor) {
    return Text(
      value,
      style: TextStyle(fontSize: fontSize, color: textColor),
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
      print('response.body ${response.body}');
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
    serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (!serviceStatus) {
      print("GPS Service is not enabled, turn on GPS location");
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("REQUESTING LOCATION PERMISSION");
    }

    if (permission == LocationPermission.whileInUse) {
      hasPermission = true;
    }

    if (hasPermission) {
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
          title: const Text("Cancel Form",
              style: TextStyle(
                color:
                    Color(0xFF3F51B5), // Change the color to your desired color
              )),
          content: const Text("Are you sure you want to cancel form?",
              style: TextStyle(
                color:
                    Color(0xFF3F51B5), // Change the color to your desired color
              )),
          actions: <Widget>[
            TextButton(
              child: const Text('No',
                  style: TextStyle(
                    color: Color(
                        0xFF3F51B5), // Change the color to your desired color
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes',
                  style: TextStyle(
                    color: Color(
                        0xFF3F51B5), // Change the color to your desired color
                  )),
              onPressed: () {
                String request =
                    'http://10.10.33.91:8080/visit_forms/${widget.form.id}/cancel';
                Navigator.of(context).pop();
                _showNote(request);
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
        );
      },
    );
  }

  Future<void> _showQuestions() async {
    try {
      final List<String> questionDetails =await Questions(); // Await the function here
      print(questionDetails);
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Questions",
              style: TextStyle(
                color: Color(0xFF3F51B5),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are you sure you want to cancel the form?",
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: questionDetails.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(questionDetails[index]),
                    );
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                  ),
                ),
                onPressed: () {
                  String request =
                      'http://10.10.33.91:8080/visit_forms/${widget.form.id}/cancel';
                  Navigator.of(context).pop(); // Close the questions dialog
                  _showNote(request);
                },
              ),
            ],
            elevation: 24.0,
            backgroundColor: Colors.white,
          );
        },
      );
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<List<String>> Questions() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://10.10.33.91:8080/visit_forms/${widget.form.id}/questions',
        ),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return List<String>.from(jsonData);
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return [];
    }
  }


  Future<void> _showNote(String request) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Feed Back",
              style: TextStyle(
                color:
                    Color(0xFF3F51B5), // Change the color to your desired color
              )),
          content: TextField(
            controller: textarea,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: const InputDecoration(
                hintText: "Suggest us what went wrong",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.redAccent))),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('cancel',
                  style: TextStyle(
                    color: Color(
                        0xFF3F51B5), // Change the color to your desired color
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('submit',
                  style: TextStyle(
                    color: Color(
                        0xFF3F51B5), // Change the color to your desired color
                  )),
              onPressed: () {
                requestServer(request);
                Navigator.of(context).pop();
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
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
      String note = "";
      if (request.contains("complete") || request.contains("cancel")) {
        note = textarea.text;
      }
      Map<String, dynamic> data = {
        "latitude": lat,
        "longitude": long,
        "note": note,
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
      final jsonData = jsonDecode(response.body);
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("Request successful");
        print(jsonData['status']);
        setState(() {
          widget.refreshCallback();
          statusText = jsonData['status'];
          Fluttertoast.showToast(
              msg: "Successfully Started",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.white,
              textColor: Color(0xFF3F51B5),
              fontSize: 16.0);
        });
      } else {
        Future.delayed(Duration.zero, () {
          Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.white,
            textColor: Color(0xFF3F51B5),
            fontSize: 16.0,
          );
        });
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  Widget _buildStatusIcon(String status) {
    Icon icon;
    Color iconColor;

    // Define icons and colors based on status
    if (status == "Completed") {
      icon = const Icon(Icons.check_circle, color: Colors.white);
    } else if (status == "Undergoing") {
      icon = const Icon(Icons.access_time, color: Colors.white);
    } else if (status == "Not Started") {
      icon = const Icon(Icons.error_outline_rounded, color: Colors.white);
    } else {
      icon = const Icon(Icons.error, color: Colors.white);
    }

    return icon;
  }

  Widget customButton({
    required Icon buttonIcon,
    required String buttonTitle,
    required Color circleColor,
    required Function onTap,
  }) {
    return Container(
      child: InkWell(
        onTap: onTap(),
        child: Container(
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  radius: 20, backgroundColor: circleColor, child: buttonIcon),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                buttonTitle,
                overflow: TextOverflow.clip,
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
