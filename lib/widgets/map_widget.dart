import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lawebdepoza_mobile/helpers/determne_position.dart';
import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:lawebdepoza_mobile/services/notifications_service.dart';
import 'package:lawebdepoza_mobile/services/places_service.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  bool _isLoading = true;
  late CameraPosition cameraPosition;
  late LatLng coords;

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  getPosition() async {
    try {
      final location = await determinePosition();
      coords = LatLng(
        location.latitude,
        location.longitude,
      );
      Provider.of<PlacesService>(context, listen: false).coordinates =
          Coordinates(lat: location.latitude, lng: location.longitude);
      cameraPosition = CameraPosition(target: coords, zoom: 19);
      _isLoading = false;
      setState(() {});
    } catch (e) {
      NotificationsService.showSnackbar('Ubicación está deshabilitada');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);
    if (_isLoading)
      return Container(child: Center(child: CircularProgressIndicator()));
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: cameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set.from({
        Marker(
            markerId: MarkerId(coords.toString()),
            draggable: true,
            position: coords,
            onDragEnd: (value) {
              final coordinates =
                  Coordinates(lat: value.latitude, lng: value.longitude);
              placesService.coordinates = coordinates;
            })
      }),
    );
  }
}
