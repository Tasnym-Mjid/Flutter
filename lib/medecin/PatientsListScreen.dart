import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pfa2/medecin/Mainlayout.dart';
import 'package:pfa2/medecin/MedecinScreen.dart';
import '../Dossier medical/DossierMedicalPage.dart';
import '../home/AppBar.dart';

class PatientsListScreen extends StatefulWidget {
  @override
  _PatientsListScreenState createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _patientsStream;

  @override
  void initState() {
    super.initState();
    _patientsStream = FirebaseFirestore.instance.collection('patients').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Liste des patients',
        onBack: () {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLayoutt()),
          );
        } ,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un patient...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _patientsStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<DocumentSnapshot> patients = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          patients[index]['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(patients[index]['lastname']),
                        trailing: IconButton(
                          onPressed: () {
                            // Récupérer l'ID du patient
                            String patientId = patients[index].id;

                            // Naviguer vers la page du dossier médical avec l'ID du patient
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MedicalRecordPage(patientId: patientId)),
                            );
                          },
                          icon: Icon(Icons.description),
                          color: Colors.blue,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}