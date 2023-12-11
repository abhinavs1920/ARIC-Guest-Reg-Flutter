import 'package:flutter/material.dart';
import 'package:guest/scan_screen.dart';
import 'coupon_list_screen.dart';
import 'coupon_service.dart';

class HomeScreen extends StatelessWidget {
  final CouponService couponService;

  HomeScreen({required this.couponService});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Coupon App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Available Coupons'),
              Tab(text: 'Expired Coupons'),
              Tab(text: 'Used Coupons'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CouponListScreen(couponService: couponService, status: 'available_coupons'),
            CouponListScreen(couponService: couponService, status: 'expired_coupons'),
            CouponListScreen(couponService: couponService, status: 'used_coupons'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScanScreen()),
            );
          },
          child: Icon(Icons.qr_code_scanner),
        ),
      ),
    );
  }
}
