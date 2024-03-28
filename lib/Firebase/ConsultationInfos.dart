import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ConsulationInfos extends StatefulWidget {
  const ConsulationInfos({super.key});

  @override
  State<ConsulationInfos> createState() => _ConsulationInfosState();
}

class _ConsulationInfosState extends State<ConsulationInfos> {
  late Stream<QuerySnapshot> _ConsStream;
  late String userId;

  Future<void> _fetchUid() async {
    try {
      // Obtenir l'utilisateur actuellement connecté avec Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
      }
    } catch (error) {
      print('Erreur lors de la récupération de l\'ID de l\'utilisateur : $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUid();
    // Créer un Stream qui écoute les modifications des documents avec un champ 'id' égal à userId
    _ConsStream = FirebaseFirestore.instance.collection('Consultations').where('patientId', isEqualTo: userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _ConsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data!.docs.isEmpty) {
          return Text("User not found");
        }

        // Accéder aux données de l'utilisateur
        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> ConsData = documents[index].data()! as Map<String, dynamic>;
            return LabResultCard(
              doctorName: ConsData['doctorName'] ?? '',
              date: ConsData['date'] ?? '',
              time: ConsData['time'] ?? '',
              notes: ConsData['notes'] ?? '',
            );
          },
        );
      },
    );
  }
}
class LabResultCard extends StatelessWidget {
  final String doctorName;
  final String date;
  final String time;
  final String notes;
  //final VoidCallback onViewDetails; // Changement de nom pour rendre son utilisation plus claire

  LabResultCard({
    required this.doctorName,
    required this.date,
    required this.time,
    required this.notes,
    //required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text('Consulation avec $doctorName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: $date'),
                Text('Heure: $time'),
                Text('Notes: $notes'),
              ],
            ),
          ),
          /*TextButton(
            onPressed: onViewDetails, // Utilisez la fonction de rappel
            child: Text('Voir les détails des tests'),
          ),*/
        ],
      ),
    );
  }
}