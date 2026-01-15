import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_ui/business_logic/all_cities_cubit/cubit/all_cities_cubit.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/business_logic/post_apartment_cubit/cubit/post_apartment_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/post_apartment_model.dart';
import 'package:easy_localization/easy_localization.dart';

class AddPropertyScreen extends StatefulWidget {
  final VoidCallback? onSuccess;

  const AddPropertyScreen({super.key, this.onSuccess});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final picker = ImagePicker();

  final areaSizeController = TextEditingController();
  final floorController = TextEditingController();
  final roomsController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  CityModel? selectedCity;
  File? selectedImage;

  Map<String, List<String>> validationErrors = {};
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        validationErrors.remove('photo');
      });
    }
  }

  void _submitData() {
    setState(() => validationErrors = {});

    final apartmentModel = PostApartmentModel(
      cityId: selectedCity?.id,
      area: int.tryParse(areaSizeController.text),
      rooms: int.tryParse(roomsController.text),
      description: descriptionController.text.trim(),
      photo: selectedImage?.path ?? "",
      price: int.tryParse(priceController.text),
      floor: int.tryParse(floorController.text),
    );

    context.read<PostApartmentCubit>().createApartment(apartmentModel);
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
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return BlocListener<PostApartmentCubit, PostApartmentState>(
      listener: (context, state) {
        setState(() => _isLoading = state is PostApartmentLoading);

        if (state is PostApartmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.kColorSuccess,
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<ApartmentCubit>().fetchApartments();
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          }
        } else if (state is PostApartmentError) {
          if (state.error is Map<String, dynamic>) {
            setState(() {
              validationErrors = (state.error as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.kColorDanger,
                content: Text(
                  'Please correct the mistakes '.tr(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.kColorDanger,
                content: Text(state.error.toString()),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Estate Adding".tr(),
            style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: fontColor),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: getErrorForField('photo') != null
                              ? AppTheme.kColorDanger
                              : theme.dividerColor,
                          width: getErrorForField('photo') != null ? 2 : 1,
                        ),
                      ),
                      child: selectedImage == null
                          ? Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: fontColor?.withOpacity(0.5),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    if (getErrorForField('photo') != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          top: 8,
                          start: 10,
                        ),
                        child: Text(
                          getErrorForField('photo')!,
                          style: TextStyle(
                            color: AppTheme.kColorDanger,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _buildDropdownField(theme, cardColor, fontColor),
              const SizedBox(height: 15),
              _inputField(
                "Area size".tr(),
                areaSizeController,
                Icons.square_foot,
                getErrorForField('area'),
                theme,
              ),
              const SizedBox(height: 15),
              _inputField(
                "Price".tr(),
                priceController,
                Icons.attach_money,
                getErrorForField('price'),
                theme,
              ),
              const SizedBox(height: 15),
              _inputField(
                "Floor".tr(),
                floorController,
                Icons.layers,
                getErrorForField('floor'),
                theme,
              ),
              const SizedBox(height: 15),
              _inputField(
                "Rooms".tr(),
                roomsController,
                Icons.bed,
                getErrorForField('rooms'),
                theme,
              ),
              const SizedBox(height: 15),
              _descriptionField(theme),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Add the estate".tr(),
                          style: TextStyle(
                            color: Colors.white,
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
    );
  }

  Widget _buildDropdownField(
    ThemeData theme,
    Color cardColor,
    Color? fontColor,
  ) {
    return BlocBuilder<AllCitiesCubit, AllCitiesState>(
      builder: (context, state) {
        List<CityModel> cities = (state is AllCitiesLoaded) ? state.cities : [];
        return DropdownButtonFormField<CityModel>(
          value: selectedCity,
          alignment: Alignment.center,
          decoration: _inputDecoration(
            "Select the city".tr(),
            Icons.location_city,
            getErrorForField('city_id'),
            theme,
          ),
          dropdownColor: cardColor,
          items: cities
              .map(
                (city) => DropdownMenuItem(
                  value: city,
                  alignment: Alignment.center,
                  child: Text(city.name, style: TextStyle(color: fontColor)),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => selectedCity = val),
        );
      },
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    IconData icon,
    String? error,
    ThemeData theme,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: _inputDecoration(label, icon, error, theme),
    );
  }

  Widget _descriptionField(ThemeData theme) {
    return TextField(
      controller: descriptionController,
      maxLines: 4,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: _inputDecoration(
        "Description".tr(),
        Icons.description,
        getErrorForField('description'),
        theme,
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
    String? errorText,
    ThemeData theme,
  ) {
    return InputDecoration(
      hintText: label,
      errorText: errorText,
      prefixIcon: Icon(icon, color: theme.primaryColor),
      filled: true,
      fillColor: theme.cardColor,
      hintStyle: TextStyle(
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.kColorDanger, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.kColorDanger, width: 2.0),
      ),
      errorStyle: TextStyle(color: AppTheme.kColorDanger, fontSize: 12),
    );
  }
}
