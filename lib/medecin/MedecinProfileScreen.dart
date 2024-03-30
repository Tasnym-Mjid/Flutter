import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ReglageMedecin.dart';

class MedecinProfileScreen extends StatefulWidget {
  @override
  _MedecinProfileScreenState createState() => _MedecinProfileScreenState();
}

class _MedecinProfileScreenState extends State<MedecinProfileScreen> {
  late Stream<DocumentSnapshot> _profileStream;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
    _profileStream = FirebaseFirestore.instance.collection('medecins')
        .doc(_userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _profileStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Une erreur est survenue. Veuillez réessayer plus tard.'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Aucune donnée trouvée pour ce médecin.'),
            );
          }

          Map<String, dynamic>? medecinData = snapshot.data!.data() as Map<
              String,
              dynamic>?;

          if (medecinData == null) {
            return Center(
              child: Text('Aucune donnée trouvée pour ce médecin.'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                      ),
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6BFtKCAZYI3irqwULvjY5drUF4IJz07Tiyw&usqp=CAU'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    ReglageMedecin(userId: _userId)),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  itemProfile('Nom', medecinData['username'] ?? 'N/A', Icons.person),
                  const SizedBox(height: 10),
                  itemProfile('Prénom', medecinData['lastname'] ?? 'N/A', Icons.person),
                  const SizedBox(height: 10),
                  itemProfile('Adresse', medecinData['address'] ?? 'N/A', Icons.location_on),
                  const SizedBox(height: 10),
                  itemProfile('Numéro de téléphone', medecinData['phoneNumber'] ?? 'N/A', Icons.phone),
                  const SizedBox(height: 10),
                  itemProfile('Disponibilité en cas d\'urgence', medecinData['disponibilite'], Icons.warning),
                  const SizedBox(height: 10),
                  itemProfile('Email', medecinData['email'] ?? 'N/A', Icons.mail),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget itemProfile(String title, dynamic data, IconData iconData) {
    String subtitle = data != null ? data.toString() : 'N/A';
    if (title == 'Disponibilité en cas d\'urgence') {
      subtitle = data != null ? (data ? 'Oui' : 'Non') : 'N/A';
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.blue.withOpacity(.4),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
}
