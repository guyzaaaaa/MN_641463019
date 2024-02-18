import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ShowStorePage.dart';
import 'HealstorePage.dart';

class RegisterStoreForm extends StatefulWidget {
  @override
  _RegisterStoreFormState createState() => _RegisterStoreFormState();
}

class _RegisterStoreFormState extends State<RegisterStoreForm> {
  TextEditingController storeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showRegisterStoreDialog();
  }

  void _showRegisterStoreDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ลงทะเบียนข้อมูลชื่อร้านค้า'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: storeNameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อร้านค้า',
                      prefixIcon: Icon(Icons.store_mall_directory, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  registerStore();
                },
                child: Text('บันทึก'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HealstorePage(),
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

  void registerStore() async {
    String storeName = storeNameController.text;

    if (storeName.isEmpty) {
      print('Please fill in all fields');
      return;
    }

    String apiUrl = 'http://localhost/tourlism_root_641463019/savestore.php';

    Map<String, dynamic> requestBody = {
      'StoreName': storeName,
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
            builder: (context) => HealstorePage(),
          ),
        );
      } else {
        print('Failed to register store');
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
          content: Text('ข้อมูลร้านค้าถูกบันทึกเรียบร้อยแล้ว'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealstorePage(),
                  ),
                );
              },
              child: Text('ไปที่หน้าลงทะเบียนประวัติการเดินทาง'),
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
