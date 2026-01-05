import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 1. Add this import
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/business_logic/profile_cubit/cubit/profile_cubit.dart'; // 2. Add your Cubit import
import 'package:pluto_ui/data/models/profile_model.dart'; // 3. Add Model import

class ProfileInfoScreen extends StatefulWidget {
  final bool isDark;
  const ProfileInfoScreen({super.key, required this.isDark});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  @override
  void initState() {
    super.initState();
    // 4. Trigger the fetch process when screen opens
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final primaryColor = AppColors.primary(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Profile Info",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: fontColor),
      ),
      // 5. Wrap the body with BlocBuilder
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.kFontColorDark),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: TextStyle(color: fontColor)),
                  // const SizedBox(height: 10),
                  // ElevatedButton(
                  //   onPressed: () =>
                  //       context.read<ProfileCubit>().retryLastAction(),
                  //   child: const Text("Retry"),
                  // ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            final profile = state.profile; // 6. Extract profile data

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Inside ProfileLoaded state in your BlocBuilder
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryColor, width: 2),
                            color:
                                cardColor, // Background color while loading or if broken
                          ),
                          child: ClipOval(
                            child: Image.network(
                              profile.profileImageUrl,
                              fit: BoxFit.cover,
                              // 🛑 Error handler for Profile Photo
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: cardColor,
                                  child: Icon(
                                    Icons
                                        .person, // Default person icon if image fails
                                    size: 50,
                                    color: fontColor.withOpacity(0.5),
                                  ),
                                );
                              },
                              // Optional: Show a loading spinner for the image itself
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
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

                  // 8. Pass dynamic balance
                  _buildWalletCard(
                    profile.balance,
                    primaryColor,
                    cardColor,
                    fontColor,
                  ),

                  const SizedBox(height: 25),

                  _sectionTitle("Personal Information", fontColor),
                  // 9. Use dynamic profile fields
                  _buildInfoCard(
                    "First Name",
                    profile.firstName,
                    cardColor,
                    fontColor,
                  ),
                  _buildInfoCard(
                    "Last Name",
                    profile.lastName,
                    cardColor,
                    fontColor,
                  ),
                  _buildInfoCard("Phone", profile.phone, cardColor, fontColor),
                  _buildInfoCard(
                    "Birthdate",
                    profile.birthDate,
                    cardColor,
                    fontColor,
                  ),

                  const SizedBox(height: 25),

                  _sectionTitle("Identity Document", fontColor),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      // 10. Use Dynamic ID Image with IP replacement
                      profile.idImageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: cardColor,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50),
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
    );
  }

  // Modified helper to accept balance string
  Widget _buildWalletCard(
    String balance,
    Color primaryColor,
    Color cardColor,
    Color fontColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              const Text(
                "Available Balance",
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
    Color fontColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDark ? 0.2 : 0.05),
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
            style: TextStyle(color: fontColor.withOpacity(0.5), fontSize: 14),
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

  Widget _sectionTitle(String title, Color fontColor) {
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
