import 'package:flutter/material.dart';
import 'package:productos_app/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: ( BuildContext context, int index ) => ProductCard(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
   );
  }
}