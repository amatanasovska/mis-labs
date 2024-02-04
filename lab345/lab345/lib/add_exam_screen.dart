import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lab345/notification_service.dart';

class AddExamScreen extends StatefulWidget {
  @override
  _AddExamScreenState createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        timeController.text = picked.format(context);
      });
    }
  }

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Exam Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Time'),
              readOnly: true,
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text.trim();
                String date = dateController.text.trim();
                String time = timeController.text.trim();
                if (name.isNotEmpty && date.isNotEmpty && time.isNotEmpty && user != null && user.uid.isNotEmpty) {
                  try {
                    final String userUid = user.uid;
                    print('Before adding to Firestore');

                    await _firestore.collection('exams').add({
                      'user': userUid,
                      'name': name,
                      'date': date,
                      'time': time,
                    });
                    print('After adding to Firestore');

                    // Combine date and time strings
                    date = date.replaceAllMapped(
                      RegExp(r'(\d+)-(\d+)-(\d+)'),
                      (match) => '${match[1]!.padLeft(2, '0')}-${match[2]!.padLeft(2, '0')}-${match[3]!.padLeft(2, '0')}',
                    );
                    var parts = time.split(" ");

                    time = "${parts[0]}:00 ${parts[1]}";

                    print("DATE $date");
                    String dateTimeString = "$date $time";

                    // Parse the combined date and time string into a DateTime object
                    DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm:ss a").parse(dateTimeString);
                    
                    Duration difference = dateTime.difference(DateTime.now());

                    int secondsDifference = difference.inSeconds;

                    await NotificationService().scheduleNotification("Event $name happening now.", 
                      secondsDifference);

                    Navigator.pop(context);
                  } catch (e) {
                    print('Exception ' + e.toString());

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to save exam details. Please try again.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields or login if not logged in.'),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
