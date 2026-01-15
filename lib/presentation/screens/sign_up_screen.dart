import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/sign_up_cubit/cubit/sign_up_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/signup_request_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pluto_ui/presentation/screens/log_in_screen.dart';
import 'package:easy_localization/easy_localization.dart';

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

  void _submitSignup(BuildContext context) {
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

  String? getErrorForField(String fieldKey) {
    if (validationErrors.containsKey(fieldKey) &&
        validationErrors[fieldKey]!.isNotEmpty) {
      return validationErrors[fieldKey]!.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is SignUpLoading;
        });

        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorSuccess,
              content: Text(
                'Successful account creation ',
                textAlign: TextAlign.center,
              ),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (state is SignUpValidationError) {
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
                'Correct the mistakes '.tr(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorDanger,
              content: Text(
                'Registration failed '.tr(),
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
              margin: const EdgeInsets.symmetric(vertical: 40),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black45 : Colors.black12,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.person_add_rounded,
                    size: 70,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Create Account".tr(),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: fontColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _inputField(
                    theme,
                    "First Name".tr(),
                    _firstNameController,
                    getErrorForField('first_name'),
                  ),
                  const SizedBox(height: 15),
                  _inputField(
                    theme,
                    "Last Name".tr(),
                    _lastNameController,
                    getErrorForField('last_name'),
                  ),
                  const SizedBox(height: 15),
                  _phoneField(
                    theme,
                    _phoneController,
                    getErrorForField('phone'),
                  ),
                  const SizedBox(height: 15),
                  _dateField(
                    theme,
                    "Birth Date".tr(),
                    _birthDateController,
                    getErrorForField('birth_date'),
                  ),
                  const SizedBox(height: 15),
                  _photoPathField(
                    theme: theme,
                    icon: Icons.camera_alt,
                    label: "Profile Photo".tr(),
                    controller: _profileImageController,
                    errorText: getErrorForField('profile_image'),
                  ),
                  const SizedBox(height: 15),
                  _photoPathField(
                    theme: theme,
                    icon: Icons.badge,
                    label: "ID Photo".tr(),
                    controller: _idImageController,
                    errorText: getErrorForField('id_image'),
                  ),
                  const SizedBox(height: 15),
                  _passwordField(
                    theme,
                    _passwordController,
                    getErrorForField('password'),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _submitSignup(context),
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
                          : Text(
                              "Sign Up".tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    ThemeData theme,
    String label,
    TextEditingController controller,
    String? errorText,
  ) {
    return TextField(
      controller: controller,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: _inputDecoration(theme, label, null, errorText),
    );
  }

  Widget _phoneField(
    ThemeData theme,
    TextEditingController controller,
    String? errorText,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: _inputDecoration(
        theme,
        "Phone Number".tr(),
        Icons.phone_android,
        errorText,
      ),
    );
  }

  Widget _passwordField(
    ThemeData theme,
    TextEditingController controller,
    String? errorText,
  ) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: _inputDecoration(
        theme,
        "Password".tr(),
        Icons.lock,
        errorText,
      ),
    );
  }

  Widget _dateField(
    ThemeData theme,
    String label,
    TextEditingController controller,
    String? errorText,
  ) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: _inputDecoration(
        theme,
        label,
        Icons.calendar_today,
        errorText,
      ),
    );
  }

  Widget _photoPathField({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickImage(controller),
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: _inputDecoration(theme, label, icon, errorText),
    );
  }

  // Common decoration for all fields
  InputDecoration _inputDecoration(
    ThemeData theme,
    String label,
    IconData? icon,
    String? errorText,
  ) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: theme.hintColor),
      errorText: errorText,
      filled: true,
      fillColor: theme.brightness == Brightness.light
          ? theme.scaffoldBackgroundColor
          : theme.colorScheme.surface,
      prefixIcon: icon != null ? Icon(icon, color: theme.primaryColor) : null,
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
    );
  }
}
