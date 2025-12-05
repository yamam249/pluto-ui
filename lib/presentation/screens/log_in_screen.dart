import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
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
                Icon(Icons.login, size: 60, color: AppColors.navyBlue),
                const SizedBox(height: 15),
                Text(
                  "تسجيل دخول",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyBlue,
                  ),
                ),
                const SizedBox(height: 30),

                _phoneField(),
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
                      "تسجيل دخول",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "إنشاء حساب جديد",
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _phoneField() {
    return TextField(
      textAlign: TextAlign.right,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "رقم الهاتف",
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

  Widget _passwordField() {
    return TextField(
      textAlign: TextAlign.right,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "كلمة المرور",
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
