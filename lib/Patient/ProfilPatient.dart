import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfa2/Dossier%20medical/DossierMedicalPage.dart';

import 'ModifierProfil.dart';

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
        elevation: 0,
        title: Text('Profile',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
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
                        width:150, // Largeur maximale
                        height:150, // Hauteur maximale
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
                        backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6BFtKCAZYI3irqwULvjY5drUF4IJz07Tiyw&usqp=CAU'),
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
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditPatientInfoScreen(userId: _userId)),
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
                      Positioned(
                        bottom: 0,
                        left: 10,
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
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MedicalRecordPage(patientId: _userId)),
                              );
                            },
                            icon: Icon(
                              Icons.folder_rounded,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                        ),)
                    ],
                  ),
                  const SizedBox(height: 20),
                  itemProfile('Nom', patientData['username'] ?? 'N/A', Icons.person),
                  const SizedBox(height: 10),
                  itemProfile('Prénom', patientData['lastname'] ?? 'N/A', Icons.person),
                  const SizedBox(height: 10),
                  itemProfile('Âge', patientData['age'] != null ? patientData['age'].toString() : 'N/A', Icons.timelapse_outlined),
                  const SizedBox(height: 10),
                  itemProfile('Numéro de téléphone', patientData['phoneNumber'] ?? 'N/A', Icons.phone),
                  const SizedBox(height: 10),
                  itemProfile('Adresse', patientData['address'] ?? 'N/A', Icons.location_on),
                  const SizedBox(height: 10),
                  itemProfile('Email', patientData['email'] ?? 'N/A', Icons.mail),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
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
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
}
