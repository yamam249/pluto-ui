import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'profile_info_screen.dart';
import 'history_screen.dart';
import 'mode_screen.dart';
import 'language_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);

    final profileImageUrl = "https://i.pravatar.cc/150?img=3";

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              "User Name",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: fontColor,
              ),
            ),
            const SizedBox(height: 40),
            _buildItem(
              icon: Icons.person,
              text: "Profile",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileInfoScreen(isDark: widget.isDark),
                ),
              ), // 🛑 تم تمرير isDark
              color: fontColor,
            ),
            _buildItem(
              icon: Icons.history,
              text: "History",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryScreen(isDark: widget.isDark),
                ),
              ),
              color: fontColor,
            ),
            _buildItem(
              icon: Icons.dark_mode,
              text: "Mode (Light / Dark)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModeScreen(
                    dark: widget.isDark,
                    onChange: widget.onThemeChanged,
                  ),
                ),
              ),
              color: fontColor,
            ),
            _buildItem(
              icon: Icons.language,
              text: "Language",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LanguageScreen(isDark: widget.isDark),
                ),
              ),
              color: fontColor,
            ),
            _buildItem(
              icon: Icons.logout,
              text: "Logout",
              onTap: () => showLogoutDialog(context),
              color: AppColors.kColorDanger,
            ), // 🛑 تم التصحيح
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String text,
    required Function() onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard(widget.isDark),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color ?? AppColors.fontColor(widget.isDark)),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  color: color ?? AppColors.fontColor(widget.isDark),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.fontColor(widget.isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void showLogoutDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text("Logout"),
  //       content: const Text("Are you sure you want to logout?"),
  //       actions: [
  //         TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
  //         TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Logout")),
  //       ],
  //     ),
  //   );
  // }

  // Inside ProfileScreen class in profile_screen.dart

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? AppColors.bgCard(true) : Colors.white,
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.kBgActive),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              // 🛑 TRIGGER THE LOGOUT HERE
              context.read<LoginCubit>().logout();
            },
            child: Text(
              "Logout",
              style: TextStyle(color: AppColors.kColorDanger),
            ),
          ),
        ],
      ),
    );
  }
}
