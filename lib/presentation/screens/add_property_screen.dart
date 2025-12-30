// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/all_cities_cubit/cubit/all_cities_cubit.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:pluto_ui/data/models/city_model.dart';

// class AddPropertyScreen extends StatefulWidget {
//   final bool isDark;

//   const AddPropertyScreen({super.key, required this.isDark});

//   @override
//   State<AddPropertyScreen> createState() => _AddPropertyScreenState();
// }

// class _AddPropertyScreenState extends State<AddPropertyScreen> {
//   File? selectedImage;
//   final picker = ImagePicker();
//   CityModel? selectedCity;
//   final areaSizeController = TextEditingController();
//   final floorController = TextEditingController();
//   final roomsController = TextEditingController();
//   final descriptionController = TextEditingController();

//   Future pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   void validateAndSubmit() {
//     if (selectedImage == null) return showError("يجب إضافة صورة الشقة");
//     if (selectedCity == null) return showError("يجب اختيار المدينة");
//     if (areaSizeController.text.trim().isEmpty)
//       return showError("يجب إدخال المساحة");
//     if (floorController.text.trim().isEmpty)
//       return showError("يجب إدخال الطابق");
//     if (roomsController.text.trim().isEmpty)
//       return showError("يجب إدخال عدد الغرف");
//     if (descriptionController.text.trim().isEmpty)
//       return showError("يجب إدخال وصف الشقة");
//     showSuccess("تمت إضافة الشقة بنجاح");
//   }

//   void showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: AppColors.kColorDanger, // 🛑 تم التصحيح
//         content: Text(message, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }

//   void showSuccess(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: AppColors.kColorSuccess, // 🛑 تم التصحيح
//         content: Text(message, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = AppColors.bgMain(widget.isDark);
//     final cardColor = AppColors.bgCard(widget.isDark);
//     final appBarBg = AppColors.bgCard(widget.isDark);
//     final hintColor = AppColors.hintColor(widget.isDark);

//     // Define a reusable border style
//     final customBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(
//         color: AppColors.bgActive(widget.isDark), // Default border color
//         width: 1.5,
//       ),
//     );

