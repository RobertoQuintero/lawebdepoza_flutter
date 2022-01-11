import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/helpers/urlLauncher.dart';
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
              padding: EdgeInsets.only(right: 15, left: 15),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    place.category!.name,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    place.address,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    place.description,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (place.facebook != '')
                        TextButton(
                            onPressed: () => urlLauncher(place.facebook),
                            child: Text(
                              'facebook',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue),
                            )),
                      SizedBox(
                        width: 30,
                      ),
                      if (place.web != '')
                        TextButton(
                            onPressed: () => urlLauncher(place.web),
                            child: Text(
                              'Sitio Web',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            )),
                      SizedBox(
                        width: 30,
                      ),
                      TextButton(
                          onPressed: () => urlLauncherMap(place.coordinates!),
                          child: Text(
                            'Mapa',
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          )),
                    ],
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
