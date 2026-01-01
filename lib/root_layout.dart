import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/profile_cubit/cubit/profile_cubit.dart'; // Ensure correct path
import 'package:pluto_ui/presentation/screens/home_screen.dart';
import 'package:pluto_ui/presentation/screens/favorites_page.dart';
import 'package:pluto_ui/presentation/screens/profile_screen.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/screens/add_property_screen.dart';
import 'package:pluto_ui/presentation/screens/notification_screen.dart';

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
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start fetching profile data globally when the app layout loads
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(isDark: widget.isDark, onThemeChanged: widget.onThemeChanged),
      FavoritesPage(isDark: widget.isDark),
      AddPropertyScreen(
        isDark: widget.isDark,
        onSuccess: () {
          setState(() {
            currentIndex = 0;
          });
        },
      ),
      NotificationScreen(isDark: widget.isDark),
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
        selectedItemColor: AppColors.primary(widget.isDark),
        unselectedItemColor: AppColors.bgActive(widget.isDark),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "",
          ),
          BottomNavigationBarItem(
            label: "",
            icon: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(
                      state.profile.profileImageUrl,
                    ),
                  );
                }
                // Fallback icon while loading or error
                return CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.bgActive(
                    widget.isDark,
                  ).withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.fontColor(widget.isDark),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
