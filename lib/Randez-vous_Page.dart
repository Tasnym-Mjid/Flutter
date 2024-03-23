import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String _selectedDoctor = ''; // Variable pour stocker le nom du médecin sélectionné

  // Liste de médecins (à titre d'exemple)
  final List<String> _doctors = ['Dr. Smith', 'Dr. Johnson', 'Dr. Lee'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blue,
        color: Colors.blue,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.account_circle_outlined, size: 26, color: Colors.white),
          Icon(Icons.add_alert, size: 26, color: Colors.white),

        ],
      ),
      appBar: AppBar(
        title: Text('Passer un rendez-vous'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisissez un médecin :',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: _selectedDoctor.isNotEmpty ? _selectedDoctor : null,
              hint: Text('Sélectionnez un médecin'),
              items: _doctors.map((doctor) {
                return DropdownMenuItem(
                  value: doctor,
                  child: Text(doctor),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDoctor = value.toString();
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique pour enregistrer le rendez-vous
                if (_selectedDoctor.isNotEmpty) {
                  // Ici, vous pouvez ajouter la logique pour enregistrer le rendez-vous
                  // par exemple, vous pouvez ajouter le rendez-vous à une collection Firestore
                  // avec les détails comme le nom du médecin, l'heure, la date, etc.
                  // Une fois le rendez-vous enregistré, vous pouvez afficher un message de succès ou naviguer vers une autre page
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Succès'),
                        content: Text('Rendez-vous passé avec $_selectedDoctor'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Afficher un message si aucun médecin n'est sélectionné
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erreur'),
                        content: Text('Veuillez sélectionner un médecin.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Confirmer le rendez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}
