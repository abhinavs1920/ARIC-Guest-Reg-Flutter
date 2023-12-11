import 'package:flutter/material.dart';
import 'coupon_model.dart';
import 'coupon_service.dart';

class CouponListScreen extends StatelessWidget {
  final CouponService couponService;
  final String status;

  CouponListScreen({required this.couponService, required this.status});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Coupon>>(
      future: couponService.getCoupons(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No $status Coupons'));
        } else {
          List<Coupon> coupons = snapshot.data!;
          return ListView.builder(
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              Coupon coupon = coupons[index];
              return ListTile(
                title: Text(coupon.code),
                subtitle: Text('Status: ${coupon.status}'),
              );
            },
          );
        }
      },
    );
  }
}
