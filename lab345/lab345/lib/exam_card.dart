import 'package:flutter/material.dart';
import 'package:lab345/exam_details_screen.dart';

class ExamCard extends StatelessWidget {
  final String subject;
  final String date;
  final String time;
  final double latitude; // Pass the latitude from your exam data
  final double longitude; // Pass the longitude from your exam data
  
  ExamCard({
    required this.subject,
    required this.date,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExamDetailsScreen(
                  latitude: this.latitude,
                  longitude: this.longitude,
                ),
              ),
            );
          }, child: Card(
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
    )
    );
  }
}
