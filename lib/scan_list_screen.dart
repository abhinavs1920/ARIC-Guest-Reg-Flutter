// user_app/lib/screens/scan_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanListScreen extends StatelessWidget {
  final String userId; // Pass the user ID to fetch the scans for a specific user

  ScanListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan List'),
      ),
      body: ScanList(userId: userId),
    );
  }
}

class ScanList extends StatelessWidget {
  final String userId;

  ScanList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user_data')
          .doc(userId)
          .collection('scans')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var scans = snapshot.data!.docs;

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, index) {
            var scan = scans[index];
            var qrCode = scan['qr_code'];
            var timestamp = scan['timestamp']?.toDate(); // Convert timestamp to DateTime

            return ListTile(
              title: Text('QR Code: $qrCode'),
              subtitle: Text('Time: ${timestamp.toString()}'),
            );
          },
        );
      },
    );
  }
}
