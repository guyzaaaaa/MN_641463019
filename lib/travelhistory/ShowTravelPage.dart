import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csit2023/travelhistory/HealTravel.dart';

class ShowTravelPage extends StatefulWidget {
  final Map<String, dynamic> data;
  ShowTravelPage({required this.data});
  @override
  _ShowTravelPageState createState() => _ShowTravelPageState();
}

class _ShowTravelPageState extends State<ShowTravelPage> {
  late TextEditingController travelIDController;
  late TextEditingController timeStampController;
  late TextEditingController locationCodeController;
  String? placeName;

  @override
  void initState() {
    super.initState();
    travelIDController =
        TextEditingController(text: widget.data['TravelID'].toString());
    timeStampController =
        TextEditingController(text: widget.data['TimeStamp'].toString());
    locationCodeController =
        TextEditingController(text: widget.data['LocationCode'].toString());

    // Fetch place name data when the page is initialized
    _fetchPlaceName();
  }

  Future<void> _fetchPlaceName() async {
    final String locationCode = widget.data['LocationCode'].toString();
    final response = await http.get(
        Uri.parse('http://localhost/tourlism_root_641463019/saveregister.php'));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      final Map<String, dynamic>? place = parsed.firstWhere(
          (element) => element['PlaceCode'] == locationCode,
          orElse: () => null);
      if (place != null) {
        setState(() {
          placeName = place['PlaceName'];
        });
      }
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ข้อมูลเส้นทางเดินรถ'),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: travelIDController,
              decoration: InputDecoration(labelText: 'ลำดับที่'),
              enabled: false,
            ),
            TextFormField(
              controller: timeStampController,
              decoration: InputDecoration(labelText: 'เวลา'),
              enabled: false,
            ),
            TextFormField(
              controller: locationCodeController,
              decoration: InputDecoration(labelText: 'รหัสสถานที่'),
              enabled: false,
            ),
            if (placeName != null) SizedBox(height: 20),
            if (placeName != null)
              Text(
                'สถานที่: $placeName',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่าง modal
              },
              child: Text('ปิด'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    travelIDController.dispose();
    timeStampController.dispose();
    locationCodeController.dispose();
    super.dispose();
  }
}
