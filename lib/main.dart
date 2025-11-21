import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Open boxes for users and contacts
  await Hive.openBox('users');    // for auth (email + password)
  await Hive.openBox('contacts'); // for contacts CRUD

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth + CRUD Simple',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
