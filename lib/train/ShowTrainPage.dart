import 'package:flutter/material.dart';

class ShowTrainPage extends StatelessWidget {
  final Map<String, dynamic> data;
  ShowTrainPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('แสดงข้อมูลรถราง'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: data['train_id'].toString(),
            decoration: InputDecoration(labelText: 'รหัส'),
            readOnly: true, // ไม่สามารถแก้ไขได้
          ),
          TextFormField(
            initialValue: data['train_number'].toString(),
            decoration: InputDecoration(labelText: 'หมายเลขรถ'),
            readOnly: true, // ไม่สามารถแก้ไขได้
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิด Dialog
          },
          child: Text('ปิด'),
        ),
      ],
    );
  }
}
