import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget {
  final String subject;
  final String date;
  final String time;

  ExamCard({
    required this.subject,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              'Date: $date',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 4.0),
            Text(
              'Time: $time',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
