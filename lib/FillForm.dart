import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:visitManagement_Mobilee/Classes/StorageManager.dart';
import 'package:visitManagement_Mobilee/util/MapUtil.dart';
import 'Classes/contact.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Classes/forms.dart';

import 'controllers/GpsController.dart';



class FillForm extends StatefulWidget {

  final forms form;
  final Function refreshCallback;
// Change the type to Function
  FillForm(this.form, {Key? key, required this.refreshCallback});

  @override
  State<StatefulWidget> createState() {
    return FillFormState();

  }
}

class FillFormState extends State<FillForm> {

  final storageManager=StorageManager();
  dynamic storedBaseJson;
  TextEditingController textarea = TextEditingController();
  late Future<List<contact>> futureAssignment;
  late Future<List<String>> futureQuestions;
  String long ="";
  String lat = "";
 /* bool serviceStatus = false;
  bool hasPermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "";
  String lat = "";*/
  bool isStarted = false;
  String statusText = ''; // Add questionData here
  late List<dynamic>question=[];
  List<String>answers=[];
  GpsController gps=GpsController();



  @override
  void initState() {
    super.initState();
    List<dynamic>question;
    statusText = widget.form.status.toString();
    futureAssignment = fetchContacts(widget.form.id);
    long = widget.form.longitude.toString();
    lat = widget.form.latitude.toString();;
    initData();
  }

  Future<void> initData() async {
    storedBaseJson = await storageManager.getObject('base');
    print("drrrrrrrrrrrrrr");
    print("jnnnnnnnnnn ${storedBaseJson}");
  }

  @override
  Widget build(BuildContext context) {
    // final bool showStartButton = widget.form.status == 'Not Started';
    TextEditingController textarea = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title:  Text('Form information'),
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
                              String request =
                                  'http://10.10.33.91:8080/visit_forms/${widget.form.id}/start';
                              startRequest(request);
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
                             MapUtil.openMap(lat, long);

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
                                  Icons.drive_eta,
                                  size: 35,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Path',
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
                            onTap: ()async  {
                             await  Questions();
                             await _showQuestions();
                             String request =
                                  'http://10.10.33.91:8080/visit_forms/${widget.form.id}/complete/question';
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
                              MapUtil.openMap(lat, long);
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
                                  Icons.drive_eta,
                                  size: 35,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Path',
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
                              return GestureDetector(
                                onTap: () {
                                  // When the ListTile is tapped, open the phone dialer with the phone number
                                  final Uri phoneUri = Uri(scheme: 'tel', path: assignment.phoneNumber);
                                  launch(phoneUri.toString());
                                },
                                child: ListTile(
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
                                  subtitle: GestureDetector(
                                    onTap: () {
                                      // When the subtitle is tapped, open the email app with the recipient's email address
                                      final Uri emailUri = Uri(
                                        scheme: 'mailto',
                                        path: assignment.email,
                                        queryParameters: {'subject': 'Regarding Assignment'},
                                      );
                                      launch(emailUri.toString());
                                    },
                                    child: Text(
                                      assignment.email,
                                      style: const TextStyle(
                                        color: Colors.white, // Make the email text look like a link
                                        decoration: TextDecoration.underline, // Underline to indicate it's clickable
                                      ),
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      // When the trailing text is tapped, open the phone dialer with the phone number
                                      final Uri phoneUri = Uri(scheme: 'tel', path: assignment.phoneNumber);
                                      launch(phoneUri.toString());
                                    },
                                    child: Text(
                                      assignment.phoneNumber,
                                      style: const TextStyle(
                                        color: Colors.white, // Make the phone number look like a link
                                        decoration: TextDecoration.underline, // Underline to indicate it's clickable
                                      ),
                                    ),
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
                //_showNote(request);
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
    // Await the function here
      print("elinaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      answers = List<String>.filled(question.length, '');
      print(question);
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Please Answer These Questions",
              style: TextStyle(
                color: Color(0xFF3F51B5),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Feed Back",
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                  ),
                ),
                TextField(
                  controller: textarea,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Suggest us what went wrong",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.redAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 500,
                  width: 500,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: question.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              question[index],
                              style: const TextStyle(
                                color: Color(0xFF3F51B5),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Enter your answer...',
                              ),
                              onChanged: (text) {
                                setState(() {
                                  answers[index] = text;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

            actions: <Widget>[

              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                  ),
                ),
                onPressed: () async{
                  String request =
                      'http://10.10.33.91:8080/visit_forms/${widget.form.id}/cancel';
                  Navigator.of(context).pop(); // Close the questions dialog

                },
              ),
              TextButton(
                child: const Text(
                  'Complete',
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                  ),
                ),
                onPressed: () {
                   print (answers);
                  String request =
                      'http://10.10.33.91:8080/visit_forms/${widget.form.id}/complete/question';
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
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> Questions() async {
    try {
      if (storedBaseJson == "QUESTION") {
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
          question = jsonData;
          print(question);
        } else {
          throw Exception("HTTP Error: ${response.statusCode}");
        }
      }else{
        question=["Payment","Amount"];
      }
      } catch (error) {
      print("Error: $error");
    }
  }


 /* Future<void> _showNote(String request) async {
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
  }*/


  Future<void> requestServer(String request) async {
    try {
      await gps.checkGps();
      String note = "";
      if (request.contains("complete") || request.contains("cancel")) {
        note = textarea.text;

      }
      Map<String, dynamic> data = {
        "latitude": gps.lat,
        "longitude": gps.long,
        "note": note,
        "answers":answers,
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
  Future<void> startRequest(String request) async {
    try {
      await gps.checkGps();

      Map<String, dynamic> data = {
        "latitude": gps.lat,
        "longitude": gps.long,

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
