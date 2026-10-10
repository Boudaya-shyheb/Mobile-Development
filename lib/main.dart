import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var firebaseReady = false;
  String? firebaseError;

  try {
    await Firebase.initializeApp();
    firebaseReady = true;
  } on FirebaseException catch (error) {
    firebaseError = error.message;
  } catch (error) {
    firebaseError = error.toString();
  }

  runApp(
    CarShareApp(firebaseReady: firebaseReady, firebaseError: firebaseError),
  );
}
