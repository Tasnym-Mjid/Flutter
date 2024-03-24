import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'Firebase/readListView.dart';

class ListMedecin extends StatefulWidget {
  @override
  _ListMedecin createState() => _ListMedecin();
}

class _ListMedecin extends State<ListMedecin> {
  String _selectedDoctor = ''; // Variable pour stocker le nom du médecin sélectionné

  // Liste de médecins (à titre d'exemple)
  final List<String> _doctors = ['Dr. Smith', 'Dr. Johnson', 'Dr. Lee'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blue,
        color: Colors.blue,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.account_circle_outlined, size: 26, color: Colors.white),
          Icon(Icons.add_alert, size: 26, color: Colors.white),

        ],
      ),
      appBar: AppBar(
        title: Text('Liste des medecins',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ReadListView(), // Afficher la liste des médecins à l'intérieur d'un Expanded pour l'étendre sur tout l'espace disponible
            ),
          ],
        ),
      ),
    );
  }
}
