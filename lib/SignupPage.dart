import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginPage.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  //final TextEditingController _roleController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final currentUser=FirebaseAuth.instance;
  final List<String> _roles = ['Patient', 'Médecin'];
  String _selectedRole = 'Patient';





  //authentificate the user
  void signUp(BuildContext context) async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Les mots de passe ne correspondent pas")),
        );
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      //String userId = userCredential.user!.uid;


      // Enregistrez d'autres informations de l'utilisateur si nécessaire.
      // Par exemple, vous pouvez enregistrer le nom d'utilisateur dans une base de données Firestore.
      // Firestore.instance.collection('users').doc(userCredential.user.uid).set({
      //   'username': _usernameController.text,
      //   'email': _emailController.text,
      //   // Ajoutez d'autres champs d'informations utilisateur ici
      // });

      // Affichez un message de succès ou naviguez vers une autre page.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inscription réussie pour ${userCredential.user?.email}'),
          duration: Duration(seconds: 2),
        ),
      );
      final String? userId=currentUser.currentUser?.uid;
      // Navigate to the login screen after successful sign up.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      addUserDetails(_usernameController.text,
          _lastNameController.text,
          _selectedRole,
          _emailController.text,
      userId!,);
      separateUsers();
    } catch (e) {
      // Gérez les erreurs ici, par exemple affichez un message d'erreur à l'utilisateur
      print("Erreur d'inscription : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur d\'inscription: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }

  }
  addUserDetails(String username,String lastname,String role,String email , String uid )async{
    User? user = FirebaseAuth.instance.currentUser;
    String? userId=user?.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'uid':uid,
      'username':username,
      'lastname':lastname,
      'role':_selectedRole,
      'email':email,
    });
  }

  void separateUsers() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId=user?.uid;
    // Récupérer tous les documents de la collection 'users'
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    querySnapshot.docs.forEach((doc) async {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> dataToTransfer = {
        'uid':userData['uid'],
        'username': userData['username'], // Champs à transférer depuis la collection 'users'
        'lastname': userData['lastname'],
         'role': userData['role'],
        'email': userData['email']
        // Ajoutez d'autres champs selon vos besoins
      };

      // Vérifier le type d'utilisateur
      String userType = userData['role']; // Suppose que vous avez un champ 'userType' pour indiquer le type d'utilisateur

      // Ajouter l'utilisateur à la collection appropriée
      if (userType == 'Médecin') {
        // Ajouter l'utilisateur à la collection des médecins
        await FirebaseFirestore.instance.collection('doctors').doc(userId).set(dataToTransfer);
      } else if (userType == 'Patient') {
        // Ajouter l'utilisateur à la collection des patients
        await FirebaseFirestore.instance.collection('patients').doc(userId).set(dataToTransfer);
      }
    });

    print('Séparation des utilisateurs terminée.');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Créer un compte, c'est gratuit ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roles.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _selectedRole = value!;
                    },
                    decoration: InputDecoration(
                      labelText: 'Rôle',
                      prefixIcon: Icon(Icons.add_circle),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirme Mot de passe',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                  ),
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () => signUp(context),
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "S'inscire",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Avez vous déjà un compte?"),
                  Text(
                    " Se connecter",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}
