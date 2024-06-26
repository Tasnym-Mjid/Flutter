import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AllergieInfos extends StatefulWidget {
  const AllergieInfos({super.key});

  @override
  State<AllergieInfos> createState() => _AllergieInfosState();
}

class _AllergieInfosState extends State<AllergieInfos> {
  late Stream<QuerySnapshot> _AllergieStream;
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
    _AllergieStream = FirebaseFirestore.instance.collection('Allergies').where('patientId', isEqualTo: userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _AllergieStream,
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
            Map<String, dynamic> AllergieData = documents[index].data()! as Map<String, dynamic>;
            return LabResultCard(
              allergen: AllergieData['allergen'] ?? '',
              severity: AllergieData['severity'] ?? '',
              description: AllergieData['description'] ?? '',
            );
          },
        );
      },
    );
  }
}
class LabResultCard extends StatelessWidget {
  final String allergen;
  final String severity;
  final String description;
  //final VoidCallback onViewDetails; // Changement de nom pour rendre son utilisation plus claire

  LabResultCard({
    required this.allergen,
    required this.severity,
    required this.description,
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
            title: Text('Allergène : $allergen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sévérité: $severity'),
                Text('Description: $description'),
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
