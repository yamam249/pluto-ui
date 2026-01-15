// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:pluto_ui/business_logic/update_booking_cubit/cubit/update_booking_cubit.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/models/update_booking_request_model.dart';

// class EditRequestScreen extends StatefulWidget {
//   final bool isDark;
//   final int bookingId;
//   final String houseName;
//   final String initialDate;
//   final String toDate;

//   const EditRequestScreen({
//     super.key,
//     required this.isDark,
//     required this.bookingId,
//     required this.houseName,
//     required this.initialDate,
//     required this.toDate,
//   });

//   @override
//   State<EditRequestScreen> createState() => _EditRequestScreenState();
// }

// class _EditRequestScreenState extends State<EditRequestScreen> {
//   DateTime? fromDate;
//   DateTime? toDate;
//   bool _isLoading = false;

//   // New: Validation errors map following your Login pattern
//   Map<String, List<String>> validationErrors = {};

//   final DateTime afterTomorrow = DateTime.now().add(const Duration(days: 2));

//   // Helper method to get specific error messages
//   String? getErrorForField(String fieldKey) {
//     if (validationErrors.containsKey(fieldKey) &&
//         validationErrors[fieldKey]!.isNotEmpty) {
//       return validationErrors[fieldKey]!.first;
//     }
//     return null;
//   }

//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     // Clear validation error when user interacts with picker
//     if (validationErrors.isNotEmpty) {
//       setState(() => validationErrors = {});
//     }

//     // 1. Logic for 'From' Date
//     // Must be at least 'afterTomorrow'
//     DateTime firstDate;
//     DateTime initialDate;

//     if (isFromDate) {
//       firstDate = afterTomorrow;
//       initialDate = fromDate ?? afterTomorrow;
//     } else {
//       // 2. Logic for 'To' Date
//       // Must be at least the selected 'fromDate', otherwise 'afterTomorrow'
//       firstDate = fromDate ?? afterTomorrow;
//       initialDate = toDate ?? firstDate;
//     }

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: DateTime(2070),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: AppColors.kFontColorDark,
//               onPrimary: AppColors.kFontColorLight,
//               onSurface: AppColors.kFontColorDark,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           fromDate = picked;
//           if (toDate != null && toDate!.isBefore(fromDate!)) {
//             toDate = null;
//           }
//         } else {
//           toDate = picked;
//         }
//       });
//     }
//   }

//   void _submitBooking() {
//     if (fromDate == null || toDate == null) return;

//     final requestModel = UpdateBookingRequestModel(
//       newFromDate: DateFormat('dd-MM-yyyy').format(fromDate!),
//       newToDate: DateFormat('dd-MM-yyyy').format(toDate!),
//     );

//     context.read<UpdateBookingCubit>().submitUpdate(
//       requestModel,
//       widget.bookingId,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<UpdateBookingCubit, UpdateBookingState>(
//       listener: (context, state) {
//         setState(() {
//           _isLoading = state is UpdateBookingLoading;
//         });

//         if (state is UpdateBookingSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               behavior: SnackBarBehavior.floating,
//               backgroundColor: AppColors.kColorSuccess,
//               content: Text(
//                 'Request added successfully ✅',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//           Navigator.pop(context);
//         } else if (state is UpdateBookingValidationError) {
//           setState(() {
//             validationErrors = state.errors;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               behavior: SnackBarBehavior.floating,
//               backgroundColor: AppColors.kColorDanger,
//               content: Text(
//                 'Please correct the date errors ⚠️',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//         } else if (state is UpdateBookingFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               behavior: SnackBarBehavior.floating,
//               backgroundColor: AppColors.kColorDanger,
//               content: Text('${state.error} ❌', textAlign: TextAlign.center),
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.kFontColorLight,
//         appBar: AppBar(
//           title: const Text("Edit Request"),
//           backgroundColor: AppColors.kFontColorLight,
//           elevation: 0,
//           iconTheme: const IconThemeData(color: AppColors.kFontColorDark),
//           titleTextStyle: const TextStyle(
//             color: AppColors.kFontColorDark,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.kBgCard.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         "Please select the new duration of your reservation ",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: AppColors.kFontColorDark,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Modified Styled From Date with Error handling
//               buildStyledDatePicker(
//                 label: "From Date",
//                 selectedDate: fromDate,
//                 errorText: getErrorForField('new_from_date'),
//                 onTap: () => _selectDate(context, true),
//               ),
//               const SizedBox(height: 20),

//               // Modified Styled To Date with Error handling
//               buildStyledDatePicker(
//                 label: "To Date",
//                 selectedDate: toDate,
//                 errorText: getErrorForField('new_to_date'),
//                 onTap: () => _selectDate(context, false),
//               ),

//               const Spacer(),

