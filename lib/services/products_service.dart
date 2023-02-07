import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/models/models.dart';

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-varios-b7784-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  // TODO: <List<Product>>
  Future loadProducts() async {

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode( resp.body );

    productsMap.forEach((key, value) {
      final Product tempProduct = Product.fromJson( value );
      tempProduct.id = key;
      products.add( tempProduct );
    });

    this.isLoading = false;
    notifyListeners();

    return this.products;

  }

  Future saveOrCreateProduct( Product product ) async {

    isSaving = true;
    notifyListeners();

    if( product.id == null ){
      // Es necesario crear
      await this.createProduct(product);
    } else {
      // Actualizar
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();

  }

  Future<String> updateProduct( Product product ) async {
    final url = Uri.https( _baseUrl, 'products/${ product.id }.json',  {
      'auth': await storage.read(key: 'token') ?? ''
    });

    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    //print( decodedData );

    //TODO: Actualizar el listado de productos
    final index = this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;


    return product.id!;

  }

  Future<String> createProduct( Product product ) async {
    final url = Uri.https( _baseUrl, 'products.json',  {
      'auth': await storage.read(key: 'token') ?? ''
    });
    
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode( resp.body );

    product.id = decodedData['name'];

    this.products.add(product);


    return product.id!;

  }

  void UpdateSelectedProductImage( String path ) {

    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri( Uri(path: path) );

    notifyListeners();

  }

  Future<String?> uploadImage() async {

    if( this.newPictureFile == null ) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/ddm2kzz9a/image/upload?upload_preset=krxy27gf');

    final imageUoloadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUoloadRequest.files.add(file);

    final streamResponse = await imageUoloadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode( resp.body );
    return decodedData['sacure_url'];

    //print( resp.body);

  }

}
