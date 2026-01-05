// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/registrations_cubit/cubit/registrations_cubit.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/models/registration_model.dart';
// import 'rental_request_screen.dart';

// class NotificationScreen extends StatefulWidget {
//   final bool isDark;
//   const NotificationScreen({super.key, required this.isDark});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   @overrides
//   void initState() {
//     super.initState();
//     // Trigger the API call via Cubit when the screen initializes
//     context.read<RegistrationsCubit>().fetchRegistrations();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fontColor = AppColors.fontColor(widget.isDark);
//     final bgColor = AppColors.bgMain(widget.isDark);

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         title: Text(
//           "Notifications",
//           style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppColors.bgCard(widget.isDark),
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: fontColor),
//       ),
//       body: BlocBuilder<RegistrationsCubit, RegistrationsState>(
//         builder: (context, state) {
//           if (state is RegistrationsLoading) {
//             return const Center(
//               child: CircularProgressIndicator(color: AppColors.kFontColorDark),
//             );
//           } else if (state is RegistrationsError) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   state.message,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: fontColor),
//                 ),
//               ),
//             );
//           } else if (state is RegistrationsLoaded) {
//             final registrations = state.registrations;

//             if (registrations.isEmpty) {
//               return Center(
//                 child: Text(
//                   "No notifications yet",
//                   style: TextStyle(
//                     color: AppColors.subFontColor(widget.isDark),
//                   ),
//                 ),
//               );
//             }

//             return RefreshIndicator(
//               onRefresh: () =>
//                   context.read<RegistrationsCubit>().fetchRegistrations(),
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: registrations.length,
//                 itemBuilder: (context, index) =>
//                     _buildNotificationItem(registrations[index]),
//               ),
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }

//   Widget _buildNotificationItem(RegistrationModel item) {
//     final primary = AppColors.primary(widget.isDark);
//     final cardBg = AppColors.bgCard(widget.isDark);
//     final fontColor = AppColors.fontColor(widget.isDark);
//     final subFontColor = AppColors.subFontColor(widget.isDark);

