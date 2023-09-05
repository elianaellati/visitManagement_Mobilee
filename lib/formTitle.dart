import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visitManagement_Mobilee/Classes/forms.dart';
import 'package:visitManagement_Mobilee/ui/size_config.dart';
import 'package:visitManagement_Mobilee/ui/theme.dart';

Color bluishClr = Colors.blue; // Replace with your desired color
Color pinkClr = Colors.pink; // Replace with your desired color
Color orangeClr = Colors.orange; // Replace with your desired color
Color greenClr = Colors.green; // Replace with your desired color

class formTitle extends StatelessWidget {
  formTitle(this.form, {Key? key}) : super(key: key);

  final forms form;

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
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFF3F51B5),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      form.customerName!,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          ' ${form.customerCity},${form.customerAddress}' ,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
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
