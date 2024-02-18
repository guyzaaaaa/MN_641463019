import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/touristplaces/HealthData.dart';

class EditDataPage extends StatefulWidget {
  final Map<String, dynamic> data;
  EditDataPage({required this.data});
  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  late TextEditingController placeCodeController;
  late TextEditingController placeNameController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    placeCodeController = TextEditingController(text: widget.data['PlaceCode'].toString());
    placeNameController = TextEditingController(text: widget.data['PlaceName'].toString());
    latitudeController = TextEditingController(text: widget.data['Latitude'].toString());
    longitudeController = TextEditingController(text: widget.data['Longitude'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('เเก้ไขสถานที่ท่องเที่ยว'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: placeCodeController,
              decoration: InputDecoration(
                labelText: 'รหัสสถานที่',
                prefixIcon: Icon(Icons.code, color: Colors.black),
              ),
            ),
            TextFormField(
              controller: placeNameController,
              decoration: InputDecoration(
                labelText: 'ชื่อสถานที่',
                prefixIcon: Icon(Icons.place, color: Colors.black),
              ),
            ),
            TextFormField(
              controller: latitudeController,
              decoration: InputDecoration(
                labelText: 'ละติจูด',
                prefixIcon: Icon(Icons.location_on, color: Colors.black),
              ),
            ),
            TextFormField(
              controller: longitudeController,
              decoration: InputDecoration(
                labelText: 'ลองติจูด',
                prefixIcon: Icon(Icons.location_on, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String updatedPlaceCode = placeCodeController.text;
                    String updatedPlaceName = placeNameController.text;
                    String updatedLatitude = latitudeController.text;
                    String updatedLongitude = longitudeController.text;

                    String apiUrl = 'http://localhost/tourlism_root_641463019/edittouristplaces.php';

                    Map<String, dynamic> requestBody = {
                      'PlaceCode': updatedPlaceCode,
                      'PlaceName': updatedPlaceName,
                      'Latitude': updatedLatitude,
                      'Longitude': updatedLongitude,
                      'case': '2', // Ensure this is a string if it's expected as a string on the server
                    };

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: requestBody,
                      );

                      if (response.statusCode == 200) {
                        showSuccessDialog(context, "เเก้ไขข้อมูลเสร็จสิ้น");
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
                  child: Text('บันทึก'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the current dialog
                    Navigator.of(context).pushReplacement( // Navigate to the HealthDataPage
                      MaterialPageRoute(
                        builder: (context) => HealthDataPage(),
                      ),
                    );
                  },
                  child: Text('ยกเลิก'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    placeCodeController.dispose();
    placeNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
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
                Navigator.of(context).pop(); // Close success dialog
                Navigator.of(context).pop(); // Close edit data dialog
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
}
