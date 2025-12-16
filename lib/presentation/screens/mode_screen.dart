import 'package:flutter/material.dart';

class ModeScreen extends StatelessWidget {
  final bool dark;
  final ValueChanged<bool> onChange;
  const ModeScreen({super.key, required this.dark, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mode")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Dark Mode", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Switch(value: dark, onChanged: onChange),
          ],
        ),
      ),
    );
  }
}