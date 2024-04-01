import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDTGgRUoaMrzjtlnMKXdIS5M8UX_ddzTjw",//  ==   current_key in google-services.json file
      appId: "1:1053506622292:android:3085b8b54bfaa07fa8eec1", // ==  mobilesdk_app_id  in google-services.json file
      messagingSenderId: "1053506622292", // ==   project_number in google-services.json file
      projectId: "pfa2-29e6e", // ==   project_id   in google-services.json file
    ),
  ).then((_) {
    print("Firebase initialisé avec succès !");
  }).catchError((error) {
    print("Erreur lors de l'initialisation de Firebase : $error");
  });;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // we will give media query height
          // double.infinity make it big as my parent allows
          // while MediaQuery make it big as per the screen

          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            // even space distribution
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Bienvenue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,

                    ),

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Sur votre application ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold

                    ),)
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/Logo-DocDash.png"),
                        fit: BoxFit.contain,
                    )
                ),
              ),

              Column(
                children: <Widget>[
                  // the login button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    elevation: 5,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));

                    },
                    // defining the shape
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    color: Colors.white,
                    child: Text(
                      "Se connecter",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  ),
                  // creating the signup button
                  SizedBox(height:20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    elevation: 5,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));

                    },
                    color: Color(0xff0095FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  )

                ],
              )



            ],
          ),
        ),
      ),
    );
  }
}