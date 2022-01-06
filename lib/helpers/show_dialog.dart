import 'package:flutter/material.dart';

showModal(
    {required BuildContext context,
    required Widget widget,
    required VoidCallback callback,
    required String title}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(
              '$title',
              textAlign: TextAlign.center,
            ),
            content: widget,
            actions: [
              TextButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                  child: Text('Ok',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onPressed: callback),
            ]);
      });
}