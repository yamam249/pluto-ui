// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Add intl to your pubspec.yaml for date formatting
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/models/apartment_model.dart';

// class BookingDetailsScreen extends StatefulWidget {
//   final ApartmentModel apartment;

//   const BookingDetailsScreen({Key? key, required this.apartment})
//     : super(key: key);

//   @override
//   State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
// }

// class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
//   DateTime? fromDate;
//   DateTime? toDate;

//   // Function to show the date picker
//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.kFontColorDark, // header background color
//               onPrimary: Colors.white, // header text color
//               onSurface: AppColors.kFontColorDark, // body text color
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
//         } else {
//           toDate = picked;
//         }
//       });
//     }
//   }

//   // Reusing your styling helper from ApartmentDetails
//   Widget infoRow(String title, String value, VoidCallback? onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: title,
//                 style: TextStyle(
//                   color: AppColors.kFontColorDark,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               TextSpan(
//                 text: value,
//                 style: TextStyle(
//                   color: onTap != null ? Colors.blue : AppColors.kFontColorDark,
//                   fontSize: 16,
//                   decoration: onTap != null ? TextDecoration.underline : null,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildDivider(double endIndent) {
//     return Divider(
//       height: 30,
//       endIndent: endIndent,
//       color: AppColors.kFontColorLight,
//       thickness: 2,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kFontColorLight,
//       appBar: AppBar(
//         title: const Text(
//           "Booking Details",
//           style: TextStyle(
//             color: AppColors.kFontColorDark,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         backgroundColor: AppColors.kBgCard,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: AppColors.kFontColorDark),
//         titleTextStyle: const TextStyle(
//           color: AppColors.kFontColorDark,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display Apartment ID (Required for API)
//             infoRow("Apartment ID: ", widget.apartment.id.toString(), null),
//             buildDivider(200),

//             // From Date Selection
//             infoRow(
//               "From Date: ",
//               fromDate == null
//                   ? "Select Date"
//                   : DateFormat('dd-MM-yyyy').format(fromDate!),
//               () => _selectDate(context, true),
//             ),
//             buildDivider(150),

//             // To Date Selection
//             infoRow(
//               "To Date: ",
//               toDate == null
//                   ? "Select Date"
//                   : DateFormat('dd-MM-yyyy').format(toDate!),
//               () => _selectDate(context, false),
//             ),
//             buildDivider(150),

//             const Spacer(),

//             // Confirm Booking Button
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.kFontColorDark,
//                 minimumSize: const Size(double.infinity, 55),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: (fromDate == null || toDate == null)
//                   ? null // Disable if dates aren't picked
//                   : () {
//                       // Logic for API call will go here
//                       print("Apartment ID: ${widget.apartment.id}");
//                       print(
//                         "From: ${DateFormat('dd-MM-yyyy').format(fromDate!)}",
//                       );
//                       print("To: ${DateFormat('dd-MM-yyyy').format(toDate!)}");
//                     },
//               child: const Text(
//                 "Confirm Reservation",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';

class BookingDetailsScreen extends StatefulWidget {
  final ApartmentModel apartment;

  const BookingDetailsScreen({Key? key, required this.apartment})
    : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  DateTime? fromDate;
  DateTime? toDate;

  // Logic: Start dates from "Tomorrow"
  final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    // If selecting 'To' date, it must be at least the 'From' date
    DateTime initialDate = isFromDate ? tomorrow : (fromDate ?? tomorrow);
    DateTime firstDate = isFromDate ? tomorrow : (fromDate ?? tomorrow);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.kFontColorDark,
              onPrimary: Colors.white,
              onSurface: AppColors.kFontColorDark,
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
          // Reset 'toDate' if it's now before the new 'fromDate'
          if (toDate != null && toDate!.isBefore(fromDate!)) {
            toDate = null;
          }
        } else {
          toDate = picked;
        }
      });
    }
  }

  // CUSTOM STYLED DATE PICKER (Matches your photo)
  Widget buildStyledDatePicker({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.kFontColorDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
              color: const Color(
                0xFFF2F2F7,
              ), // Light grey background from photo
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xFF4A5568), // Icon color from photo
                  size: 28,
                ),
                const SizedBox(width: 15),
                Text(
                  selectedDate == null
                      ? "select date"
                      : DateFormat('dd-MM-yyyy').format(selectedDate),
                  style: const TextStyle(
                    color: Color(0xFF4A5568),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Booking Details"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kFontColorDark),
        titleTextStyle: const TextStyle(
          color: AppColors.kFontColorDark,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Styled Info for Apartment ID
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.kBgCard.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text(
                    "Please select the duration of your reservation ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.kFontColorDark,
                    ),
                  ),
                  // Text(
                  //   widget.apartment.id.toString(),
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Styled From Date
            buildStyledDatePicker(
              label: "From Date",
              selectedDate: fromDate,
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 20),

            // Styled To Date
            buildStyledDatePicker(
              label: "To Date",
              selectedDate: toDate,
              onTap: () => _selectDate(context, false),
            ),

            const Spacer(),

            // Confirm Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kFontColorDark,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              onPressed: (fromDate == null || toDate == null)
                  ? null
                  : () {
                      // API Call Logic
                    },
              child: const Text(
                "Confirm Reservation",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
