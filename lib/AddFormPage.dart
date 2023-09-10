import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'controllers/_taskController.dart';

import '../Classes/Assignment.dart';
import '../ui/button.dart';
import '../ui/inputField.dart';
import '../ui/theme.dart';
import '../Classes/forms.dart';

class AddFormPage extends StatefulWidget {
  final Assignment assignment;

  AddFormPage(this.assignment);

  @override
  State<AddFormPage> createState() => _AddFormPageState();
}

class _AddFormPageState extends State<AddFormPage> {
  late LocationPermission permission;
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
        backgroundColor: Color(0xFF3F51B5),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Text(
              //   'Add Form',
              //   style: headingStyle,
              // ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
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
                    prefixIcon: Icon(Icons.account_box_outlined),
                    hintText: 'Enter Customer Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Customer Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
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
                          labelText: 'Contact FirstName',
                          prefixIcon: Icon(Icons.account_box_outlined),
                          hintText: 'Enter Contact First Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Contact First Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
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
                          labelText: 'Contact LastName',
                          prefixIcon: Icon(Icons.account_box_outlined),
                          hintText: 'Enter Contact Last Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Contact Last Name';
                          }
                          return null;
                        },
                      ),
                ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _phoneController,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    labelText: 'Contact PhoneNumber',
                    hintText: 'Enter Contact Phone Number',
                    prefixIcon: Icon(Icons.phone_android_outlined),
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
                padding: EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    labelText: 'Contact Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Enter Contact Email',
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
      } else {
        // Handle other response codes if needed
        print("Your Location is Far : ${response.statusCode}");
      }
    } catch (error) {
      // Handle any exceptions that may occur during the request
      print("Error: $error");
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
      String requestBody = json.encode(data);
      String request = 'http://10.10.33.91:8080/visit_assignments/${assignment.id}/new_visit';

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