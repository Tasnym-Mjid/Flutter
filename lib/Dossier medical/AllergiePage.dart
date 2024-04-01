import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfa2/Dossier%20medical/DossierMedicalPage.dart';
import 'package:pfa2/Firebase/AllergieInfos.dart';

import '../home/AppBar.dart';

class AllergiesScreen extends StatelessWidget {
  String? patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Allérgie',
        onBack: () {
          User? user = FirebaseAuth.instance.currentUser;
          patientId=user?.uid;
          if (patientId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MedicalRecordPage(patientId: patientId!)),
            );
          } else {
            // Gérer le cas où patientId est nul
          }
        },
      ),
      body:AllergieInfos(),
    );
  }
}

/*class AllergyCard extends StatelessWidget {
  final String allergen;
  final String severity;
  final String description;

  AllergyCard({
    required this.allergen,
    required this.severity,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              'Allergène: $allergen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gravité: $severity'),
                Text('Description: $description'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AllergiesScreen(),
  ));
}*/
