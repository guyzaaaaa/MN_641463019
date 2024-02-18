import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/login_screen.dart';
import 'package:csit2023/touristplaces/HealthData.dart';

class RegisterPlaceForm extends StatefulWidget {
  @override
  _RegisterPlaceFormState createState() => _RegisterPlaceFormState();
}

class _RegisterPlaceFormState extends State<RegisterPlaceForm> {
  TextEditingController placeNameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showRegisterPlaceDialog();
    });
  }

  void _showRegisterPlaceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ลงทะเบียนข้อมูลสถานที่ท่องเที่ยว'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                    prefixIcon: Icon(Icons.map, color: Colors.black),
                  ),
                ),
                TextFormField(
                  controller: longitudeController,
                  decoration: InputDecoration(
                    labelText: 'ลองจิจูด',
                    prefixIcon: Icon(Icons.map, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                registerPlace(context);
              },
              child: Text('บันทึก'),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform action when "ชื่อสวัสดี" button is pressed
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
  }

  void registerPlace(BuildContext context) async {
    String placeName = placeNameController.text;
    String latitude = latitudeController.text;
    String longitude = longitudeController.text;

    // URL of the API to be called (saveregister.php)
    String apiUrl = 'http://localhost/tourlism_root_641463019/saveregister.php';

    // Create the request body to send data
    Map<String, dynamic> requestBody = {
      'PlaceName': placeName,
      'Latitude': latitude,
      'Longitude': longitude,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        // Action to take when the request is successful
        showSuccessDialog(context);
      } else {
        // Action to take when the request fails
        print('Failed to register place');
      }
    } catch (error) {
      // Action to take when there is a connection error
      print('Connection error: $error');
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('บันทึกสำเร็จ'),
          content: Text('ข้อมูลสถานที่ท่องเที่ยวถูกบันทึกเรียบร้อยแล้ว'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Perform navigation to the desired page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealthDataPage(),
                  ),
                );
              },
              child: Text('ไปที่หน้าข้อมูลสถานที่ท่องเที่ยว'),
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
