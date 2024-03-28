import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReglageMedecin extends StatelessWidget {
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController locationController = TextEditingController(); // Contrôleur pour la localisation

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
                    // Télécharger l'image vers Firebase Storage
                    Reference ref = FirebaseStorage.instance.ref().child('medecin_images/${currentUser.uid}/profile_image.jpg');
                    UploadTask uploadTask = ref.putFile(imageFile);
                    await uploadTask.whenComplete(() async {
                      String imageUrl = await ref.getDownloadURL();
                      // Mettre à jour Firestore avec l'URL de l'image
                      await FirebaseFirestore.instance.collection('medecins').doc(currentUser.uid).update({
                        'photoUrl': imageUrl,
                      });
                      // Afficher un message de succès
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Photo ajoutée avec succès !'),
                      ));
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
            Text(
              "Localisation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: "Entrez votre localisation",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final specialiteMedicale = specialtyController.text;
                final localisation = locationController.text; // Récupérer la localisation saisie
                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  await FirebaseFirestore.instance.collection('medecins').doc(currentUser.uid).update({
                    'specialite': specialiteMedicale,
                    'localisation': localisation, // Enregistrer la localisation dans Firestore
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Spécialité et localisation ajoutées avec succès !'),
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
