// import 'package:flutter/material.dart';

// class ModeScreen extends StatelessWidget {
//   final bool dark;
//   final ValueChanged<bool> onChange;
//   const ModeScreen({super.key, required this.dark, required this.onChange});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Mode")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Dark Mode", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Switch(value: dark, onChanged: onChange),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/theme_cubit.dart';

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    // We watch the Cubit to know if we are currently in dark mode
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.cardColor,
        iconTheme: IconThemeData(color: fontColor),
        title: Text(
          "Appearance",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: fontColor,
                    ),
                  ),
                ],
              ),
              // Switch(
              //   value: isDarkMode,
              //   activeColor: theme.primaryColor,
              //   // 🚀 Directly trigger the Cubit
              //   onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
              // ),
              Switch(
                value: isDarkMode,
                // Color of the circle when ON
                activeColor: Colors.white,
                // Color of the background track when ON
                activeTrackColor: theme.primaryColor,
                // Color of the circle when OFF
                inactiveThumbColor: theme.primaryColor,
                // Color of the background track when OFF
                inactiveTrackColor: theme.primaryColor.withOpacity(0.3),
                onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
