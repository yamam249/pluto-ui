import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/sign_up_cubit/cubit/sign_up_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/signup_request_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _profileImageController = TextEditingController();
  final _idImageController = TextEditingController();

  //  حالة لتخزين أخطاء التحقق (422)
  Map<String, List<String>> validationErrors = {};
  bool _isLoading = false;

  Future<void> _pickImage(TextEditingController controller) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      controller.text = image.path;
      setState(() {});
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1925),

      lastDate: DateTime(2007),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      _birthDateController.text = formattedDate;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    _profileImageController.dispose();
    _idImageController.dispose();
    super.dispose();
  }

  //  دالة بدء عملية التسجيل
  void _submitSignup(BuildContext context) {
    //  مسح أي أخطاء سابقة
    setState(() {
      validationErrors = {};
    });

    final userRequest = SignupRequestModel(
      phone: _phoneController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      password: _passwordController.text,
      birthDate: _birthDateController.text,
      idImagePath: _idImageController.text,
      profileImagePath: _profileImageController.text,
    );

    BlocProvider.of<SignUpCubit>(context).createNewUser(userRequest);
  }

  //  دالة مساعدة للحصول على رسالة خطأ محددة لحقل معين
  String? getErrorForField(String fieldKey) {
    if (validationErrors.containsKey(fieldKey) &&
        validationErrors[fieldKey]!.isNotEmpty) {
      return validationErrors[fieldKey]!.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is SignUpLoading;
        });

        if (state is SignUpSuccess) {
          // حالة النجاح
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ تم إنشاء الحساب بنجاح ',
                textAlign: TextAlign.center,
              ),
            ),
          );
          // (مثلاً: Navigator.push(...))
        } else if (state is SignUpValidationError) {
          // حالة خطأ التحقق (422)
          setState(() {
            validationErrors = state.errors.map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '⚠️ يرجى تصحيح الأخطاء  ',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is SignUpFailure) {
          // حالة الفشل العام
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ فشل التسجيل', textAlign: TextAlign.center),
            ),
          );
        }
      },
      child: Scaffold(
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
                  const SizedBox(height: 10),
                  Text(
                    "إنشاء حساب",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _inputField(
                    "الاسم الأول",
                    _firstNameController,
                    getErrorForField('first_name'),
                  ),
                  const SizedBox(height: 15),
                  _inputField(
                    "الاسم الأخير",
                    _lastNameController,
                    getErrorForField('last_name'),
                  ),
                  const SizedBox(height: 15),
                  _phoneField(_phoneController, getErrorForField('phone')),
                  const SizedBox(height: 15),
                  _dateField(
                    "تاريخ الميلاد",
                    _birthDateController,
                    getErrorForField('birth_date'),
                  ),
                  const SizedBox(height: 15),

                  _photoPathField(
                    icon: Icons.camera_alt,
                    label: "صورة شخصية",
                    controller: _profileImageController,
                    errorText: getErrorForField('profile_image'),
                  ),
                  const SizedBox(height: 15),
                  _photoPathField(
                    icon: Icons.badge,
                    label: "صورة الهوية",
                    controller: _idImageController,
                    errorText: getErrorForField('id_image'),
                  ),
                  const SizedBox(height: 15),

                  _passwordField(
                    _passwordController,
                    getErrorForField('password'),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _submitSignup(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.pureWhite,
                            )
                          : const Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.pureWhite,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {},
                  //       child: Text(
                  //         "تسجيل دخول",
                  //         style: TextStyle(
                  //           color: AppColors.darkBlue,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //     const Text("لديك حساب؟ "),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    String? errorText,
  ) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: label,
        errorText: errorText,
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.brightRed, width: 1.5),
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
        hintText: "رقم الموبايل",
        errorText: errorText,
        filled: true,
        fillColor: AppColors.lightGrey,
        suffixIcon: Icon(Icons.phone_android, color: AppColors.navyBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.brightRed, width: 1.5),
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
        hintText: " كلمة المرور",
        errorText: errorText,
        filled: true,
        fillColor: AppColors.lightGrey,
        suffixIcon: const Icon(Icons.lock, color: AppColors.navyBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.brightRed, width: 1.5),
        ),
      ),
    );
  }

  Widget _dateField(
    String label,
    TextEditingController controller,
    String? errorText,
  ) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        hintText: label,
        errorText: errorText,
        filled: true,
        fillColor: AppColors.lightGrey,
        suffixIcon: Icon(Icons.calendar_today, color: AppColors.navyBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.brightRed, width: 1.5),
        ),
      ),
    );
  }

  Widget _photoPathField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      readOnly: true,
      decoration: InputDecoration(
        hintText: label,
        errorText: errorText,
        filled: true,
        fillColor: AppColors.lightGrey,
        prefixIcon: Icon(icon, color: AppColors.navyBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.brightRed, width: 1.5),
        ),
      ),
      onTap: () => _pickImage(controller),
    );
  }
}
