// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pluto_ui/root_layout.dart';
// import 'package:pluto_ui/business_logic/all_cities_cubit/cubit/all_cities_cubit.dart';
// import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
// import 'package:pluto_ui/business_logic/post_apartment_cubit/cubit/post_apartment_cubit.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/models/city_model.dart';
// import 'package:pluto_ui/data/models/post_apartment_model.dart';

// class AddPropertyScreen extends StatefulWidget {
//   final bool isDark;
//   final VoidCallback? onSuccess;

//   const AddPropertyScreen({super.key, required this.isDark, this.onSuccess});

//   @override
//   State<AddPropertyScreen> createState() => _AddPropertyScreenState();
// }

// class _AddPropertyScreenState extends State<AddPropertyScreen> {
//   final picker = ImagePicker();

//   // Controllers
//   final areaSizeController = TextEditingController();
//   final floorController = TextEditingController();
//   final roomsController = TextEditingController();
//   final priceController = TextEditingController();
//   final descriptionController = TextEditingController();

//   CityModel? selectedCity;
//   File? selectedImage;

//   // Validation state (422 Errors)
//   Map<String, List<String>> validationErrors = {};
//   bool _isLoading = false;

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         selectedImage = File(pickedFile.path);
//         // Clear manual validation error if image is picked
//         validationErrors.remove('photo');
//       });
//     }
//   }

//   // void _submitData() {
//   //   setState(() => validationErrors = {});

//   //   // Basic Local Validation before API call
//   //   if (selectedImage == null) {
//   //     setState(() => validationErrors['photo'] = ["يجب إضافة صورة الشقة"]);
//   //     return;
//   //   }
//   //   if (selectedCity == null) {
//   //     setState(() => validationErrors['city_id'] = ["يجب اختيار المدينة"]);
//   //     return;
//   //   }

//   //   final apartmentModel = PostApartmentModel(
//   //     cityId: selectedCity!.id,
//   //     area: int.tryParse(areaSizeController.text) ?? 0,
//   //     rooms: int.tryParse(roomsController.text) ?? 0,
//   //     description: descriptionController.text.trim(),
//   //     photo: selectedImage!.path,
//   //     price: int.tryParse(priceController.text) ?? 0,
//   //     floor: int.tryParse(floorController.text) ?? 0,
//   //   );

//   //   context.read<PostApartmentCubit>().createApartment(apartmentModel);
//   // }

//   // void _submitData() {
//   //   // Clear previous UI errors before the new request
//   //   setState(() => validationErrors = {});

//   //   final apartmentModel = PostApartmentModel(
//   //     cityId:
//   //         selectedCity?.id ??
//   //         0, // Pass 0 or null so backend triggers 'required'
//   //     area: int.tryParse(areaSizeController.text) ?? 0,
//   //     rooms: int.tryParse(roomsController.text) ?? 0,
//   //     description: descriptionController.text.trim(),
//   //     photo:
//   //         selectedImage?.path ??
//   //         "", // Pass empty so backend triggers 'required'
//   //     price: int.tryParse(priceController.text) ?? -1,
//   //     floor: int.tryParse(floorController.text) ?? -1,
//   //   );

//   //   context.read<PostApartmentCubit>().createApartment(apartmentModel);
//   // }

//   void _submitData() {
//     // Clear previous UI errors before the new request
//     setState(() => validationErrors = {});

//     final apartmentModel = PostApartmentModel(
//       cityId: selectedCity?.id, // Pass 0 or null so backend triggers 'required'
//       area: int.tryParse(areaSizeController.text),
//       rooms: int.tryParse(roomsController.text),
//       description: descriptionController.text.trim(),
//       photo:
//           selectedImage?.path ??
//           "", // Pass empty so backend triggers 'required'
//       price: int.tryParse(priceController.text),
//       floor: int.tryParse(floorController.text),
//     );

//     context.read<PostApartmentCubit>().createApartment(apartmentModel);
//   }

//   String? getErrorForField(String fieldKey) {
//     if (validationErrors.containsKey(fieldKey) &&
//         validationErrors[fieldKey]!.isNotEmpty) {
//       return validationErrors[fieldKey]!.first;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = AppColors.bgMain(widget.isDark);
//     final cardColor = AppColors.bgCard(widget.isDark);
//     final fontColor = AppColors.fontColor(widget.isDark);

//     return BlocListener<PostApartmentCubit, PostApartmentState>(
//       listener: (context, state) {
//         setState(() => _isLoading = state is PostApartmentLoading);

//         if (state is PostApartmentSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               backgroundColor: AppColors.kColorSuccess,
//               content: Text(state.message),
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//           //////
//           context.read<ApartmentCubit>().fetchApartments();
//           // if (mounted) {
//           //   Navigator.of(context).pop();
//           // }
//           // // Navigator.of(context).pop(
//           // //   MaterialPageRoute(
//           // //     builder: (_) => RootLayout(isDark: false, onThemeChanged: (_) {}),
//           // //   ),
//           // // ); // Return after success

