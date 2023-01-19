import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({
    super.key, 
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [

            _BackgroundImage(product.picture),

            _ProductDetails(
              title: product.name,
              subTitle: product.id!,
            ),

            const Positioned(
              top: 0,
              right: 0,
              child: _PriceTag()
            ),

            if(!product.available)
              const Positioned(
               top: 0,
               left: 0,
               child: _NotAvailable()
              )

          ]
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 7),
        blurRadius: 10
      )
    ]
  );



}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No Diponible', 
            style: TextStyle( color: Colors.white, fontSize: 20)
          )
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.yellow[800], 
        borderRadius: const BorderRadius.only( topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$10333.99', style: TextStyle( color: Colors.white, fontSize: 20))),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.black, 
        borderRadius: BorderRadius.only( topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {

  final String title;
  final String subTitle;

  const _ProductDetails({
    required this.title, 
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( right: 50 ),
      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Dico Duro G',
              style: TextStyle( fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Id del Disco Duro',
              style: TextStyle( fontSize: 15, color: Colors.white ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.only( bottomLeft: Radius.circular(25), topRight: Radius.circular(25) )
  );
}

class _BackgroundImage extends StatelessWidget {

  final String? url;

  const _BackgroundImage(String? picture, {
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(url!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
