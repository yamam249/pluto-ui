// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/update_registrations_cubit/cubit/update_registrations_cubit.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/models/update_registration_model.dart';

// class UpdateDetailsForOwnerScreen extends StatefulWidget {
//   final bool isDark;
//   final UpdateRegistrationModel updateRequest;

//   const UpdateDetailsForOwnerScreen({
//     super.key,
//     required this.isDark,
//     required this.updateRequest,
//   });

//   @override
//   State<UpdateDetailsForOwnerScreen> createState() =>
//       _UpdateDetailsForOwnerScreenState();
// }

// class _UpdateDetailsForOwnerScreenState
//     extends State<UpdateDetailsForOwnerScreen> {
//   bool _isAccepting = false;
//   bool _isDeclining = false;

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = AppColors.bgMain(widget.isDark);
//     final cardColor = AppColors.bgCard(widget.isDark);
//     final fontColor = AppColors.fontColor(widget.isDark);
//     final subFontColor = AppColors.subFontColor(widget.isDark);
//     final primaryColor = AppColors.primary(widget.isDark);

//     // Extracting nested data for easier access
//     final booking = widget.updateRequest.booking;

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: cardColor,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Date Change Request",
//           style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: IconThemeData(color: fontColor),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             _statusBanner("NEW UPDATE REQUEST", Colors.orange),

//             _sectionTitle("Tenant Information", fontColor),
//             _buildCard(
//               cardColor,
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: primaryColor.withOpacity(0.1),
//                     backgroundImage: booking.user.profileImage.isNotEmpty
//                         ? NetworkImage(booking.user.profileImageUrl)
//                         : null,
//                     child: booking.user.profileImage.isEmpty
//                         ? Icon(Icons.person, color: primaryColor)
//                         : null,
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${booking.user.firstName} ${booking.user.lastName}",
//                           style: TextStyle(
//                             color: fontColor,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           booking.user.phone,
//                           style: TextStyle(color: subFontColor, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // --- OLD DATES CARD ---
//             _sectionTitle("Original Rental Duration", fontColor),
//             _buildCard(
//               cardColor.withOpacity(0.6), // Dimmed slightly to show it's old
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _dateBox("From", booking.fromDate, subFontColor),
//                   Icon(
//                     Icons.arrow_forward_rounded,
//                     color: subFontColor,
//                     size: 20,
//                   ),
//                   _dateBox("To", booking.toDate, subFontColor),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 15),
//             Icon(
//               Icons.keyboard_double_arrow_down_rounded,
//               color: Colors.orange,
//               size: 30,
//             ),
//             const SizedBox(height: 5),

//             // --- NEW REQUESTED DATES CARD ---
//             _sectionTitle("Requested New Duration", Colors.orange),
//             _buildCard(
//               widget.isDark
//                   ? Colors.orange.withOpacity(0.1)
//                   : Colors.orange.withOpacity(0.05),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.orange.withOpacity(0.3),
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _dateBox(
//                       "New From",
//                       widget.updateRequest.newFromDate,
//                       Colors.orange,
//                     ),
//                     Icon(Icons.calendar_month, color: Colors.orange, size: 20),
//                     _dateBox(
//                       "New To",
//                       widget.updateRequest.newToDate,
//                       Colors.orange,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             _sectionTitle("Apartment Details", fontColor),
//             _buildCard(
//               cardColor,
//               Column(
//                 children: [
//                   _infoRow(
//                     "Location",
//                     "${booking.apartment.governorate}, ${booking.apartment.city}",
//                     fontColor,
//                     subFontColor,
//                   ),
//                   const Divider(height: 30),
//                   _infoRow(
//                     "Price per Night",
//                     "${booking.apartment.price} SYP",
//                     fontColor,
//                     subFontColor,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 40),

//             // --- UPDATE ACTION BLOC ---
//             BlocConsumer<UpdateRegistrationsCubit, UpdateRegistrationsState>(
//               listener: (context, state) {
//                 if (state is UpdateActionSuccess) {
//                   Navigator.pop(context); // Close details and return to list
//                 }
//               },
//               builder: (context, state) {
//                 return _buildActionButtons(
//                   context,
//                   state is UpdateRegistrationsLoading,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, bool isLoading) {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.kColorSuccess,
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             // onPressed: isLoading ? null : () {
//             //   setState(() => _isAccepting = true);
//             //   context.read<UpdateRegistrationsCubit>().acceptUpdate(widget.updateRequest.bookingId);
//             // },
//             onPressed: () {},
//             child: (isLoading && _isAccepting)
//                 ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Text(
//                     "Accept Change",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//           ),
//         ),
//         const SizedBox(width: 15),
//         Expanded(
//           child: OutlinedButton(
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: AppColors.kColorDanger),
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             // onPressed: isLoading ? null : () {
//             //   setState(() => _isDeclining = true);
//             //   context.read<UpdateRegistrationsCubit>().declineUpdate(widget.updateRequest.bookingId);
//             // },
//             onPressed: () {},
//             child: (isLoading && _isDeclining)
//                 ? SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       color: AppColors.kColorDanger,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : Text(
//                     "Decline",
//                     style: TextStyle(
//                       color: AppColors.kColorDanger,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   // --- Reused Helpers from Original Screen ---
//   Widget _statusBanner(String text, Color color) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: TextStyle(color: color, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildCard(Color color, Widget child) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: child,
//     );
//   }

