import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/models/place.dart';
import 'package:lawebdepoza_mobile/screens/screens.dart';
import 'package:lawebdepoza_mobile/services/services.dart';
import 'package:lawebdepoza_mobile/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final productService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final placesService = Provider.of<PlacesService>(context);
    if (placesService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Places'),
        leading: IconButton(
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.login_outlined)),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, 'categories'),
              icon: Icon(Icons.add_box)),
        ],
      ),
      body: ListView.builder(
          padding: EdgeInsets.only(left: 15, right: 15, top: 30),
          physics: BouncingScrollPhysics(),
          itemCount: placesService.places.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                placesService.selectedPlace =
                    placesService.places[index].copy();
                Navigator.pushNamed(context, 'place');
              },
              child: PlaceCard(
                place: placesService.places[index],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final coordinates = Coordinates(lat: 0, lng: 0);
          placesService.selectedPlace = new Place(
              name: '', description: '', address: '', coordinates: coordinates);

          Navigator.pushNamed(context, 'add-place');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
