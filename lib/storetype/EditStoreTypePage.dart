import 'package:flutter/material.dart';
import 'HealStoreTypePage.dart';
import 'package:http/http.dart' as http;

class EditStoreTypePage extends StatefulWidget {
  final Map<String, dynamic> data;
  EditStoreTypePage({required this.data});
  @override
  _EditStoreTypePageState createState() => _EditStoreTypePageState();
}

class _EditStoreTypePageState extends State<EditStoreTypePage> {
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
        title: Text('Edit Store Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: typeCodeController,
              decoration: InputDecoration(
                labelText: 'Type Code',
                prefixIcon: Icon(Icons.code, color: Colors.black),
              ),
            ),
            TextFormField(
              controller: typeNameController,
              decoration: InputDecoration(
                labelText: 'Type Name',
                prefixIcon: Icon(Icons.store, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String updatedTypeCode = typeCodeController.text;
                String updatedTypeName = typeNameController.text;

                String apiUrl = 'http://localhost/tourlism_root_641463019/editstoretype.php';

                Map<String, dynamic> requestBody = {
                  'TypeCode': updatedTypeCode,
                  'TypeName': updatedTypeName,
                  'case': '2', // Ensure this is a string if it's expected as a string on the server
                };

                try {
                  var response = await http.post(
                    Uri.parse(apiUrl),
                    body: requestBody,
                  );

                  if (response.statusCode == 200) {
                    showSuccessDialog(context, "Data saved successfully");
                  } else {
                    showSuccessDialog(
                        context, "Failed to save data. ${response.body}");
                  }
                } catch (error) {
                  showSuccessDialog(
                    context,
                    'Error connecting to the server: $error',
                  );
                }
              },
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            // Display data
            Text('Type Code: ${widget.data['TypeCode']}'),
            Text('Type Name: ${widget.data['TypeName']}'),
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

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealStoreTypePage(),
                  ),
                );
              },
              child: Text('Go to Health Data Page'),
            ),
          ],
        );
      },
    );
  }
}
