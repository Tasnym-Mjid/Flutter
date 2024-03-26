import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class MedecinProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user == null) {
      // Si aucun utilisateur n'est connecté, renvoyer à l'écran de connexion
      // ou afficher un message d'erreur.
      return Scaffold(
        body: Center(
          child: Text('Aucun utilisateur connecté'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil du Médecin",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // Action pour accéder aux réglages du médecin
              Navigator.push(context, MaterialPageRoute(builder: (context) => MedecinSettingsScreen()));
            },
            icon: const Icon(Icons.settings, size: 26),
            color: Colors.blue,
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('medecins').doc(user!.uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Aucune donnée disponible'),
            );
          }

          final medecinData = snapshot.data!;

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: medecinData['photoUrl'] != null ? NetworkImage(
                    medecinData['photoUrl'],
                  ) : AssetImage('assets/placeholder_image.jpg') as ImageProvider,
                  backgroundColor: Colors.grey, // Couleur de fond pour le placeholder
                  child: medecinData['photoUrl'] == null ? Icon(Icons.person, size: 60, color: Colors.white) : null,
                ),
                SizedBox(height: 20),
                Text(
                  "Nom d'utilisateur: ${medecinData['username']}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Nom de famille: ${medecinData['lastname']}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "E-mail: ${medecinData['email']}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Spécialité: ${medecinData['specialite'] ?? 'Non spécifié'}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MedecinSettingsScreen extends StatelessWidget {
  final TextEditingController specialtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Paramètres",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Ajouter une photo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  // Mettre à jour l'URL de la photo dans Firestore
                  await FirebaseFirestore.instance.collection('medecins').doc(FirebaseAuth.instance.currentUser!.uid).update({
                    'photoUrl': pickedFile.path,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Photo ajoutée avec succès !'),
                  ));
                }
              },
              child: Text("Sélectionner une photo"),
            ),
            SizedBox(height: 20),
            Text(
              "Spécialité médicale",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: specialtyController,
              decoration: InputDecoration(
                hintText: "Entrez votre spécialité médicale",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Récupérer la spécialité médicale entrée par l'utilisateur
                final specialiteMedicale = specialtyController.text;
                // Mettre à jour la spécialité médicale dans Firestore
                await FirebaseFirestore.instance.collection('medecins').doc(FirebaseAuth.instance.currentUser!.uid).update({
                  'specialite': specialiteMedicale,
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Spécialité ajoutée avec succès !'),
                ));
              },
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MedecinProfileScreen(),
  ));
}
