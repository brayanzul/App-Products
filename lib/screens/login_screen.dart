import 'package:flutter/material.dart';
import 'package:productos_app/widgets/widgets.dart';


class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox( height: 250 ),

              CardContainer(
                child: Column(
                  children: [

                    const SizedBox( height: 10 ),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox( height: 30 ),

                    Text('Formulario')

                  ],
                )
              ),

            ],
          ),
        )
      )
    );
  }
}