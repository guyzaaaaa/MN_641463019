import 'package:flutter/material.dart';

class ShowStorePage extends StatelessWidget {
  final Map<String, dynamic> data;
  ShowStorePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        'ข้อมูลร้านค้า',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: data['StoreID'].toString(),
              decoration: InputDecoration(labelText: 'รหัสร้านค้า'),
              readOnly: true, // Disable editing
            ),
            TextFormField(
              initialValue: data['StoreName'].toString(),
              decoration: InputDecoration(labelText: 'ชื่อร้านค้า'),
              readOnly: true, // Disable editing
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('กลับ'),
            ),
          ],
        ),
      ),
    );
  }
}
