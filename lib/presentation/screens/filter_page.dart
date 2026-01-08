// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/filter_cubit/cubit/filter_cubit.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
// import 'package:pluto_ui/data/models/city_model.dart';
// import 'package:pluto_ui/data/models/governorate_model.dart';
// import 'package:pluto_ui/data/repositories/apartment_repo.dart';
// import 'package:pluto_ui/data/web_services/apartment_api.dart';

// class FilterPage extends StatefulWidget {
//   final bool isDark;

//   const FilterPage({super.key, required this.isDark});

//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   GovernorateModel? selectedGovernorate;

//   CityModel? selectedCity;
//   List<CityModel> currentCities = [];
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController areaSizeController = TextEditingController();
//   final TextEditingController roomsController = TextEditingController();

//   void _resetFilters() {
//     setState(() {
//       selectedGovernorate = null;
//       selectedCity = null; // Clear selection
//       currentCities = []; // Clear list
//       priceController.clear();
//       areaSizeController.clear();
//       roomsController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bg = AppColors.bgMain(widget.isDark);
//     final card = AppColors.bgCard(widget.isDark);
//     final fontColor = AppColors.fontColor(widget.isDark);
//     final subColor = AppColors.subFontColor(widget.isDark);

//     InputDecoration inputDec(String hint) => InputDecoration(
//       filled: true,
//       fillColor: card,
//       hintText: hint,
//       hintStyle: TextStyle(color: subColor),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: AppColors.kFontColorDark,
//           width: 2.0,
//         ),
//       ),
//       // The border when the field is enabled but not focused
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//     );

//     return BlocProvider(
//       create: (context) =>
//           FilterCubit(ApartmentRepo(ApartmentApi(), SecureStorageService()))
//             ..getGovernorates(),
//       child: Scaffold(
//         backgroundColor: bg,
//         appBar: AppBar(
//           backgroundColor: card,
//           elevation: 0,
//           centerTitle: true,
//           title: Text(
//             "Filters",
//             style: TextStyle(
//               color: fontColor,
//               fontSize: 22,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           iconTheme: IconThemeData(color: fontColor),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: ListView(
//             children: [
//               Text(
//                 "governorate",
//                 style: TextStyle(
//                   color: subColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               BlocBuilder<FilterCubit, FilterState>(
//                 builder: (context, state) {
//                   List<GovernorateModel> govsToShow = [];
//                   if (state is FilterGovernoratesLoaded)
//                     govsToShow = state.governorates;
//                   if (state is FilterLoadingCities)
//                     govsToShow = state.governorates;
//                   if (state is FilterCitiesLoaded)
//                     govsToShow = state.governorates;

//                   if (state is FilterLoadingGovernorates) {
//                     return const Center(
//                       child: LinearProgressIndicator(
//                         color: AppColors.kFontColorDark,
//                         backgroundColor: AppColors.kBgActive,
//                         minHeight: 2,
//                       ),
//                     );
//                   }

//                   return DropdownButtonFormField<GovernorateModel>(
//                     dropdownColor: AppColors.bgCard(widget.isDark),
//                     decoration: inputDec("Select governorate"),
//                     value: selectedGovernorate,
//                     alignment: Alignment.center,

//                     items: govsToShow.map((gov) {
//                       return DropdownMenuItem(
//                         value: gov,
//                         alignment: Alignment.center,

//                         child: Text(gov.name),
//                       );
//                     }).toList(),
//                     onChanged: (val) {
//                       setState(() {
//                         selectedGovernorate = val;
//                         selectedCity =
//                             null; // Reset city when governorate changes
//                         currentCities = [];
//                       });
//                       if (val != null) {
//                         context.read<FilterCubit>().getCities(val.id);
//                       }
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "City",
//                 style: TextStyle(
//                   color: subColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               BlocConsumer<FilterCubit, FilterState>(
//                 listener: (context, state) {
//                   if (state is FilterCitiesLoaded) {
//                     setState(() => currentCities = state.cities);
//                   }
//                 },
//                 builder: (context, state) {
//                   // 1. Determine if we are in a "No Cities Found" state
//                   final bool noCitiesFound =
//                       state is FilterCitiesLoaded && currentCities.isEmpty;

