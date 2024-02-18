import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csit2023/product/HealthProduct.dart';

class ShowProductPage extends StatelessWidget {
  final Map<String, dynamic> data;

  ShowProductPage({required this.data});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowProductModal(data: data);
        },
      );
    });

    return SizedBox.shrink(); // Return an empty SizedBox to avoid any visual impact
  }
}

class ShowProductModal extends StatefulWidget {
  final Map<String, dynamic> data;

  ShowProductModal({required this.data});

  @override
  _ShowProductModalState createState() => _ShowProductModalState();
}

class _ShowProductModalState extends State<ShowProductModal> {
  late Future<String?> _storeName;

  Future<String?> _fetchStoreName(String storeID) async {
    final response = await http.get(Uri.parse('http://localhost/tourlism_root_641463019/savestore.php'));
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      final Map<String, dynamic>? store = parsed.firstWhere((element) => element['StoreID'] == storeID, orElse: () => null);
      if (store != null) {
        return store['StoreName'];
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _storeName = _fetchStoreName(widget.data['StoreID'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Product Information'),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<String?>(
              future: _storeName,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text('Error fetching store name'),
                  );
                } else {
                  return _buildTextFormField('ชื่อร้านค้า', snapshot.data!);
                }
              },
            ),
            _buildTextFormField('รหัสสินค้า', widget.data['ProductID'].toString()),
            _buildTextFormField('ชื่อสินค้า', widget.data['ProductName'].toString()),
            _buildTextFormField('หน่วยนับ', widget.data['Unit'].toString()),
            _buildTextFormField('ราคาขาย', widget.data['SellingPrice'].toString()),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
                Navigator.of(context).pushReplacement( // Navigate to HealthProductPage
                  MaterialPageRoute(
                    builder: (context) => HealthProductPage(),
                  ),
                );
              },
              child: Text('กลับ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      readOnly: true, // Make it read-only
    );
  }
}
