import 'package:dp_maker_app/EditingScreen.dart';
import 'package:dp_maker_app/GenderSelectionScreen.dart';
import 'package:dp_maker_app/ImagesScreen.dart';
import 'package:dp_maker_app/MainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DPMaker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => Stack(
        children: [child!, DropdownAlert()],
      ),
      home: MainScreen(),
    );
  }
}
