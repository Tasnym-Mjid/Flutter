import 'package:flutter/material.dart';

import '../Firebase/ConsultationInfos.dart';

class ConsultationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultations'),
        backgroundColor: Colors.blue,
      ),
      body: ConsulationInfos(),
    );
  }
}

/*class ConsultationCard extends StatelessWidget {
  final String doctorName;
  final String date;
  final String time;
  final String notes;

  ConsultationCard({
    required this.doctorName,
    required this.date,
    required this.time,
    required this.notes,
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
              'Consultation avec $doctorName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: $date'),
                Text('Heure: $time'),
                Text('Notes: $notes'),
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
    home: ConsultationScreen(),
  ));
}*/