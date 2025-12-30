import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class ProfileInfoScreen extends StatefulWidget {
  final bool isDark;
  const ProfileInfoScreen({super.key, required this.isDark});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final String firstName = "Ahmad";
  final String lastName = "Ali";
  final String phone = "+962 79 000 0000";
  final String birthDate = "1995-05-20";
  final String walletBalance = "1,250.00";

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final primaryColor = AppColors.primary(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Profile Info", style: TextStyle(color: fontColor, fontWeight: FontWeight.bold)),
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: SingleChildScrollView(
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
                      image: const DecorationImage(
                        image: NetworkImage("https://i.pravatar.cc/150?img=3"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: Colors.white, size: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            _buildWalletCard(primaryColor, cardColor, fontColor),

            const SizedBox(height: 25),

            _sectionTitle("Personal Information", fontColor),
            _buildInfoCard("First Name", firstName, cardColor, fontColor),
            _buildInfoCard("Last Name", lastName, cardColor, fontColor),
            _buildInfoCard("Phone", phone, cardColor, fontColor),
            _buildInfoCard("Birthdate", birthDate, cardColor, fontColor),

            const SizedBox(height: 25),

            _sectionTitle("Identity Document", fontColor),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://via.placeholder.com/400x200.png?text=ID+Card+Preview",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(Color primaryColor, Color cardColor, Color fontColor) {
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
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 40),
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
                "$walletBalance JOD",
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color cardColor, Color fontColor) {
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
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: fontColor.withOpacity(0.5), fontSize: 14)),
          Text(value, style: TextStyle(color: fontColor, fontWeight: FontWeight.bold, fontSize: 15)),
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
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}