//   Widget _dateBox(String label, String date, Color color) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 10, color: color.withOpacity(0.7)),
//         ),
//         Text(
//           date,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: color,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _infoRow(String label, String val, Color fColor, Color sColor) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: TextStyle(color: sColor)),
//         Flexible(
//           child: Text(
//             val,
//             textAlign: TextAlign.right,
//             style: TextStyle(color: fColor, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _sectionTitle(String title, Color color) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.only(bottom: 8, top: 10),
//       child: Text(
//         title,
//         style: TextStyle(
//           color: color.withOpacity(0.6),
//           fontWeight: FontWeight.bold,
//           fontSize: 13,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/update_registrations_cubit/cubit/update_registrations_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/update_registration_model.dart';

class UpdateDetailsForOwnerScreen extends StatefulWidget {
  final bool isDark;
  final UpdateRegistrationModel updateRegistrationModel;

  const UpdateDetailsForOwnerScreen({
    super.key,
    required this.isDark,
    required this.updateRegistrationModel,
  });

  @override
  State<UpdateDetailsForOwnerScreen> createState() =>
      _UpdateDetailsForOwnerScreenState();
}

class _UpdateDetailsForOwnerScreenState
    extends State<UpdateDetailsForOwnerScreen> {
  // Local tracking for which button was pressed
  bool _isAccepting = false;
  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final subFontColor = AppColors.subFontColor(widget.isDark);
    final primaryColor = AppColors.primary(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Update Booking Request",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status Banner
            _statusBanner(
              "Status: ${widget.updateRegistrationModel.booking.status.toUpperCase()}",
              widget.updateRegistrationModel.booking.status.toLowerCase() ==
                      'accepted'
                  ? AppColors.kColorSuccess
                  : primaryColor,
            ),

            _sectionTitle("Tenant Information", fontColor),
            _buildCard(
              cardColor,
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    backgroundImage:
                        widget
                            .updateRegistrationModel
                            .booking
                            .user
                            .profileImage
                            .isNotEmpty
                        ? NetworkImage(
                            widget
                                .updateRegistrationModel
                                .booking
                                .user
                                .profileImageUrl,
                          )
                        : null,
                    child:
                        widget
                            .updateRegistrationModel
                            .booking
                            .user
                            .profileImage
                            .isEmpty
                        ? Icon(Icons.person, color: primaryColor)
                        : null,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.updateRegistrationModel.booking.user.firstName} ${widget.updateRegistrationModel.booking.user.lastName}",
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.updateRegistrationModel.booking.user.phone,
                          style: TextStyle(color: subFontColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("The Original Rental Duration", fontColor),
            _buildCard(
              cardColor,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _dateBox(
                    "From Date",
                    widget.updateRegistrationModel.booking.fromDate,
                    primaryColor,
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: subFontColor,
                    size: 20,
                  ),
                  _dateBox(
                    "To Date",
                    widget.updateRegistrationModel.booking.toDate,
                    primaryColor,
                  ),
                ],
              ),
            ),

            // --- NEW REQUESTED DATES CARD ---
            _sectionTitle("Requested New Duration", Colors.orange),
            _buildCard(
              widget.isDark
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.05),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dateBox(
                      "New From",
                      widget.updateRegistrationModel.newFromDate,
                      Colors.orange,
                    ),
                    Icon(Icons.calendar_month, color: Colors.orange, size: 20),
                    _dateBox(
                      "New To",
                      widget.updateRegistrationModel.newToDate,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("apartment Details", fontColor),
            _buildCard(
              cardColor,
              Column(
                children: [
                  _infoRow(
                    "Location",
                    "${widget.updateRegistrationModel.booking.apartment.governorate}, ${widget.updateRegistrationModel.booking.apartment.city}",
                    fontColor,
                    subFontColor,
                  ),
                  const Divider(height: 30),
                  _infoRow(
                    "Price per Night",
                    "${widget.updateRegistrationModel.booking.apartment.price} SYP",
                    fontColor,
                    subFontColor,
                  ),
                  const Divider(height: 30),
                  // THE OLD TOTAL PRICE
                  Builder(
                    builder: (context) {
                      final nights = _calculateTotalNights(
                        widget.updateRegistrationModel.booking.fromDate,
                        widget.updateRegistrationModel.booking.toDate,
                      );
                      final totalPrice =
                          nights *
                          (double.tryParse(
                                widget
                                    .updateRegistrationModel
                                    .booking
                                    .apartment
                                    .price
                                    .toString(),
                              ) ??
                              0);

                      return _infoRow(
                        "The Old Total Price ($nights nights)",
                        "${totalPrice.toStringAsFixed(2)} SYP",
                        primaryColor, // Highlight the total price with the primary color
                        subFontColor,
                      );
                    },
                  ),
                  const Divider(height: 30),
                  // THE NEW TOTAL PRICE
                  Builder(
                    builder: (context) {
                      final nights = _calculateTotalNights(
                        widget.updateRegistrationModel.newFromDate,
                        widget.updateRegistrationModel.newToDate,
                      );
                      final totalPrice =
                          nights *
                          (double.tryParse(
                                widget
                                    .updateRegistrationModel
                                    .booking
                                    .apartment
                                    .price
                                    .toString(),
                              ) ??
                              0);

                      return _infoRow(
                        "The New Total Price ($nights nights)",
                        "${totalPrice.toStringAsFixed(2)} SYP",
                        primaryColor, // Highlight the total price with the primary color
                        subFontColor,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- API ACTION BLOC CONSUMER ---
            BlocConsumer<UpdateRegistrationsCubit, UpdateRegistrationsState>(
              // Only trigger the listener when we transition from loading back to loaded
              listenWhen: (prev, curr) =>
                  prev is UpdateRegistrationsLoading &&
                  curr is UpdateRegistrationsLoaded,
              listener: (context, state) {
                setState(() {
                  _isAccepting = false;
                  _isDeleting = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.kColorSuccess,
                    content: Text(
                      "Action completed successfully",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                Navigator.pop(context); // Return to notification list
              },

              builder: (context, state) {
                return _buildActionButtons(
                  context,
                  state is UpdateRegistrationsLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool globalLoading) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kColorSuccess,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: globalLoading
                ? null
                : () {
                    setState(() => _isAccepting = true);
                    context.read<UpdateRegistrationsCubit>().acceptUpdate(
                      widget.updateRegistrationModel.id,
                    );
                  },

            child:
                (globalLoading &&
                    _isAccepting) // Only show if Accept was clicked
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Accept The Update",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.kColorDanger),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: globalLoading
                ? null
                : () {
                    setState(() => _isDeleting = true);
                    context.read<UpdateRegistrationsCubit>().deleteUpdate(
                      widget.updateRegistrationModel.id,
                    );
                  },

            child:
                (globalLoading &&
                    _isDeleting) // Only show if Decline was clicked
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.kColorDanger,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Decline The Update",
                    style: TextStyle(
                      color: AppColors.kColorDanger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---
  Widget _statusBanner(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCard(Color color, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  Widget _dateBox(String label, String date, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: color.withOpacity(0.7)),
        ),
        Text(
          date,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String val, Color fColor, Color sColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: sColor)),
        Flexible(
          child: Text(
            val,
            textAlign: TextAlign.right,
            style: TextStyle(color: fColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(
        title,
        style: TextStyle(
          color: color.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  int _calculateTotalNights(String from, String to) {
    try {
      DateTime start = DateTime.parse(from);
      DateTime end = DateTime.parse(to);
      int difference = end.difference(start).inDays;
      // Ensure at least 1 night is charged if dates are same or for standard booking logic
      return difference <= 0 ? 1 : difference;
    } catch (e) {
      return 0;
    }
  }
}
