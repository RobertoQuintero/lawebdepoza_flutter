import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = new SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.indigo,
        content: Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14)));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
