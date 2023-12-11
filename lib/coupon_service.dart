import 'package:cloud_firestore/cloud_firestore.dart';

import 'coupon_model.dart';

class CouponService {
  final String userEmail;

  CouponService({required this.userEmail});

  Future<List<Coupon>> getCoupons(String status) async {
    CollectionReference couponCollection = FirebaseFirestore.instance.collection('users').doc(userEmail).collection(status);

    QuerySnapshot querySnapshot = await couponCollection.get();

    List<Coupon> coupons = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Coupon(
        id: doc.id,
        code: data['code'],
        status: data['status'],
      );
    }).toList();

    return coupons;
  }
}
