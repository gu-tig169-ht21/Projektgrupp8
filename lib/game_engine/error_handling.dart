import 'package:flutter/material.dart';

class ErrorHandling {
  void errorHandling(var e, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: Text('$e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }
}
