import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HealStoreTypePage.dart';

class DeleteStoreTypePage extends StatefulWidget {
  final Map<String, dynamic> data;
  DeleteStoreTypePage({required this.data});
  @override
  _DeleteStoreTypePageState createState() => _DeleteStoreTypePageState();
}

class _DeleteStoreTypePageState extends State<DeleteStoreTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Store Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display data
            Text('Type Code: ${widget.data['TypeCode']}'),
            Text('Type Name: ${widget.data['TypeName']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String deletedTypeCode = widget.data['TypeCode'].toString();

                String apiUrl = 'http://localhost/tourlism_root_641463019/deletestoretype.php';

                Map<String, dynamic> requestBody = {
                  'TypeCode': deletedTypeCode,
                };

                try {
                  var response = await http.post(
                    Uri.parse(apiUrl),
                    body: requestBody,
                  );

                  if (response.statusCode == 200) {
                    showSuccessDialog(context, "Data deleted successfully");
                  } else {
                    showSuccessDialog(
                        context, "Failed to delete data. ${response.body}");
                  }
                } catch (error) {
                  showSuccessDialog(
                    context,
                    'Error connecting to the server: $error',
                  );
                }
              },
              child: Text('Delete'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
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
              child: Text('Go to Heal Store Page'),
            ),
          ],
        );
      },
    );
  }
}
