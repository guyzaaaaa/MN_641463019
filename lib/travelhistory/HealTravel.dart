import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csit2023/travelhistory/EditTravelPage.dart';
import 'package:csit2023/travelhistory/DeleteTravelPage.dart';
import 'package:csit2023/travelhistory/ShowTravelPage.dart';
import 'package:csit2023/travelhistory/travelhistory.dart';
import 'package:csit2023/menu.dart';

class HealTravelHistoryPage extends StatefulWidget {
  @override
  _HealTravelHistoryPageState createState() => _HealTravelHistoryPageState();
}

class _HealTravelHistoryPageState extends State<HealTravelHistoryPage> {
  late Future<List<Map<String, dynamic>>> _travelHistoryData;
  late Map<String, String> _placeNames = {};

  Future<List<Map<String, dynamic>>> _fetchTravelHistoryData() async {
    final response = await http.get(Uri.parse('http://localhost/tourlism_root_641463019/savehealtravel.php'));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  Future<void> _fetchTouristPlacesData() async {
    final response = await http.get(Uri.parse('http://localhost/tourlism_root_641463019/saveregister.php'));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      for (var place in parsed) {
        _placeNames[place['PlaceCode']] = place['PlaceName'];
      }
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  @override
  void initState() {
    super.initState();
    _travelHistoryData = _fetchTravelHistoryData();
    _fetchTouristPlacesData(); // ดึงข้อมูล touristplaces เมื่อหน้าโหลด
  }

  // ฟังก์ชันสำหรับรับชื่อสถานที่จาก PlaceCode
  String? _getPlaceName(String locationCode) {
    return _placeNames[locationCode];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade400,
        leading: IconButton(
          icon: Icon(Icons.home_outlined),
          color: Colors.red,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainMenu(), // Go to MainMenu page
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'จัดการข้อมูลเส้นทางเดินรถ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _travelHistoryData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen.shade400,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('ไม่พบข้อมูล');
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DataTable(
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      columns: <DataColumn>[
                        DataColumn(label: Text(' ')),
                        DataColumn(label: Text('ลำดับที่')),
                        DataColumn(label: Text('เวลา')),
                        DataColumn(label: Text('รหัสสถานที่')),
                        DataColumn(label: Text('สถานที่')),
                        DataColumn(label: Text('แก้ไข')),
                        DataColumn(label: Text('ลบ')),
                        DataColumn(label: Text('ดูข้อมูล')),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(' ')),
                            DataCell(Text(data['TravelID'].toString())),
                            DataCell(Text(data['TimeStamp'].toString())),
                            DataCell(Text(data['LocationCode'].toString())),
                            DataCell(Text(_getPlaceName(data['LocationCode'].toString()) ?? '')), // แสดงชื่อสถานที่
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditTravelPage(data: data),
                                    ),
                                  );
                                },
                                color: Colors.blue, // เปลี่ยนสีไอคอนเป็นสีฟ้า
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DeleteTravelPage(data: data),
                                    ),
                                  );
                                },
                                color: Colors.red, // เปลี่ยนสีไอคอนเป็นสีแดง
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ShowTravelPage(data: data),
                                    ),
                                  );
                                },
                                color: Colors.green, // เปลี่ยนสีไอคอนเป็นสีเขียว
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RegisterTravelHistoryForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen.shade400,
      ),
    );
  }
}
