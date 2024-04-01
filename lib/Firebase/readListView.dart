import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa2/Patient/Randez-vous_Page.dart';

class ReadListView extends StatefulWidget {
  const ReadListView({Key? key});

  @override
  State<ReadListView> createState() => _ReadListViewState();
}

class _ReadListViewState extends State<ReadListView> {
  final _userStream = FirebaseFirestore.instance.collection('doctors').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur de connexion');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        var docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6BFtKCAZYI3irqwULvjY5drUF4IJz07Tiyw&usqp=CAU'),
                  ),
                ),
                title: Text(
                  docs[index]['username'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(docs[index]['lastname'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    Text(docs[index]['spécialité'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                          color: Colors.blue
                        ),
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentScreen(medecinId: docs[index].id),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Prendre un rendez-vous'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
