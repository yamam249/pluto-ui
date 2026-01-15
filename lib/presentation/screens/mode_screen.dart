import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.cardColor,
        iconTheme: IconThemeData(color: fontColor),
        title: Text(
          "Appearance".tr(),
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20),
        child: Container(
          padding: const EdgeInsetsDirectional.all(16),
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
                    "Dark Mode".tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: fontColor,
                    ),
                  ),
                ],
              ),

              Switch(
                value: isDarkMode,
                activeColor: Colors.white,
                activeTrackColor: theme.primaryColor,
                inactiveThumbColor: theme.primaryColor,
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
