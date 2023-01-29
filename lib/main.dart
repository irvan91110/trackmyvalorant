import 'package:flutter/material.dart';
import 'package:trackmyvalorant/login/login.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  //final idih = (await fungsi.login("irvan9110", "Imnot404@", true));

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
