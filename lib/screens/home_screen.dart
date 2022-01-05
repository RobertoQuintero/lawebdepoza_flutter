import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:lawebdepoza_mobile/screens/screens.dart';
import 'package:lawebdepoza_mobile/services/services.dart';
import 'package:lawebdepoza_mobile/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final placesService = Provider.of<PlacesService>(context);
    if (productService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        leading: IconButton(
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.login_outlined)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'add-category');
              },
              icon: Icon(Icons.add_box)),
        ],
      ),
      body: ListView.builder(
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
          productService.selectedProduct =
              new Product(available: false, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
