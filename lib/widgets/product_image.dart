import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;

  final BorderRadius borderRadius;

  const ProductImage(
      {this.url,
      this.borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(45), topRight: Radius.circular(45))});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 400,
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(borderRadius: borderRadius, child: getImage(url)),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.black,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5))
          ]);

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
