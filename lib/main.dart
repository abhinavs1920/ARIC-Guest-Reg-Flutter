import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guest/coupon_service.dart';
import 'firebase_options.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MaterialApp(
          title: 'ARIC Support',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AuthWrapper(),
        ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        } else if (snapshot.hasData) {
          // Pass the signed-in user's email to the CouponService
          CouponService couponService = CouponService(userEmail: snapshot.data!.email ?? '');
          return HomeScreen(couponService: couponService);
        } else {
          return SignInScreen();
        }
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await signInWithGoogle();
          },
          child: Text('Sign In with Google'),
        ),
      ),
    );
  }
  void generateDefaultTokens(String email) {
    // Generate default tokens in the available coupons collection for the user

    // Assume your available coupons collection path is 'users/{userEmail}/available_coupons'
    String collectionPath = 'users/$email/available_coupons';

    // Generate tokens for breakfast, lunch, and dinner
    for (int day = 1; day <= 2; day++) {
      String breakfastToken = 'DAY $day: BREAKFAST';
      String lunchToken = 'DAY $day: LUNCH';
      String dinnerToken = 'DAY $day: DINNER';

      // Add tokens to Firestore
      FirebaseFirestore.instance.collection(collectionPath).add({
        'type': 'breakfast',
        'code': breakfastToken,
        'status': 'available',
      });

      FirebaseFirestore.instance.collection(collectionPath).add({
        'type': 'lunch',
        'code': lunchToken,
        'status': 'available',
      });

      FirebaseFirestore.instance.collection(collectionPath).add({
        'type': 'dinner',
        'code': dinnerToken,
        'status': 'available',
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      generateDefaultTokens(googleSignInAccount!.email);
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }
}
