import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfa2/Patient/ListMedecin.dart';

import '../home/AppBar.dart';

class AppointmentScreen extends StatefulWidget {
  final String medecinId;

  const AppointmentScreen({Key? key,  required this.medecinId});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
  Future<bool> checkAppointmentAvailability(DateTime selectedDate, TimeOfDay selectedTime) async {
    try {
      // Obtenez une référence à la collection des rendez-vous
      CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');

      // Vérifiez si un rendez-vous existe déjà à la date et à l'heure spécifiées
      QuerySnapshot querySnapshot = await appointments.where('date', isEqualTo: selectedDate).get();
      List<QueryDocumentSnapshot> appointmentsAtSameDate = querySnapshot.docs.where((doc) {
        // Convertir l'heure du document Firestore en TimeOfDay
        List<String> timeParts = (doc['heure'] as String).split(':');
        int appointmentHour = int.parse(timeParts[0]);
        int appointmentMinute = int.parse(timeParts[1]);
        TimeOfDay appointmentTime = TimeOfDay(hour: appointmentHour, minute: appointmentMinute);

        // Vérifier si l'heure du rendez-vous correspond à l'heure sélectionnée
        return appointmentTime == selectedTime;
      }).toList();

      return appointmentsAtSameDate.isEmpty;
    } catch (e) {
      print('Erreur lors de la vérification de la disponibilité du rendez-vous : $e');
      return false;
    }
  }

  Future<void> _saveAppointment(String medecinId) async {
    try {
      // Vérifiez d'abord si tous les champs sont remplis
      if (selectedDate == null ||
          selectedTime == null ||
          _nameController.text.isEmpty ||
          _phoneNumberController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Champs incomplets'),
              content: Text(
                  'Veuillez remplir tous les champs pour enregistrer le rendez-vous.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
      // Vérifiez si le rendez-vous est disponible
      bool isAvailable = await checkAppointmentAvailability(selectedDate!, selectedTime!);
      if (!isAvailable) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Heure non disponible',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue, // Couleur du titre
                  ),
                ),
              ),
              content: Text(
                'L\'heure sélectionnée n\'est pas disponible. Veuillez choisir une autre heure.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Couleur du contenu
                ),
              ),
              backgroundColor: Colors.white, // Couleur de fond de l'AlertDialog
              elevation: 8.0, // Élévation de l'AlertDialog
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Bordure arrondie
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Couleur du bouton
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return;
      }
      User? user = FirebaseAuth.instance.currentUser;
      String? patientId=user?.uid;
      DocumentSnapshot medecinSnapshot = await FirebaseFirestore.instance.collection('doctors').doc(medecinId).get();
      String medecinName = medecinSnapshot['username'];
      String medecinlLastName = medecinSnapshot['lastname'];



      // Obtenez une référence à la collection des rendez-vous
      CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

      // Créez un document avec les données du rendez-vous
      await appointments.add({
        'nomPatient': _nameController.text,
        'numeroTelephone': _phoneNumberController.text,
        'date': selectedDate,
        'heure': '${selectedTime!.hour}:${selectedTime!.minute}',
        'NomMedecin': medecinName,
        'PrenomMedecin': medecinlLastName,
        'medecinId': medecinId, // Convertir en chaîne
        'patientId': patientId,
        'completed': false,
      });
      setState(() {
        selectedDate = null;
        selectedTime = null;
        _nameController.clear();
        _phoneNumberController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rendez-vous enregistré avec succès')),
      );

      print('Rendez-vous enregistré avec succès');
    } catch (e) {
      print('Erreur lors de l\'enregistrement du rendez-vous : $e');
    }
  }
  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar(
        pageTitle: '',
        onBack: () {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListMedecin()),
          );
        } ,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Réservez un Rendez-vous',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[300]
                  ),
                ),
                SizedBox(height: 60,),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? 'Choisir une date'
                              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTime == null
                              ? 'Choisir l\'heure'
                              : '${selectedTime!.hour}:${selectedTime!.minute}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.access_time,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Votre nom',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  cursorColor: Colors.blue,
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: '+216',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  cursorColor: Colors.blue,
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: (){_saveAppointment(widget.medecinId);},
                  child: Text(
                    'Réserver',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
