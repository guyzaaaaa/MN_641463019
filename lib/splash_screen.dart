import 'package:flutter/material.dart';
import 'package:csit2023/menu.dart'; // Import your menu.dart file

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    border: Border.all(color: Colors.white, width: 2.0), // White border
                  ),
                  child: Image.asset(
                    'images/Lisbon.jpg',
                    fit: BoxFit.cover, // Use cover to fill the container
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'รถรางนำเที่ยว',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 200, // Adjust button width as needed
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MainMenu(), // Replace with your menu.dart class
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0), // Increase button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.white), // Add border
                    ),
                    elevation: 5, // Add elevation for shadow effect
                  ),
                  child: Text(
                    'เริ่มต้นใช้งาน',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Add space below the button
            ],
          ),
        ),
      ),
    );
  }
}
