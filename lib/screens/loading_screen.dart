import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.6),
      body: Center(
        child: Container(
          width: 300,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(0, 2))
              ]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircularProgressIndicator(
                strokeWidth: 2, color: Theme.of(context).primaryColor),
            SizedBox(
              width: 20,
            ),
            Text(
              'Cargando',
              style: TextStyle(fontSize: 18),
            )
          ]),
        ),
      ),
    );
  }
}
