import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csit2023/train/EditTrainPage.dart';
import 'package:csit2023/train/DeleteTrainPage.dart';
import 'package:csit2023/train/ShowTrainPage.dart';
import 'package:csit2023/train/train.dart';
import 'package:csit2023/menu.dart';

class HealTrainPage extends StatefulWidget {
  @override
  _HealTrainPageState createState() => _HealTrainPageState();
}

class _HealTrainPageState extends State<HealTrainPage> {
  late Future<List<Map<String, dynamic>>> _trainData;

  Future<List<Map<String, dynamic>>> _fetchTrainData() async {
    final response = await http.get(
        Uri.parse('http://localhost/tourlism_root_641463019/savetrain.php'));
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
    _trainData = _fetchTrainData();
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
                builder: (context) => MainMenu(), // ไปที่หน้า MainMenu
              ),
            );
          },
        ),
        title: Text(
          'จัดการข้อมูลรถราง',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _trainData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('ไม่พบข้อมูล');
              } else {
                return SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color.fromARGB(255, 12, 5, 5),
                        width: 3,
                      ),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: DataTable(
                      columnSpacing: 12,
                      dataRowHeight: 60, // ปรับความสูงของแต่ละแถว
                      columns: <DataColumn>[
                        DataColumn(label: Text('รหัส', style: TextStyle(fontSize: 14))),
                        DataColumn(label: Text('หมายเลขรถ', style: TextStyle(fontSize: 14))),
                        DataColumn(label: Text('แก้ไข', style: TextStyle(fontSize: 14))),
                        DataColumn(label: Text('ลบ', style: TextStyle(fontSize: 14))),
                        DataColumn(label: Text('แสดงข้อมูล', style: TextStyle(fontSize: 14))),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(data['train_id'].toString(), style: TextStyle(fontSize: 14))),
                            DataCell(Text(data['train_number'].toString(), style: TextStyle(fontSize: 14))),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTrainPage(data: data),
                                    ),
                                  );
                                },
                                color: Colors.blue,
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeleteTrainPage(data: data),
                                    ),
                                  );
                                },
                                color: Colors.red,
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.visibility, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowTrainPage(data: data),
                                    ),
                                  );
                                },
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterTrainForm()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen.shade400,
      ),
    );
  }
}
