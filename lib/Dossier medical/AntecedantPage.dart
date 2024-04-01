import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Firebase/AntecedentInfos.dart';
import '../home/AppBar.dart';
import 'DossierMedicalPage.dart';

class MedicalHistoryScreen extends StatelessWidget {
  String? patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Antécédents médicaux',
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
      body:MedicalHistoryInfos(),
    );
  }
}

/*class HistoryItem extends StatelessWidget {
  final String title;
  final String description;

  HistoryItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MedicalHistoryScreen(),
  ));
}*/
