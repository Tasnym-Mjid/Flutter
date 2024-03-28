import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfa2/Dossier%20medical/DossierMedicalPage.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<DocumentSnapshot> _profileStream;
  late String _userId;

  @override
  void initState() {
    super.initState();
    // Récupérer l'ID de l'utilisateur connecté
    _userId = FirebaseAuth.instance.currentUser!.uid;
    // Utiliser l'ID récupéré pour récupérer les données du patient
    _profileStream = FirebaseFirestore.instance.collection('patients').doc(_userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Enlever l'ombre sous l'app bar
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _profileStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur est survenue. Veuillez réessayer plus tard.'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Aucune donnée trouvée pour ce patient.'),
            );
          }

          // Accéder aux données du patient
          Map<String, dynamic>? patientData = snapshot.data!.data() as Map<String, dynamic>?;

          // Vérifier si patientData est null
          if (patientData == null) {
            return Center(
              child: Text('Aucune donnée trouvée pour ce patient.'),
            );
          }

          return Card(
            color: Colors.blue[300],
            margin: EdgeInsets.all(20.0),
            elevation: 5, // Ajout d'une ombre pour le card
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Column(
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
                        backgroundImage: NetworkImage( 'https://media.istockphoto.com/id/1090878494/fr/photo/bouchent-portrait-du-jeune-souriant-bel-homme-en-polo-bleu-isol%C3%A9-sur-fond-gris.jpg?s=612x612&w=0&k=20&c=d4gHKQJEydpFppzIO3poAdV5dcyYN3MiTGvP07bBSrY='),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nom: ${patientData['username'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Prénom: ${patientData['lastname'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Fond bleu pour le bouton
                            padding: EdgeInsets.all(15),
                            elevation: 5,
                          ),
                          onPressed: () {
                            // Action à effectuer lorsqu'on appuie sur le bouton
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 20), // Ajout d'un espace entre les boutons
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Fond bleu pour le bouton
                            padding: EdgeInsets.all(15),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MedicalRecordPage(),)
                            );
                          },
                          child: Icon(
                            Icons.folder_rounded,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
