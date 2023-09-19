import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'controllers/_taskController.dart';

import '../Classes/Assignment.dart';
import '../ui/button.dart';

class AddFormPage extends StatefulWidget {
  final Function refreshCallback; // Change the type to Function
  final Assignment assignment;

  final Function() onFormAdded;

  const AddFormPage(this.assignment,{super.key, required this.onFormAdded,required this.refreshCallback});

  @override
  State<AddFormPage> createState() => _AddFormPageState();
}

class _AddFormPageState extends State<AddFormPage> {
  late LocationPermission permission;
  bool isButtonDisabled = false;
  bool servicestatus = false;
  bool haspermission = false;
  late Position position;
  String long = "";
  String lat = "";
  final TaskController _taskController = Get.put(TaskController());
  final formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        backgroundColor: const Color(0xFF3F51B5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Text(
              //   'Add Form',
              //   style: headingStyle,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _customerNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+')),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    labelText: 'Customer Name',
                    prefixIcon: Icon(Icons.account_box_outlined,color:Color(0xFF3F51B5) ,),
                    //hintText: 'Enter Customer Name',
                    //hintStyle: TextStyle(color: Color(0xFF3F51B5)), // Change hint text color
                    labelStyle: TextStyle(color:Color(0xFF3F51B5)),

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Customer Name';
                    }
                    if (value.length < 5 || value.length > 30) {
                      return 'Customer Name must be between 5 and 30 characters';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _firstNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[a-zA-Z]+')),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    labelText: 'Contact First Name',
                    prefixIcon: Icon(Icons.account_box_outlined,color:Color(0xFF3F51B5) ,),
                   // hintText: 'Enter Contact First Name',
                    //hintStyle: TextStyle(color: Color(0xFF3F51B5)), // Change hint text color
                    labelStyle: TextStyle(color:Color(0xFF3F51B5)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Contact First Name';
                    }
                    if (value.length < 3 || value.length > 30) {
                      return 'First Name must be between 3 and 30 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _lastNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[a-zA-Z]+')),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    labelText: 'Contact Last Name',
                    prefixIcon: Icon(Icons.account_box_outlined,color: Color(0xFF3F51B5),),
                   // hintText: 'Enter Contact Last Name',
                   // hintStyle: TextStyle(color: Color(0xFF3F51B5)), // Change hint text color
                    labelStyle: TextStyle(color:Color(0xFF3F51B5)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Contact Last Name';
                    }
                    if (value.length < 3 || value.length > 30) {
                      return 'First Name must be between 3 and 30 characters';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    labelText: 'Contact Phone Number',
                   // hintText: 'Enter Contact Phone Number',
                  //  hintStyle: TextStyle(color: Color(0xFF3F51B5)), // Change hint text color
                    labelStyle: TextStyle(color:Color(0xFF3F51B5)),
                    prefixIcon: Icon(Icons.phone_android_outlined,color:Color(0xFF3F51B5),),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Contact Phone Number';
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Color(0xFF3F51B5)),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    labelText: 'Contact Email',
                   // hintStyle: TextStyle(color: Color(0xFF3F51B5)), // Change hint text color
                    labelStyle: TextStyle(color:Color(0xFF3F51B5)),
                    prefixIcon: Icon(Icons.email_outlined,color: Color(0xFF3F51B5),),
                   // hintText: 'Enter Contact Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Contact Email';

                    } else if (!RegExp(
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              MyButton(
                label: 'Create Form',
                onTap: () {
                    validateData(widget.assignment);

                },

              ),
            ],
          ),
        ),
      ),
    );
  }


  void validateData(Assignment assignment) {
    if (formKey.currentState!.validate()) {
      // All fields are valid, you can proceed with form submission
      submitForm(assignment);
    }
  }

  Future<void> requestServer(String request) async {
    try {
      await checkGps();
      Map<String, dynamic> data = {
        "latitude": lat,
        "longitude": long,
      };

      String requestBody = json.encode(data);

      final response = await http.put(
        Uri.parse(request),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Handle a successful response
        print("Request successful");
        setState(() {
          isButtonDisabled = true;
        });
        Text( "Added Successfully");
        widget.onFormAdded();
      } else {
        // Handle other response codes if needed
        print("Your Location is Far : ${response.statusCode}");
        Fluttertoast.showToast(
            msg: "Your Location is Far : ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.white,
            textColor: Color(0xFF3F51B5),
            fontSize: 16.0);
        setState(() {
          isButtonDisabled = false;
        });
      }
    } catch (error) {
      // Handle any exceptions that may occur during the request
      print("Error: $error");
      setState(() {
        isButtonDisabled = false;
      });

      Fluttertoast.showToast(
          msg: "Error : ${error}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.white,
          textColor: Color(0xFF3F51B5),
          fontSize: 16.0);
    }
  }

  Future<void> checkGps() async {
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

  Future<void> getLocation() async {
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

  void submitForm(Assignment assignment) async {
    try {
      await checkGps();
      Map<String, dynamic> data = {
        "latitude": lat,
        "longitude": long,
        "name": _customerNameController.text,
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "phoneNumber": _phoneController.text,
        "email": _emailController.text,
      };
      print(_customerNameController.text);
      String requestBody = json.encode(data);
      String request = 'http://10.10.33.91:8080/visit_assignments/${assignment.id}/new_visit';

      final response = await http.post(
        Uri.parse(request),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,

      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Successfully Added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.white,
            textColor: Color(0xFF3F51B5),
            fontSize: 16.0);
        widget.refreshCallback();
        Navigator.pop(context);


        print("Request successful");
      } else {
        // Handle other response codes if needed
        print("Error : ${response.statusCode}");
      }
    } catch (error) {
      // Handle any exceptions that may occur during the request
      print("Error: $error");
    }
  }

}
