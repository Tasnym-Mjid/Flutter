import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pfa2/home/Main_layout.dart';

import '../Firebase/readListView.dart';
import '../home/AppBar.dart';

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

      appBar: CustomAppBar(
        pageTitle: 'Liste des médecins',
        onBack: () {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainLayout()),
            );
          } ,
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
