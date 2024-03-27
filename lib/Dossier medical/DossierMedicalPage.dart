import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfa2/Dossier%20medical/ConsultationPage.dart';
import 'package:pfa2/Dossier%20medical/ResultatLaboPage.dart';
import 'AllergiePage.dart';
import 'AntecedantPage.dart';

class MedicalRecordPage extends StatefulWidget {
  @override
  _MedicalRecordPageState createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  String? uid; // L'ID de l'utilisateur connecté
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
    // Récupérer l'ID de l'utilisateur connecté lorsque le widget est créé
    _fetchUid();
  }

  Future<void> _fetchUid() async {
    try {
      // Obtenir l'utilisateur actuellement connecté avec Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          uid = user.uid;
        });
      }
    } catch (error) {
      print('Erreur lors de la récupération de l\'ID de l\'utilisateur : $error');
    }
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
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/account.png', // Chemin vers votre image
                  height: 170, // Hauteur de l'image
                  width: 150, // Largeur de l'image, réglée sur la largeur maximale disponible
                  fit: BoxFit.cover, // Ajustement de l'image pour couvrir le conteneur
                ),
                SizedBox(height: 16),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('patients').doc(uid).snapshots(),
                  builder: (context, patientSnapshot) {
                    if (patientSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Indicateur de chargement
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
                      // Naviguer vers la page correspondante à l'index de la carte
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => pages[index]),
                      );
                    },
                    child: Card(
                      elevation: 4, // Élévation de la carte
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: _buildIcon(categories[index]), // Icône à côté du texte
                        title: Text(
                          categories[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Couleur du texte en gras
                          ),
                        ),
                        //subtitle: _buildSubtitle(medicalData.entries.elementAt(index).value),
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

  // Méthode pour construire l'icône en fonction du texte de l'élément de la liste
  Widget _buildIcon(String text) {
    switch (text) {
      case 'Résultats labos':
        return Icon(Icons.local_hospital); // Icône pour le résultat de laboratoire
      case 'Allergies':
        return Icon(Icons.coronavirus); // Icône pour les allergies
      case 'Consultations':
        return Icon(Icons.local_hospital_outlined); // Icône pour les consultations
      case 'Antécédents':
        return Icon(Icons.history); // Icône pour les antécédents médicaux
      default:
        return Icon(Icons.error); // Icône par défaut en cas de texte inconnu
    }
  }

  Widget _buildSubtitle(dynamic value) {
    if (value is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value
            .map(
              (item) => Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '- $item',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87, // Couleur du texte de la liste
              ),
            ),
          ),
        )
            .toList(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87, // Couleur du texte
          ),
        ),
      );
    }
  }
}
