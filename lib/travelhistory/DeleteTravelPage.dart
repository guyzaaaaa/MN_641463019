import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HealTravel.dart'; // Import HealTravelHistoryPage

class DeleteTravelPage extends StatefulWidget {
  final Map<String, dynamic> data;
  DeleteTravelPage({required this.data});
  @override
  _DeleteTravelPageState createState() => _DeleteTravelPageState();
}

class _DeleteTravelPageState extends State<DeleteTravelPage> {
  late String deletedTravelID;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _showDeleteDialog();
  }

  void _showDeleteDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ลบเส้นทางเดินรถ'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ลำดับที่: ${widget.data['TravelID']}'),
                Text('เวลา: ${widget.data['TimeStamp']}'),
                Text('รหัสสถานที่: ${widget.data['LocationCode']}'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  deletedTravelID = widget.data['TravelID'].toString();
                  await deleteTravel();
                },
                child: Text('ลบ'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HealTravelHistoryPage(), // Navigate to HealTravelHistoryPage
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

  Future<void> deleteTravel() async {
    String apiUrl = 'http://localhost/tourlism_root_641463019/deletetravel.php'; // ปรับเปลี่ยน URL ตามที่เหมาะสม

    Map<String, dynamic> requestBody = {
      'TravelID': deletedTravelID,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบเส้นทางเดินรถเสร็จสิ้น");
      } else {
        showSuccessDialog(
            context, "Failed to delete data. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(
        context,
        'Error connecting to the server: $error',
      );
    }
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealTravelHistoryPage(), // Navigate to HealTravelHistoryPage
                  ),
                );
              },
              child: Text('ไปที่หน้าจัดการเส้นทางการเดินรถ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder widget
    return Scaffold(
      key: _scaffoldKey,
      body: Container(),
    );
  }
}
