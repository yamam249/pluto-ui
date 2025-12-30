import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class EditRequestScreen extends StatefulWidget {
  final bool isDark;
  final String houseName;
  final String initialDate;

  const EditRequestScreen({
    super.key,
    required this.isDark,
    required this.houseName,
    required this.initialDate,
  });

  @override
  State<EditRequestScreen> createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends State<EditRequestScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _parseDate();
  }

  void _parseDate() {
    try {
      selectedDate = DateTime.parse(widget.initialDate);
      if (selectedDate.isBefore(DateTime.now())) {
        selectedDate = DateTime.now();
      }
    } catch (e) {
      selectedDate = DateTime.now();
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime firstAllowedDate = selectedDate.isBefore(DateTime.now())
        ? selectedDate
        : DateTime.now().subtract(const Duration(days: 365));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: widget.isDark ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final primary = AppColors.primary(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Edit Request"),
        backgroundColor: cardColor,
        iconTheme: IconThemeData(color: fontColor),
        titleTextStyle: TextStyle(color: fontColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Updating duration for:", style: TextStyle(color: fontColor.withOpacity(0.6))),
            const SizedBox(height: 8),
            Text(widget.houseName, style: TextStyle(color: fontColor, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            Text("Tap to change date:", style: TextStyle(color: fontColor, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            InkWell(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                      style: TextStyle(color: fontColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.calendar_today, color: primary),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Rental duration updated successfully!")),
                  );
                },
                child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}