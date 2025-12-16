import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  final bool isDark;

  const HistoryScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(isDark);
    final cardColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);

    List<Map<String, String>> houses = [
      {"name": "House in Damascus", "date": "2024-03-10"},
      {"name": "Apartment in Homs", "date": "2024-04-18"},
      {"name": "Villa in Latakia", "date": "2024-05-22"},
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: cardColor,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: houses.length,
        itemBuilder: (context, i) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: cardColor,
            child: ListTile(
              leading: Icon(Icons.house, size: 30, color: AppColors.kPrimaryColor), // 🛑 تم التصحيح
              title: Text(houses[i]["name"]!,
                  style: TextStyle(color: fontColor, fontWeight: FontWeight.bold)),
              subtitle: Text("Rented on: ${houses[i]["date"]}",
                  style: TextStyle(color: fontColor.withOpacity(0.7))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.edit, color: AppColors.kPrimaryColor), onPressed: () {}), // 🛑 تم التصحيح
                  IconButton(icon: Icon(Icons.delete, color: AppColors.kColorDanger), onPressed: () {}), // 🛑 تم التصحيح
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}