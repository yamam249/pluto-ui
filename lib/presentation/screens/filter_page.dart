// lib/presentation/screens/filter_page.dart

import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedGovernorate;

  final List<String> syrianGovernorates = [
    "دمشق",
    "ريف دمشق",
    "حلب",
    "حمص",
    "حماة",
    "اللاذقية",
    "طرطوس",
    "إدلب",
    "درعا",
    "القنيطرة",
    "السويداء",
    "دير الزور",
    "الحسكة",
    "الرقة",
  ];

  final TextEditingController areaController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController districtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBgCard,
        elevation: 0,
        iconTheme: IconThemeData(color: kFontColorDark),
        title: Text(
          "Filter",
          style: TextStyle(
            color: kFontColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      backgroundColor: kBgMain,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildLabel("المحافظة"),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: kBgCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedGovernorate,
                isExpanded: true,
                underline: const SizedBox(),
                hint: Text("اختر المحافظة", style: TextStyle(color: kFontColorDark)),
                items: syrianGovernorates.map((gov) {
                  return DropdownMenuItem(
                    value: gov,
                    child: Text(gov),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGovernorate = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            _buildLabel("المنطقة"),
            const SizedBox(height: 8),
            _buildTextField(controller: districtController, hint: "مثال: المزة"),

            const SizedBox(height: 20),

            _buildLabel("السعر (البادجت)"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: priceController,
              hint: "مثال: 500000000",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            _buildLabel("المساحة"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: areaController,
              hint: "مثال: 150 م²",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            _buildLabel("عدد الغرف"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: roomsController,
              hint: "مثال: 3",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kFontColorDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Apply Filter",
                  style: TextStyle(fontSize: 18, color: kFontColorLight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: kFontColorDark,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}
