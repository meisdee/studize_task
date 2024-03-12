import 'package:flutter/material.dart';

import 'package:studize_interview/screens/single_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SinglePageScreen(),
    );
  }
}
