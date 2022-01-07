import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/models/category.dart';
import 'package:lawebdepoza_mobile/services/services.dart';
import 'package:lawebdepoza_mobile/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);
    final categoryService = Provider.of<CategoryService>(context);
    final place = placesService.selectedPlace;
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Categoría'),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  initialValue: place.name,
                  autocorrect: false,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Sopes el Texano...', labelText: 'Nombre'),
                  onChanged: (value) => place.name = value,
                  validator: (value) {
                    return value != null && value.length > 2
                        ? null
                        : 'Nombre muy corto';
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: place.description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecorations.authInputDecoration(
                      hintText:
                          'En este negocio ofrecemos el mejor servicio...',
                      labelText: 'Descripción'),
                  onChanged: (value) => place.description = value,
                  validator: (value) {
                    return value != null && value.length > 2
                        ? null
                        : 'Nombre muy corto';
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: place.address,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Calle 20 Nov, col. Cazones...',
                      labelText: 'Dirección'),
                  onChanged: (value) => place.description = value,
                  validator: (value) {
                    return value != null && value.length > 2
                        ? null
                        : 'Nombre muy corto';
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (categoryService.isLoading)
                  Container(
                    height: 80,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Categoría',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    CategoryDropdownButton(categoryService.categories),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class CategoryDropdownButton extends StatefulWidget {
  final List<Category> categories;

  const CategoryDropdownButton(this.categories);
  @override
  _CategoryDropdownButtonState createState() => _CategoryDropdownButtonState();
}

class _CategoryDropdownButtonState extends State<CategoryDropdownButton> {
  String dropdownValue = 'categorias';
  int index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) return Container();
    return DropdownButton(
      value: widget.categories[index].name,
      items: widget.categories.map((value) {
        return DropdownMenuItem(
          value: value.name,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (newValue) {
        final category =
            widget.categories.firstWhere((c) => c.name == newValue);
        index = widget.categories.indexOf(category);
        setState(() {
          Provider.of<PlacesService>(context, listen: false)
              .selectedPlace
              .category = category;
          dropdownValue = '$newValue';
          // index = widget.categories.indexOf);
        });
      },
    );
  }
}
