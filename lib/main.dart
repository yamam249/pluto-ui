import 'package:flutter/material.dart';
import 'package:pluto_ui/app_router.dart';

void main() {
  runApp(const PlutoApp());
}

class PlutoApp extends StatefulWidget {
  const PlutoApp({super.key});

  @override
  State<PlutoApp> createState() => _PlutoAppState();
}

class _PlutoAppState extends State<PlutoApp> {
  bool isDark = false;

  void changeTheme(bool value) {
    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: RootLayout(
        isDark: isDark,
        onThemeChanged: changeTheme,
      ),
    );
  }
}
