# Event Token Scanner App

This Flutter application allows event organizers to efficiently scan and manage food passes using QR code scanning technology and Firebase for real-time data management.

## Features

- **QR Code Scanner:** Utilizes `qr_code_scanner` package to scan QR codes from food passes.
- **Firebase Integration:**
  - Authentication: Uses `firebase_auth` for user authentication and `google_sign_in` for Google sign-in.
  - Database: Integrates `cloud_firestore` for storing and managing scanned data in real-time.
- **Toast Notifications:** Displays notifications using the `toast` package.
- **Reactive Programming:** Implements reactive programming patterns with `rxdart`.

## Packages Used

- `firebase_core: ^2.24.2`
- `firebase_auth: ^4.15.3`
- `cloud_firestore: ^4.13.5`
- `qr_code_scanner: ^1.0.1`
- `toast: ^0.3.0`
- `google_sign_in: ^6.1.6`
- `rxdart: ^0.27.7`

## Getting Started

Follow these steps to get started with the app:

1. Clone the repository.
2. Ensure Flutter SDK is installed on your machine.
3. Run `flutter pub get` to install dependencies.
4. Set up Firebase project and add necessary configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).
5. Run the app using `flutter run`.

