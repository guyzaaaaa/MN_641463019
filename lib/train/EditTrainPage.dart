import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HealTrain.dart';

class EditTrainPage extends StatefulWidget {
  final Map<String, dynamic> data;
  EditTrainPage({required this.data});
  @override
  _EditTrainPageState createState() => _EditTrainPageState();
}

class _EditTrainPageState extends State<EditTrainPage> {
  late TextEditingController trainIdController;
  late TextEditingController trainNumberController;

  @override
  void initState() {
    super.initState();
    trainIdController = TextEditingController(text: widget.data['train_id'].toString());
    trainNumberController = TextEditingController(text: widget.data['train_number'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: FractionallySizedBox(
        widthFactor: 0.2,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: trainIdController,
              decoration: InputDecoration(
                labelText: 'รหัส',
                prefixIcon: Icon(Icons.train, color: Colors.black),
              ),
            ),
            TextFormField(
              controller: trainNumberController,
              decoration: InputDecoration(
                labelText: 'หมายเลขรถ',
                prefixIcon: Icon(Icons.confirmation_number, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String updatedTrainId = trainIdController.text;
                    String updatedTrainNumber = trainNumberController.text;

                    String apiUrl = 'http://localhost/tourlism_root_641463019/edittrain.php';

                    Map<String, dynamic> requestBody = {
                      'train_id': updatedTrainId,
                      'train_number': updatedTrainNumber,
                      'case': '2',
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
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('ยกเลิก'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('รหัส: ${widget.data['train_id']}'),
            Text('หมายเลขรถ: ${widget.data['train_number']}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    trainIdController.dispose();
    trainNumberController.dispose();
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
}