//                   // 2. Determine the hint text based on the state
//                   String hintText = "Select city";
//                   if (selectedGovernorate == null) {
//                     hintText = "Select a governorate first";
//                   } else if (noCitiesFound) {
//                     hintText = "No cities found";
//                   }

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       DropdownButtonFormField<CityModel>(
//                         dropdownColor: AppColors.bgCard(widget.isDark),

//                         // Dynamically change the decoration hint
//                         decoration: inputDec(hintText),
//                         value: selectedCity,
//                         alignment: Alignment.center,

//                         // The text shown when the dropdown is disabled
//                         disabledHint: Text(
//                           hintText,
//                           style: TextStyle(color: subColor.withOpacity(0.5)),
//                         ),
//                         items: currentCities.map((city) {
//                           return DropdownMenuItem(
//                             value: city,
//                             alignment: Alignment.center,

//                             child: Text(city.name),
//                           );
//                         }).toList(),
//                         // Disable if no governorate selected OR if no cities were found
//                         onChanged:
//                             (selectedGovernorate == null || noCitiesFound)
//                             ? null
//                             : (val) {
//                                 setState(() => selectedCity = val);
//                               },
//                       ),

//                       // Show the loading indicator when fetching
//                       if (state is FilterLoadingCities)
//                         const Padding(
//                           padding: EdgeInsets.only(top: 8.0),
//                           child: LinearProgressIndicator(
//                             color: AppColors.kFontColorDark,
//                             backgroundColor: AppColors.kBgActive,
//                             minHeight: 2,
//                           ),
//                         ),

//                       // 3. Show a small error message under the field if cities list is empty
//                       if (noCitiesFound)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0, left: 4.0),
//                           child: Text(
//                             "We couldn't find any cities for ${selectedGovernorate?.name}.",
//                             style: TextStyle(
//                               color: AppColors.kColorDanger,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),

//               const SizedBox(height: 20),
//               Text(
//                 "Price",
//                 style: TextStyle(
//                   color: subColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: inputDec("Enter price"),
//                 style: TextStyle(color: fontColor),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Area Size (m²)",
//                 style: TextStyle(
//                   color: subColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: areaSizeController,
//                 keyboardType: TextInputType.number,
//                 decoration: inputDec("Enter area size"),
//                 style: TextStyle(color: fontColor),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Rooms",
//                 style: TextStyle(
//                   color: subColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: roomsController,
//                 keyboardType: TextInputType.number,
//                 decoration: inputDec("Enter number of rooms"),
//                 style: TextStyle(color: fontColor),
//               ),
//               const SizedBox(height: 30),

//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: AppColors.primary(widget.isDark)),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 onPressed: _resetFilters,
//                 child: Text(
//                   "Clear All",
//                   style: TextStyle(
//                     color: AppColors.primary(widget.isDark),
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary(widget.isDark),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),

//                 // onPressed: (){} => Navigator.pop(context),
//                 onPressed: () {
//                   final Map<String, dynamic> filterResult = {
//                     if (selectedGovernorate != null)
//                       'governorate_id': selectedGovernorate!.id,

//                     if (selectedCity != null) 'city_id': selectedCity!.id,
//                     if (priceController.text.isNotEmpty)
//                       'price': int.tryParse(priceController.text),
//                     if (areaSizeController.text.isNotEmpty)
//                       'area': int.tryParse(areaSizeController.text),
//                     if (roomsController.text.isNotEmpty)
//                       'rooms': int.tryParse(roomsController.text),
//                   };

//                   // Return the Map to the HomeScreen
//                   Navigator.pop(context, filterResult);
//                 },
//                 child: const Text(
//                   "Apply Filters",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/filter_cubit/cubit/filter_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/governorate_model.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';
import 'package:pluto_ui/data/web_services/apartment_api.dart';

class FilterPage extends StatefulWidget {
  // 🚨 Removed isDark parameter
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  GovernorateModel? selectedGovernorate;
  CityModel? selectedCity;
  List<CityModel> currentCities = [];
  final TextEditingController priceController = TextEditingController();
  final TextEditingController areaSizeController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();

