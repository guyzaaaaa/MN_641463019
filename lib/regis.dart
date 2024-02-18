import 'package:csit2023/touristplaces/HealthData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:csit2023/menu.dart';

class menu_health extends StatefulWidget {
  @override
  _menu_healthState createState() => _menu_healthState();
}

class _menu_healthState extends State<menu_health> {
  TextEditingController idCardController = TextEditingController();
  TextEditingController titleNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController heartValueController = TextEditingController();
  TextEditingController pulseValueController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void registerUser() async {
    String idCard = idCardController.text;
    String titleName = titleNameController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String dob = dobController.text;
    String heartValue = heartValueController.text;
    String pulseValue = pulseValueController.text;

    // ตรวจสอบว่าข้อมูลทั้งหมดถูกกรอกหรือไม่
    if (idCard.isEmpty ||
        titleName.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        dob.isEmpty ||
        heartValue.isEmpty ||
        pulseValue.isEmpty) {
      // แสดง AlertDialog ถ้าข้อมูลไม่ครบ
      showIncompleteDataDialog(context);
      return;
    }

    String apiUrl = 'http://localhost/health/saveregister.php';

    Map<String, dynamic> requestBody = {
      'id_card': idCard,
      'titlename': titleName,
      'firstname': firstName,
      'lastname': lastName,
      'date_of_birth': dob,
      'heart_value': heartValue,
      'pulse_value': pulseValue,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        showSuccessDialog(context);
      } else {
        print('ไม่สามารถลงทะเบียนผู้ใช้ได้');
      }
    } catch (error) {
      print('เกิดข้อผิดพลาดในการเชื่อมต่อ: $error');
    }
  }

  void showIncompleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incomplete Data'),
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด AlertDialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully'),
          content: Text('Your information has been successfully saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MainMenu(),
                ));
              },
              child: Text('Go to Login Page'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HealthDataPage(),
                ));
              },
              child: Text('View Health Data'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MainMenu(),
            ));
          },
        ),
        centerTitle: true,
        title: Text('Smart Tracker'),
        titleTextStyle: TextStyle(
          fontSize: 30,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: idCardController,
              decoration: InputDecoration(labelText: 'ID Card'),
            ),
            TextFormField(
              controller: titleNameController,
              decoration: InputDecoration(labelText: 'Title Name'),
            ),
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'Firstname'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Lastname'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(labelText: 'Date of Birth'),
                    enabled: false,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            TextFormField(
              controller: heartValueController,
              decoration: InputDecoration(labelText: 'Heart Value'),
            ),
            TextFormField(
              controller: pulseValueController,
              decoration: InputDecoration(labelText: 'Pulse Value'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('ยืนยัน'),
              style: OutlinedButton.styleFrom(
                fixedSize: Size(300, 50),
                side: BorderSide(
                  color: Color.fromARGB(255, 0, 255, 0),
                  width: 2.0,
                ),
                backgroundColor: Color.fromARGB(255, 0, 255, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
