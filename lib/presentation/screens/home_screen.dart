import 'package:flutter/material.dart';
import 'package:pluto_ui/data/place_data.dart';
import 'package:pluto_ui/presentation/widgets/place_card.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/screens/filter_page.dart';

class HomeScreen extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(isDark);
    final appBarColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);
    final subColor = AppColors.subFontColor(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pluto',
                style: TextStyle(
                    color: fontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
            IconButton(
              icon: Icon(Icons.filter_list, color: fontColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FilterPage(isDark: isDark),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockPlaces.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PlaceCard(
              place: mockPlaces[index],
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}
