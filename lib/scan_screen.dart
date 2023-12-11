// user_app/lib/screens/scan_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guest/home_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  final String userId;

  ScanScreen({required this.userId});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool scanned = false; // Flag to track whether a scan has already been processed
  late String lastScannedQrCode;
  late Timer debounceTimer;

  @override
  void initState() {
    super.initState();
    debounceTimer = Timer(Duration(seconds: 2), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: (controller) {
          this.controller = controller;
          controller.scannedDataStream.listen((scanData) {
            // Add the scanned QR code to the stream
            handleScannedData(scanData.code.toString());
          });
        },
      ),
    );
  }

  void handleScannedData(String qrCode) {
    if (!scanned) {
      scanned = true; // Set the flag to true to prevent multiple scans
      lastScannedQrCode = qrCode;

      // Save data to Firestore
      saveDataToFirestore(lastScannedQrCode);



      // Automatically exit the camera screen and go back to the home screen
      Route route = MaterialPageRoute(builder: (context) => HomeScreen(userId: 'abhishek'));
      Navigator.pushReplacement(context, route);
      // Start the debounce timer
      debounceTimer = Timer(Duration(seconds: 2), () {
        scanned = false; // Reset the flag after the debounce time
      });
    }
  }

  void saveDataToFirestore(String qrCode) {
    // Save data to Firestore
    FirebaseFirestore.instance
        .collection('user_data')
        .doc(widget.userId)
        .collection('scans')
        .add({
      'qr_code': qrCode,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    controller.dispose();
    debounceTimer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }
}
