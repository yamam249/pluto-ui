// import 'package:flutter/material.dart';
// import 'package:pluto_ui/constants/app_colors.dart';

// class LanguageScreen extends StatelessWidget {
//   final bool isDark;

//   const LanguageScreen({super.key, required this.isDark});

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = AppColors.bgMain(isDark);
//     final cardColor = AppColors.bgCard(isDark);
//     final fontColor = AppColors.fontColor(isDark);

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         title: Text("Language", style: TextStyle(color: fontColor)),
//         backgroundColor: cardColor,
//       ),
//       body: Column(
//         children: [
//           ListTile(
//               leading: Icon(Icons.language, color: fontColor),
//               title: Text("English", style: TextStyle(color: fontColor))),
//           const Divider(),
//           ListTile(
//               leading: Icon(Icons.language, color: fontColor),
//               title: Text("Arabic", style: TextStyle(color: fontColor))),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Language",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.cardColor,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            _buildLanguageItem(
              context: context,
              title: "English",
              theme: theme,
              fontColor: fontColor,
              isSelected: true,
            ),
            const Divider(height: 1),
            _buildLanguageItem(
              context: context,
              title: "Arabic",
              theme: theme,
              fontColor: fontColor,
              isSelected: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem({
    required BuildContext context,
    required String title,
    required ThemeData theme,
    required Color? fontColor,
    required bool isSelected,
  }) {
    return ListTile(
      leading: Icon(
        Icons.language,
        color: isSelected ? theme.primaryColor : fontColor?.withOpacity(0.6),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: fontColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.primaryColor)
          : null,
      onTap: () {
        // Handle language change logic here
      },
    );
  }
}
