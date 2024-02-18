import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/product/HealthProduct.dart';

class EditProductModal extends StatefulWidget {
  final Map<String, dynamic> data;

  EditProductModal({required this.data});

  @override
  _EditProductModalState createState() => _EditProductModalState();
}

class _EditProductModalState extends State<EditProductModal> {
  late TextEditingController storeIdController;
  late TextEditingController productIdController;
  late TextEditingController productNameController;
  late TextEditingController unitController;
  late TextEditingController sellingPriceController;

  @override
  void initState() {
    super.initState();
    storeIdController =
        TextEditingController(text: widget.data['StoreID'].toString());
    productIdController =
        TextEditingController(text: widget.data['ProductID'].toString());
    productNameController =
        TextEditingController(text: widget.data['ProductName'].toString());
    unitController =
        TextEditingController(text: widget.data['Unit'].toString());
    sellingPriceController =
        TextEditingController(text: widget.data['SellingPrice'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('แก้ไขข้อมูลสินค้า'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: storeIdController,
              enabled: false, // Disable editing
              decoration: InputDecoration(labelText: 'รหัสร้านค้า'),
            ),
            TextFormField(
              controller: productIdController,
              enabled: false, // Disable editing
              decoration: InputDecoration(labelText: 'รหัสสินค้า'),
            ),
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
            ),
            TextFormField(
              controller: unitController,
              decoration: InputDecoration(labelText: 'หน่วยนับ'),
            ),
            TextFormField(
              controller: sellingPriceController,
              decoration: InputDecoration(labelText: 'ราคาขาย'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิดหน้าต่าง Modal
          },
          child: Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: () async {
            String updatedProductName = productNameController.text;
            String updatedUnit = unitController.text;
            String updatedSellingPrice = sellingPriceController.text;

            String apiUrl =
                'http://localhost/tourlism_root_641463019/editproduct.php';

            Map<String, dynamic> requestBody = {
              'StoreID': widget.data['StoreID'].toString(),
              'ProductID': widget.data['ProductID'].toString(),
              'ProductName': updatedProductName,
              'Unit': updatedUnit,
              'SellingPrice': updatedSellingPrice,
            };

            try {
              var response = await http.post(
                Uri.parse(apiUrl),
                body: requestBody,
              );

              if (response.statusCode == 200) {
                Navigator.of(context).pop(); // ปิดหน้าต่าง Modal
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealthProductPage(),
                  ),
                );
              } else {
                showSuccessDialog(
                    context, "Failed to save data. ${response.body}");
              }
            } catch (error) {
              showSuccessDialog(
                context,
                'Error connecting to the server: $error',
              );
            }
          },
          child: Text('บันทึก'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    storeIdController.dispose();
    productIdController.dispose();
    productNameController.dispose();
    unitController.dispose();
    sellingPriceController.dispose();
    super.dispose();
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
                Navigator.of(context).pop(); // ปิดหน้าต่าง Dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
