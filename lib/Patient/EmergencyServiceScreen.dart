
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home/AppBar.dart';
import '../home/Main_layout.dart';

class EmergencyServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Service d\'urgence',
        onBack: () {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLayout()),
          );
        } ,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Aucun médecin disponible en cas d\'urgence.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> medecinData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              if (medecinData['disponibilite'] == true) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue, // Fond bleu pour le cercle de l'avatar
                      child: Icon(Icons.person, color: Colors.white), // Icône blanche pour l'avatar
                    ),
                    title: Text(
                      medecinData['username'] ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Nom en gras
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Adresse: ${medecinData['adress'] ?? 'N/A'}',
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: 5),
                            Text(
                              medecinData['phoneNumber'] ?? 'N/A',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox(); // Si le médecin n'est pas disponible, retourne un widget vide
              }
            },
          );
        },
      ),
    );
  }
}
