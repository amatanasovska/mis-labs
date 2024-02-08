import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchExamLocations();
  }

  Future<void> _fetchExamLocations() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;

    try {
      QuerySnapshot<Map<String, dynamic>> exams =
          await  _firestore.collection('exams')
          .where('user', isEqualTo: user!.uid).get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> exam in exams.docs) {
        final double? latitude = exam['latitude'];
        final double? longitude = exam['longitude'];

        if (latitude != null && longitude != null) {
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId(exam.id),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(
                  title: exam['name'],
                  snippet: 'Exam Details: ${exam['date']} at ${exam['time']}',
                ),
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error fetching exam locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Locations'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers,
      ),
    );
  }
}

