import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Firebase/ConsultationInfos.dart';
import '../home/AppBar.dart';
import 'DossierMedicalPage.dart';

class ConsultationScreen extends StatelessWidget {
  String? patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Consultation',
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
      body: ConsulationInfos(),
    );
  }
}

/*class ConsultationCard extends StatelessWidget {
  final String doctorName;
  final String date;
  final String time;
  final String notes;

  ConsultationCard({
    required this.doctorName,
    required this.date,
    required this.time,
    required this.notes,
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
              'Consultation avec $doctorName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: $date'),
                Text('Heure: $time'),
                Text('Notes: $notes'),
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
    home: ConsultationScreen(),
  ));
}*/
