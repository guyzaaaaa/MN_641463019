import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/touristplaces/HealthData.dart';

class DeleteDataPage extends StatefulWidget {
  final Map<String, dynamic> data;
  DeleteDataPage({required this.data});
  @override
  _DeleteDataPageState createState() => _DeleteDataPageState();
}

class _DeleteDataPageState extends State<DeleteDataPage> {
  late TextEditingController placeCodeController;
  late TextEditingController placeNameController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    placeCodeController =
        TextEditingController(text: widget.data['PlaceCode'].toString());
    placeNameController =
        TextEditingController(text: widget.data['PlaceName'].toString());
    latitudeController =
        TextEditingController(text: widget.data['Latitude'].toString());
    longitudeController =
        TextEditingController(text: widget.data['Longitude'].toString());
    _showDeleteDialog();
  }

  void _showDeleteDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ลบสถานที่ท่องเที่ยว'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: placeCodeController,
                    decoration: InputDecoration(labelText: 'รหัสสถานที่'),
                    enabled: false,
                  ),
                  TextFormField(
                    controller: placeNameController,
                    decoration: InputDecoration(labelText: 'ชื่อสถานที่'),
                    enabled: false,
                  ),
                  TextFormField(
                    controller: latitudeController,
                    decoration: InputDecoration(labelText: 'ละติจูด'),
                    enabled: false,
                  ),
                  TextFormField(
                    controller: longitudeController,
                    decoration: InputDecoration(labelText: 'ลองติจูด'),
                    enabled: false,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  deletePlace(context);
                },
                child: Text('ลบ'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the "ชื่อโมมา" page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HealthDataPage(),
                    ),
                  );
                },
                child: Text('ยกเลิก'),
              ),
            ],
          );
        },
      );
    });
  }

  void deletePlace(BuildContext context) async {
    String placeCodeToDelete = placeCodeController.text;

    String apiUrl =
        'http://localhost/tourlism_root_641463019/deletetouristplaces.php';

    Map<String, dynamic> requestBody = {
      'PlaceCode': placeCodeToDelete,
      'case':
          '3', // Ensure this is a string if it's expected as a string on the server
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบสถานที่ท่องเที่ยวเสร็จสิ้น");
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
                    builder: (context) => HealthDataPage(),
                  ),
                );
              },
              child: Text('กลับหน้าจัดการข้อมูลสถานที่ท่องเที่ยว'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder widget
    return Container();
  }
}
