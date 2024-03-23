import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    // Récupérer les informations de l'utilisateur actuellement connecté
    getCurrentUserData();
  }

  Future<void> getCurrentUserData() async {
    // Récupérer l'utilisateur actuellement connecté
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Utiliser l'ID de l'utilisateur pour récupérer ses données depuis Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
         print(user.uid);
      // Récupérer le nom de l'utilisateur depuis les données récupérées
      setState(() {
        _userName = userData['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Text(
          'Welcome, $_userName!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
