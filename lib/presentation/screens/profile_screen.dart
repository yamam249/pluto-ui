import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';
import 'package:pluto_ui/business_logic/profile_cubit/cubit/profile_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'profile_info_screen.dart';
import 'history_screen.dart';
import 'mode_screen.dart';
import 'language_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        backgroundColor: theme.cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile".tr(),
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

            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.cardColor,
                        backgroundImage: NetworkImage(
                          state.profile.profileImageUrl,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${state.profile.firstName} ${state.profile.lastName}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: fontColor,
                        ),
                      ),
                    ],
                  );
                } else if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.cardColor,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: fontColor?.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Guest User".tr(),
                        style: TextStyle(fontSize: 18, color: fontColor),
                      ),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 40),
            _buildItem(
              theme: theme,
              icon: Icons.person_outline,
              text: "Profile Information".tr(),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileInfoScreen()),
              ),
              color: fontColor,
            ),
            _buildItem(
              theme: theme,
              icon: Icons.history,
              text: "History".tr(),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
              color: fontColor,
            ),
            _buildItem(
              theme: theme,
              icon: Icons.dark_mode_outlined,
              text: "Mode (Light / Dark)".tr(),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ModeScreen()),
              ),
              color: fontColor,
            ),
            _buildItem(
              theme: theme,
              icon: Icons.language,
              text: "Language".tr(),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LanguageScreen(), // 🚨 Cleaned
                ),
              ),
              color: fontColor,
            ),
            _buildItem(
              theme: theme,
              icon: Icons.logout,
              text: "Logout".tr(),
              onTap: () => showLogoutDialog(context, theme, isDarkMode),
              color: AppTheme.kColorDanger,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required ThemeData theme,
    required IconData icon,
    required String text,
    required Function() onTap,
    Color? color,
  }) {
    final defaultFontColor = theme.textTheme.titleLarge?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color ?? defaultFontColor),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  color: color ?? defaultFontColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: defaultFontColor?.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLogoutDialog(
    BuildContext context,
    ThemeData theme,
    bool isDarkMode,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text("Logout".tr()),
        content: Text("Are you sure you want to logout?".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel".tr(), style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);

              context.read<LoginCubit>().logout();
            },
            child: Text(
              "Logout".tr(),
              style: TextStyle(color: AppTheme.kColorDanger),
            ),
          ),
        ],
      ),
    );
  }
}
