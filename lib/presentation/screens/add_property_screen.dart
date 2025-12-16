import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddPropertyScreen extends StatefulWidget {
  final bool isDark;

  const AddPropertyScreen({super.key, required this.isDark});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  File? selectedImage;
  final picker = ImagePicker();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final sizeController = TextEditingController();
  final floorController = TextEditingController();
  final roomsController = TextEditingController();
  final descriptionController = TextEditingController();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void validateAndSubmit() {
    if (selectedImage == null) return showError("يجب إضافة صورة الشقة");
    if (cityController.text.trim().isEmpty) return showError("يجب إدخال المحافظة");
    if (areaController.text.trim().isEmpty) return showError("يجب إدخال المنطقة / المدينة");
    if (sizeController.text.trim().isEmpty) return showError("يجب إدخال المساحة");
    if (floorController.text.trim().isEmpty) return showError("يجب إدخال الطابق");
    if (roomsController.text.trim().isEmpty) return showError("يجب إدخال عدد الغرف");
    if (descriptionController.text.trim().isEmpty) return showError("يجب إدخال وصف الشقة");
    showSuccess("تمت إضافة الشقة بنجاح");
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.kColorDanger, // 🛑 تم التصحيح
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.kColorSuccess, // 🛑 تم التصحيح
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final appBarBg = AppColors.bgCard(widget.isDark);
    final hintColor = AppColors.hintColor(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        title: Text(
          "إضافة شقة",
          style: TextStyle(
            color: AppColors.fontColor(widget.isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.bgActive(widget.isDark)),
                ),
                child: selectedImage == null
                    ? Center(
                  child: Icon(Icons.add_a_photo, size: 40, color: hintColor),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _label("المحافظة"),
            _input(cityController, "أدخل اسم المحافظة", cardColor, hintColor),
            const SizedBox(height: 14),
            _label("المنطقة / المدينة"),
            _input(areaController, "أدخل اسم المنطقة", cardColor, hintColor),
            const SizedBox(height: 14),
            _label("المساحة (م²)"),
            _input(sizeController, "مثال: 120", cardColor, hintColor),
            const SizedBox(height: 14),
            _label("الطابق"),
            _input(floorController, "مثال: 3", cardColor, hintColor),
            const SizedBox(height: 14),
            _label("عدد الغرف"),
            _input(roomsController, "مثال: 4", cardColor, hintColor),
            const SizedBox(height: 14),
            _label("الوصف"),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: cardColor,
                hintText: "أدخل وصف الشقة...",
                hintStyle: TextStyle(color: hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.bgActive(widget.isDark)),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor, // 🛑 تم التصحيح
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: validateAndSubmit,
                child: const Text(
                  "إضافة الشقة",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.fontColor(widget.isDark),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _input(TextEditingController controller, String hint, Color bgColor, Color hintColor) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: bgColor,
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.bgActive(widget.isDark)),
        ),
      ),
    );
  }
}