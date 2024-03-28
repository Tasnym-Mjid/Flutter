import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LabResultsInfos extends StatefulWidget {
  const LabResultsInfos({Key? key}) : super(key: key);

  @override
  State<LabResultsInfos> createState() => _LabResultsInfosState();
}

class _LabResultsInfosState extends State<LabResultsInfos> {
  late Stream<QuerySnapshot> _labStream;
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
    _labStream = FirebaseFirestore.instance.collection('Résultats labos').where('patientId', isEqualTo: userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _labStream,
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
            Map<String, dynamic> labData = documents[index].data()! as Map<String, dynamic>;
            return LabResultCard(
              testName: labData['testName'] ?? '',
              resultValue: labData['resultValue'] ?? '',
              resultDate: labData['resultDate'] ?? '',
            );
          },
        );
      },
    );
  }
}
class LabResultCard extends StatelessWidget {
  final String testName;
  final String resultValue;
  final String resultDate;
  //final VoidCallback onViewDetails; // Changement de nom pour rendre son utilisation plus claire

  LabResultCard({
    required this.testName,
    required this.resultValue,
    required this.resultDate,
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
            title: Text(
              testName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Résultat: $resultValue'),
                Text('Date: $resultDate'),
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