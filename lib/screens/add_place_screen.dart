import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lawebdepoza_mobile/helpers/show_dialog.dart';
import 'package:lawebdepoza_mobile/models/category.dart';
import 'package:lawebdepoza_mobile/services/services.dart';
import 'package:lawebdepoza_mobile/ui/input_decorations.dart';
import 'package:lawebdepoza_mobile/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double sizedboxHeight = 5;
    final placesService = Provider.of<PlacesService>(context);
    final categoryService = Provider.of<CategoryService>(context);
    final place = placesService.selectedPlace;
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: Text(
                  place.id == null ? 'Agregar Lugar ' : 'Actualizar Lugar'),
              actions: [
                place.id == null
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          showModal(
                              context: context,
                              widget: Text(
                                '¿Desea eliminar este registro?',
                                textAlign: TextAlign.center,
                              ),
                              callback: () async {
                                Navigator.pop(context);
                                final resp = await placesService.deletePlace();
                                if (resp != null) {
                                  NotificationsService.showSnackbar(resp);
                                } else {
                                  Navigator.pushReplacementNamed(
                                      context, 'home');
                                }
                              },
                              title: 'Eliminar');
                        },
                        icon: Icon(Icons.delete))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: placesService.isSaving
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Icon(Icons.add),
              onPressed: placesService.isSaving
                  ? null
                  : () async {
                      if (!placesService.isValidForm()) return;
                      if (placesService.selectedPlace.img == null ||
                          placesService.selectedPlace.category == null) {
                        NotificationsService.showSnackbar(
                            'Faltan campos por cubrir');
                        return;
                      }
                      await placesService.createOrUpdate();
                      Navigator.pop(context);
                    },
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 15, top: 15, right: 15),
              child: Form(
                key: placesService.formKey,
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
                      height: sizedboxHeight,
                    ),
                    TextFormField(
                      initialValue: place.description,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
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
                    SizedBox(height: sizedboxHeight),
                    TextFormField(
                      initialValue: place.address,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'Calle 20 Nov, col. Cazones...',
                          labelText: 'Dirección'),
                      onChanged: (value) => place.address = value,
                      validator: (value) {
                        return value != null && value.length > 2
                            ? null
                            : 'Nombre muy corto';
                      },
                    ),
                    TextFormField(
                      initialValue: place.facebook,
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'https://www.facebook...',
                          labelText: 'Facebook'),
                      onChanged: (value) => place.facebook = value,
                    ),
                    SizedBox(height: sizedboxHeight),
                    TextFormField(
                      initialValue: place.web,
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'https://www...', labelText: 'Web'),
                      onChanged: (value) => place.web = value,
                    ),
                    SizedBox(
                      height: sizedboxHeight,
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
                      height: sizedboxHeight,
                    ),
                    Row(
                      children: [
                        Text(
                          'Categoría',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        CategoryDropdownButton(categoryService.categories),
                      ],
                    ),
                    SizedBox(
                      height: sizedboxHeight,
                    ),
                    _PickImageRow(
                      url: place.img,
                    ),
                    SizedBox(
                      height: sizedboxHeight + 15,
                    ),
                    _PickLocationRow(),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            )),
        if (placesService.isLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withOpacity(.6),
            child: Center(child: CircularProgressIndicator()),
          )
      ],
    );
  }
}

class _PickLocationRow extends StatefulWidget {
  @override
  __PickLocationRowState createState() => __PickLocationRowState();
}

class __PickLocationRowState extends State<_PickLocationRow> {
  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);
    final place = placesService.selectedPlace;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 150,
            child: Icon(Icons.pin_drop_outlined,
                color: place.coordinates != null
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                size: 60)),
        AppButton(
            width: 100,
            title: 'Maps',
            onPressed: () {
              showModal(
                  context: context,
                  widget: MapWidget(),
                  callback: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  title: 'Ubicación');
            })
      ],
    );
  }
}

class _PickImageRow extends StatelessWidget {
  final String? url;

  const _PickImageRow({this.url});
  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(150)),
          child: Container(
            width: 150,
            height: 150,
            child: getImage(url),
          ),
        ),
        AppButton(
          title: 'Imagen',
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) => Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      padding: EdgeInsets.all(15),
                      height: 200,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              await setImage(ImageSource.camera, placesService);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 60,
                                    color: Theme.of(context).primaryColor),
                                Text('Cámara',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              await setImage(
                                  ImageSource.gallery, placesService);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo,
                                    size: 60,
                                    color: Theme.of(context).primaryColor),
                                Text('Galería',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
          },
          width: 100,
        )
      ],
    );
  }

  Future setImage(ImageSource source, PlacesService placesService) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: source, imageQuality: 100, maxWidth: 500);

    if (pickedFile == null) {
      print('No seleccionó nada');
      return;
    }
    print('Tenemos imagen ${pickedFile.path}');
    placesService.updateSelectedPlaceImage(pickedFile.path);
  }

  Widget getImage(String? picture) {
    return picture == null
        ? Image(
            image: AssetImage('assets/no-image.png'),
            fit: BoxFit.cover,
          )
        : picture.startsWith('http')
            ? FadeInImage(
                image: NetworkImage(
                  this.url!,
                ),
                placeholder: AssetImage('assets/jar-loading.gif'),
                fit: BoxFit.cover,
              )
            : Image.file(
                File(picture),
                fit: BoxFit.cover,
              );
  }
}

class CategoryDropdownButton extends StatefulWidget {
  final List<Category> categories;

  const CategoryDropdownButton(this.categories);
  @override
  _CategoryDropdownButtonState createState() => _CategoryDropdownButtonState();
}

class _CategoryDropdownButtonState extends State<CategoryDropdownButton> {
  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);
    if (widget.categories.isEmpty) return Container();
    return DropdownButton(
      value: placesService.selectedPlace.category != null
          ? placesService.selectedPlace.category!.name
          : null,
      items: widget.categories.map((value) {
        return DropdownMenuItem(
          value: value.name,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (newValue) {
        final category =
            widget.categories.firstWhere((c) => c.name == newValue);
        placesService.selectedPlace.category = category;
        setState(() {});
      },
    );
  }
}
