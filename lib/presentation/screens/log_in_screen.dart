import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';
import 'package:pluto_ui/presentation/screens/home_screen.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // 💡 افتراض أن هذه الشاشة تستخدم الوضع الفاتح كإعداد افتراضي
  bool get _isDark => false;

  Map<String, List<String>> validationErrors = {};

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? getErrorForField(String fieldKey) {
    if (validationErrors.containsKey(fieldKey) &&
        validationErrors[fieldKey]!.isNotEmpty) {
      return validationErrors[fieldKey]!.first;
    }
    return null;
  }

  // Login Submission Method
  void _submitLogin(BuildContext context) {
    setState(() {
      validationErrors = {};
    });

    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    BlocProvider.of<LoginCubit>(context).loginUser(phone, password);
  }

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان بناءً على الوضع الافتراضي (_isDark)
    final bgColor = AppColors.bgMain(_isDark);
    final cardColor = AppColors.bgCard(_isDark);
    final fontColor = AppColors.fontColor(_isDark);
    final activeColor = AppColors.bgActive(_isDark);
    final dangerColor =
        AppColors.kColorDanger; // Danger color is usually constant
    final primaryColor = AppColors.primary(_isDark);

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is AuthStatusChecked) {
          return;
        }

        setState(() {
          _isLoading = state is LoginLoading;
        });

        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '✅ تم تسجيل الدخول بنجاح',
                textAlign: TextAlign.center,
              ),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => HomeScreen(isDark: false, onThemeChanged: (_) {}),
            ),
          );
        } else if (state is LoginValidationError) {
          setState(() {
            validationErrors = state.errors.map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '⚠️ يرجى تصحيح الأخطاء ',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        // Handle General Failure (401, Network, Unexpected)
        else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ فشل تسجيل الدخول: ${state.errorMessage}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: bgColor, // ✅ تم تصحيح اللون
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(
                vertical: 100,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: cardColor, // ✅ تم تصحيح اللون
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: activeColor,
                    blurRadius: 20,
                    spreadRadius: 3,
                  ), // ✅ تم تصحيح اللون
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.login,
                    size: 60,
                    color: fontColor,
                  ), // ✅ تم تصحيح اللون
                  const SizedBox(height: 15),
                  Text(
                    "تسجيل دخول",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: fontColor, // ✅ تم تصحيح اللون
                    ),
                  ),
                  const SizedBox(height: 30),

                  _phoneField(
                    _phoneController,
                    getErrorForField('phone'),
                    bgColor,
                    fontColor,
                    dangerColor,
                  ),
                  const SizedBox(height: 15),

                  _passwordField(
                    _passwordController,
                    getErrorForField('password'),
                    bgColor,
                    fontColor,
                    dangerColor,
                  ),
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _submitLogin(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            fontColor, // ✅ تم تصحيح اللون (استخدام fontColor للدلالة على اللون الداكن أو الأساسي)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: cardColor,
                            ) // ✅ تم تصحيح اللون (استخدام لون فاتح)
                          : Text(
                              "تسجيل دخول",
                              style: TextStyle(
                                fontSize: 18,
                                color: cardColor, // ✅ تم تصحيح اللون (لون فاتح)
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        // 🚀 هنا يجب إضافة دالة التنقل
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          " إنشاء حساب جديد ",
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryColor, // ✅ استخدام اللون الأساسي
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(" ليس لديك حساب؟ "),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _phoneField(
    TextEditingController controller,
    String? errorText,
    Color bgColor,
    Color fontColor,
    Color dangerColor,
  ) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: fontColor), // إضافة لون الخط
      decoration: InputDecoration(
        hintText: "رقم الهاتف",
        errorText: errorText,
        filled: true,
        fillColor: bgColor, // ✅ تم تصحيح اللون
        suffixIcon: Icon(
          Icons.phone_android,
          color: fontColor,
        ), // ✅ تم تصحيح اللون
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: dangerColor,
            width: 1.5,
          ), // ✅ تم تصحيح اللون
        ),
      ),
    );
  }

  Widget _passwordField(
    TextEditingController controller,
    String? errorText,
    Color bgColor,
    Color fontColor,
    Color dangerColor,
  ) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      obscureText: true,
      style: TextStyle(color: fontColor), // إضافة لون الخط
      decoration: InputDecoration(
        hintText: "كلمة المرور",
        errorText: errorText,
        filled: true,
        fillColor: bgColor, // ✅ تم تصحيح اللون
        suffixIcon: Icon(Icons.lock, color: fontColor), // ✅ تم تصحيح اللون
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: dangerColor,
            width: 1.5,
          ), // ✅ تم تصحيح اللون
        ),
      ),
    );
  }
}
