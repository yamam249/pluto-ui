import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pluto_ui/business_logic/create_booking_cubit/cubit/create_booking_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/models/create_booking_model.dart';
import 'package:easy_localization/easy_localization.dart';

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
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.brightness == Brightness.dark
                ? ColorScheme.dark(
                    primary: theme.primaryColor,
                    onPrimary: Colors.white,
                    surface: theme.cardColor,
                  )
                : ColorScheme.light(
                    primary: theme.primaryColor,
                    onPrimary: Colors.white,
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
    final model = CreateBookingModel(
      apartmentId: widget.apartment.id,
      fromDate: fromDate!,
      toDate: toDate!,
    );
    context.read<CreateBookingCubit>().submitBooking(model);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
    final cardBg = theme.cardColor;

    return BlocListener<CreateBookingCubit, CreateBookingState>(
      listener: (context, state) {
        setState(() => _isLoading = state is CreateBookingLoading);

        if (state is CreateBookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorSuccess,
              content: Text(
                'Request added successfully '.tr(),
                textAlign: TextAlign.center,
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state is CreateBookingValidationError) {
          setState(() => validationErrors = state.errors);
        } else if (state is CreateBookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.kColorDanger,
              content: Text('${state.message} ', textAlign: TextAlign.center),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text("Booking Details".tr()),
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
                    Icon(Icons.info_outline, color: theme.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Please select the duration of your reservation".tr(),
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
                theme: theme,
                label: "From Date".tr(),
                selectedDate: fromDate,
                errorText: getErrorForField('from_date'),
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 25),

              buildStyledDatePicker(
                theme: theme,
                label: "To Date".tr(),
                selectedDate: toDate,
                errorText: getErrorForField('to_date'),
                onTap: () => _selectDate(context, false),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
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
                      : Text(
                          "Confirm Reservation".tr(),
                          style: TextStyle(
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

  Widget buildStyledDatePicker({
    required ThemeData theme,
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    String? errorText,
  }) {
    final isError = errorText != null;
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: fontColor?.withOpacity(0.7),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
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
                color: isError
                    ? AppTheme.kColorDanger
                    : theme.dividerColor.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: isError ? theme.colorScheme.error : theme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 15),
                Text(
                  selectedDate == null
                      ? "Select date".tr()
                      : DateFormat('dd MMM, yyyy').format(selectedDate),
                  style: TextStyle(
                    color: fontColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              errorText,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
            ),
          ),
      ],
    );
  }
}
