import 'package:flutter/material.dart';
import 'package:pfa2/Firebase/LabResultsInfos.dart';

class LaboResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de laboratoire'),
        backgroundColor: Colors.blue,
      ),
      body:LabResultsInfos(),
    );
  }
}

/*class LabResultCard extends StatelessWidget {
  final String testName;
  final String resultValue;
  final String resultDate;
  final VoidCallback onPressed;

  LabResultCard({
    required this.testName,
    required this.resultValue,
    required this.resultDate,
    required this.onPressed,
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
              testName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Résultat: $resultValue'),
                Text('Date: $resultDate'),
              ],
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text('Voir les détails des tests'),
          ),
        ],
      ),
    );
  }
}

class LabTestDetailScreen extends StatelessWidget {
  final String testName;
  final String testDetails;

  LabTestDetailScreen({
    required this.testName,
    required this.testDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails des tests de $testName'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          testDetails,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LaboResultScreen(),
  ));
}*/
