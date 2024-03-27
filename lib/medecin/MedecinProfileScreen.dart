import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MedecinProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user == null) {
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
                // Affichage de la photo si elle est disponible
                medecinData['photoUrl'] != null
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(medecinData['photoUrl']),
                )
                    : CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 10),
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
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    File imageFile = File(pickedFile.path);
                    // Obtenir le nom de fichier
                    String fileName = pickedFile.path.split('/').last;
                    // Télécharger l'image vers Firebase Storage
                    Reference ref = FirebaseStorage.instance.ref().child('medecin_images/${currentUser.uid}/$fileName');
                    UploadTask uploadTask = ref.putFile(imageFile);
                    await uploadTask.whenComplete(() async {
                      String imageUrl = await ref.getDownloadURL();
                      // Mettre à jour Firestore avec l'URL de l'image
                      await FirebaseFirestore.instance.collection('medecins').doc(currentUser.uid).update({
                        'photoUrl': imageUrl,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Photo ajoutée avec succès !'),
                      ));
                      Navigator.pop(context); // Retour à l'écran précédent pour rafraîchir la page
                    });
                  }
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
                final specialiteMedicale = specialtyController.text;
                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  await FirebaseFirestore.instance.collection('medecins').doc(currentUser.uid).update({
                    'specialite': specialiteMedicale,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Spécialité ajoutée avec succès !'),
                  ));
                }
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

