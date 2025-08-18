import 'package:flutter/material.dart';
import 'package:hit_confirm/screens/hit_confirm_screen.dart';

class HitConfirmApp extends StatelessWidget {
  const HitConfirmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ヒット確認練習',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HitConfirmScreen(),
    );
  }
}
