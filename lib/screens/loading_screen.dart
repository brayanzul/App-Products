import 'package:flutter/material.dart';


class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products'),
      ),
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
     ),
   );
  }
}