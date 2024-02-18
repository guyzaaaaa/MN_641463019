import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csit2023/touristplaces/EditDataPage.dart';
import 'package:csit2023/touristplaces/DeleteDataPage.dart';
import 'package:csit2023/touristplaces/ShowDataPage.dart';
import 'package:csit2023/touristplaces/register.dart'; // Import the RegisterPlaceForm page
import 'package:csit2023/menu.dart';

class HealthDataPage extends StatefulWidget {
  @override
  _HealthDataPageState createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  late Future<List<Map<String, dynamic>>> _touristPlaces;

  Future<List<Map<String, dynamic>>> _fetchTouristPlaces() async {
    final response = await http.get(Uri.parse('http://localhost/tourlism_root_641463019/saveregister.php'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  @override
  void initState() {
    super.initState();
    _touristPlaces = _fetchTouristPlaces();
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
            Navigator.of(context).pushReplacement(
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
              'จัดการข้อมูลสถานที่ท่องเที่ยว',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add an icon related to tourism
            Icon(
              Icons.tour,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _touristPlaces,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('ไม่พบข้อมูล');
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5), // Reduce padding to make the table smaller
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1), // Reduce border width
                        ),
                        child: DataTable(
                          columnSpacing: 3, // Reduce column spacing
                          headingTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 12, // Reduce font size
                          ),
                          dataTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 10, // Reduce font size
                          ),
                          columns: <DataColumn>[
                            DataColumn(
                              label: SizedBox(
                                width: 40, // Set fixed width for column
                                child: Text('รหัส'), // Display short label
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 120, // Set fixed width for column
                                child: Text('ชื่อ'), // Display short label
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 60, // Set fixed width for column
                                child: Text('แก้ไข'), // Display short label
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 40, // Set fixed width for column
                                child: Text('ลบ'), // Display short label
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 70, // Set fixed width for column
                                child: Text('ดูข้อมูล'), // Display short label
                              ),
                            ),
                          ],
                          rows: snapshot.data!.map((data) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(data['PlaceCode'].toString())),
                                DataCell(Text(data['PlaceName'].toString())),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => EditDataPage(data: data),
                                        ),
                                      );
                                    },
                                    color: Colors.blue, // Set icon color
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DeleteDataPage(data: data),
                                        ),
                                      );
                                    },
                                    color: Colors.red, // Set icon color
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ShowDataPage(data: data),
                                        ),
                                      );
                                    },
                                    color: Colors.green, // Set icon color
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RegisterPlaceForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen.shade400,
      ),
    );
  }
}
