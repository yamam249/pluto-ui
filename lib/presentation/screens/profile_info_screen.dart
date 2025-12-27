// import 'package:flutter/material.dart';
// import 'package:pluto_ui/constants/app_colors.dart';

// class ProfileInfoScreen extends StatefulWidget {
//   final bool isDark; // 🛑 تم إضافة isDark
//   const ProfileInfoScreen({super.key, required this.isDark}); // 🛑 تم تعديل الـ Constructor

//   @override
//   State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
// }

// class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
//   // بيانات المستخدم
//   String firstName = "Ahmad";
//   String lastName = "Ali";
//   String phone = "+963 999 999";
//   String birthdate = "2000-01-01";

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = AppColors.bgMain(widget.isDark); // 🛑 استخدام AppColors
//     final cardColor = AppColors.bgCard(widget.isDark); // 🛑 استخدام AppColors
//     final fontColor = AppColors.fontColor(widget.isDark); // 🛑 استخدام AppColors

//     return Scaffold(
//       backgroundColor: bgColor, // 🛑 استخدام المتغير
//       appBar: AppBar(
//         title: Text("Profile Info", style: TextStyle(color: fontColor)), // 🛑 استخدام fontColor
//         backgroundColor: cardColor, // 🛑 استخدام cardColor
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // صورة البروفايل
//             Center(
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundImage: NetworkImage(
//                   "https://i.pravatar.cc/150?img=3",
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // معلومات المستخدم
//             _buildInfoCard("First Name", firstName),
//             _buildInfoCard("Last Name", lastName),
//             _buildInfoCard("Phone", phone),
//             _buildInfoCard("Birthdate", birthdate),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget لكل حقل معلومات
//   Widget _buildInfoCard(String title, String value) {
//     final cardColor = AppColors.bgCard(widget.isDark); // 🛑 استخدام AppColors
//     final fontColor = AppColors.fontColor(widget.isDark); // 🛑 استخدام AppColors

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cardColor, // 🛑 استخدام cardColor
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: fontColor.withOpacity(0.8), // 🛑 استخدام fontColor
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   value,
//                   style: TextStyle(fontSize: 18, color: fontColor), // 🛑 استخدام fontColor
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/profile_cubit/cubit/profile_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/profile_model.dart';

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
    // Trigger the API call when the screen initializes
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Profile Info", style: TextStyle(color: fontColor)),
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppColors.kColorDanger,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: fontColor, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().retryLastAction(),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileLoaded) {
            return _buildProfileBody(state.profile);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Separated the main UI content into its own method for clarity
  Widget _buildProfileBody(ProfileModel user) {
    final fontColor = AppColors.fontColor(widget.isDark);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Image
          // Center(
          //   child: CircleAvatar(
          //     radius: 60,
          //     backgroundColor: Colors.grey[300],
          //     backgroundImage: NetworkImage(user.profileImage),
          //   ),
          // ),

          // Profile Image
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: ClipOval(
                child: Image.network(
                  user.profileImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: 60,
                    color: fontColor.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // User Information from API
          _buildInfoCard("First Name", user.firstName),
          _buildInfoCard("Last Name", user.lastName),
          _buildInfoCard("Phone", user.phone),
          _buildInfoCard("Birthdate", user.birthDate),

          const SizedBox(height: 20),

          // Optional: Displaying the ID Image as well
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Identity Document",
              style: TextStyle(
                color: fontColor.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Container(
          //   height: 200,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     image: DecorationImage(
          //       image: NetworkImage(user.idImage),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),

          // Identity Document Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              user.idImageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  color: AppColors.kBgCard,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: AppColors.kBgCard,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image,
                      color: fontColor.withOpacity(0.5),
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Could not load image",
                      style: TextStyle(color: fontColor.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Info Card Widget
  Widget _buildInfoCard(String title, String value) {
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: fontColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: fontColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
