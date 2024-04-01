
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Dossier medical/DossierMedicalPage.dart';
import '../Patient/AskDoctorScreen.dart';
import '../Patient/ListMedecin.dart';
import '../Patient/EmergencyServiceScreen.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? patientId;
  String? userName;// L'ID de l'utilisateur connecté
  List<DocumentSnapshot> appointments = [];

  @override
  void initState() {
    super.initState();
    // Récupérer l'ID de l'utilisateur connecté lorsque le widget est créé
    _fetchUserId();
    // Récupérer les rendez-vous du patient pour aujourd'hui
    _fetchTodaysAppointments();
  }

  Future<void> _fetchUserId() async {
    try {
      // Obtenir l'utilisateur actuellement connecté avec Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          patientId = user.uid;
          FirebaseFirestore.instance.collection('patients').doc(patientId).get().then((doc) {
            if (doc.exists) {
              setState(() {
                userName = doc['username']; // Supposant que le champ contenant le nom du patient est 'nom'
              });
            }
          });
        });
      }
    } catch (error) {
      print('Erreur lors de la récupération de l\'ID de l\'utilisateur : $error');
    }
  }

  Future<void> _fetchTodaysAppointments() async {
    try {
      // Obtenez une référence à la collection des rendez-vous
      CollectionReference appointmentsRef = FirebaseFirestore.instance.collection('appointments');

      // Récupérez les rendez-vous du patient pour aujourd'hui
      QuerySnapshot querySnapshot = await appointmentsRef
          .where('patientId', isEqualTo: patientId)
          .get();

      setState(() {
        appointments = querySnapshot.docs;
      });
    } catch (error) {
      print('Erreur lors de la récupération des rendez-vous du patient : $error');
    }
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    try {
      // Obtenez une référence au document du rendez-vous
      DocumentReference appointmentRef = FirebaseFirestore.instance.collection('appointments').doc(appointmentId);

      // Supprimez le rendez-vous
      await appointmentRef.delete();

      // Mettez à jour l'interface utilisateur en rechargeant les rendez-vous
      _fetchTodaysAppointments();
    } catch (error) {
      print('Erreur lors de l\'annulation du rendez-vous : $error');
    }
  }

  Future<void> _markAsCompleted(String appointmentId) async {
    try {
      // Obtenez une référence au document du rendez-vous
      DocumentReference appointmentRef = FirebaseFirestore.instance.collection('appointments').doc(appointmentId);

      // Marquez le rendez-vous comme terminé
      await appointmentRef.update({'completed': true});

      // Mettez à jour l'interface utilisateur en rechargeant les rendez-vous
      _fetchTodaysAppointments();
    } catch (error) {
      print('Erreur lors du marquage du rendez-vous comme terminé : $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$userName',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:24,
                      fontWeight:FontWeight.bold,
                    ),),
                  Image.asset(
                    'images/Logo-DocDash.png', // Chemin de l'image locale
                    height: 80, // Ajustez la taille selon vos besoins
                    // width: 40,
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Text('Qu\'est ce que vous souhaitez faire?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:18,
                      fontWeight:FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Column(
                children: [
                  ElevatedButton(onPressed:(){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MedicalRecordPage(patientId: patientId!,),)
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 8,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.folder_rounded, // Icône à afficher (par exemple)
                          color: Colors.black,   // Couleur de l'icône
                        ),
                        SizedBox(width: 8),  // Espacement entre l'icône et le texte
                        Text(
                          "Consulter Dossier médical",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),

                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  ElevatedButton(onPressed:(){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ListMedecin())
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 8,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.calendar_month, // Icône à afficher (par exemple)
                          color: Colors.black,   // Couleur de l'icône
                        ),
                        SizedBox(width: 8),  // Espacement entre l'icône et le texte
                        Text(
                          "Passer un rendez-vous",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),

                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 16,),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AskDoctorScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.local_hospital,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Demander un avis de médecin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(onPressed:(){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => EmergencyServiceScreen())
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 8,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.local_hospital, // Icône à afficher (par exemple)
                          color: Colors.black,   // Couleur de l'icône
                        ),
                        SizedBox(width: 8),  // Espacement entre l'icône et le texte
                        Text(
                          "Demander Service d\'urgence",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),

                        ),

                      ],
                    ),
                  ),
                ],

              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Text('Randez-vous :',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:18,
                      fontWeight:FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Expanded(
                child: appointments.isEmpty
                    ? Center(child: Text('Aucun rendez-vous pour aujourd\'hui'))
                    : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    // Récupérez les détails du rendez-vous
                    Map<String, dynamic> appointmentData = appointments[index].data() as Map<String, dynamic>;
                    TimeOfDay time = TimeOfDay(
                      hour: int.parse(appointmentData['heure'].split(':')[0]),
                      minute: int.parse(appointmentData['heure'].split(':')[1]),
                    );

                    // Formattez l'heure du rendez-vous
                    String formattedTime = DateFormat.jm().format(DateTime(1, 1, 1, time.hour, time.minute));

                    return Card(
                      shadowColor: Colors.blue,
                      elevation: 8,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.blue, width: 2), // Bordure noire de 2 pixels
                                ),
                                child: CircleAvatar(
                                  radius: 20, // Taille du cercle d'avatar
                                  backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6BFtKCAZYI3irqwULvjY5drUF4IJz07Tiyw&usqp=CAU'),
                                ),
                              ),
                              SizedBox(width: 16), // Espacement entre le cercle d'avatar et les informations du rendez-vous
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rendez-vous à $formattedTime avec',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Dr. ${appointmentData['NomMedecin']} ${appointmentData['PrenomMedecin']}',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Date: ${DateFormat('dd/MM/yyyy').format(appointmentData['date'].toDate())}',
                                    style: TextStyle(fontSize: 15,color:Colors.blue),
                                  ),
                                ],
                              ),
                            ],
                          ),




                          appointmentData['completed'] == true
                              ? Text('Terminé', style: TextStyle(color: Colors.green))
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 35),
                              ElevatedButton(
                                onPressed: () => _cancelAppointment(appointments[index].id),
                                child: Text('Annuler',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 8,
                                ),                              ),
                              SizedBox(width: 80),
                              ElevatedButton(
                                onPressed: () => _markAsCompleted(appointments[index].id),
                                child: Text('Terminer',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  elevation: 8,
                                ),                              ),
                            ],
                          ),
                        ],

                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
