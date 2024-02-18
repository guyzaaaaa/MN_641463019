import 'package:flutter/material.dart';
import 'package:csit2023/touristplaces/HealthData.dart';
import 'package:csit2023/store/HealstorePage.dart';
import 'package:csit2023/travelhistory/HealTravel.dart';
import 'package:csit2023/train/HealTrain.dart';
import 'package:csit2023/product/HealthProduct.dart';
import 'package:csit2023/gpstracking.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เส้นทางของรถรางนำเที่ยว'),
        backgroundColor: Colors.green, // Change the app bar color here
        centerTitle: true,
      ),
      backgroundColor: Colors.lightGreen[100], // Change the background color here
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'รายการหลัก',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return GridView.count(
                    crossAxisCount:
                        orientation == Orientation.portrait ? 2 : 3,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    children: <Widget>[
                      _buildMenuButton(
                        context,
                        Icons.location_pin,
                        'สถานที่ท่องเที่ยว',
                        HealthDataPage(),
                        Colors.green,
                      ),
                      _buildMenuButton(
                        context,
                        Icons.shopping_bag,
                        'ร้านค้า',
                        HealstorePage(),
                        Colors.orange,
                      ),
                      _buildMenuButton(
                        context,
                        Icons.directions_walk,
                        'เส้นทางเดินรถ',
                        HealTravelHistoryPage(),
                        const Color.fromARGB(255, 39, 165, 176),
                      ),
                      _buildMenuButton(
                        context,
                        Icons.train,
                        'รถราง',
                        HealTrainPage(),
                        Colors.blue,
                      ),
                      _buildMenuButton(
                        context,
                        Icons.shopping_cart,
                        'สินค้า',
                        HealthProductPage(),
                        Colors.red,
                      ),
                      _buildMenuButton(
                        context,
                        Icons.map,
                        'จุดท่องเที่ยว',
                        GPSTracking(),
                        Colors.teal,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, IconData icon, String label,
      Widget page, Color borderColor) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      onHover: (value) {
        // Add your hover effect here
        print(value);
      },
      child: GestureDetector(
        onTapDown: (_) {
          // Add your pressed effect here
        },
        onTapUp: (_) {
          // Add your pressed effect here
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 100.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
