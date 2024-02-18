import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/store/HealstorePage.dart';

class DeleteStorePage extends StatelessWidget {
  final Map<String, dynamic> data;
  DeleteStorePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ลบร้านค้า'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display data
            Text('รหัสร้านค้า: ${data['StoreID']}'),
            Text('ชื่อร้านค้า: ${data['StoreName']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                deleteStore(context); // Call deleteStore directly
              },
              child: Text('ลบ'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HealstorePage(),
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

  void deleteStore(BuildContext context) async {
    String deletedStoreCode = data['StoreID'].toString();

    String apiUrl = 'http://localhost/tourlism_root_641463019/deletestore.php';

    Map<String, dynamic> requestBody = {
      'StoreID': deletedStoreCode,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(
            context, "ล้มเหลวในการลบข้อมูล. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(
        context,
        'เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $error',
      );
    }
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
                Navigator.of(context).pop(); // Close the success dialog
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
}
