import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../store/HealstorePage.dart'; // ให้แก้ชื่อไฟล์ตามที่เหมาะสม
import 'HealTravel.dart';

class RegisterTravelHistoryForm extends StatefulWidget {
  @override
  _RegisterTravelHistoryFormState createState() =>
      _RegisterTravelHistoryFormState();
}

class _RegisterTravelHistoryFormState extends State<RegisterTravelHistoryForm> {
  String? dropdownLocationCode;
  List<Map<String, dynamic>> dropdownLocationItems = []; // รายการสำหรับ dropdown

  TextEditingController timeStampController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLocationData(); // เรียกใช้ฟังก์ชันเมื่อ StatefulWidget ถูกสร้างขึ้น
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ลงทะเบียนตารางการเดินรถ'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title for the form
                    Text(
                      'ลงทะเบียนตารางการเดินรถ',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 20.0),

                    TextFormField(
                      controller: timeStampController,
                      decoration: InputDecoration(
                        labelText: 'เวลาที่บันทึก',
                        prefixIcon:
                            Icon(Icons.access_time, color: Colors.black),
                      ),
                      onTap: () => _selectTime(context),
                    ),
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: dropdownLocationItems.isNotEmpty
                          ? dropdownLocationItems[0]
                          : null,
                      decoration: InputDecoration(
                        labelText: 'สถานที่',
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.black),
                      ),
                      items: dropdownLocationItems.map((location) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: location,
                          child: Text(location['PlaceName']),
                        );
                      }).toList(),
                      onChanged: (Map<String, dynamic>? newValue) {
                        setState(() {
                          dropdownLocationCode =
                              newValue!['PlaceCode'].toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    registerTravelHistory();
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
            );
          },
        );
      },
      child: Text('ลงทะเบียนตารางการเดินรถ'),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        timeStampController.text = selectedTime.format(context);
      });
    }
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

  void registerTravelHistory() async {
    String timeStamp = timeStampController.text;
    String locationCode = dropdownLocationCode ?? '';

    if (timeStamp.isEmpty || locationCode.isEmpty) {
      print('Please fill in all fields');
      return;
    }

    String apiUrl =
        'http://localhost/tourlism_root_641463019/savehealtravel.php';

    Map<String, dynamic> requestBody = {
      'TimeStamp': timeStamp,
      'LocationCode': locationCode,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HealTravelHistoryPage(),
          ),
        );
      } else {
        print('Failed to register travel history');
      }
    } catch (error) {
      print('Connection error: $error');
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('บันทึกสำเร็จ'),
          content: Text('ข้อมูลตารางการเดินรถถูกบันทึกเรียบร้อยแล้ว'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }
}
