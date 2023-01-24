import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {

  final String? url;

  const ProductImage({
    super.key, 
    this.url
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( left: 10, right: 10, top: 10 ),
      child: Container(
        decoration: _builBoxDecoration(),
        width: double.infinity,
        height: 450,
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: const BorderRadius.only( topLeft: Radius.circular(45), topRight: Radius.circular(45) ),
            child: getImage(url)
          ),
        ),
      ),
    );
  }

  BoxDecoration _builBoxDecoration() => BoxDecoration(
    color: Colors.black,
    borderRadius: const BorderRadius.only( topLeft: Radius.circular(45), topRight: Radius.circular(45) ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0,5)
      )
    ]
  );

  Widget getImage( String? picture ){
    
    if( picture == null )
      return Image(
       image: AssetImage('assets/no-image.jpg'),
       fit: BoxFit.cover,
      );

    if( picture.startsWith('http') )
      return FadeInImage(
        image: NetworkImage( this.url! ),
        placeholder: const AssetImage('assets/jar-loading.gif'), 
        fit: BoxFit.cover,
      );

    return Image.file(
      File( picture ),
      fit: BoxFit.cover,
    );

  }

}
