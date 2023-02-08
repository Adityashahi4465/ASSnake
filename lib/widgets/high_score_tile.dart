import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HighScoreTile extends StatelessWidget {
  final String documentId;
  final int index;
  const HighScoreTile({required this.documentId, required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference highscores =
        FirebaseFirestore.instance.collection('highscores');
    return FutureBuilder<DocumentSnapshot>(
        future: highscores.doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Row(
              children: [
                Text('${(index + 1).toString()}.'),
                Text(data['name']),
                Text('   ${data['score'].toString()}'),
              ],
            );
          } else {
            return const Text('loding...');
          }
        });
  }
}
