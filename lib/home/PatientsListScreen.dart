import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


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
      appBar: AppBar(
        title: Text(
          "DocDash",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, size: 26),
            color: Colors.blue,
          ),
        ],
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
                        title: Text(patients[index]['username']),
                        subtitle: Text(patients[index]['lastname']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Naviguer vers le dossier du patient
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PatientFileScreen(patient: patients[index])),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text(
                            'Consulter dossier médical',
                            style: TextStyle(color: Colors.white),
                          ),
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
      bottomNavigationBar: CurvedNavigationBar(
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
            // Action pour l'onglet Notifications
              break;
            case 2:
            // Action pour l'onglet Profil
              break;
            default:
          }
        },
      ),
    );
  }
}

class PatientFileScreen extends StatelessWidget {
  final DocumentSnapshot patient;

  const PatientFileScreen({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dossier de ${patient['username']}"),
      ),
      body: Center(
        child: Text("Contenu du dossier médical du patient"),
      ),
    );
  }
}
