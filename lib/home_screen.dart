// user_app/lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:guest/scan_list_screen.dart';
import 'package:guest/scan_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User App Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanScreen(userId: userId),
                  ),
                );
              },
              child: Text('Scan QR Code'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanListScreen(userId: userId),
                  ),
                );
              },
              child: Text('View Previous Scans'),
            ),
            // Add other UI elements as needed
          ],
        ),
      ),
    );
  }
}
