import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(
    home: MedecinQuestionsScreen(),
  ));
}

class MedecinQuestionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donner un avis aux Patients'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('questions').snapshots(),
        builder: (context, snapshot) {
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
          final questions = snapshot.data!.docs;
          if (questions.isEmpty) {
            return Center(
              child: Text('Aucune question n\'a été posée pour le moment.'),
            );
          }
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return QuestionTileForDoctor(question: question);
            },
          );
        },
      ),
    );
  }
}

class QuestionTileForDoctor extends StatelessWidget {
  final QueryDocumentSnapshot question;

  const QuestionTileForDoctor({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.question_answer), // Ajout de l'icône pour chaque question
        title: Text(
          question['question'],
          style: TextStyle(fontWeight: FontWeight.bold), // Mettre le texte en gras
        ),
        subtitle: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('patients').doc(question['patientId']).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Chargement...');
            }
            if (snapshot.hasError) {
              return Text('Erreur de chargement');
            }
            final patientData = snapshot.data!.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic> to avoid the error
            final patientName = patientData?['username'] ?? 'Utilisateur inconnu';
            return Text(
              'Patient: $patientName',
              style: TextStyle(fontWeight: FontWeight.bold), // Mettre le texte en gras
            );
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.reply),
          onPressed: () {
            _showAnswerDialog(context, question.reference);
          },
        ),
      ),
    );
  }

  void _showAnswerDialog(BuildContext context, DocumentReference questionRef) {
    String answer = '';
    String doctorId = FirebaseAuth.instance.currentUser!.uid;
    String doctorName = FirebaseAuth.instance.currentUser!.displayName ?? 'Dr. Inconnu';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Répondre à la question'),
          content: TextField(
            onChanged: (value) {
              answer = value;
            },
            decoration: InputDecoration(
              hintText: 'Entrez votre réponse ici...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (answer.isNotEmpty) {
                  String doctorId = FirebaseAuth.instance.currentUser!.uid; // Récupérer l'ID du médecin connecté
                  String doctorName = FirebaseAuth.instance.currentUser!.displayName ?? 'Dr. Inconnu'; // Récupérer le nom du médecin connecté
                  await questionRef.update({
                    'responses': FieldValue.arrayUnion([
                      {
                        'text': answer,
                        'doctorId': doctorId, // Enregistrer l'ID du médecin avec la réponse
                        'doctorName': doctorName,
                      }
                    ])
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Réponse envoyée avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez entrer une réponse'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }
}