  void _resetFilters() {
    setState(() {
      selectedGovernorate = null;
      selectedCity = null;
      currentCities = [];
      priceController.clear();
      areaSizeController.clear();
      roomsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
    final subColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.6);

    InputDecoration inputDec(String hint) => InputDecoration(
      filled: true,
      fillColor: cardColor,
      hintText: hint,
      hintStyle: TextStyle(color: subColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );

    return BlocProvider(
      create: (context) =>
          FilterCubit(ApartmentRepo(ApartmentApi(), SecureStorageService()))
            ..getGovernorates(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Filters",
            style: TextStyle(
              color: fontColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          iconTheme: IconThemeData(color: fontColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Governorate",
                style: TextStyle(
                  color: fontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              BlocBuilder<FilterCubit, FilterState>(
                builder: (context, state) {
                  List<GovernorateModel> govsToShow = [];
                  if (state is FilterGovernoratesLoaded)
                    govsToShow = state.governorates;
                  if (state is FilterLoadingCities)
                    govsToShow = state.governorates;
                  if (state is FilterCitiesLoaded)
                    govsToShow = state.governorates;

                  if (state is FilterLoadingGovernorates) {
                    return Center(
                      child: LinearProgressIndicator(
                        color: theme.primaryColor,
                        minHeight: 2,
                      ),
                    );
                  }

                  return DropdownButtonFormField<GovernorateModel>(
                    dropdownColor: cardColor,
                    decoration: inputDec("Select governorate"),
                    value: selectedGovernorate,
                    alignment: Alignment.center,
                    items: govsToShow.map((gov) {
                      return DropdownMenuItem(
                        value: gov,
                        alignment: Alignment.center,
                        child: Text(
                          gov.name,
                          style: TextStyle(color: fontColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedGovernorate = val;
                        selectedCity = null;
                        currentCities = [];
                      });
                      if (val != null) {
                        context.read<FilterCubit>().getCities(val.id);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                "City",
                style: TextStyle(
                  color: fontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              BlocConsumer<FilterCubit, FilterState>(
                listener: (context, state) {
                  if (state is FilterCitiesLoaded) {
                    setState(() => currentCities = state.cities);
                  }
                },
                builder: (context, state) {
                  final bool noCitiesFound =
                      state is FilterCitiesLoaded && currentCities.isEmpty;

                  String hintText = "Select city";
                  if (selectedGovernorate == null) {
                    hintText = "Select a governorate first";
                  } else if (noCitiesFound) {
                    hintText = "No cities found";
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<CityModel>(
                        dropdownColor: cardColor,
                        decoration: inputDec(hintText),
                        value: selectedCity,
                        alignment: Alignment.center,
                        disabledHint: Text(
                          hintText,
                          style: TextStyle(color: subColor),
                        ),
                        items: currentCities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            alignment: Alignment.center,
                            child: Text(
                              city.name,
                              style: TextStyle(color: fontColor),
                            ),
                          );
                        }).toList(),
                        onChanged:
                            (selectedGovernorate == null || noCitiesFound)
                            ? null
                            : (val) => setState(() => selectedCity = val),
                      ),
                      if (state is FilterLoadingCities)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: LinearProgressIndicator(
                            color: theme.primaryColor,
                            minHeight: 2,
                          ),
                        ),
                      if (noCitiesFound)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Text(
                            "We couldn't find any cities for ${selectedGovernorate?.name}.",
                            style: TextStyle(
                              color: AppTheme.kColorDanger,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
              _buildSectionTitle("Price", fontColor),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: inputDec("Enter price"),
                style: TextStyle(color: fontColor),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle("Area Size (m²)", fontColor),
              const SizedBox(height: 10),
              TextField(
                controller: areaSizeController,
                keyboardType: TextInputType.number,
                decoration: inputDec("Enter area size"),
                style: TextStyle(color: fontColor),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle("Rooms", fontColor),
              const SizedBox(height: 10),
              TextField(
                controller: roomsController,
                keyboardType: TextInputType.number,
                decoration: inputDec("Enter number of rooms"),
                style: TextStyle(color: fontColor),
              ),
              const SizedBox(height: 30),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _resetFilters,
                child: Text(
                  "Clear All",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final Map<String, dynamic> filterResult = {
                    if (selectedGovernorate != null)
                      'governorate_id': selectedGovernorate!.id,
                    if (selectedCity != null) 'city_id': selectedCity!.id,
                    if (priceController.text.isNotEmpty)
                      'price': int.tryParse(priceController.text),
                    if (areaSizeController.text.isNotEmpty)
                      'area': int.tryParse(areaSizeController.text),
                    if (roomsController.text.isNotEmpty)
                      'rooms': int.tryParse(roomsController.text),
                  };
                  Navigator.pop(context, filterResult);
                },
                child: const Text(
                  "Apply Filters",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color? color) {
    return Text(
      title,
      style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}
