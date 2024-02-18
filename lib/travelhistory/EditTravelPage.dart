import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/travelhistory/HealTravel.dart';
import 'dart:convert';

class EditTravelPage extends StatefulWidget {
  final Map<String, dynamic> data;
  EditTravelPage({required this.data});

  @override
  _EditTravelPageState createState() => _EditTravelPageState();
}

class _EditTravelPageState extends State<EditTravelPage> {
  String? dropdownLocationCode;
  List<Map<String, dynamic>> dropdownLocationItems = [];

  TextEditingController travelIDController = TextEditingController();
  TextEditingController timeStampController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLocationData();
    travelIDController.text = widget.data['TravelID'].toString();
    timeStampController.text = widget.data['TimeStamp'].toString();
    dropdownLocationCode = widget.data['LocationCode'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('แก้ไขเส้นทางเดินรถ'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: travelIDController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'ลำดับที่',
                prefixIcon: Icon(Icons.card_travel, color: Colors.black),
              ),
            ),
            TextFormField(
              controller: timeStampController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'เวลา',
                prefixIcon: Icon(Icons.access_time, color: Colors.black),
              ),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (selectedTime != null) {
                  String formattedTime = selectedTime.format(context);
                  timeStampController.text = formattedTime;
                }
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<Map<String, dynamic>>(
              value: dropdownLocationItems.isNotEmpty
                  ? dropdownLocationItems
                      .firstWhere((element) =>
                          element['PlaceCode'] == dropdownLocationCode)
                  : null,
              onChanged: null, // ตั้งค่า onChanged เป็น null เพื่อป้องกันการเปลี่ยนแปลงค่า
              items: dropdownLocationItems.map((location) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: location,
                  child: Text(location['PlaceName']),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'สถานที่',
                prefixIcon: Icon(Icons.location_on, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String updatedTravelID = travelIDController.text;
                String updatedTimeStamp = timeStampController.text;
                String updatedLocationCode = dropdownLocationCode ?? '';

                String apiUrl =
                    'http://localhost/tourlism_root_641463019/edittravel.php';

                Map<String, dynamic> requestBody = {
                  'TravelID': updatedTravelID,
                  'TimeStamp': updatedTimeStamp,
                  'LocationCode': updatedLocationCode,
                  'case': '2',
                };

                try {
                  var response = await http.post(
                    Uri.parse(apiUrl),
                    body: requestBody,
                  );

                  if (response.statusCode == 200) {
                    showSuccessDialog(context, "บันทึกข้อมูลสำเร็จ");
                  } else {
                    showSuccessDialog(
                        context, "ไม่สามารถบันทึกข้อมูลได้. ${response.body}");
                  }
                } catch (error) {
                  showSuccessDialog(
                    context,
                    'เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $error',
                  );
                }
              },
              child: Text('บันทึก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealTravelHistoryPage(),
                  ),
                );
              },
              child: Text('ยกเลิก'),
            ),
          ],
        ),
      ),
    );
  }

  void fetchLocationData() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost/tourlism_root_641463019/saveregister.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> locationData =
            data.cast<Map<String, dynamic>>();

        setState(() {
          dropdownLocationItems = locationData;
        });
      } else {
        throw Exception('Failed to fetch location data');
      }
    } catch (error) {
      print('Connection error: $error');
    }
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ผลลัพธ์'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealTravelHistoryPage(),
                  ),
                );
              },
              child: Text('ไปยังหน้าเส้นทางเดินรถ'),
            ),
          ],
        );
      },
    );
  }
}