//     final activeBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(
//         color: AppColors.kFontColorDark, // Color when focused/active
//         width: 2.0,
//       ),
//     );

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: appBarBg,
//         elevation: 0,
//         title: Text(
//           "إضافة شقة",
//           style: TextStyle(
//             color: AppColors.fontColor(widget.isDark),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: pickImage,
//               child: Container(
//                 height: 180,
//                 decoration: BoxDecoration(
//                   color: cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.bgActive(widget.isDark)),
//                 ),
//                 child: selectedImage == null
//                     ? Center(
//                         child: Icon(
//                           Icons.add_a_photo,
//                           size: 40,
//                           color: hintColor,
//                         ),
//                       )
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(
//                           selectedImage!,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             _label("المنطقة / المدينة"),
//             const SizedBox(height: 8),
//             BlocBuilder<AllCitiesCubit, AllCitiesState>(
//               builder: (context, state) {
//                 if (state is AllCitiesLoading) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: LinearProgressIndicator(
//                       color: AppColors.kFontColorDark, // Progress bar color
//                       backgroundColor: AppColors.bgActive(widget.isDark),
//                       minHeight: 4,
//                     ),
//                   );
//                 }

//                 List<CityModel> cities = [];
//                 if (state is AllCitiesLoaded) {
//                   cities = state.cities;
//                 }

//                 return DropdownButtonFormField<CityModel>(
//                   value: selectedCity,
//                   alignment: Alignment.center,
//                   isExpanded: true,
//                   items: cities.map((city) {
//                     return DropdownMenuItem(
//                       value: city,
//                       alignment: Alignment.center,
//                       child: Text(
//                         city.name,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: AppColors.fontColor(widget.isDark),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (val) {
//                     setState(() => selectedCity = val);
//                   },
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: cardColor,
//                     hintText: state is AllCitiesError
//                         ? "خطأ في تحميل المدن"
//                         : "اختر المدينة",
//                     hintStyle: TextStyle(color: hintColor),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     enabledBorder: customBorder,
//                     focusedBorder: activeBorder,
//                     border: customBorder,
//                   ),
//                   dropdownColor: cardColor,
//                 );
//               },
//             ),
//             const SizedBox(height: 14),
//             _label("المساحة (م²)"),
//             _input(
//               areaSizeController,
//               "مثال: 120",
//               cardColor,
//               hintColor,
//               customBorder,
//               activeBorder,
//             ),
//             const SizedBox(height: 14),
//             _label("الطابق"),
//             _input(
//               floorController,
//               "مثال: 3",
//               cardColor,
//               hintColor,
//               customBorder,
//               activeBorder,
//             ),
//             const SizedBox(height: 14),
//             _label("عدد الغرف"),
//             _input(
//               roomsController,
//               "مثال: 4",
//               cardColor,
//               hintColor,
//               customBorder,
//               activeBorder,
//             ),
//             const SizedBox(height: 14),
//             _label("الوصف"),
//             TextField(
//               controller: descriptionController,
//               maxLines: 5,
//               style: TextStyle(color: AppColors.fontColor(widget.isDark)),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: cardColor,
//                 hintText: "أدخل وصف الشقة...",
//                 hintStyle: TextStyle(color: hintColor),
//                 enabledBorder: customBorder,
//                 focusedBorder: activeBorder,
//                 border: customBorder,
//               ),
//             ),
//             const SizedBox(height: 25),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kPrimaryColor, // 🛑 تم التصحيح
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: validateAndSubmit,
//                 child: const Text(
//                   "إضافة الشقة",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _label(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         color: AppColors.fontColor(widget.isDark),
//         fontWeight: FontWeight.bold,
//         fontSize: 16,
//       ),
//     );
//   }

//   Widget _input(
//     TextEditingController controller,
//     String hint,
//     Color bgColor,
//     Color hintColor,
//     InputBorder normalBorder,
//     InputBorder focusBorder,
//   ) {
//     return TextField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       style: TextStyle(color: AppColors.fontColor(widget.isDark)),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: bgColor,
//         hintText: hint,
//         hintStyle: TextStyle(color: hintColor),
//         enabledBorder: normalBorder,
//         focusedBorder: focusBorder,
//         border: normalBorder,
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_ui/root_layout.dart';
import 'package:pluto_ui/business_logic/all_cities_cubit/cubit/all_cities_cubit.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/business_logic/post_apartment_cubit/cubit/post_apartment_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/post_apartment_model.dart';

class AddPropertyScreen extends StatefulWidget {
  final bool isDark;

  const AddPropertyScreen({super.key, required this.isDark});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final picker = ImagePicker();

  // Controllers
  final areaSizeController = TextEditingController();
  final floorController = TextEditingController();
  final roomsController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  CityModel? selectedCity;
  File? selectedImage;

  // Validation state (422 Errors)
  Map<String, List<String>> validationErrors = {};
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        // Clear manual validation error if image is picked
        validationErrors.remove('photo');
      });
    }
  }

  // void _submitData() {
  //   setState(() => validationErrors = {});

  //   // Basic Local Validation before API call
  //   if (selectedImage == null) {
  //     setState(() => validationErrors['photo'] = ["يجب إضافة صورة الشقة"]);
  //     return;
  //   }
  //   if (selectedCity == null) {
  //     setState(() => validationErrors['city_id'] = ["يجب اختيار المدينة"]);
  //     return;
  //   }

  //   final apartmentModel = PostApartmentModel(
  //     cityId: selectedCity!.id,
  //     area: int.tryParse(areaSizeController.text) ?? 0,
  //     rooms: int.tryParse(roomsController.text) ?? 0,
  //     description: descriptionController.text.trim(),
  //     photo: selectedImage!.path,
  //     price: int.tryParse(priceController.text) ?? 0,
  //     floor: int.tryParse(floorController.text) ?? 0,
  //   );

  //   context.read<PostApartmentCubit>().createApartment(apartmentModel);
  // }

  // void _submitData() {
  //   // Clear previous UI errors before the new request
  //   setState(() => validationErrors = {});

  //   final apartmentModel = PostApartmentModel(
  //     cityId:
  //         selectedCity?.id ??
  //         0, // Pass 0 or null so backend triggers 'required'
  //     area: int.tryParse(areaSizeController.text) ?? 0,
  //     rooms: int.tryParse(roomsController.text) ?? 0,
  //     description: descriptionController.text.trim(),
  //     photo:
  //         selectedImage?.path ??
  //         "", // Pass empty so backend triggers 'required'
  //     price: int.tryParse(priceController.text) ?? -1,
  //     floor: int.tryParse(floorController.text) ?? -1,
  //   );

  //   context.read<PostApartmentCubit>().createApartment(apartmentModel);
  // }

  void _submitData() {
    // Clear previous UI errors before the new request
    setState(() => validationErrors = {});

    final apartmentModel = PostApartmentModel(
      cityId: selectedCity?.id, // Pass 0 or null so backend triggers 'required'
      area: int.tryParse(areaSizeController.text),
      rooms: int.tryParse(roomsController.text),
      description: descriptionController.text.trim(),
      photo:
          selectedImage?.path ??
          "", // Pass empty so backend triggers 'required'
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
    final bgColor = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);

    return BlocListener<PostApartmentCubit, PostApartmentState>(
      listener: (context, state) {
        setState(() => _isLoading = state is PostApartmentLoading);

        if (state is PostApartmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.kColorSuccess,
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
          //////
          context.read<ApartmentCubit>().fetchApartments();
          if (mounted) {
            Navigator.of(context).pop();
          }
          // Navigator.of(context).pop(
          //   MaterialPageRoute(
          //     builder: (_) => RootLayout(isDark: false, onThemeChanged: (_) {}),
          //   ),
          // ); // Return after success
        } else if (state is PostApartmentError) {
          if (state.error is Map<String, dynamic>) {
            print("SERVER VALIDATION ERRORS: ${state.error}");
            setState(() {
              validationErrors = (state.error as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.kColorDanger,
                // content: Text(state.error.toString()),
                content: Text(
                  'Please correct the mistakes ⚠️',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            // General Error (Server down, etc.)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.kColorDanger,
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
            "estate adding",
            style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Inside your Column in body:
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align error text to left
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          // Logic: if there is an error for 'photo', show red border
                          color: getErrorForField('photo') != null
                              ? AppColors.kColorDanger
                              : AppColors.bgActive(widget.isDark),
                          width: getErrorForField('photo') != null ? 2 : 1,
                        ),
                      ),
                      child: selectedImage == null
                          ? Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: fontColor.withOpacity(0.5),
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
                        padding: const EdgeInsets.only(top: 8, left: 10),
                        child: Text(
                          getErrorForField('photo')!,
                          style: const TextStyle(
                            color: AppColors.kColorDanger,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Form Fields
              _buildDropdownField(),
              const SizedBox(height: 15),
              _inputField(
                " area size ",
                areaSizeController,
                Icons.square_foot,
                getErrorForField('area'),
              ),
              const SizedBox(height: 15),
              _inputField(
                "price",
                priceController,
                Icons.attach_money,
                getErrorForField('price'),
              ),
              const SizedBox(height: 15),
              _inputField(
                "floor",
                floorController,
                Icons.layers,
                getErrorForField('floor'),
              ),
              const SizedBox(height: 15),
              _inputField(
                "rooms",
                roomsController,
                Icons.bed,
                getErrorForField('rooms'),
              ),
              const SizedBox(height: 15),
              _descriptionField(),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kFontColorDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "add the estate",
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

  // --- UI Helpers matching Sign Up Pattern ---

  Widget _buildDropdownField() {
    return BlocBuilder<AllCitiesCubit, AllCitiesState>(
      builder: (context, state) {
        List<CityModel> cities = (state is AllCitiesLoaded) ? state.cities : [];
        return DropdownButtonFormField<CityModel>(
          value: selectedCity,
          alignment: Alignment.center,
          decoration: _inputDecoration(
            "select the city",
            Icons.location_city,
            getErrorForField('city_id'),
          ),
          dropdownColor: AppColors.bgCard(widget.isDark),
          items: cities
              .map(
                (city) => DropdownMenuItem(
                  value: city,
                  alignment: Alignment.center,
                  child: Text(
                    city.name,
                    style: TextStyle(color: AppColors.fontColor(widget.isDark)),
                  ),
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
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.left,
      style: TextStyle(color: AppColors.fontColor(widget.isDark)),
      decoration: _inputDecoration(label, icon, error),
    );
  }

  Widget _descriptionField() {
    return TextField(
      controller: descriptionController,
      maxLines: 4,
      textAlign: TextAlign.left,
      style: TextStyle(color: AppColors.fontColor(widget.isDark)),
      decoration: _inputDecoration(
        "description",
        Icons.description,
        getErrorForField('description'),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
    String? errorText,
  ) {
    return InputDecoration(
      hintText: label,
      errorText: errorText, // This triggers the red text and border
      prefixIcon: Icon(icon, color: AppColors.kFontColorDark),
      filled: true,
      fillColor: AppColors.bgCard(widget.isDark),
      hintStyle: TextStyle(color: AppColors.hintColor(widget.isDark)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

      // Default Border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      // Border when there is an ERROR
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.kColorDanger, width: 1.5),
      ),

      // Border when focused AND there is an error
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.kColorDanger, width: 2.0),
      ),

      // Styling the error text itself (under the field)
      errorStyle: const TextStyle(color: AppColors.kColorDanger, fontSize: 12),
    );
  }
}
