import 'package:flutter/material.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/web_services/apartment_api.dart';
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
  final String profileImageUrl = "https://i.pravatar.cc/150?img=3";

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(isDark: widget.isDark, onThemeChanged: widget.onThemeChanged),
      FavoritesPage(isDark: widget.isDark),
      AddPropertyScreen(isDark: widget.isDark),
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

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/favorite_cubit/cubit/favorite_cubit.dart';
// import 'package:pluto_ui/presentation/screens/home_screen.dart';
// import 'package:pluto_ui/presentation/screens/favorites_page.dart';
// import 'package:pluto_ui/presentation/screens/profile_screen.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/presentation/screens/add_property_screen.dart';

// class RootLayout extends StatefulWidget {
//   final bool isDark;
//   final ValueChanged<bool> onThemeChanged;

//   const RootLayout({
//     super.key,
//     required this.isDark,
//     required this.onThemeChanged,
//   });

//   @override
//   State<RootLayout> createState() => _RootLayoutState();
// }

// class _RootLayoutState extends State<RootLayout> {
//   int currentIndex = 0;
//   final String profileImageUrl = "https://i.pravatar.cc/150?img=3";

//   @override
//   Widget build(BuildContext context) {
//     // 1. Define screens
//     final screens = [
//       HomeScreen(isDark: widget.isDark, onThemeChanged: widget.onThemeChanged),
//       FavoritesPage(isDark: widget.isDark),
//       AddPropertyScreen(isDark: widget.isDark),
//       Placeholder(color: widget.isDark ? Colors.white70 : Colors.black26),
//       ProfileScreen(
//         isDark: widget.isDark,
//         onThemeChanged: widget.onThemeChanged,
//       ),
//     ];

//     // 2. Define colors
//     final bgColor = AppColors.bgMain(widget.isDark);
//     final navBarColor = AppColors.bgCard(widget.isDark);
//     final fontColor = AppColors.fontColor(widget.isDark);
//     final activeColor = AppColors.bgActive(widget.isDark);
//     final dangerColor = AppColors.danger(widget.isDark);

//     return BlocListener<FavoriteCubit, FavoriteState>(
//       // Only listen when the state is specifically an error
//       listenWhen: (previous, current) => current is FavoriteError,
//       listener: (context, state) {
//         if (state is FavoriteError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: dangerColor,
//               behavior: SnackBarBehavior.floating,
//               duration: const Duration(seconds: 4),
//               action: SnackBarAction(
//                 label: "Retry",
//                 textColor: Colors.white,
//                 onPressed: () {
//                   // Re-fetch favorites if the previous toggle or fetch failed
//                   context.read<FavoriteCubit>().getFavorites();
//                 },
//               ),
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: bgColor,
//         body: IndexedStack(index: currentIndex, children: screens),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: currentIndex,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: navBarColor,
//           selectedItemColor: fontColor,
//           unselectedItemColor: activeColor,
//           onTap: (index) {
//             setState(() {
//               currentIndex = index;
//             });
//           },
//           items: [
//             const BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.favorite),
//               label: "",
//             ),
//             const BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.notifications_none),
//               label: "",
//             ),
//             BottomNavigationBarItem(
//               label: "",
//               icon: CircleAvatar(
//                 radius: 14,
//                 backgroundImage: NetworkImage(profileImageUrl),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