//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kFontColorDark,
//                   minimumSize: const Size(double.infinity, 60),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 0,
//                 ),
//                 onPressed:
//                     (fromDate == null ||
//                         toDate == null ||
//                         _isLoading ||
//                         toDate!.isBefore(fromDate!))
//                     ? null
//                     : _submitBooking,
//                 child: _isLoading
//                     ? const CircularProgressIndicator(
//                         color: AppColors.kFontColorLight,
//                       )
//                     : const Text(
//                         "Confirm The Changes",
//                         style: TextStyle(
//                           color: AppColors.kFontColorLight,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- UI Style Pattern for Validation Errors ---
//   Widget buildStyledDatePicker({
//     required String label,
//     required DateTime? selectedDate,
//     required VoidCallback onTap,
//     String? errorText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 8),
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: AppColors.kFontColorDark,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ),
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(15),
//           child: Container(
//             height: 65,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: AppColors.kFontColorLight,
//               borderRadius: BorderRadius.circular(15),
//               // Show red border if there is an error
//               border: errorText != null
//                   ? Border.all(color: AppColors.kColorDanger, width: 1.5)
//                   : null,
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.calendar_month_outlined,
//                   color: AppColors.kFontColorDark,
//                   size: 28,
//                 ),
//                 const SizedBox(width: 15),
//                 Text(
//                   selectedDate == null
//                       ? "select date"
//                       : DateFormat('dd-MM-yyyy').format(selectedDate),
//                   style: const TextStyle(
//                     color: AppColors.kFontColorDark,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // Error Message UI Pattern
//         if (errorText != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8, left: 8),
//             child: Text(
//               errorText,
//               style: const TextStyle(
//                 color: AppColors.kColorDanger,
//                 fontSize: 13,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pluto_ui/business_logic/update_booking_cubit/cubit/update_booking_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/update_booking_request_model.dart';
import 'package:easy_localization/easy_localization.dart';

class EditRequestScreen extends StatefulWidget {
  final int bookingId;
  final String houseName;
  final String initialDate;
  final String toDate;

  const EditRequestScreen({
    super.key,
    required this.bookingId,
    required this.houseName,
    required this.initialDate,
    required this.toDate,
  });

  @override
  State<EditRequestScreen> createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends State<EditRequestScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  bool _isLoading = false;

  Map<String, List<String>> validationErrors = {};

  final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

  String? getErrorForField(String fieldKey) {
    if (validationErrors.containsKey(fieldKey) &&
        validationErrors[fieldKey]!.isNotEmpty) {
      return validationErrors[fieldKey]!.first;
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final theme = Theme.of(context);

    if (validationErrors.isNotEmpty) {
      setState(() => validationErrors = {});
    }

    DateTime firstDate;
    DateTime initialDate;

    if (isFromDate) {
      firstDate = tomorrow;
      initialDate = fromDate ?? tomorrow;
    } else {
      firstDate = fromDate ?? tomorrow;
      initialDate = toDate ?? firstDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2070),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
              onSurface: theme.textTheme.bodyLarge?.color,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          if (toDate != null && toDate!.isBefore(fromDate!)) {
            toDate = null;
          }
        } else {
          toDate = picked;
        }
      });
    }
  }

  void _submitBooking() {
    if (fromDate == null || toDate == null) return;

    final requestModel = UpdateBookingRequestModel(
      newFromDate: DateFormat('dd-MM-yyyy').format(fromDate!),
      newToDate: DateFormat('dd-MM-yyyy').format(toDate!),
    );

    context.read<UpdateBookingCubit>().submitUpdate(
      requestModel,
      widget.bookingId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return BlocListener<UpdateBookingCubit, UpdateBookingState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is UpdateBookingLoading;
        });

        if (state is UpdateBookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorSuccess,
              content: Text(
                'Request updated successfully '.tr(),
                textAlign: TextAlign.center,
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state is UpdateBookingValidationError) {
          setState(() {
            validationErrors = state.errors;
          });
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorDanger,
              content: Text(
                'Please correct the date errors '.tr(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is UpdateBookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorDanger,
              content: Text('${state.error} ', textAlign: TextAlign.center),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title:  Text("Edit Request".tr()),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: fontColor),
          titleTextStyle: TextStyle(
            color: fontColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Please select the new duration of your reservation for ${widget.houseName}".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: fontColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              buildStyledDatePicker(
                label: "From Date".tr(),
                selectedDate: fromDate,
                theme: theme,
                errorText: getErrorForField('new_from_date'),
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 20),

              buildStyledDatePicker(
                label: "To Date".tr(),
                selectedDate: toDate,
                theme: theme,
                errorText: getErrorForField('new_to_date'),
                onTap: () => _selectDate(context, false),
              ),

              const Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed:
                    (fromDate == null ||
                        toDate == null ||
                        _isLoading ||
                        toDate!.isBefore(fromDate!))
                    ? null
                    : _submitBooking,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    :  Text(
                        "Confirm The Changes".tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStyledDatePicker({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required ThemeData theme,
    String? errorText,
  }) {
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: fontColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: errorText != null
                    ? theme.colorScheme.error
                    : theme.dividerColor.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: theme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 15),
                Text(
                  selectedDate == null
                      ? "Select date".tr()
                      : DateFormat('dd-MM-yyyy').format(selectedDate),
                  style: TextStyle(
                    color: fontColor?.withOpacity(
                      selectedDate == null ? 0.5 : 1.0,
                    ),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              errorText,
              style: TextStyle(color: AppTheme.kColorDanger, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
