import 'package:flutter/material.dart';
import 'package:pluto_ui/presentation/screens/home_screen.dart';
import 'package:pluto_ui/presentation/screens/favorites_page.dart';
import 'package:pluto_ui/presentation/screens/profile_screen.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class RootLayout extends StatefulWidget {
  const RootLayout({super.key});

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  int currentIndex = 0;

  final String profileImageUrl =
      "https://i.pravatar.cc/150?img=3";

  final screens = const [
    HomeScreen(),
    FavoritesPage(),
    Placeholder(),
    Placeholder(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kFontColorDark,
        unselectedItemColor: kBgActive,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          const BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ""),
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
