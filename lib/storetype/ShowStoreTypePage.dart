import 'package:flutter/material.dart';

class ShowStoreTypePage extends StatefulWidget {
  final Map<String, dynamic> data;
  ShowStoreTypePage({required this.data});
  @override
  ShowStoreTypePageState createState() => ShowStoreTypePageState();
}

class ShowStoreTypePageState extends State<ShowStoreTypePage> {
  late TextEditingController typeCodeController;
  late TextEditingController typeNameController;

  @override
  void initState() {
    super.initState();
    typeCodeController = TextEditingController(text: widget.data['TypeCode'].toString());
    typeNameController = TextEditingController(text: widget.data['TypeName'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Store Type'),  // เปลี่ยนจาก 'Show Data' เป็น 'Show Store Type'
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: typeCodeController,
              decoration: InputDecoration(labelText: 'Type Code'),
              enabled: false, // Disable editing
            ),
            TextFormField(
              controller: typeNameController,
              decoration: InputDecoration(labelText: 'Type Name'),
              enabled: false, // Disable editing
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    typeCodeController.dispose();
    typeNameController.dispose();
    super.dispose();
  }
}
