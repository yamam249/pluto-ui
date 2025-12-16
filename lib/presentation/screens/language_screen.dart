import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class LanguageScreen extends StatelessWidget {
  final bool isDark;

  const LanguageScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(isDark);
    final cardColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Language", style: TextStyle(color: fontColor)),
        backgroundColor: cardColor,
      ),
      body: Column(
        children: [
          ListTile(
              leading: Icon(Icons.language, color: fontColor),
              title: Text("English", style: TextStyle(color: fontColor))),
          const Divider(),
          ListTile(
              leading: Icon(Icons.language, color: fontColor),
              title: Text("Arabic", style: TextStyle(color: fontColor))),
        ],
      ),
    );
  }
}