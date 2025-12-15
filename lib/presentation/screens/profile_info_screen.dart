import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

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
    return Scaffold(
      backgroundColor: kBgMain,
      appBar: AppBar(
        title: Text("Profile Info", style: TextStyle(color: kFontColorDark)),
        backgroundColor: kBgCard,
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
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
                    color: kFontColorDark.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, color: kFontColorDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
