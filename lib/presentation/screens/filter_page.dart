import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class FilterPage extends StatefulWidget {
  final bool isDark;

  const FilterPage({super.key, required this.isDark});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedCity;

  final List<String> cities = ["Damascus", "Homs", "Latakia"];

  final TextEditingController areaController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController areaSizeController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.bgMain(widget.isDark);
    final card = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final subColor = AppColors.subFontColor(widget.isDark);

    InputDecoration inputDec(String hint) => InputDecoration(
      filled: true,
      fillColor: card,
      hintText: hint,
      hintStyle: TextStyle(color: subColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Filters",
          style: TextStyle(
            color: fontColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text("City",
                style: TextStyle(
                    color: subColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: card,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: selectedCity,
              hint: Text("Select city", style: TextStyle(color: subColor)),
              items: cities
                  .map((city) => DropdownMenuItem(
                  value: city, child: Text(city)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCity = val),
            ),
            const SizedBox(height: 20),
            Text("Area",
                style: TextStyle(
                    color: subColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: areaController,
              decoration: inputDec("Enter area name"),
              style: TextStyle(color: fontColor),
            ),
            const SizedBox(height: 20),
            Text("Price",
                style: TextStyle(
                    color: subColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: inputDec("Enter price"),
              style: TextStyle(color: fontColor),
            ),
            const SizedBox(height: 20),
            Text("Area Size (m²)",
                style: TextStyle(
                    color: subColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: areaSizeController,
              keyboardType: TextInputType.number,
              decoration: inputDec("Enter area size"),
              style: TextStyle(color: fontColor),
            ),
            const SizedBox(height: 20),
            Text("Rooms",
                style: TextStyle(
                    color: subColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: roomsController,
              keyboardType: TextInputType.number,
              decoration: inputDec("Enter number of rooms"),
              style: TextStyle(color: fontColor),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(widget.isDark),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Apply Filters",
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}