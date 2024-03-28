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
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          elevation: 4, // Élévation de la carte
          color: Colors.blueGrey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:Center(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue, // Couleur bleue pour le fond
                          shape: BoxShape.circle, // Forme circulaire
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('https://media.istockphoto.com/id/1090878494/fr/photo/bouchent-portrait-du-jeune-souriant-bel-homme-en-polo-bleu-isol%C3%A9-sur-fond-gris.jpg?s=612x612&w=0&k=20&c=d4gHKQJEydpFppzIO3poAdV5dcyYN3MiTGvP07bBSrY='),
                        ),
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
                            String patientlastName = patientSnapshot.data!.data()!['lastname'];
                            return Text(
                              '$patientName $patientlastName',
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
              ),
              ...categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      // Naviguer vers la page correspondante à l'index de la carte
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => pages[categories.indexOf(category)]),
                      );
                    },
                    child: Card(
                      elevation: 4, // Élévation de la carte
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: _buildIcon(category), // Icône à côté du texte
                        title: Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Couleur du texte en gras
                          ),
                        ),
                        //subtitle: _buildSubtitle(medicalData.entries.elementAt(index).value),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
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
