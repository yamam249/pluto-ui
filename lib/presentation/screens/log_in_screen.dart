import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';
import 'package:pluto_ui/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

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
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (_) => const HomeScreen()),
          // );
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
        backgroundColor: kBgMain,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(
                vertical: 100,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: kFontColorLight,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: kBgActive, blurRadius: 20, spreadRadius: 3),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.login, size: 60, color: kFontColorDark),
                  const SizedBox(height: 15),
                  Text(
                    "تسجيل دخول",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: kFontColorDark,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _phoneField(_phoneController, getErrorForField('phone')),
                  const SizedBox(height: 15),

                  _passwordField(
                    _passwordController,
                    getErrorForField('password'),
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
                        backgroundColor: kFontColorDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: kFontColorLight)
                          : Text(
                              "تسجيل دخول",
                              style: TextStyle(
                                fontSize: 18,
                                color: kFontColorLight,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          " إنشاء حساب جديد ",
                          style: TextStyle(
                            fontSize: 15,
                            color: kFontColorDark,
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

  Widget _phoneField(TextEditingController controller, String? errorText) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "رقم الهاتف",
        errorText: errorText,
        filled: true,
        fillColor: kBgMain,
        suffixIcon: Icon(Icons.phone_android, color: kFontColorDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kColorDanger, width: 1.5),
        ),
      ),
    );
  }

  Widget _passwordField(TextEditingController controller, String? errorText) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "كلمة المرور",
        errorText: errorText,
        filled: true,
        fillColor: kBgMain,
        suffixIcon: Icon(Icons.lock, color: kFontColorDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kColorDanger, width: 1.5),
        ),
      ),
    );
  }
}
