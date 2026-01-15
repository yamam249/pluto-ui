import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/registrations_cubit/cubit/registrations_cubit.dart';
import 'package:pluto_ui/business_logic/update_registrations_cubit/cubit/update_registrations_cubit.dart';
import 'package:pluto_ui/data/models/registration_model.dart';
import 'package:pluto_ui/data/models/update_registration_model.dart';
import 'package:pluto_ui/presentation/screens/update_details_for_owner_screen.dart';
import 'rental_request_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

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
    context.read<RegistrationsCubit>().fetchRegistrations();
    context.read<UpdateRegistrationsCubit>().fetchUpdateRequests();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Notifications".tr(),
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.cardColor,
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
              if (regState is RegistrationsLoading ||
                  updateState is UpdateRegistrationsLoading) {
                return Center(
                  child: CircularProgressIndicator(color: theme.primaryColor),
                );
              }

              final List<RegistrationModel> normalRequests =
                  (regState is RegistrationsLoaded)
                  ? regState.registrations
                  : [];
              final List<UpdateRegistrationModel> updateRequests =
                  (updateState is UpdateRegistrationsLoaded)
                  ? updateState.updateRequests
                  : [];

              if (normalRequests.isEmpty && updateRequests.isEmpty) {
                return Center(
                  child: Text(
                    "No notifications yet".tr(),
                    style: TextStyle(color: fontColor),
                  ),
                );
              }

              return RefreshIndicator(
                color: theme.primaryColor,
                onRefresh: _refreshData,
                child: ListView(
                  padding: const EdgeInsetsDirectional.all(16),
                  children: [
                    if (normalRequests.isNotEmpty) ...[
                      _sectionHeader("New Booking Requests".tr(), fontColor),
                      ...normalRequests.map(
                        (item) => _buildNormalItem(item, theme),
                      ),
                    ],
                    if (updateRequests.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionHeader("Date Change Requests".tr(), fontColor),
                      ...updateRequests.map(
                        (item) => _buildUpdateItem(item, theme),
                      ),
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

  Widget _sectionHeader(String title, Color? fontColor) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12, start: 4),
      child: Text(
        title,
        style: TextStyle(
          color: fontColor?.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNormalItem(RegistrationModel item, ThemeData theme) {
    return _baseNotificationCard(
      theme: theme,
      title: "${item.user.firstName} ${item.user.lastName}",
      subtitle: "New Booking Request".tr(),
      location: "${item.apartment.governorate}, ${item.apartment.city}",
      imageUrl: item.user.profileImageUrl,
      hasImage: item.user.profileImage.isNotEmpty,
      initials: item.user.firstName[0],
      status: item.status,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentalRequestScreen(registration: item),
          ),
        );
      },
    );
  }

  Widget _buildUpdateItem(UpdateRegistrationModel item, ThemeData theme) {
    final booking = item.booking;
    return _baseNotificationCard(
      theme: theme,
      title: "${booking.user.firstName} ${booking.user.lastName}",
      subtitle: "Requested Date Change".tr(),
      subtitleColor: Colors.orange,
      location: "${booking.apartment.governorate}, ${booking.apartment.city}",
      imageUrl: booking.user.profileImageUrl,
      hasImage: booking.user.profileImage.isNotEmpty,
      initials: booking.user.firstName[0],
      status: "UPDATE".tr(),
      isUpdate: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UpdateDetailsForOwnerScreen(updateRegistrationModel: item),
          ),
        );
      },
    );
  }

  Widget _baseNotificationCard({
    required ThemeData theme,
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
    final primary = theme.primaryColor;
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
    final subFontColor = theme.textTheme.bodySmall?.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: isUpdate
              ? Border.all(color: Colors.orange.withOpacity(0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                theme.brightness == Brightness.dark ? 0.2 : 0.05,
              ),
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
              _buildStatusChip(status, isUpdate, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isUpdate, ThemeData theme) {
    final color = isUpdate
        ? Colors.orange
        : (status.toLowerCase() == 'accepted'
              ? Colors.green
              : theme.primaryColor);
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
