import 'package:flutter/material.dart';
// تأكد من أن المسار هنا يطابق مكان ملف الألوان في مشروعك
import 'package:pluto_ui/constants/app_colors.dart'; 

class RentalRequestScreen extends StatelessWidget {
  final bool isDark;

  const RentalRequestScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // استدعاء الألوان باستخدام الدوال التي تدعم الوضع الليلي من ملفك
    final bgColor = AppColors.bgMain(isDark);
    final cardColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);
    final primaryColor = AppColors.primary(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Rental Request",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Tenant Information", fontColor),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Icon(Icons.person, color: primaryColor, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ahmad Mohammad",
                          style: TextStyle(color: fontColor, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text("Verified Profile",
                          style: TextStyle(color: Colors.green, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _sectionTitle("Request Details", fontColor),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _infoRow(Icons.calendar_today, "Duration", "6 Months", fontColor, primaryColor),
                  _infoRow(Icons.event, "Start Date", "01 Feb 2024", fontColor, primaryColor),
                  _infoRow(Icons.people_outline, "Occupants", "2 People", fontColor, primaryColor),
                  _infoRow(Icons.account_balance_wallet_outlined, "Total Price", "3000 JOD", fontColor, primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // أزرار التحكم - تم تصحيح استدعاء الألوان هنا
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // تم التعديل هنا: الوصول للون من خلال اسم الكلاس AppColors
                      backgroundColor: AppColors.kColorSuccess, 
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // منطق القبول
                    },
                    child: const Text("Accept", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      // تم التعديل هنا: الوصول للون الخطر من خلال اسم الكلاس AppColors
                      side: BorderSide(color: AppColors.kColorDanger),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // منطق الرفض
                    },
                    child: Text("Decline", style: TextStyle(color: AppColors.kColorDanger, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(
        title,
        style: TextStyle(color: color.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color fontColor, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: fontColor.withOpacity(0.6), fontSize: 15)),
          const Spacer(),
          Text(value, style: TextStyle(color: fontColor, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}