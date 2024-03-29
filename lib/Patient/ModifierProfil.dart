import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfa2/pickImage.dart';

class EditPatientInfoScreen extends StatefulWidget {
  final String userId;

  EditPatientInfoScreen({required this.userId});

  @override
  _EditPatientInfoScreenState createState() => _EditPatientInfoScreenState();
}

class _EditPatientInfoScreenState extends State<EditPatientInfoScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _lastnameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs de texte avec les données actuelles du patient
    _usernameController = TextEditingController();
    _lastnameController = TextEditingController();
    _ageController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();

    // Récupérer les données du patient pour pré-remplir les champs
    FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.userId)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        setState(() {
          _usernameController.text = snapshot.data()!['username'];
          _lastnameController.text = snapshot.data()!['lastname'];
          _ageController.text = snapshot.data()!['age']?.toString() ?? '';
          _phoneNumberController.text = snapshot.data()!['phoneNumber'] ?? '';
          _addressController.text = snapshot.data()!['address'] ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    // Libérer les ressources des contrôleurs de texte
    _usernameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier les informations'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white, // Couleur bleue pour le fond
                  shape: BoxShape.circle, // Forme circulaire
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Changement de la position de l'ombre
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 80,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6BFtKCAZYI3irqwULvjY5drUF4IJz07Tiyw&usqp=CAU'),
                    ),
                    Positioned(
                      bottom: -6,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _lastnameController,
                      decoration: InputDecoration(
                        labelText: 'Prénom',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Âge',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Adresse',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Mettre à jour les informations du patient dans Firestore
                        FirebaseFirestore.instance.collection('patients').doc(widget.userId).update({
                          'username': _usernameController.text,
                          'lastname': _lastnameController.text,
                          'age': int.tryParse(_ageController.text) ?? 0,
                          'phoneNumber': _phoneNumberController.text,
                          'address': _addressController.text,
                        }).then((_) {
                          // Afficher un message de succès
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Informations mises à jour avec succès'),
                            backgroundColor: Colors.green,
                          ));
                        }).catchError((error) {
                          // Afficher un message d'erreur s'il y a eu un problème
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Erreur lors de la mise à jour des informations'),
                            backgroundColor: Colors.red,
                          ));
                        });
                      },
                      child: Text(
                        'Enregistrer',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
