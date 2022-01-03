import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/services/services.dart';
import 'package:provider/provider.dart';

class PlaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);
    final place = placesService.selectedPlace;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height * .5;

    return Scaffold(
        body: Stack(
      children: [
        Hero(
          tag: place.id!,
          child: Image(
              width: width,
              height: height,
              fit: BoxFit.cover,
              image: NetworkImage(place.img!)),
        ),
        ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: height,
              color: Colors.transparent,
            ),
            Container(
              padding: EdgeInsets.only(right: 15, left: 15, top: 15),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    place.description,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    place.description,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    place.description,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    place.description,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    place.description,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    place.description,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