//     // Status color logic based on your Backend Status constants
//     Color statusColor;
//     switch (item.status.toLowerCase()) {
//       case 'registered':
//         statusColor = primary;
//         break;
//       case 'accepted':
//         statusColor = AppColors.kColorSuccess;
//         break;
//       default:
//         statusColor = subFontColor;
//     }

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => RentalRequestScreen(
//               isDark: widget.isDark,
//               registration: item, // This carries all the info we need!
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: cardBg,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(widget.isDark ? 0.2 : 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: primary.withOpacity(0.1),
//                 backgroundImage: item.user.profileImage.isNotEmpty
//                     ? NetworkImage(item.user.profileImageUrl)
//                     : null,
//                 child: item.user.profileImage.isEmpty
//                     ? Text(
//                         item.user.firstName[0].toUpperCase(),
//                         style: TextStyle(
//                           color: primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Full Name (First + Last)
//                     Text(
//                       "${item.user.firstName} ${item.user.lastName}",
//                       style: TextStyle(
//                         color: fontColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       "Booking Request",
//                       style: TextStyle(color: subFontColor, fontSize: 12),
//                     ),
//                     const SizedBox(height: 6),
//                     // Location: Governorate and City
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           color: primary,
//                           size: 14,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           "${item.apartment.governorate}, ${item.apartment.city}",
//                           style: TextStyle(
//                             color: primary,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Status Chip
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   item.status.toUpperCase(),
//                   style: TextStyle(
//                     color: statusColor,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
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
import 'package:pluto_ui/business_logic/registrations_cubit/cubit/registrations_cubit.dart';
import 'package:pluto_ui/business_logic/update_registrations_cubit/cubit/update_registrations_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/registration_model.dart';
import 'package:pluto_ui/data/models/update_registration_model.dart';
import 'package:pluto_ui/presentation/screens/update_details_for_owner_screen.dart';
import 'rental_request_screen.dart';

class NotificationScreen extends StatefulWidget {
  final bool isDark;
  const NotificationScreen({super.key, required this.isDark});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    // Fetch both types of requests simultaneously
    context.read<RegistrationsCubit>().fetchRegistrations();
    context.read<UpdateRegistrationsCubit>().fetchUpdateRequests();
  }

  @override
  Widget build(BuildContext context) {
    final fontColor = AppColors.fontColor(widget.isDark);
    final bgColor = AppColors.bgMain(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.bgCard(widget.isDark),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: BlocBuilder<RegistrationsCubit, RegistrationsState>(
        builder: (context, regState) {
          return BlocBuilder<
            UpdateRegistrationsCubit,
            UpdateRegistrationsState
          >(
            builder: (context, updateState) {
              // 1. Loading State
              if (regState is RegistrationsLoading ||
                  updateState is UpdateRegistrationsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.kFontColorDark,
                  ),
                );
              }

              // 2. Data Extraction
              final List<RegistrationModel> normalRequests =
                  (regState is RegistrationsLoaded)
                  ? regState.registrations
                  : [];
              final List<UpdateRegistrationModel> updateRequests =
                  (updateState is UpdateRegistrationsLoaded)
                  ? updateState.updateRequests
                  : [];

              // 3. Empty State
              if (normalRequests.isEmpty && updateRequests.isEmpty) {
                return Center(
                  child: Text(
                    "No notifications yet",
                    style: TextStyle(
                      color: AppColors.subFontColor(widget.isDark),
                    ),
                  ),
                );
              }

              // 4. Content List
              return RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (normalRequests.isNotEmpty) ...[
                      _sectionHeader("New Booking Requests"),
                      ...normalRequests.map((item) => _buildNormalItem(item)),
                    ],
                    if (updateRequests.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionHeader("Date Change Requests"),
                      ...updateRequests.map((item) => _buildUpdateItem(item)),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Header for different notification types
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.fontColor(widget.isDark).withOpacity(0.6),
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// UI for Standard Booking Requests
  Widget _buildNormalItem(RegistrationModel item) {
    return _baseNotificationCard(
      title: "${item.user.firstName} ${item.user.lastName}",
      subtitle: "New Booking Request",
      location: "${item.apartment.governorate}, ${item.apartment.city}",
      imageUrl: item.user.profileImageUrl,
      hasImage: item.user.profileImage.isNotEmpty,
      initials: item.user.firstName[0],
      status: item.status,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RentalRequestScreen(isDark: widget.isDark, registration: item),
          ),
        );
      },
    );
  }

  /// UI for Update (Date Change) Requests
  Widget _buildUpdateItem(UpdateRegistrationModel item) {
    final booking = item.booking;
    return _baseNotificationCard(
      title: "${booking.user.firstName} ${booking.user.lastName}",
      subtitle: "Requested Date Change",
      subtitleColor: Colors.orange, // Highlight as a warning/change
      location: "${booking.apartment.governorate}, ${booking.apartment.city}",
      imageUrl: booking.user.profileImageUrl,
      hasImage: booking.user.profileImage.isNotEmpty,
      initials: booking.user.firstName[0],
      status: "UPDATE",
      isUpdate: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateDetailsForOwnerScreen(
              isDark: widget.isDark,
              updateRegistrationModel: item,
            ),
          ),
        );
      },
    );
  }

  /// Shared Card Template to keep UI consistent
  Widget _baseNotificationCard({
    required String title,
    required String subtitle,
    required String location,
    required String imageUrl,
    required bool hasImage,
    required String initials,
    required String status,
    required VoidCallback onTap,
    Color? subtitleColor,
    bool isUpdate = false,
  }) {
    final primary = AppColors.primary(widget.isDark);
    final cardBg = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final subFontColor = AppColors.subFontColor(widget.isDark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(15),
          border: isUpdate
              ? Border.all(color: Colors.orange.withOpacity(0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: primary.withOpacity(0.1),
                backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
                child: !hasImage
                    ? Text(
                        initials.toUpperCase(),
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: fontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subtitleColor ?? subFontColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            color: primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildStatusChip(status, isUpdate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isUpdate) {
    final color = isUpdate
        ? Colors.orange
        : (status.toLowerCase() == 'accepted'
              ? AppColors.kColorSuccess
              : AppColors.primary(widget.isDark));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
