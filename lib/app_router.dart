import 'package:flutter/material.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/web_services/apartment_api.dart';
import 'package:pluto_ui/presentation/screens/home_screen.dart';
import 'package:pluto_ui/presentation/screens/favorites_page.dart';
import 'package:pluto_ui/presentation/screens/profile_screen.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/screens/add_property_screen.dart';

class RootLayout extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const RootLayout({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  // late ApartmentModel added by me
  late ApartmentModel apartmentModel;
  int currentIndex = 0;
  final String profileImageUrl = "https://i.pravatar.cc/150?img=3";

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(isDark: widget.isDark, onThemeChanged: widget.onThemeChanged),
      FavoritesPage(isDark: widget.isDark, apartmentModel: apartmentModel),
      AddPropertyScreen(isDark: widget.isDark),
      Placeholder(color: widget.isDark ? Colors.white70 : Colors.black26),
      ProfileScreen(
        isDark: widget.isDark,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    final bgColor = AppColors.bgMain(widget.isDark);
    final navBarColor = AppColors.bgCard(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBarColor,
        selectedItemColor: AppColors.fontColor(widget.isDark),
        unselectedItemColor: AppColors.bgActive(widget.isDark),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          const BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "",
          ),
          BottomNavigationBarItem(
            label: "",
            icon: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
          ),
        ],
      ),
    );
  }
}
