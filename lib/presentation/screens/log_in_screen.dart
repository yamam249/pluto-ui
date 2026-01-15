// import 'package:flutter/material.dart';
// import 'package:pluto_ui/root_layout.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;

//   // 💡 افتراض أن هذه الشاشة تستخدم الوضع الفاتح كإعداد افتراضي
//   bool get _isDark => false;

//   Map<String, List<String>> validationErrors = {};

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   String? getErrorForField(String fieldKey) {
//     if (validationErrors.containsKey(fieldKey) &&
//         validationErrors[fieldKey]!.isNotEmpty) {
//       return validationErrors[fieldKey]!.first;
//     }
//     return null;
//   }

//   // Login Submission Method
//   void _submitLogin(BuildContext context) {
//     setState(() {
//       validationErrors = {};
//     });

//     final phone = _phoneController.text.trim();
//     final password = _passwordController.text;

//     BlocProvider.of<LoginCubit>(context).loginUser(phone, password);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // تحديد الألوان بناءً على الوضع الافتراضي (_isDark)
//     final bgColor = AppColors.bgMain(_isDark);
//     final cardColor = AppColors.bgCard(_isDark);
//     final fontColor = AppColors.fontColor(_isDark);
//     final activeColor = AppColors.bgActive(_isDark);
//     final dangerColor =
//         AppColors.kColorDanger; // Danger color is usually constant
//     final primaryColor = AppColors.primary(_isDark);

//     return BlocListener<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state is AuthStatusChecked) {
//           return;
//         }

//         setState(() {
//           _isLoading = state is LoginLoading;
//         });

//         if (state is LoginSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               behavior: SnackBarBehavior.floating,

//               backgroundColor: AppColors.kColorSuccess,

//               content: Text(
//                 ' successful log in ✅',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );

//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (_) => RootLayout(isDark: false, onThemeChanged: (_) {}),
//             ),
//           );
//         } else if (state is LoginValidationError) {
//           setState(() {
//             validationErrors = state.errors.map(
//               (key, value) => MapEntry(key, List<String>.from(value)),
//             );
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               behavior: SnackBarBehavior.floating,

//               backgroundColor: AppColors.kColorDanger,

//               content: Text(
//                 'correct the mistakes, please ⚠️ ',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//         }
//         // Handle General Failure (401, Network, Unexpected)
//         else if (state is LoginFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               behavior: SnackBarBehavior.floating,

//               backgroundColor: AppColors.kColorDanger,

//               content: Text(
//                 ' the log in has failed ❌ ',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//           print(state.errorMessage);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: bgColor, // ✅ تم تصحيح اللون
//         body: Center(
//           child: SingleChildScrollView(
//             child: Container(
//               width: 350,
//               padding: const EdgeInsets.symmetric(
//                 vertical: 100,
//                 horizontal: 20,
//               ),
//               decoration: BoxDecoration(
//                 color: cardColor, // ✅ تم تصحيح اللون
//                 borderRadius: BorderRadius.circular(25),
//                 boxShadow: [
//                   BoxShadow(
//                     color: activeColor,
//                     blurRadius: 20,
//                     spreadRadius: 3,
//                   ), // ✅ تم تصحيح اللون
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.login,
//                     size: 60,
//                     color: fontColor,
//                   ), // ✅ تم تصحيح اللون
//                   const SizedBox(height: 15),
//                   Text(
//                     "log in",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: fontColor, // ✅ تم تصحيح اللون
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   _phoneField(
//                     _phoneController,
//                     getErrorForField('phone'),
//                     bgColor,
//                     fontColor,
//                     dangerColor,
//                   ),
//                   const SizedBox(height: 15),

//                   _passwordField(
//                     _passwordController,
//                     getErrorForField('password'),
//                     bgColor,
//                     fontColor,
//                     dangerColor,
//                   ),
//                   const SizedBox(height: 25),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: _isLoading
//                           ? null
//                           : () => _submitLogin(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             fontColor, // ✅ تم تصحيح اللون (استخدام fontColor للدلالة على اللون الداكن أو الأساسي)
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: _isLoading
//                           ? CircularProgressIndicator(
//                               color: cardColor,
//                             ) // ✅ تم تصحيح اللون (استخدام لون فاتح)
//                           : Text(
//                               " log in",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: cardColor, // ✅ تم تصحيح اللون (لون فاتح)
//                               ),
//                             ),
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Don't you have an account ?"),

//                       GestureDetector(
//                         // 🚀 هنا يجب إضافة دالة التنقل
//                         onTap: () {
//                           Navigator.pushNamed(context, '/signup');
//                         },
//                         child: Text(
//                           " create a new account ",
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: primaryColor, // ✅ استخدام اللون الأساسي
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _phoneField(
//     TextEditingController controller,
//     String? errorText,
//     Color bgColor,
//     Color fontColor,
//     Color dangerColor,
//   ) {
//     return TextField(
//       controller: controller,
//       textAlign: TextAlign.left,
//       keyboardType: TextInputType.phone,
//       style: TextStyle(color: fontColor), // إضافة لون الخط
//       decoration: InputDecoration(
//         hintText: " phone number",
//         errorText: errorText,
//         filled: true,
//         fillColor: bgColor, // ✅ تم تصحيح اللون
//         prefixIcon: Icon(
//           Icons.phone_android,
//           color: fontColor,
//         ), // ✅ تم تصحيح اللون
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: dangerColor,
//             width: 1.5,
//           ), // ✅ تم تصحيح اللون
//         ),
//       ),
//     );
//   }

//   Widget _passwordField(
//     TextEditingController controller,
//     String? errorText,
//     Color bgColor,
//     Color fontColor,
//     Color dangerColor,
//   ) {
//     return TextField(
//       controller: controller,
//       textAlign: TextAlign.left,
//       obscureText: true,
//       style: TextStyle(color: fontColor), // إضافة لون الخط
//       decoration: InputDecoration(
//         hintText: "password ",
//         errorText: errorText,
//         filled: true,
//         fillColor: bgColor, // ✅ تم تصحيح اللون
//         prefixIcon: Icon(Icons.lock, color: fontColor), // ✅ تم تصحيح اللون
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: dangerColor,
//             width: 1.5,
//           ), // ✅ تم تصحيح اللون
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/root_layout.dart';
import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart'; // Ensure correct import
import 'package:easy_localization/easy_localization.dart';


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
    // 🎨 Dynamic Theme values
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is AuthStatusChecked) return;

        setState(() {
          _isLoading = state is LoginLoading;
        });

        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorSuccess,
              content: Text('Successful log in '.tr(), textAlign: TextAlign.center),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RootLayout()),
          );
        } else if (state is LoginValidationError) {
          setState(() {
            validationErrors = state.errors.map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorDanger,
              content: Text(
                'Correct the mistakes, please '.tr(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorDanger,
              content: Text(
                'The log in has failed '.tr(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black54 : Colors.black12,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.login_rounded,
                    size: 70,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Welcome Back".tr(),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: fontColor,
                    ),
                  ),
                  const SizedBox(height: 35),

                  _buildTextField(
                    theme: theme,
                    controller: _phoneController,
                    label: "Phone Number".tr(),
                    icon: Icons.phone_android,
                    errorText: getErrorForField('phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    theme: theme,
                    controller: _passwordController,
                    label: "Password".tr(),
                    icon: Icons.lock,
                    errorText: getErrorForField('password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _submitLogin(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          :  Text(
                              "Login".tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ".tr(),
                        style: TextStyle(color: fontColor?.withOpacity(0.7)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Register Now".tr(),
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildTextField({
    required ThemeData theme,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: theme.hintColor),
        errorText: errorText,
        filled: true,
        fillColor: theme.brightness == Brightness.light
            ? theme.scaffoldBackgroundColor
            : theme.colorScheme.surface,
        prefixIcon: Icon(icon, color: theme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.kColorDanger, width: 1.5),
        ),
      ),
    );
  }
}
