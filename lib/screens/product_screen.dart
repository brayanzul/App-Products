import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    ); 
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              children: [
                ProductImage( url: productService.selectedProduct.picture ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    icon: const Icon( Icons.arrow_back_ios_new_outlined, size: 40, color: Colors.black), 
                    onPressed: () => Navigator.of(context).pop()
                  ),
                ),

                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.black), 
                    onPressed: () async {
                      
                      final picker = new ImagePicker();
                      final PickedFile? pickedFile = await picker.getImage(
                        //source: ImageSource.gallery,
                        source: ImageSource.camera,
                        imageQuality: 100
                      );

                      if( pickedFile == null ) {
                        print('No selecciono nada');
                        return;
                      }

                      print('Tenemos imagen ${ pickedFile.path }');
                      productService.UpdateSelectedProductImage(pickedFile.path);

                    }
                  ),
                ),
              ],
            ),

            const _ProductForm(),

            const SizedBox(height: 100)

          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.save_outlined),
        onPressed: () async {
          
          if(!productForm.isValidForm()) return;

          final String? imageUrl = await productService.uploadImage();

          if( imageUrl != null ) productForm.product.picture = imageUrl;

          await productService.saveOrCreateProduct(productForm.product);
        },
      ),

    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 10 ),
      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20 ),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [

              const SizedBox( height: 10 ),

              TextFormField(
                initialValue: product.name,
                onChanged: ( value ) => product.name = value,
                validator: (value) {
                  if( value == null || value.length < 1 )
                   return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del Producto', 
                  labelText: 'Nombre:',
                  
                ),
              ),

              const SizedBox( height: 30 ),

              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: ( value ) {
                  if( double.tryParse(value) == null){
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Precio:',
                  
                ),
              ),

              const SizedBox( height: 30 ),

              SwitchListTile.adaptive(
                value: product.available, 
                title: const Text('Disponible'),
                activeColor: Colors.black,
                onChanged: productForm.updateAvailability
              ),

              const SizedBox( height: 30 ),

            ],
          )
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only( bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25) ),
    boxShadow: [
      BoxShadow(
       color: Colors.black.withOpacity(0.05),
       offset: const Offset(0, 5),
       blurRadius: 5 
      )
    ]
  );
}