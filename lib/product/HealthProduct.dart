import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csit2023/product/EditProductPage.dart';
import 'package:csit2023/product/DeleteProductPage.dart';
import 'package:csit2023/product/ShowProductPage.dart';
import 'package:csit2023/product/product.dart';
import 'package:csit2023/menu.dart';

class HealthProductPage extends StatefulWidget {
  @override
  _HealthProductPageState createState() => _HealthProductPageState();
}

class _HealthProductPageState extends State<HealthProductPage> {
  late Future<List<Map<String, dynamic>>> _productData;
  Map<String, String> _storeNames = {};

  Future<List<Map<String, dynamic>>> _fetchProductData() async {
    final response = await http.get(Uri.parse('http://localhost/tourlism_root_641463019/saveproduct.php'));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  Future<void> _fetchStoreName(String storeID) async {
    final response = await http.get(Uri.parse('http://localhost/tourlism_root_641463019/savestore.php'));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      final Map<String, dynamic>? store = parsed.firstWhere((element) => element['StoreID'] == storeID, orElse: () => null);
      if (store != null) {
        setState(() {
          _storeNames[storeID] = store['StoreName'];
        });
      }
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้ กรุณาตรวจสอบ');
    }
  }

  @override
  void initState() {
    super.initState();
    _productData = _fetchProductData();
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
                builder: (context) => MainMenu(),
              ),
            );
          },
        ),
        title: Text(
          'จัดการข้อมูลสินค้า',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _productData,
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
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2), // Add border to the Container
                  ),
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: Text('ชื่อสินค้า')),
                      DataColumn(label: Text('รหัสสินค้า')),
                      DataColumn(label: Text('ราคา')),
                      DataColumn(label: Text('ร้านค้า')),
                      DataColumn(label: Text('แก้ไข')),
                      DataColumn(label: Text('ลบ')),
                      DataColumn(label: Text('ดูข้อมูล')),
                    ],
                    rows: snapshot.data!.map((data) {
                      final storeID = data['StoreID'].toString();
                      _fetchStoreName(storeID);
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(data['ProductName'].toString())),
                          DataCell(Text(data['ProductID'].toString())),
                          DataCell(Text(data['SellingPrice'].toString())),
                          DataCell(Text(_storeNames[storeID] ?? 'Loading...')),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditProductModal(data: data),
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
                                    builder: (context) => DeleteProductPage(data: data),
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
                                    builder: (context) => ShowProductPage(data: data),
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
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RegisterproductForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen.shade400,
      ),
    );
  }
}
