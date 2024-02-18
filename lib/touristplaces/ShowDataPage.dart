import 'package:flutter/material.dart';

class ShowDataPage extends StatelessWidget {
  final Map<String, dynamic> data;
  ShowDataPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ข้อมูลสถานที่ท่องเที่ยว'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: data['PlaceCode'].toString(),
              decoration: InputDecoration(labelText: 'รหัสสถานที่'),
              readOnly: true, // Disable editing
            ),
            TextFormField(
              initialValue: data['PlaceName'].toString(),
              decoration: InputDecoration(labelText: 'ชื่อสถานที่'),
              readOnly: true, // Disable editing
            ),
            TextFormField(
              initialValue: data['Latitude'].toString(),
              decoration: InputDecoration(labelText: 'ละติดจูด'),
              readOnly: true, // Disable editing
            ),
            TextFormField(
              initialValue: data['Longitude'].toString(),
              decoration: InputDecoration(labelText: 'ลองติจูด'),
              readOnly: true, // Disable editing
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('กลับ'),
        ),
      ],
    );
  }
}
