import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HealTrain.dart'; // Import the page to navigate after successful deletion

class DeleteTrainPage extends StatefulWidget {
  final Map<String, dynamic> data;
  DeleteTrainPage({required this.data});
  @override
  _DeleteTrainPageState createState() => _DeleteTrainPageState();
}

class _DeleteTrainPageState extends State<DeleteTrainPage> {
  @override
  void initState() {
    super.initState();
    _showDeleteTrainDialog();
  }

  void _showDeleteTrainDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ลบข้อมูลรถราง'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Display data
                  Text('รหัส: ${widget.data['train_id']}'),
                  Text('หมายเลขรถ: ${widget.data['train_number']}'),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  deleteTrain(context);
                },
                child: Text('ลบ'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HealTrainPage(),
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

  void deleteTrain(BuildContext context) async {
    String deletedTrainId = widget.data['train_id'].toString();

    String apiUrl = 'http://localhost/tourlism_root_641463019/deletetrain.php';

    Map<String, dynamic> requestBody = {
      'train_id': deletedTrainId,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(context, "ล้มเหลวในการลบข้อมูล. ${response.body}");
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
          title: Text('ผลลัพธ์'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealTrainPage(),
                  ),
                );
              },
              child: Text('ไปที่หน้ารายการรถราง'),
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
