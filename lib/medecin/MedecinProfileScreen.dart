import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Importation du package pour la barre de navigation incurvée

import 'ReglageMedecin.dart';

class MedecinProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MedecinProfileScreen> {
  late Stream<DocumentSnapshot> _profileStream;
  late String _userId;

  @override
  void initState() {
    super.initState();
    // Récupérer l'ID de l'utilisateur connecté
    _userId = FirebaseAuth.instance.currentUser!.uid;
    // Utiliser l'ID récupéré pour récupérer les données du patient
    _profileStream = FirebaseFirestore.instance.collection('medecins').doc(_userId).snapshots();
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
              child: Text('Aucune donnée trouvée pour ce médecin.'),
            );
          }

          // Accéder aux données du médecin
          Map<String, dynamic>? medecinData = snapshot.data!.data() as Map<String, dynamic>?;

          // Vérifier si medecinData est null
          if (medecinData == null) {
            return Center(
              child: Text('Aucune donnée trouvée pour ce médecin.'),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Card(
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
                          backgroundImage: NetworkImage('https://thumbs.dreamstime.com/z/cute-little-female-doctor-cartoon-waving-hand-illustration-33233171.jpg'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Nom: ${medecinData['username'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Prénom: ${medecinData['lastname'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Spécialité: ${medecinData['specialite'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Localisation: ${medecinData['localisation'] ?? 'N/A'}', // Affichage de la localisation
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Fond bleu pour le bouton
                          padding: EdgeInsets.all(15),
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReglageMedecin())); // Naviguer vers la page de réglages du médecin
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar( // Ajout de la CurvedNavigationBar
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: Colors.blue,
              color: Colors.blue,
              animationDuration: const Duration(milliseconds: 300),
              items: const <Widget>[
                Icon(Icons.home, size: 26, color: Colors.white),
                Icon(Icons.account_circle_outlined, size: 26, color: Colors.white),
                Icon(Icons.add_alert, size: 26, color: Colors.white),
              ],
              onTap: (index) {
                // Actions à effectuer lors de la navigation entre les onglets
                switch (index) {
                  case 0:
                  // Action pour l'onglet Accueil
                    break;
                  case 1:
                  // Naviguer vers l'écran du profil du médecin
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReglageMedecin()),
                    );
                    break;
                  case 2:
                  // Action pour l'onglet Notifications
                    break;
                  default:
                }
              },
            ),
          );
        },
      ),
    );
  }
}