import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.slateBlue,
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.person_add, size: 60, color: AppColors.navyBlue),
                const SizedBox(height: 15),
                Text(
                  "إنشاء حساب",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyBlue,
                  ),
                ),
                const SizedBox(height: 30),
                _inputField("الاسم الأول"),
                const SizedBox(height: 15),
                _inputField("الاسم الأخير"),
                const SizedBox(height: 15),
                _phoneField(),
                const SizedBox(height: 15),
                _dateField("تاريخ الميلاد"),
                const SizedBox(height: 20),
                _photoPathField(icon: Icons.camera_alt, label: "صورة شخصية"),
                const SizedBox(height: 15),
                _photoPathField(icon: Icons.badge, label: "صورة الهوية"),
                const SizedBox(height: 15),
                _passwordField(),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navyBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "إنشاء حساب",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "تسجيل دخول",
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text("لديك حساب؟ "),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label) {
    return TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dateField(String label) {
    return TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: AppColors.lightGrey,
        suffixIcon: Icon(Icons.calendar_today, color: AppColors.navyBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _phoneField() {
    return TextField(
      textAlign: TextAlign.right,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "رقم الموبايل",
        filled: true,
        fillColor: AppColors.lightGrey,
        suffixIcon: Icon(Icons.phone_android, color: AppColors.navyBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _photoPathField({required IconData icon, required String label}) {
    return TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: AppColors.lightGrey,
        prefixIcon: Icon(icon, color: AppColors.navyBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      textAlign: TextAlign.right,
      obscureText: true,
      decoration: InputDecoration(
        hintText: " كلمة المرور",
        filled: true,
        fillColor: AppColors.lightGrey,
        suffixIcon: const Icon(Icons.lock, color: AppColors.navyBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
