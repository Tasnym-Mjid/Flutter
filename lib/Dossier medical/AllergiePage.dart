import 'package:flutter/material.dart';
import 'package:pfa2/Firebase/AllergieInfos.dart';

class AllergiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergies'),
        backgroundColor: Colors.blue,
      ),
      body:AllergieInfos(),
    );
  }
}

/*class AllergyCard extends StatelessWidget {
  final String allergen;
  final String severity;
  final String description;

  AllergyCard({
    required this.allergen,
    required this.severity,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              'Allergène: $allergen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gravité: $severity'),
                Text('Description: $description'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AllergiesScreen(),
  ));
}*/
