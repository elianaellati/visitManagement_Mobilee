import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visitManagement_Mobilee/Classes/forms.dart';
import 'package:visitManagement_Mobilee/ui/size_config.dart';
import 'package:visitManagement_Mobilee/ui/theme.dart';


class formTitle extends StatelessWidget {
  formTitle(this.form, {Key? key}) : super(key: key);

  final forms form;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          '${form.customerCity},${form.customerAddress}',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          form.status,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        trailing: _buildStatusIcon(form.status)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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