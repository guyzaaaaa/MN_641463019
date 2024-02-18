import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csit2023/product/HealthProduct.dart'; // Import HealthProductPage

class DeleteProductPage extends StatelessWidget {
  final Map<String, dynamic> data;

  DeleteProductPage({required this.data});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Show delete product modal once the page has been built
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteProductModal(data: data);
        },
      );
    });

    return Container();
  }
}

class DeleteProductModal extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteProductModal({required this.data});

  @override
  _DeleteProductModalState createState() => _DeleteProductModalState();
}

class _DeleteProductModalState extends State<DeleteProductModal> {
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
      title: Text('ลบสินค้า'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: storeIdController,
              decoration: InputDecoration(labelText: 'รหัสร้านค้า'),
              enabled: false,
            ),
            TextFormField(
              controller: productIdController,
              decoration: InputDecoration(labelText: 'รหัสสินค้า'),
              enabled: false,
            ),
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              enabled: false,
            ),
            TextFormField(
              controller: unitController,
              decoration: InputDecoration(labelText: 'หน่วยนับ'),
              enabled: false,
            ),
            TextFormField(
              controller: sellingPriceController,
              decoration: InputDecoration(labelText: 'ราคาขาย'),
              enabled: false,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String productIdToDelete = productIdController.text;

                String apiUrl =
                    'http://localhost/tourlism_root_641463019/deleteproduct.php';

                Map<String, dynamic> requestBody = {
                  'ProductID': productIdToDelete,
                  'case': '3', // Ensure this is a string if it's expected as a string on the server
                };

                try {
                  var response = await http.post(
                    Uri.parse(apiUrl),
                    body: requestBody,
                  );

                  if (response.statusCode == 200) {
                    Navigator.of(context).pop(); // Close the modal
                    showSuccessDialog(
                        context, "ลบสินค้าเสร็จสิ้น");
                  } else {
                    showSuccessDialog(
                        context, "Failed to delete product. ${response.body}");
                  }
                } catch (error) {
                  showSuccessDialog(
                    context,
                    'Error connecting to the server: $error',
                  );
                }
              },
              child: Text('ลบ'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealthProductPage(),
                  ),
                );
              },
              child: Text('ยกเลิก'),
            ),
          ],
        ),
      ),
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
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HealthProductPage(),
                  ),
                );
              },
              child: Text('ไปหน้าจัดการข้อมูลสินค้า'),
            ),
          ],
        );
      },
    );
  }
}
