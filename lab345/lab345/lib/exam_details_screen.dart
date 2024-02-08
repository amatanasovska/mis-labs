import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ExamDetailsScreen extends StatelessWidget {
  final double latitude; // Pass the latitude from your exam data
  final double longitude; // Pass the longitude from your exam data

  ExamDetailsScreen({required this.latitude, required this.longitude});

  Future<void> _launchGoogleMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _launchGoogleMaps(),
            child: Text('Show Route on Google Maps'),
          ),
        ],
      ),
    );
  }
}
