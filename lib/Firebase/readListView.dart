import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadListView extends StatefulWidget {
  const ReadListView({super.key});

  @override
  State<ReadListView> createState() => _ReadListViewState();
}

class _ReadListViewState extends State<ReadListView> {
  final _userStream=FirebaseFirestore.instance.collection('doctors').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _userStream,
          builder: (context,snapshot) {
            if(snapshot.hasError){
              return Text('connection error');
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Text(('Loading..'));
            }
            var docs = snapshot.data!.docs;
            //return Text('${docs.length}');
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context,index),
            ),

          },
      ),
    );
  }
}
