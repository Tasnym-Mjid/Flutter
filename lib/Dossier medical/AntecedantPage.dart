import 'package:flutter/material.dart';

import '../Firebase/AntecedentInfos.dart';

class MedicalHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Antécédents médicaux'),
        backgroundColor: Colors.blue,
      ),
      body:MedicalHistoryInfos(),
    );
  }
}

/*class HistoryItem extends StatelessWidget {
  final String title;
  final String description;

  HistoryItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MedicalHistoryScreen(),
  ));
}*/
