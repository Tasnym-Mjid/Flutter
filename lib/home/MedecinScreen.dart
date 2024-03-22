import 'package:flutter/material.dart';

class MedecinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace Médecin'),
      ),
      body: Center(
        child: Text(
          'Bienvenue dans l\'espace Médecin !',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
