import 'package:flutter/material.dart';
import 'package:pluto_ui/presentation/screens/root_layout.dart';

void main() {
  runApp(const PlutoApp());
}

class PlutoApp extends StatelessWidget {
  const PlutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RootLayout(),
    );
  }
}
