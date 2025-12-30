import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class RentalRequestScreen extends StatelessWidget {
  final bool isDark;
  final bool isEditRequest;
  final bool isAlreadyAccepted;
  final String tenantName;
  final String? oldDate;
  final String? newDate;

  const RentalRequestScreen({
    super.key,
    required this.isDark,
    this.isEditRequest = false,
    this.isAlreadyAccepted = false,
    required this.tenantName,
    this.oldDate,
    this.newDate,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(isDark);
    final cardColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);
    final subFontColor = AppColors.subFontColor(isDark);
    final primaryColor = AppColors.primary(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEditRequest ? "Review Change" : "Request Details",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (isAlreadyAccepted && isEditRequest)
              _statusBanner("Accepted - Update Requested", Colors.orange)
            else if (isAlreadyAccepted)
              _statusBanner("Booking Confirmed", AppColors.kColorSuccess),

            _sectionTitle("Tenant Information", fontColor),
            _buildCard(cardColor, Row(
              children: [
                CircleAvatar(backgroundColor: primaryColor.withOpacity(0.1), child: Text(tenantName[0], style: TextStyle(color: primaryColor))),
                const SizedBox(width: 15),
                Text(tenantName, style: TextStyle(color: fontColor, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )),

            const SizedBox(height: 20),

            if (isEditRequest && oldDate != null && newDate != null) ...[
              _sectionTitle("Proposed Changes", fontColor),
              _buildCard(cardColor, Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dateBox("Previous", oldDate!, subFontColor),
                  Icon(Icons.swap_horiz, color: primaryColor),
                  _dateBox("New Proposed", newDate!, Colors.orange),
                ],
              )),
              const SizedBox(height: 20),
            ],

            _sectionTitle("Property Details", fontColor),
            _buildCard(cardColor, Column(
              children: [
                _infoRow("Property", "Damascus Villa", fontColor, subFontColor),
                const Divider(height: 20),
                _infoRow("Total Price", "3000 JOD", fontColor, subFontColor),
              ],
            )),

            const SizedBox(height: 40),

            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _statusBanner(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCard(Color color, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: child,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kColorSuccess,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(isEditRequest ? "Approve Edit" : "Accept Booking", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.kColorDanger),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(isEditRequest ? "Keep Old Date" : "Decline", style: TextStyle(color: AppColors.kColorDanger, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _dateBox(String label, String date, Color color) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 10, color: color)),
      Text(date, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
    ]);
  }

  Widget _infoRow(String label, String val, Color fColor, Color sColor) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(color: sColor)),
      Text(val, style: TextStyle(color: fColor, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _sectionTitle(String title, Color color) {
    return Container(width: double.infinity, padding: const EdgeInsets.only(bottom: 8, top: 10), child: Text(title, style: TextStyle(color: color.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 13)));
  }
}