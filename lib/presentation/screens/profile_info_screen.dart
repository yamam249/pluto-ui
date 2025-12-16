import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class ProfileInfoScreen extends StatefulWidget {
  final bool isDark; // 🛑 تم إضافة isDark
  const ProfileInfoScreen({super.key, required this.isDark}); // 🛑 تم تعديل الـ Constructor

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  // بيانات المستخدم
  String firstName = "Ahmad";
  String lastName = "Ali";
  String phone = "+963 999 999";
  String birthdate = "2000-01-01";

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(widget.isDark); // 🛑 استخدام AppColors
    final cardColor = AppColors.bgCard(widget.isDark); // 🛑 استخدام AppColors
    final fontColor = AppColors.fontColor(widget.isDark); // 🛑 استخدام AppColors

    return Scaffold(
      backgroundColor: bgColor, // 🛑 استخدام المتغير
      appBar: AppBar(
        title: Text("Profile Info", style: TextStyle(color: fontColor)), // 🛑 استخدام fontColor
        backgroundColor: cardColor, // 🛑 استخدام cardColor
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // صورة البروفايل
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=3",
                ),
              ),
            ),
            const SizedBox(height: 20),

            // معلومات المستخدم
            _buildInfoCard("First Name", firstName),
            _buildInfoCard("Last Name", lastName),
            _buildInfoCard("Phone", phone),
            _buildInfoCard("Birthdate", birthdate),
          ],
        ),
      ),
    );
  }

  // Widget لكل حقل معلومات
  Widget _buildInfoCard(String title, String value) {
    final cardColor = AppColors.bgCard(widget.isDark); // 🛑 استخدام AppColors
    final fontColor = AppColors.fontColor(widget.isDark); // 🛑 استخدام AppColors

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor, // 🛑 استخدام cardColor
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: fontColor.withOpacity(0.8), // 🛑 استخدام fontColor
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, color: fontColor), // 🛑 استخدام fontColor
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}