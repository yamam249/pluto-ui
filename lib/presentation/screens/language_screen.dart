import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Language")),
      body: Column(
        children: const [
          ListTile(
            leading: Icon(Icons.language),
            title: Text("English"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Arabic"),
          ),
        ],
      ),
    );
  }
}
