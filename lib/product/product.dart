import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/login_screen.dart';
import 'package:csit2023/product/HealthProduct.dart';

class RegisterproductForm extends StatefulWidget {
  @override
  _RegisterproductFormState createState() => _RegisterproductFormState();
}

class _RegisterproductFormState extends State<RegisterproductForm> {
  String? dropdownStoreID;
  List<Map<String, dynamic>> dropdownStoreItems = [];

  TextEditingController productNameController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStoreNames();
  }

  void fetchStoreNames() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost/tourlism_root_641463019/savestore.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> storeNames =
            data.map((store) => {
                  'StoreID': store['StoreID'].toString(),
                  'StoreName': store['StoreName'].toString(),
                }).toList();
        setState(() {
          dropdownStoreItems = storeNames;
        });
        _showRegisterProductModal(context); // เรียกเมื่อข้อมูลร้านค้าถูกดึงมาแล้ว
      } else {
        throw Exception('Failed to fetch store names');
      }
    } catch (error) {
      print('Connection error: $error');
    }
  }

  void registerProduct() async {
    String storeID = dropdownStoreID ?? '';
    String productName = productNameController.text;
    String unit = unitController.text;
    String sellingPrice = sellingPriceController.text;

    String apiUrl = 'http://localhost/tourlism_root_641463019/saveproduct.php';

    Map<String, dynamic> requestBody = {
      'StoreID': storeID,
      'ProductName': productName,
      'Unit': unit,
      'SellingPrice': sellingPrice,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        showSuccessDialog(context);
      } else {
        print('Failed to register product');
      }
    } catch (error) {
      print('Connection error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(); // ไม่ต้องมีการสร้าง Widget บนหน้าจอ
  }

  void _showRegisterProductModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ลงทะเบียนข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<Map<String, dynamic>>(
                  value: dropdownStoreItems.isNotEmpty ? dropdownStoreItems[0] : null,
                  decoration: InputDecoration(
                    labelText: 'ร้านค้า',
                    prefixIcon: Icon(Icons.store, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: dropdownStoreItems.map((store) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: store,
                      child: Text(store['StoreName']),
                    );
                  }).toList(),
                  onChanged: (Map<String, dynamic>? newValue) {
                    setState(() {
                      dropdownStoreID = newValue!['StoreID'].toString();
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อสินค้า',
                    prefixIcon: Icon(Icons.shopping_bag, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: unitController,
                  decoration: InputDecoration(
                    labelText: 'หน่วยนับ',
                    prefixIcon: Icon(Icons.add_box, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: sellingPriceController,
                  decoration: InputDecoration(
                    labelText: 'ราคาขาย',
                    prefixIcon: Icon(Icons.attach_money, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    registerProduct();
                  },
                  child: Text('บันทึก'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HealthProductPage(),
                    ));
                  },
                  child: Text('ยกเลิก'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('บันทึกสำเร็จ'),
          content: Text('ข้อมูลสินค้าถูกบันทึกเรียบร้อยแล้ว'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HealthProductPage(),
                ));
              },
              child: Text('ไปที่หน้าข้อมูลสินค้า'),
            ),
          ],
        );
      },
    );
  }
}
