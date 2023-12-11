// user_app/lib/screens/scan_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream
        .debounce((_) => TimerStream(true, Duration(seconds: 1)))
        .listen((scanData) {
      // Call a function to save data to Firestore
      saveDataToFirestore(scanData.code.toString(), controller);
    });
  }

  void saveDataToFirestore(String qrCode, QRViewController controller) async {
    try {
      // Get the current user's email (replace with your authentication logic)
      String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

      // Check the status of the coupon using a Firestore query
      CollectionReference couponsCollection = FirebaseFirestore.instance.collection('users').doc(userEmail).collection('available_coupons');
      QuerySnapshot querySnapshot = await couponsCollection.where('code', isEqualTo: qrCode).get();

      if (querySnapshot.docs.isNotEmpty) {
        // The coupon is available, mark it as used
        String couponId = querySnapshot.docs.first.id;
        await couponsCollection.doc(couponId).delete(); // Remove from available coupons

        CollectionReference usedCouponsCollection = FirebaseFirestore.instance.collection('users').doc(userEmail).collection('used_coupons');
        await usedCouponsCollection.add({
          'code': qrCode,
          'status': "used",
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Coupon successfully scanned and marked as used.'),
        ));

        // Pop the ScanScreen and return to the previous screen
        Navigator.pop(context);
      } else {
        // The coupon is not available or already used
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Coupon not valid or already used.'),
        ));
      }
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
