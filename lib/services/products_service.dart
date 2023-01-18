import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'https://flutter-varios-b7784-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;

  ProductsService() {
    this.loadProducts();
  }

  // TODO: <List<Product>>
  Future loadProducts() async {

    final url = Uri.https( _baseUrl, 'products.json' );
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode( resp.body );

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap( value );
      tempProduct.id = key;
      this.products.add( tempProduct );
    });

    print( this.products[0].name );

  }


}
