import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trackmyvalorant/login/login.dart';
import 'package:flutter/services.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //Apps update
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VALORANT TRACKERS',
      theme: ThemeData(fontFamily: 'dmsans'),
      home: const login(),
    );
  }
}
