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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBPZPd1W02Dfy-933dCDnEWT6qDajab8TM',
    appId: '1:524848728792:web:493b227c05ccb6d3bb65ad',
    messagingSenderId: '524848728792',
    projectId: 'assnake-5e577',
    authDomain: 'assnake-5e577.firebaseapp.com',
    storageBucket: 'assnake-5e577.appspot.com',
    measurementId: 'G-5WTK29XC3S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2wawS2Q2vo4MkG5t9YrTf2YOb3cMitdU',
    appId: '1:524848728792:android:cbbe54b8889c09f5bb65ad',
    messagingSenderId: '524848728792',
    projectId: 'assnake-5e577',
    storageBucket: 'assnake-5e577.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3tjuqjlE1TDhB4yP10pDv24Wkt5hcZ9Q',
    appId: '1:524848728792:ios:aad66233f37666ecbb65ad',
    messagingSenderId: '524848728792',
    projectId: 'assnake-5e577',
    storageBucket: 'assnake-5e577.appspot.com',
    iosClientId: '524848728792-7musljo2alfnu0eprmnru6efp5ejppp3.apps.googleusercontent.com',
    iosBundleId: 'com.example.assnake',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3tjuqjlE1TDhB4yP10pDv24Wkt5hcZ9Q',
    appId: '1:524848728792:ios:6e96e115a4d42a9fbb65ad',
    messagingSenderId: '524848728792',
    projectId: 'assnake-5e577',
    storageBucket: 'assnake-5e577.appspot.com',
    iosClientId: '524848728792-3ichvh3jdn1ifq4faa5kftbnr8bj5pn9.apps.googleusercontent.com',
    iosBundleId: 'com.example.assnake.RunnerTests',
  );
}
