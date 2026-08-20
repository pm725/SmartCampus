import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notice_provider.dart';
import 'notice_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NoticeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Campus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NoticeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
