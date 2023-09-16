import 'package:flutter/material.dart';

/*class DialogueNote{
  Future<void> _showAlertDialog( ) async {
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
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
        );
      },
    );
  }
}*/
