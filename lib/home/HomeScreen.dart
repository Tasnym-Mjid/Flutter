import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa2/Randez-vous_Page.dart';
import 'package:pfa2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



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
      body: SafeArea(
        child:Padding(
         padding: const EdgeInsets.symmetric(horizontal: 25.0),
         child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hi Jared',
                style: TextStyle(
                  color: Colors.black,
                  fontSize:24,
                  fontWeight:FontWeight.bold,
                ),),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(16),
                  child:Icon(Icons.settings,
                    color:Colors.blue,size: 30),
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
                ElevatedButton(onPressed:(){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
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
                      MaterialPageRoute(builder: (context) => AppointmentScreen())
                  );
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
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
                ElevatedButton(onPressed:(){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
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
                Text('Randez-vous pour aujourd\'hui',
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
              child: Container(
                color: Colors.blue[300],

              ),
            )
          ],


        ),
      ),




    ),
    );
  }
}