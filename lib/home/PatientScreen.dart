import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pfa2/main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
      appBar:AppBar(
        title: Text(
          "DocDash",
          style:TextStyle(
              fontSize:20,
              fontWeight: FontWeight.w600,
              color: Colors.blue
          ) ,),
        actions: <Widget>[
          IconButton(
            onPressed:() {},
            icon: const Icon(Icons.settings, size: 26),
            color: Colors.blue,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                  "Bienvenu notre cher patient",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                  "Que souhaitez vous faire?",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  )
              ),
            ),
            SizedBox(height: 20,),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                // Action à effectuer lors du clic sur le bouton
              },
              color: Color(0xff0095FF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                // Alignement des icônes et du texte au centre
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.folder_rounded, // Icône à afficher (par exemple)
                    color: Colors.white,   // Couleur de l'icône
                  ),
                  SizedBox(width: 8),  // Espacement entre l'icône et le texte
                  Text(
                    "Consulter Dossier médical",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height:20),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                // Action à effectuer lors du clic sur le bouton
              },
              color: Color(0xff0095FF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                // Alignement des icônes et du texte au centre
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.calendar_month, // Icône à afficher
                    color: Colors.white,   // Couleur de l'icône
                  ),
                  SizedBox(width: 8),  // Espacement entre l'icône et le texte
                  Text(
                    "Passer Rendez-vous",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )






          ],
        ),
      ),


    );
  }
}