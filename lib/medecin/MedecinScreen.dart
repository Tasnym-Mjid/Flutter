import 'package:flutter/material.dart';
import 'PatientsListScreen.dart'; // Importez l'écran de liste des patients ici
import 'MedecinProfileScreen.dart'; // Importez l'écran du profil du médecin ici
import 'DonnerAvis.dart'; // Importez l'écran pour donner un avis ici
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AgendaMedecin.dart';

class MedecinScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DocDash",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        actions: <Widget>[
          Image.asset(
            'images/Logo-DocDash.png', // Chemin de l'image locale
            height: 100, // Ajustez la taille selon vos besoins
            // width: 40,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Bienvenue, Docteur",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Que souhaitez-vous faire?",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () async {
                // Récupérer l'ID du médecin
                String? medecinId = FirebaseAuth.instance.currentUser?.uid;

                // Vérifier si l'ID du médecin est récupéré
                if (medecinId != null) {
                  // Naviguer vers la page de l'agenda en passant l'ID du médecin en paramètre
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgendaMedecin(medecinId: medecinId)),
                  );
                } else {
                  // Afficher une alerte ou effectuer une autre action si l'ID du médecin n'est pas récupéré
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Erreur'),
                      content: Text('Impossible de récupérer l\'ID du médecin.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              color: Color(0xff0095FF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.folder_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Visualiser Agenda",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                // Naviguer vers la liste des patients
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientsListScreen()),
                );
              },
              color: Color(0xff0095FF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Patients",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                // Naviguer vers la page pour donner un avis
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedecinQuestionsScreen()),
                );
              },
              color: Color(0xff0095FF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.warning,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Donner un avis",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}