import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/profile_cubit/cubit/profile_cubit.dart';
import 'package:pluto_ui/presentation/screens/home_screen.dart';
import 'package:pluto_ui/presentation/screens/favorites_page.dart';
import 'package:pluto_ui/presentation/screens/profile_screen.dart';
import 'package:pluto_ui/presentation/screens/add_property_screen.dart';
import 'package:pluto_ui/presentation/screens/notifications_screen.dart';

class RootLayout extends StatefulWidget {
  const RootLayout({super.key});

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screens = [
      const HomeScreen(),
      const FavoritesPage(),
      AddPropertyScreen(onSuccess: () => setState(() => currentIndex = 0)),
      const NotificationScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.cardColor,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.secondary,
        onTap: (index) => setState(() => currentIndex = index),
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
                return CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: theme.iconTheme.color,
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
