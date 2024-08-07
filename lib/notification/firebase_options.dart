// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCkX5ECArbNAlS7oTtEae3VTcpB8KrgEA',
    appId: '1:6415992671:android:441d9aad9d158d69c1d8ea',
    messagingSenderId: '6415992671',
    projectId: 'druti-int',
    storageBucket: 'druti-int.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'Your-key',
    appId: '1:757941782079:ios:662f379e338c8748125a8a',
    messagingSenderId: '757941782079',
    projectId: 'fcm-flutter-demo-a8f8f',
    storageBucket: 'fcm-flutter-demo-a8f8f.appspot.com',
    iosClientId: '757941782079-mtmoukdf91egsh8tbjrfgj577pl25jam.apps.googleusercontent.com',
    iosBundleId: 'com.example.pushnotifications',
  );
}