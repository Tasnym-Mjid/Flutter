import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgendaMedecin extends StatelessWidget {
  final String medecinId;

  const AgendaMedecin({Key? key, required this.medecinId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agenda du Médecin',
          style: TextStyle(
            color: Colors.blue, // Changer la couleur du texte en bleu
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('medecinId', isEqualTo: medecinId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur s\'est produite.'),
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Aucun rendez-vous trouvé.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var appointment = snapshot.data!.docs[index];
              var date = appointment['date'] as Timestamp?; // Convertir en Timestamp
              var heure = appointment['heure'] as String?;
              var nomPatient = appointment['nomPatient'] as String?;

              if (date == null || heure == null || nomPatient == null) {
                // Si l'une des valeurs est null, afficher un message d'erreur
                return ListTile(
                  title: Text('Données de rendez-vous incomplètes'),
                );
              }

              var dateTime = date.toDate(); // Convertir en DateTime

              return Card(
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.calendar_today), // Ajouter un icône à gauche du rendez-vous
                  title: Text(
                    nomPatient,
                    style: TextStyle(fontWeight: FontWeight.bold), // Mettre en gras le nom du patient
                  ),
                  subtitle: Text('${dateTime.day}/${dateTime.month}/${dateTime.year} $heure'),
                  // Ajoutez d'autres informations sur le rendez-vous ici
                ),
              );
            },
          );
        },
      ),
    );
  }
}