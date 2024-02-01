import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab345/exam_card.dart';

class ExamList extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // Handle the case where the user is not logged in
      return Center(
        child: Text('Please log in to view exams.'),
      );
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('exams')
          .where('user', isEqualTo: user!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while data is being fetched
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No exams found for the current user.'),
          );
        }

        // Display the list of exams
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var exam = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return ExamCard(
              subject: exam['name'],
              date: exam['date'],
              time: exam['time'],
            );
          },
        );
      },
    );
  }
}
