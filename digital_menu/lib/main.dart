import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'core/config/firebase_options.dart';
import 'core/di/di.dart' as di;
import 'core/utils/database_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Seed initial data if database is empty (non-blocking)
    DatabaseSeeder.seedIfEmpty();

    // Initialize dependency injection
    await di.init();
  } catch (e, stackTrace) {
    initError = 'Error during initialization:\n$e\n\nStacktrace:\n$stackTrace';
  }

  runApp(DigitalMenuApp(initError: initError));
}
