import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfa2/medecin/Mainlayout.dart';
import 'package:pfa2/medecin/MedecinProfileScreen.dart';

import '../home/AppBar.dart';
import '../pickImage.dart';

class ReglageMedecin extends StatefulWidget {
  final String userId;

  ReglageMedecin({required this.userId});

  @override
  _ReglageMedecinState createState() => _ReglageMedecinState();
}

class _ReglageMedecinState extends State<ReglageMedecin> {
  late TextEditingController _usernameController;
  late TextEditingController _lastnameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _disponibiliteController;
  late TextEditingController _specialiteController;


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
    _usernameController = TextEditingController();
    _lastnameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _disponibiliteController = TextEditingController();
    _specialiteController= TextEditingController();


    FirebaseFirestore.instance
        .collection('medecins')
        .doc(widget.userId)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        if (data != null) {
          setState(() {
            _usernameController.text = data['username'] ?? '';
            _lastnameController.text = data['lastname'] ?? '';
            _phoneNumberController.text = data['phoneNumber'] ?? '';
            _addressController.text = data['address'] ?? '';
            _disponibiliteController.text =
            data['disponibilite'] != null ? data['disponibilite'].toString() : '';
            _specialiteController.text= data['spécialité'] ?? '';
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _lastnameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _disponibiliteController.dispose();
    _specialiteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Modifier les informations',
        onBack: () {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLayoutt()),
          );
        } ,
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
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
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
                      controller: _specialiteController,
                      decoration: InputDecoration(
                        labelText: 'Spécialité',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Adresse',
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
                      controller: _disponibiliteController,
                      decoration: InputDecoration(
                        labelText: 'Disponibilité en cas d\'urgence',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance.collection('doctors').doc(widget.userId).update({
                          'username': _usernameController.text,
                          'lastname': _lastnameController.text,
                          'address': _addressController.text,
                          'phoneNumber': _phoneNumberController.text,
                          'disponibilite': _disponibiliteController.text.toLowerCase() == 'true',
                          'spécialité':_specialiteController.text
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Informations mises à jour avec succès'),
                            backgroundColor: Colors.green,
                          ));
                        }).catchError((error) {
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