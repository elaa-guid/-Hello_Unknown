// lib/main.dart
import 'package:flutter/material.dart';
import 'contract_sim.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello DApp (Simulé)',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HelloSimPage(),
    );
  }
}
