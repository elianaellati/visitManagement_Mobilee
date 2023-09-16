import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:visitManagement_Mobilee/FillForm.dart';
import 'package:visitManagement_Mobilee/ui/button.dart';
import 'package:visitManagement_Mobilee/ui/size_config.dart';
import 'package:visitManagement_Mobilee/ui/theme.dart';
import 'Classes/StorageManager.dart';
import 'controllers/_taskController.dart';
import 'AddFormPage.dart';
import 'Classes/Assignment.dart';

import 'Classes/forms.dart';
import 'package:http/http.dart' as http;


import 'formTitle.dart';

class AssignmentDetails extends StatefulWidget {
  final Assignment assignment;
  final  Function refreshCallback;
  AssignmentDetails(this.assignment, {Key? key,required this.refreshCallback} );

  @override
  State<StatefulWidget> createState() {
    return AssignmentDetailsState();
  }

}

class AssignmentDetailsState extends State<AssignmentDetails> {
  final storageManager=StorageManager();
  late Future<List<forms>> futureAssignment;
  late Future<List<forms>> updated;
  late Assignment _assignment;
  @override
  void initState() {
    super.initState();
    futureAssignment = fetchAssignments(widget.assignment.id);
    _assignment = widget.assignment;
    final String idAsString=widget.assignment.id.toString();
    storageManager.storeObject('assignmentId', idAsString);
    storageManager.storeObject('base', _assignment.base);
print(_assignment.base);
  }


  @override
  Widget build(BuildContext context) {
    widget.refreshCallback();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        backgroundColor: Color(0xFF3F51B5),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Add your desired padding
            child: _addFormBar(context, _assignment),
          ),

          Expanded(
            child: FutureBuilder<List<forms>>(
              future: futureAssignment,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _noTaskMsg();
                } else {
                  final assignmentDetails = snapshot.data!;
                  return ListView.builder(
                    itemCount: assignmentDetails.length,
                    itemBuilder: (context, index) {
                      final assignment = assignmentDetails[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: GestureDetector(
                            onTap: () {
                              //    widget.refreshCallback();
                              Navigator.of(context).push(
                                MaterialPageRoute(

                                  builder: (context) => FillForm(assignment, refreshCallback: _refreshAssignmentDetails),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 5), // Add padding here
                              child: formTitle(assignment),
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
        ],
      ),
    );
  }



  Future<List<forms>> fetchAssignments(int assignmentId) async {
    final response = await http.get(
      Uri.parse(
          'http://10.10.33.91:8080/visit_assignments/$assignmentId/forms'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      print(jsonData);
      return jsonData.map((userJson) {
        final customerName = userJson['customer']['name'] ?? 'Unknown Customer';
        final customerAddress = userJson['customer']['location']['address'] ??
            'Unknown Address';
        final customerCity = userJson['customer']['location']['cityName'] ??
            'Unknown city';
        final customerId = userJson['customer']['id'] ?? 'Unknown customer id';
        final endTime = userJson['endTime'] ?? 'Unknown endTime';
        final startTime = userJson['startTime'] ?? 'Unknown startTime';
        final status = userJson['status'] ?? 'Unknown status';
        final id = userJson['id'] ?? 'Unknown id';
        final longitude = userJson['customer']['longitude'] ?? 'Unknown longitude';
        final latitude = userJson['customer']['latitude'] ?? 'Unknown latitude';

        return forms(
          longitude:longitude,
          latitude:latitude,
          customerName: customerName,
          customerAddress: customerAddress,
          status: status,
          startTime: startTime,
          endTime: endTime,
          id: id,
          customerId: customerId,
          customerCity: customerCity,
        );
      }).toList();
    } else {
      print('API Request Failed: ${response.statusCode}');
      throw Exception('Failed to load assignment details');
    }
  }
  _addFormBar(BuildContext context,Assignment assignment) {
    // final TaskController _taskController = Get.put(TaskController());
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assignment.comment,
                style: subHeadingStyle,
              ),
              // Text(
              //   'Today',
              //   style: subHeadingStyle,
              // ),
            ],
          ),
          MyButton(
            label: '+ Add Form',
            onTap: () {
              // Navigate to AddFormPage
              Navigator.push(

                context,
                MaterialPageRoute(builder: (context) => AddFormPage(assignment,onFormAdded: (){}, refreshCallback: _refreshAssignmentDetails)),
              );
            },
          ),
        ],
      ),
    );
  }

  // ...

  Future<void> _refreshAssignmentDetails() async {
 updated = fetchAssignments(widget.assignment.id);
 print("kkkkkkkkkkkkkkddddddddddddddddddddddddddddddkkkkkkkkkkkkkkkkkkk");
    // Update the state of your widget with the new data.
    setState(() {
      print("eliana");
      futureAssignment = updated;
      // Assign the updated data to your widget's state variable.
      // For example:
      // assignmentData = updatedData;
    });
  }


}


_noTaskMsg() {
  return Stack(
    children: [
      AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: [
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(
                height: 6,
              )
                  : const SizedBox(
                height: 220,
              ),
              SvgPicture.asset(
                'images/task.svg',
                // ignore: deprecated_member_use
                color: primaryClr.withOpacity(0.5),
                height: 90,
                semanticsLabel: 'Task',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10),
                child: Text(
                  'No Forms  available.!',
                  style: subTitleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(
                height: 90,
              )
                  : const SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),

    ],
  );

}


/*_addFormBar(BuildContext context,Assignment assignment) {
  final TaskController _taskController = Get.put(TaskController());
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.comment,
              style: subHeadingStyle,
            ),
            // Text(
            //   'Today',
            //   style: subHeadingStyle,
            // ),
          ],
        ),
        MyButton(
          label: '+ Add Form',
          onTap: () {
            // Navigate to AddFormPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFormPage(assignment,onFormAdded: (){}, refreshCallback:_refreshAssignmentDetails)),
            );
          },
        ),
      ],
    ),
  );
}*/


/*_addFormBar(BuildContext context,Assignment assignment) {
  final TaskController _taskController = Get.put(TaskController());
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.comment,
              style: subHeadingStyle,
            ),
            // Text(
            //   'Today',
            //   style: subHeadingStyle,
            // ),
          ],
        ),
        MyButton(
          label: '+ Add Form',
          onTap: () {
            // Navigate to AddFormPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFormPage(assignment,onFormAdded: (){}, refreshCallback:_refreshAssignmentDetails)),
            );
          },
        ),
      ],
    ),
  );
}*/
Widget _buildStatusIcon(String status) {
  Icon icon;
  Color iconColor;

  // Define icons and colors based on status
  if (status == "Completed") {
    icon = const Icon(Icons.check_circle, color: Colors.green);
  } else if (status == "Undergoing") {
    icon = const Icon(Icons.access_time, color: Colors.orange);
  } else if (status == "Not Started") {
    icon = const Icon(Icons.error, color: Colors.red);
  } else {
    icon = const Icon(Icons.error, color: Colors.grey);
  }

  return icon;
}