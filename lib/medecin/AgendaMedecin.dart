import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pfa2/medecin/Mainlayout.dart';
import 'package:pfa2/medecin/MedecinScreen.dart';

import '../home/AppBar.dart';

class AgendaMedecin extends StatelessWidget {
  final String medecinId;

  const AgendaMedecin({Key? key, required this.medecinId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Agenda du médecin',
        onBack: () {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLayoutt()),
          );
        } ,
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
              var date = appointment['date'] as Timestamp?;
              var heure = appointment['heure'] as String?;
              var nomPatient = appointment['nomPatient'] as String?;
              var isCompleted = appointment['completed'] as bool? ?? false;

              if (date == null || heure == null || nomPatient == null) {
                // Si l'une des valeurs est null, afficher un message d'erreur
                return ListTile(
                  title: Text('Données de rendez-vous incomplètes'),
                );
              }

              var dateTime = date.toDate(); // Convertir en DateTime
              //var formattedDate = DateFormat.yMMMMd().format(dateTime);
              //var formattedTime = DateFormat.Hm().format(dateTime);
              var formattedDate = DateFormat('d/MM/yyyy').format(dateTime);
              TimeOfDay time = TimeOfDay(
                hour: int.parse(heure!.split(':')[0]),
                minute: int.parse(heure.split(':')[1]),
              );

// Déterminer si l'heure est AM ou PM
              String amPm = time.hour < 12 ? 'AM' : 'PM';

// Formater l'heure pour afficher les heures sur un format de 12 heures
              String formattedTime = '${time.hourOfPeriod}:${time.minute} $amPm';



              // Si le rendez-vous est terminé, afficher un message et un bouton de suppression
              if (isCompleted) {
                return Card(
                  elevation: 8,
                  shadowColor: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6BFtKCAZYI3irqwULvjY5drUF4IJz07Tiyw&usqp=CAU'),
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$nomPatient',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$formattedDate',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Heure: $formattedTime',
                                style: TextStyle(fontSize: 15, color: Colors.blue),
                              ),

                              Row(
                                children: [
                                  Text(
                                    'Terminé',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.red),
                                  ),
                                  SizedBox(width: 80),
                                  ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance.collection('appointments').doc(appointment.id).delete().then((_) {
                                        // Afficher un message de confirmation de suppression
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Rendez-vous supprimé avec succès')),
                                        );
                                      }).catchError((error) {
                                        // Afficher un message d'erreur s'il y a eu un problème lors de la suppression
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Erreur lors de la suppression du rendez-vous')),
                                        );
                                        print('Erreur lors de la suppression du rendez-vous : $error');
                                      });
                                    },
                                    child: Text('Supprimer',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                    ),),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[300],
                                      elevation: 8,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              // Si le rendez-vous n'est pas terminé, afficher normalement
              return Card(
                elevation: 8,
                shadowColor: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6BFtKCAZYI3irqwULvjY5drUF4IJz07Tiyw&usqp=CAU'),
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$nomPatient',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$formattedDate',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Heure: $formattedTime',
                              style: TextStyle(fontSize: 15, color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