//           // Call the callback instead of Navigator.pop()
//           if (widget.onSuccess != null) {
//             widget.onSuccess!();
//           }
//         } else if (state is PostApartmentError) {
//           if (state.error is Map<String, dynamic>) {
//             print("SERVER VALIDATION ERRORS: ${state.error}");
//             setState(() {
//               validationErrors = (state.error as Map<String, dynamic>).map(
//                 (key, value) => MapEntry(key, List<String>.from(value)),
//               );
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor: AppColors.kColorDanger,
//                 // content: Text(state.error.toString()),
//                 content: Text(
//                   'Please correct the mistakes ⚠️',
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             );
//           } else {
//             // General Error (Server down, etc.)
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor: AppColors.kColorDanger,
//                 content: Text(state.error.toString()),
//               ),
//             );
//           }
//         }
//       },
//       child: Scaffold(
//         backgroundColor: bgColor,
//         appBar: AppBar(
//           backgroundColor: cardColor,
//           elevation: 0,
//           centerTitle: true,
//           title: Text(
//             "estate adding",
//             style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Inside your Column in body:
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start, // Align error text to left
//                   children: [
//                     Container(
//                       height: 180,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: cardColor,
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(
//                           // Logic: if there is an error for 'photo', show red border
//                           color: getErrorForField('photo') != null
//                               ? AppColors.kColorDanger
//                               : AppColors.bgActive(widget.isDark),
//                           width: getErrorForField('photo') != null ? 2 : 1,
//                         ),
//                       ),
//                       child: selectedImage == null
//                           ? Center(
//                               child: Icon(
//                                 Icons.add_a_photo,
//                                 size: 50,
//                                 color: fontColor.withOpacity(0.5),
//                               ),
//                             )
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(13),
//                               child: Image.file(
//                                 selectedImage!,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                     ),
//                     if (getErrorForField('photo') != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8, left: 10),
//                         child: Text(
//                           getErrorForField('photo')!,
//                           style: const TextStyle(
//                             color: AppColors.kColorDanger,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 25),

//               // Form Fields
//               _buildDropdownField(),
//               const SizedBox(height: 15),
//               _inputField(
//                 " area size ",
//                 areaSizeController,
//                 Icons.square_foot,
//                 getErrorForField('area'),
//               ),
//               const SizedBox(height: 15),
//               _inputField(
//                 "price",
//                 priceController,
//                 Icons.attach_money,
//                 getErrorForField('price'),
//               ),
//               const SizedBox(height: 15),
//               _inputField(
//                 "floor",
//                 floorController,
//                 Icons.layers,
//                 getErrorForField('floor'),
//               ),
//               const SizedBox(height: 15),
//               _inputField(
//                 "rooms",
//                 roomsController,
//                 Icons.bed,
//                 getErrorForField('rooms'),
//               ),
//               const SizedBox(height: 15),
//               _descriptionField(),

//               const SizedBox(height: 30),

//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _submitData,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.kFontColorDark,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                           "add the estate",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- UI Helpers matching Sign Up Pattern ---

//   Widget _buildDropdownField() {
//     return BlocBuilder<AllCitiesCubit, AllCitiesState>(
//       builder: (context, state) {
//         List<CityModel> cities = (state is AllCitiesLoaded) ? state.cities : [];
//         return DropdownButtonFormField<CityModel>(
//           value: selectedCity,
//           alignment: Alignment.center,
//           decoration: _inputDecoration(
//             "select the city",
//             Icons.location_city,
//             getErrorForField('city_id'),
//           ),
//           dropdownColor: AppColors.bgCard(widget.isDark),
//           items: cities
//               .map(
//                 (city) => DropdownMenuItem(
//                   value: city,
//                   alignment: Alignment.center,
//                   child: Text(
//                     city.name,
//                     style: TextStyle(color: AppColors.fontColor(widget.isDark)),
//                   ),
//                 ),
//               )
//               .toList(),
//           onChanged: (val) => setState(() => selectedCity = val),
//         );
//       },
//     );
//   }

//   Widget _inputField(
//     String label,
//     TextEditingController controller,
//     IconData icon,
//     String? error,
//   ) {
//     return TextField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       textAlign: TextAlign.left,
//       style: TextStyle(color: AppColors.fontColor(widget.isDark)),
//       decoration: _inputDecoration(label, icon, error),
//     );
//   }

//   Widget _descriptionField() {
//     return TextField(
//       controller: descriptionController,
//       maxLines: 4,
//       textAlign: TextAlign.left,
//       style: TextStyle(color: AppColors.fontColor(widget.isDark)),
//       decoration: _inputDecoration(
//         "description",
//         Icons.description,
//         getErrorForField('description'),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(
//     String label,
//     IconData icon,
//     String? errorText,
//   ) {
//     return InputDecoration(
//       hintText: label,
//       errorText: errorText, // This triggers the red text and border
//       prefixIcon: Icon(icon, color: AppColors.kFontColorDark),
//       filled: true,
//       fillColor: AppColors.bgCard(widget.isDark),
//       hintStyle: TextStyle(color: AppColors.hintColor(widget.isDark)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

//       // Default Border
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),

//       // Border when there is an ERROR
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.kColorDanger, width: 1.5),
//       ),

//       // Border when focused AND there is an error
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.kColorDanger, width: 2.0),
//       ),

//       // Styling the error text itself (under the field)
//       errorStyle: const TextStyle(color: AppColors.kColorDanger, fontSize: 12),
//     );
//   }
// }

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

class AddPropertyScreen extends StatefulWidget {
  // 🚨 Removed isDark parameter
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
                content: const Text(
                  'Please correct the mistakes ',
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
            "Estate Adding",
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
                        padding: const EdgeInsets.only(top: 8, left: 10),
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
                "Area size",
                areaSizeController,
                Icons.square_foot,
                getErrorForField('area'),
                theme,
              ),
              const SizedBox(height: 15),
              _inputField(
                "Price",
                priceController,
                Icons.attach_money,
                getErrorForField('price'),
                theme,
              ),
              const SizedBox(height: 15),
              _inputField(
                "Floor",
                floorController,
                Icons.layers,
                getErrorForField('floor'),
                theme,
              ),
              const SizedBox(height: 15),
              _inputField(
                "Rooms",
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
                      : const Text(
                          "Add the estate",
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
            "Select the city",
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
        "Description",
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
