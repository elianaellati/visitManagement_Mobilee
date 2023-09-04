import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Classes/contact.dart';
import 'package:http/http.dart' as http;

import 'Classes/forms.dart';

class Dialogue extends StatefulWidget {
  final forms form;

  Dialogue(this.form);

  @override
  State<StatefulWidget> createState() {
    return AssignmentDetailsState();
  }
}

class AssignmentDetailsState extends State<Dialogue> {
  late Future<List<contact>> futureAssignment;

  @override
  void initState() {
    super.initState();
    futureAssignment = fetchAssignments(widget.form.id);
  }

  @override
  Widget build(BuildContext context) {
    final bool showStartButton =
        widget.form.status == 'Not Started';

    bool isStarted = false;
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
                const SizedBox(height: 8), // Add space between the title and rows
                buildInfoRow('Name', widget.form.customerName),
                const SizedBox(height: 8), // Add space between rows
                buildInfoRow('Location', '${widget.form.customerAddress}, ${widget.form.customerCity}'),
                const SizedBox(height: 8), // Add space between rows
                buildInfoRow('Status', widget.form.status),


                if (showStartButton)
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isStarted = true;
                        print('isStarted set to true');
                      });
                      await http.put(
                        Uri.parse('http://10.10.33.91:8080/visit_forms/${widget.form.id}/start'),
                      );

                    },
                    child: Text('Start'),
                  ),
                if (isStarted) // Show "Cancelled" and "Completed" buttons if the form is started
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle the "Cancelled" button click here
                        },
                        child: Text('Cancelled'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle the "Completed" button click here
                        },
                        child: Text('Completed'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 8), // Add space between "Contacts" and the list view
          const Padding(
            padding: EdgeInsets.all(16.0), // Add padding around the "Contacts" text
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
                  return const Center(child: Text('No Assignment Details available.'));
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
        Text(
          '$label: $value',
        ),
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
                  // Handle the error (e.g., show a message)
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
                  // Handle the error (e.g., show a message)
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
            // Add more widgets to display other details
          ],
        )
      ),


    );
  }
  Future<List<contact>> fetchAssignments(int assignmentId) async {
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


}