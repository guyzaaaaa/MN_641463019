import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/storetype/ShowStoreTypePage.dart';
import 'HealStoreTypePage.dart';

class RegisterStoreTypeForm extends StatefulWidget {
  @override
  _RegisterStoreTypeFormState createState() => _RegisterStoreTypeFormState();
}

class _RegisterStoreTypeFormState extends State<RegisterStoreTypeForm> {
  TextEditingController typeCodeController = TextEditingController();
  TextEditingController typeNameController = TextEditingController();

  void registerStoreType() async {
    String typeCode = typeCodeController.text;
    String typeName = typeNameController.text;

    if (typeCode.isEmpty || typeName.isEmpty) {
      print('Please fill in all fields');
      return;
    }

    String apiUrl = 'http://localhost/tourlism_root_641463019/savestoretype.php';

    Map<String, dynamic> requestBody = {
      'TypeCode': typeCode,
      'TypeName': typeName,
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
            builder: (context) => HealStoreTypePage(),
          ),
        );
      } else {
        print('Failed to register store type');
      }
    } catch (error) {
      print('Connection error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Store Type Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title for the form
            Text(
              'ลงทะเบียนประเภทร้านค้า',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20.0),

            TextFormField(
              controller: typeCodeController,
              decoration: InputDecoration(
                labelText: 'รหัสประเภทร้านค้า',
                prefixIcon: Icon(Icons.store, color: Colors.black),
              ),
            ),
            TextFormField(
              controller: typeNameController,
              decoration: InputDecoration(
                labelText: 'ชื่อประเภทร้านค้า',
                prefixIcon: Icon(Icons.store_mall_directory, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: registerStoreType,
              child: Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('บันทึกสำเร็จ'),
          content: Text('ข้อมูลประเภทร้านค้าถูกบันทึกเรียบร้อยแล้ว'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => ShowStoreTypePage(),
                //   ),
                // );
              },
              child: Text('ไปที่หน้าแสดงประเภทร้านค้า'),
            ),
          ],
        );
      },
    );
  }
}
