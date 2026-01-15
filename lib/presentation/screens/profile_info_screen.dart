import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/profile_cubit/cubit/profile_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final fontColor = theme.brightness == Brightness.light
        ? theme.primaryColor
        : Colors.white;
    final primaryColor = theme.primaryColor;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Profile Info".tr(),
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        backgroundColor: cardColor,
        onRefresh: () async {
          await context.read<ProfileCubit>().fetchProfile();
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppTheme.kColorDanger,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message.tr(),
                      style: TextStyle(color: fontColor),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoaded) {
              final profile = state.profile;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 2),
                              color: cardColor,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                profile.profileImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: cardColor,
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: fontColor.withOpacity(0.5),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            bottom: 5,
                            end: 5,
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildWalletCard(profile.balance, primaryColor),
                    const SizedBox(height: 25),
                    _sectionTitle("Personal Information".tr(), fontColor),
                    _buildInfoCard(
                      "First Name".tr(),
                      profile.firstName,
                      cardColor,
                      fontColor,
                      isDarkMode,
                    ),
                    _buildInfoCard(
                      "Last Name".tr(),
                      profile.lastName,
                      cardColor,
                      fontColor,
                      isDarkMode,
                    ),
                    _buildInfoCard(
                      "Phone".tr(),
                      profile.phone,
                      cardColor,
                      fontColor,
                      isDarkMode,
                    ),
                    _buildInfoCard(
                      "Birthdate".tr(),
                      profile.birthDate,
                      cardColor,
                      fontColor,
                      isDarkMode,
                    ),
                    const SizedBox(height: 25),
                    _sectionTitle("Identity Document".tr(), fontColor),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        profile.idImageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: cardColor,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: fontColor,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildWalletCard(String balance, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available Balance".tr(),
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 5),
              Text(
                "$balance SYP",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    Color cardColor,
    Color? fontColor,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: fontColor?.withOpacity(0.5), fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: fontColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color? fontColor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 5),
        child: Text(
          title,
          style: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
