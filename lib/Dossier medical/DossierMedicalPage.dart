import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AllergiePage.dart';
import 'AntecedantPage.dart';
import 'ConsultationPage.dart';
import 'ResultatLaboPage.dart';

class MedicalRecordPage extends StatefulWidget {
  final String patientId;

  const MedicalRecordPage({Key? key, required this.patientId}) : super(key: key);

  @override
  _MedicalRecordPageState createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  List<Widget> pages = [
    LaboResultScreen(),
    MedicalHistoryScreen(),
    ConsultationScreen(),
    AllergiesScreen(),
    // Ajoutez les autres écrans ici
  ];

  List<String> categories = [
    'Résultats labos',
    'Antécédents',
    'Consultations',
    'Allergies',
    // Ajoutez les autres catégories si nécessaire
  ];

  @override
  void initState() {
    super.initState();
    // Supprimez la récupération de l'ID de l'utilisateur connecté
    // car vous utilisez l'ID du patient passé en tant que propriété
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dossier médical'),
        backgroundColor: Colors.blue, // Couleur de l'app bar
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/account.png',
                  height: 170,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('patients').doc(widget.patientId).snapshots(),
                  builder: (context, patientSnapshot) {
                    if (patientSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (patientSnapshot.hasError) {
                      return Text('Erreur de chargement du nom du patient');
                    } else if (!patientSnapshot.hasData || !patientSnapshot.data!.exists) {
                      return Text('Nom de patient non trouvé');
                    } else {
                      String patientName = patientSnapshot.data!.data()!['username'];
                      String patientlastName=patientSnapshot.data!.data()!['lastname'];
                      return Text(
                        patientName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => pages[index]),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: _buildIcon(categories[index]),
                        title: Text(
                          categories[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String text) {
    switch (text) {
      case 'Résultats labos':
        return Icon(Icons.local_hospital);
      case 'Allergies':
        return Icon(Icons.coronavirus);
      case 'Consultations':
        return Icon(Icons.local_hospital_outlined);
      case 'Antécédents':
        return Icon(Icons.history);
      default:
        return Icon(Icons.error);
    }
  }
}
