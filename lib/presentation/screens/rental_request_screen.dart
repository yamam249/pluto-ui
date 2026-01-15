import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/registrations_cubit/cubit/registrations_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/registration_model.dart';
import 'package:easy_localization/easy_localization.dart';

class RentalRequestScreen extends StatefulWidget {
  final RegistrationModel registration;

  const RentalRequestScreen({super.key, required this.registration});

  @override
  State<RentalRequestScreen> createState() => _RentalRequestScreenState();
}

class _RentalRequestScreenState extends State<RentalRequestScreen> {
  bool _isAccepting = false;
  bool _isDeclining = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
    final subFontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Booking Request".tr(),
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _statusBanner(
              "Status: ${widget.registration.status.toUpperCase()}".tr(),
              widget.registration.status.toLowerCase() == 'accepted'
                  ? AppTheme.kColorSuccess
                  : primaryColor,
            ),

            _sectionTitle("Tenant Information".tr(), fontColor),
            _buildCard(
              cardColor,
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    backgroundImage:
                        widget.registration.user.profileImage.isNotEmpty
                        ? NetworkImage(widget.registration.user.profileImageUrl)
                        : null,
                    child: widget.registration.user.profileImage.isEmpty
                        ? Icon(Icons.person, color: primaryColor)
                        : null,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.registration.user.firstName} ${widget.registration.user.lastName}",
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.registration.user.phone,
                          style: TextStyle(color: subFontColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("Rental duration".tr(), fontColor),
            _buildCard(
              cardColor,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _dateBox(
                    "From Date".tr(),
                    widget.registration.fromDate,
                    primaryColor,
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: subFontColor,
                    size: 20,
                  ),
                  _dateBox(
                    "To Date".tr(),
                    widget.registration.toDate,
                    primaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("Apartment Details".tr(), fontColor),
            _buildCard(
              cardColor,
              Column(
                children: [
                  _infoRow(
                    "Location".tr(),
                    "${widget.registration.apartment.governorate}, ${widget.registration.apartment.city}",
                    fontColor,
                    subFontColor,
                  ),
                  Divider(height: 30, color: subFontColor),
                  _infoRow(
                    "Price per Night".tr(),
                    "${widget.registration.apartment.price} SYP",
                    fontColor,
                    subFontColor,
                  ),
                  Divider(height: 30, color: subFontColor),
                  Builder(
                    builder: (context) {
                      final nights = _calculateTotalNights(
                        widget.registration.fromDate,
                        widget.registration.toDate,
                      );
                      final totalPrice =
                          nights *
                          (double.tryParse(
                                widget.registration.apartment.price.toString(),
                              ) ??
                              0);

                      return _infoRow(
                        "Total Price ($nights nights)".tr(),
                        "${totalPrice.toStringAsFixed(2)} SYP",
                        primaryColor,
                        subFontColor,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            BlocConsumer<RegistrationsCubit, RegistrationsState>(
              listenWhen: (prev, curr) =>
                  prev is RegistrationsLoading && curr is RegistrationsLoaded,
              listener: (context, state) {
                setState(() {
                  _isAccepting = false;
                  _isDeclining = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppTheme.kColorSuccess,
                    content: Text(
                      "Action completed successfully".tr(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              builder: (context, state) {
                return _buildActionButtons(
                  context,
                  state is RegistrationsLoading,
                  theme,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool globalLoading,
    ThemeData theme,
  ) {
    if (widget.registration.status.toLowerCase() == 'accepted') {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text("Close".tr()),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.kColorSuccess,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: globalLoading
                ? null
                : () {
                    setState(() => _isAccepting = true);
                    context.read<RegistrationsCubit>().acceptBooking(
                      widget.registration.id,
                    );
                  },
            child: (globalLoading && _isAccepting)
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Accept".tr(),
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
              side: BorderSide(color: AppTheme.kColorDanger),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: globalLoading
                ? null
                : () {
                    setState(() => _isDeclining = true);
                    context.read<RegistrationsCubit>().declineBooking(
                      widget.registration.id,
                    );
                  },
            child: (globalLoading && _isDeclining)
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.error,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Decline".tr(),
                    style: TextStyle(
                      color: AppTheme.kColorDanger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

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

  Widget _infoRow(String label, String val, Color? fColor, Color? sColor) {
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

  Widget _sectionTitle(String title, Color? color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(
        title,
        style: TextStyle(
          color: color?.withOpacity(0.6),
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
      int difference = end.difference(start).inDays + 1;
      return difference;
    } catch (e) {
      return 0;
    }
  }
}
