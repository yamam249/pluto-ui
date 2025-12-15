import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class ProfileInfoScreen extends StatelessWidget {
  final bool isDark;

  const ProfileInfoScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(isDark);
    final cardColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);

    String firstName = "Ahmad";
    String lastName = "Ali";
    String phone = "+963 999 999";
    String birthdate = "2000-01-01";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Profile Info", style: TextStyle(color: fontColor)),
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
                child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=3"))),
            const SizedBox(height: 20),
            _buildInfoCard("First Name", firstName, cardColor, fontColor),
            _buildInfoCard("Last Name", lastName, cardColor, fontColor),
            _buildInfoCard("Phone", phone, cardColor, fontColor),
            _buildInfoCard("Birthdate", birthdate, cardColor, fontColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color cardColor, Color fontColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: fontColor.withOpacity(0.8))),
                const SizedBox(height: 5),
                Text(value, style: TextStyle(fontSize: 18, color: fontColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
