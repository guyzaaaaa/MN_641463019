import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HealstorePage.dart'; // Ensure the correct import path


class EditStorePage extends StatefulWidget {
  final Map<String, dynamic> data;
  EditStorePage({required this.data});
  @override
  _EditStorePageState createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  late TextEditingController storeCodeController;
  late TextEditingController storeNameController;

  @override
  void initState() {
    super.initState();
    storeCodeController =
        TextEditingController(text: widget.data['StoreID'].toString());
    storeNameController =
        TextEditingController(text: widget.data['StoreName'].toString());
    // Call showDialog automatically when the page is loaded
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('แก้ไขข้อมูลร้านค้า'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: storeCodeController,
                    decoration: InputDecoration(
                      labelText: 'รหัสร้านค้า',
                      prefixIcon: Icon(Icons.store, color: Colors.black),
                    ),
                    enabled: false, // Disable editing
                  ),
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
                onPressed: () async {
                  String updatedStoreCode = storeCodeController.text;
                  String updatedStoreName = storeNameController.text;

                  String apiUrl = 'http://localhost/tourlism_root_641463019/editstore.php';

                  Map<String, dynamic> requestBody = {
                    'StoreID': updatedStoreCode,
                    'StoreName': updatedStoreName,
                    'case': '2', // Ensure this is a string if it's expected as a string on the server
                  };

                  try {
                    var response = await http.post(
                      Uri.parse(apiUrl),
                      body: requestBody,
                    );

                    if (response.statusCode == 200) {
                      showSuccessDialog(context, "บันทึกข้อมูลเรียบร้อยแล้ว");
                    } else {
                      showSuccessDialog(
                          context, "เกิดข้อผิดพลาดในการบันทึกข้อมูล: ${response.body}");
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HealstorePage(),
                    ),
                  );
                },
                child: Text('ยกเลิก'), // Add the button for "ชื่อทามา"
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    storeCodeController.dispose();
    storeNameController.dispose();
    super.dispose();
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('สำเร็จ'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealstorePage(),
                  ),
                );
              },
              child: Text('ไปที่หน้าร้านค้า'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return an empty container because the dialog is already shown in initState
    return Container();
  }
}
