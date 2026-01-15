import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pluto_ui/business_logic/history_cubit/cubit/history_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/history_model.dart';
import 'package:pluto_ui/presentation/screens/rating_screen.dart';
import 'package:pluto_ui/presentation/screens/edit_request_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().fetchHistory();
  }

  bool _isCurrentlyLiving(String fromDate, String toDate, String status) {
    if (status != 'accepted') return false;

    try {
      DateTime now = DateTime.now();
      DateFormat format = DateFormat("dd-MM-yyyy", context.locale.languageCode);
      ;
      DateTime start = format.parse(fromDate);
      DateTime end = format.parse(toDate);

      DateTime today = DateTime(now.year, now.month, now.day);

      return (today.isAfter(start) || today.isAtSameMomentAs(start)) &&
          (today.isBefore(end) || today.isAtSameMomentAs(end));
    } catch (e) {
      return false;
    }
  }

  void _showDeleteDialog(int bookingId, String name, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Cancel Request".tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).primaryColor
                : Colors.white,
          ),
        ),
        content: Text(
          "Are you sure you want to cancel the request for $name?".tr(),
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("No".tr(), style: TextStyle(color: theme.hintColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<HistoryCubit>().cancelBooking(bookingId);
            },
            child: Text(
              "Yes, Cancel".tr(),
              style: TextStyle(
                color: AppTheme.kColorDanger,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
    final subFontColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.6);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Rental History".tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.cardColor,
        foregroundColor: fontColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: theme.primaryColor,
        backgroundColor: theme.cardColor,
        onRefresh: () async {
          await context.read<HistoryCubit>().fetchHistory();
        },
        child: BlocListener<HistoryCubit, HistoryState>(
          listener: (context, state) {
            // Only handle side-effects here (Snackbars, Navigation)
            if (state is HistoryActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.kColorSuccess,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<HistoryCubit, HistoryState>(
            buildWhen: (previous, current) =>
                current is HistoryLoading ||
                current is HistoryLoaded ||
                current is HistoryError,
            builder: (context, state) {
              if (state is HistoryLoading) {
                return Center(
                  child: CircularProgressIndicator(color: theme.primaryColor),
                );
              } else if (state is HistoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppTheme.kColorDanger,
                      ),
                      const SizedBox(height: 16),
                      Text(state.message, style: TextStyle(color: fontColor)),
                    ],
                  ),
                );
              } else if (state is HistoryLoaded) {
                if (state.history.isEmpty) {
                  return Center(
                    child: Text(
                      "No bookings found".tr(),
                      style: TextStyle(color: subFontColor),
                    ),
                  );
                }

                final sortedHistory = List.from(state.history)
                  ..sort((a, b) => b.id.compareTo(a.id));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: sortedHistory.length,
                  itemBuilder: (context, i) {
                    return _buildHistoryCard(
                      sortedHistory[i],
                      theme,
                      fontColor,
                      subFontColor,
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    HistoryModel booking,
    ThemeData theme,
    Color? fontColor,
    Color? subFontColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: theme.primaryColor.withOpacity(0.1),
                    child: booking.apartment.photo.isNotEmpty
                        ? Image.network(
                            booking.apartment.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.home_work_rounded,
                              color: theme.primaryColor,
                            ),
                          )
                        : Icon(
                            Icons.home_work_rounded,
                            color: theme.primaryColor,
                          ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${booking.apartment.governorate}, ${booking.apartment.city}",
                        style: TextStyle(
                          color: fontColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${booking.fromDate} → ${booking.toDate}",
                        style: TextStyle(color: subFontColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(booking, theme),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(thickness: 0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Actions".tr(),
                  style: TextStyle(
                    color: subFontColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _buildActionButtons(booking, theme, subFontColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(HistoryModel booking, ThemeData theme) {
    Color color;
    String text;

    if (_isCurrentlyLiving(booking.fromDate, booking.toDate, booking.status)) {
      color = Colors.orange;
      text = "Living".tr();
    } else {
      switch (booking.status.toLowerCase()) {
        case 'accepted':
          color = AppTheme.kColorSuccess;
          text = "Agreed".tr();
          break;
        case 'declined':
        case 'canceled':
          color = AppTheme.kColorDanger;
          text = booking.status == 'declined'
              ? "Declined".tr()
              : "Canceled".tr();
          break;
        case 'completed':
          color = Colors.blue;
          text = "Done".tr();
          break;
        default:
          color = theme.primaryColor;
          text = "Pending".tr();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    HistoryModel booking,
    ThemeData theme,
    Color? subFontColor,
  ) {
    final String status = booking.status.toLowerCase();
    final bool isLiving = _isCurrentlyLiving(
      booking.fromDate,
      booking.toDate,
      booking.status,
    );

    if (status != 'completed' &&
        status != 'canceled' &&
        status != 'declined' &&
        !isLiving) {
      return Row(
        children: [
          if (status == 'accepted')
            _iconAction(Icons.edit_note_rounded, theme.primaryColor, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRequestScreen(
                    bookingId: booking.id,
                    houseName: booking.apartment.city,
                    initialDate: booking.fromDate,
                    toDate: booking.toDate,
                  ),
                ),
              ).then((_) {
                if (mounted) context.read<HistoryCubit>().fetchHistory();
              });
            }),
          if (status == 'accepted') const SizedBox(width: 10),
          _iconAction(
            Icons.delete_outline_rounded,
            AppTheme.kColorDanger,
            () => _showDeleteDialog(booking.id, booking.apartment.city, theme),
          ),
        ],
      );
    } else if (status == 'completed') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RatingScreen(apartmentModel: booking.apartment),
            ),
          );
        },
        child: Text(
          "Rate Now".tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Text("No actions".tr(), style: TextStyle(color: subFontColor));
  }

  Widget _iconAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
