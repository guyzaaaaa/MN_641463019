import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csit2023/store/EditStorePage.dart';
import 'package:csit2023/store/DeleteStorePage.dart';
import 'package:csit2023/store/ShowStorePage.dart';
import 'package:csit2023/store/ืnamestore.dart';
import 'package:csit2023/menu.dart';

class HealstorePage extends StatefulWidget {
  @override
  _HealstorePageState createState() => _HealstorePageState();
}

class _HealstorePageState extends State<HealstorePage> {
  late Future<List<Map<String, dynamic>>> _storeData;

  Future<List<Map<String, dynamic>>> _fetchStoreData() async {
    final response = await http.get(Uri.parse('http://localhost/tourlism_root_641463019/savestore.php'));
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
    _storeData = _fetchStoreData();
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
                builder: (context) => MainMenu(), // ไปที่หน้า MainMenu
              ),
            );
          },
        ),
        title: Text(
          'จัดการข้อมูลร้านค้า',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _storeData,
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
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black, // Change the border color here
                        width: 3, // Change the border width here
                      ),
                    ),
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(label: Text('รหัสร้านค้า')),
                        DataColumn(label: Text('ชื่อร้านค้า')),
                        DataColumn(label: Text('แก้ไข')),
                        DataColumn(label: Text('ลบ')),
                        DataColumn(label: Text('ดูข้อมูล')),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(cells: <DataCell>[
                          DataCell(Text(data['StoreID'].toString())),
                          DataCell(Text(data['StoreName'].toString())),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditStorePage(data: data),
                                  ),
                                );
                              },
                              color: Colors.blue, // ตั้งสีไอคอน
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DeleteStorePage(data: data),
                                  ),
                                );
                              },
                              color: Colors.red, // ตั้งสีไอคอน
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ShowStorePage(data: data),
                                  ),
                                );
                              },
                              color: Colors.green, // ตั้งสีไอคอน
                            ),
                          ),
                        ]);
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
              builder: (context) => RegisterStoreForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen.shade400,
      ),
    );
  }
}
