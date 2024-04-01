import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home/AppBar.dart';
import '../home/Main_layout.dart';

void main() {
  runApp(MaterialApp(
    home: AskDoctorScreen(),
  ));
}

class AskDoctorScreen extends StatefulWidget {
  @override
  _AskDoctorScreenState createState() => _AskDoctorScreenState();
}

class _AskDoctorScreenState extends State<AskDoctorScreen> {
  final TextEditingController _questionController = TextEditingController();
  String? patientId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          patientId = user.uid;
        });
      }
    } catch (error) {
      print('Erreur lors de la récupération de l\'ID de l\'utilisateur : $error');
    }
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.isNotEmpty) {
      try {
        if (patientId != null) {
          await FirebaseFirestore.instance.collection('questions').add({
            'patientId': patientId,
            'question': _questionController.text,
            'responses': [], // Ajout du champ 'responses'
            'timestamp': FieldValue.serverTimestamp(),
          });
          _questionController.clear();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Votre question a été envoyée avec succès'),
            backgroundColor: Colors.green,
          ));
        } else {
          print('L\'ID de l\'utilisateur est null');
        }
      } catch (error) {
        print('Erreur lors de l\'envoi de la question : $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Une erreur est survenue. Veuillez réessayer plus tard.'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer votre question'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Demander un avis',
        onBack: () {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLayout()),
          );
        } ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posez votre question au médecin :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _questionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Entrez votre question ici...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitQuestion,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Couleur du bouton en bleu
              ),
              child: Text('Envoyer la question'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientQuestionsScreen(patientId: patientId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Couleur du bouton en bleu
              ),
              child: Text('Voir mes questions'),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientQuestionsScreen extends StatelessWidget {
  final String? patientId;

  PatientQuestionsScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos Questions et Réponses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .where('patientId', isEqualTo: patientId)
            .snapshots(),
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
              return QuestionTile(question: question);
            },
          );
        },
      ),
    );
  }
}

class QuestionTile extends StatelessWidget {
  final QueryDocumentSnapshot question;

  const QuestionTile({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        leading: Icon(Icons.question_answer), // Ajout de l'icône pour chaque question
        title: Text(question['question']),
        subtitle: QuestionResponses(question: question),
      ),
    );
  }
}

class QuestionResponses extends StatelessWidget {
  final QueryDocumentSnapshot question;

  const QuestionResponses({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> responses = question['responses'];
    if (responses.isEmpty) {
      return Text('Aucune réponse pour le moment');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: responses.map((response) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue, // Couleur de fond de l'avatar
                child: Icon(
                  Icons.person,
                  color: Colors.white, // Couleur de l'icône
                ),
              ),
              title: Text(response['text']),
              subtitle: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance.collection('medecins').doc(response['doctorId']).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Chargement...');
                  }
                  if (snapshot.hasError) {
                    return Text('Erreur de chargement');
                  }
                  final doctorData = snapshot.data!.data();
                  final doctorName = doctorData?['username'] ?? 'Médecin inconnu';
                  return RichText(
                    text: TextSpan(
                      text: 'Répondu par: ',
                      style: TextStyle(color: Colors.black), // Style du texte avant le nom du médecin
                      children: [
                        TextSpan(
                          text: '$doctorName',
                          style: TextStyle(fontWeight: FontWeight.bold), // Mettre en gras le nom du médecin
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      );
    }
  }
}