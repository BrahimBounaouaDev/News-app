import 'package:flutter/material.dart';
import 'package:news_app/Screen/home.dart'; // تأكد من المسار الصحيح

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false, // إزالة شريط DEBUG
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsHomeScreen(), // تعيين الشاشة الرئيسية
    );
  }
}