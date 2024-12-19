import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymapp/notifications/notifications.dart';
import 'package:gymapp/pages/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationService notificationService = NotificationService();
  await notificationService.initNotification();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Wrapper(),
    );
  }
}
