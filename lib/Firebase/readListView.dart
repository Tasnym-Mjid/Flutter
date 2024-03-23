import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadListView extends StatefulWidget {
  const ReadListView({super.key});

  @override
  State<ReadListView> createState() => _ReadListViewState();
}

class _ReadListViewState extends State<ReadListView> {
  final _userStream=FirebaseFirestore.instance.collection('doctors').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userStream,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text('Erreur de connexion');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        var docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4, // Ajouter une élévation pour donner une ombre à la carte
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: Text(
                  docs[index]['username'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(docs[index]['lastname']),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Action à effectuer lorsqu'on appuie sur le bouton "Prendre un rendez-vous"
                    // Vous pouvez implémenter ici la logique pour passer un rendez-vous avec le médecin
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Couleur du texte du bouton
                  ),
                  child: Text('Prendre un rendez-vous'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}