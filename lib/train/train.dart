import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/storetype/ShowStoreTypePage.dart';
import '../storetype/HealStoreTypePage.dart';
import 'package:csit2023/train/HealTrain.dart';


class RegisterTrainForm extends StatefulWidget {
  @override
  _RegisterTrainTypeFormState createState() => _RegisterTrainTypeFormState();
}

class _RegisterTrainTypeFormState extends State<RegisterTrainForm> {
  TextEditingController trainNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showRegisterTrainDialog();
  }

  void _showRegisterTrainDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ลงทะเบียนข้อมูลรถราง'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title for the form
                  Text(
                    'ลงทะเบียนข้อมูลรถราง',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20.0),

                  TextFormField(
                    controller: trainNumberController,
                    decoration: InputDecoration(
                      labelText: 'หมายเลขรถ',
                      prefixIcon: Icon(Icons.store_mall_directory, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  registerStoreType();
                },
                child: Text('บันทึก'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the "TathaPage" page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HealTrainPage(),
                    ),
                  );
                },
                child: Text('ยกเลิก'), // Add the button for "ชื่อทาทา"
              ),
            ],
          );
        },
      );
    });
  }

  void registerStoreType() async {
    String trainNumber = trainNumberController.text;

    if (trainNumber.isEmpty) {
      print('Please fill in all fields');
      return;
    }

    String apiUrl = 'http://localhost/tourlism_root_641463019/savetrain.php';

    Map<String, dynamic> requestBody = {
      'train_number': trainNumber,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        showSuccessDialog(context);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HealTrainPage(),
          ),
        );
      } else {
        print('Failed to register store type');
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
          content: Text('ข้อมูลรถรางถูกบันทึกเรียบร้อยแล้ว'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealTrainPage(),
                  ),
                );
              },
              child: Text('ไปที่หน้าแสดงข้อมูลรถราง'),
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
