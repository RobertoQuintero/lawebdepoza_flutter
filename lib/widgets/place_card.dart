import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/models/models.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({required this.place});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: double.infinity,
      height: 400,
      decoration: _cardBorders(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Hero(
            tag: place.id!,
            child: _BackgroundImage(
              url: place.img,
            ),
          ),
          _ProductDetails(
            title: place.name,
            subtitle: place.description,
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))
          ]);
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ProductDetails({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 50),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 70,
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 15, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage({this.url});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
            width: double.infinity,
            height: 400,
            child: url == null
                ? Image(
                    image: AssetImage('assets/no-image.png'),
                    fit: BoxFit.cover,
                  )
                : FadeInImage(
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(url!),
                    fit: BoxFit.cover,
                  )));
  }
}
