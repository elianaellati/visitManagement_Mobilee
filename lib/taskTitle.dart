import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visitManagement_Mobilee/Classes/Assignment.dart';
import 'package:visitManagement_Mobilee/ui/size_config.dart';
import 'package:visitManagement_Mobilee/ui/theme.dart';

Color bluishClr = Colors.blue; // Replace with your desired color
Color pinkClr = Colors.pink; // Replace with your desired color
Color orangeClr = Colors.orange; // Replace with your desired color
Color greenClr = Colors.green; // Replace with your desired color

class TaskTitle extends StatelessWidget {
  TaskTitle(this.task, {Key? key}) : super(key: key);

  final Assignment task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(
          SizeConfig.orientation == Orientation.landscape ? 4 : 20,
        ),
      ),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(12.0),
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
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        title: Text(
                          task.comment,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 2,
                            ),
                          ),
                        ),

                        subtitle:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Text(
                    task.city + ", " + task.location,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Text(
                  task.type,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

                        trailing: _buildStatusIcon(task.status)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      icon = const Icon(Icons.error, color: Colors.white);
    } else {
      icon = const Icon(Icons.error, color: Colors.white);
    }

    return icon;
  }
}
