import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pluto_ui/business_logic/history_cubit/cubit/history_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/history_model.dart';
import 'package:pluto_ui/presentation/screens/rating_screen.dart';
import 'package:pluto_ui/presentation/screens/edit_request_screen.dart';

class HistoryScreen extends StatefulWidget {
  final bool isDark;
  const HistoryScreen({super.key, required this.isDark});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the API call via Cubit when the screen initializes
    context.read<HistoryCubit>().fetchHistory();
  }

  /// Checks if the current date is within the booking range to show "Living"
  // bool _isCurrentlyLiving(String fromDate, String toDate, String status) {
  //   if (status != 'accepted') return false;

  //   try {
  //     DateTime now = DateTime.now();
  //     DateTime start = DateTime.parse(fromDate);
  //     DateTime end = DateTime.parse(toDate);

  //     return (now.isAfter(start) || now.isAtSameMomentAs(start)) &&
  //         (now.isBefore(end) || now.isAtSameMomentAs(end));
  //   } catch (e) {
  //     return false;
  //   }
  // }

  bool _isCurrentlyLiving(String fromDate, String toDate, String status) {
    if (status != 'accepted') return false;

    try {
      DateTime now = DateTime.now();

      // Use DateFormat to ensure it parses the dd-MM-yyyy format correctly
      DateFormat format = DateFormat("dd-MM-yyyy");
      DateTime start = format.parse(fromDate);
      DateTime end = format.parse(toDate);

      // Standardize to date-only comparison to avoid time-of-day bugs
      DateTime today = DateTime(now.year, now.month, now.day);

      return (today.isAfter(start) || today.isAtSameMomentAs(start)) &&
          (today.isBefore(end) || today.isAtSameMomentAs(end));
    } catch (e) {
      return false;
    }
  }

  void _showDeleteDialog(
    int bookingId,
    String name,
    Color cardColor,
    Color fontColor,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Cancel Request",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to cancel the request for $name?",
          style: TextStyle(color: fontColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "No",
              style: TextStyle(color: AppColors.subFontColor(widget.isDark)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Trigger the cancellation via Cubit
              context.read<HistoryCubit>().cancelBooking(bookingId);
            },
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(
                color: AppColors.kColorDanger,
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
    return Scaffold(
      backgroundColor: AppColors.bgMain(widget.isDark),
      appBar: AppBar(
        title: const Text(
          "Rental History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.bgCard(widget.isDark),
        foregroundColor: AppColors.fontColor(widget.isDark),
        elevation: 0,
        centerTitle: true,
      ),
      // BlocListener handles "One-time" events like showing SnackBars
      body: BlocListener<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is HistoryActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.kColorSuccess,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<HistoryCubit, HistoryState>(
          // buildWhen ensures we don't clear the screen/list when an action (like cancel) starts
          buildWhen: (previous, current) =>
              current is HistoryLoading ||
              current is HistoryLoaded ||
              current is HistoryError,
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.kFontColorDark,
                ),
              );
            } else if (state is HistoryError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.fontColor(widget.isDark)),
                  ),
                ),
              );
            } else if (state is HistoryLoaded) {
              final historyList = state.history;

              if (historyList.isEmpty) {
                return Center(
                  child: Text(
                    "No bookings found",
                    style: TextStyle(
                      color: AppColors.subFontColor(widget.isDark),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: historyList.length,
                itemBuilder: (context, i) {
                  return _buildHistoryCard(historyList[i]);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHistoryCard(HistoryModel booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard(widget.isDark),
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
                    color: AppColors.primary(widget.isDark).withOpacity(0.1),
                    child: booking.apartment.photo.isNotEmpty
                        ? Image.network(
                            booking.apartment.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.home_work_rounded,
                              color: AppColors.primary(widget.isDark),
                            ),
                          )
                        : Icon(
                            Icons.home_work_rounded,
                            color: AppColors.primary(widget.isDark),
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
                          color: AppColors.fontColor(widget.isDark),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${booking.fromDate} → ${booking.toDate}",
                        style: TextStyle(
                          color: AppColors.subFontColor(widget.isDark),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(booking),
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
                  "Actions",
                  style: TextStyle(
                    color: AppColors.subFontColor(widget.isDark),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _buildActionButtons(booking),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(HistoryModel booking) {
    Color color;
    String text;

    if (_isCurrentlyLiving(booking.fromDate, booking.toDate, booking.status)) {
      color = Colors.orange;
      text = "Living";
    } else {
      switch (booking.status.toLowerCase()) {
        case 'accepted':
          color = AppColors.kColorSuccess;
          text = "Agreed";
          break;
        case 'declined':
        case 'canceled':
          color = AppColors.kColorDanger;
          text = booking.status == 'declined' ? "Declined" : "Canceled";
          break;
        case 'completed':
          color = const Color(0xFF3B82F6);
          text = "Done";
          break;
        default:
          color = AppColors.kBgActive;
          text = "Pending";
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

  // Widget _buildActionButtons(HistoryModel booking) {
  //   // Logic for showing Edit/Cancel (Only if status is accepted/pending and not currently living)
  //   if (booking.status != 'completed' &&
  //       booking.status != 'canceled' &&
  //       booking.status != 'declined' &&
  //       !_isCurrentlyLiving(booking.fromDate, booking.toDate, booking.status)) {
  //     return Row(
  //       children: [
  //         _iconAction(
  //           Icons.edit_note_rounded,
  //           AppColors.primary(widget.isDark),
  //           () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => EditRequestScreen(
  //                   isDark: widget.isDark,
  //                   bookingId: booking.id,
  //                   houseName: booking.apartment.city,
  //                   initialDate: booking.fromDate,
  //                   toDate: booking.toDate,
  //                 ),
  //               ),
  //             ).then((_) {
  //               // This triggers after the user pops back from EditRequestScreen
  //               if (mounted) {
  //                 context.read<HistoryCubit>().fetchHistory();
  //               }
  //             });
  //           },
  //         ),

  //         const SizedBox(width: 10),
  //         _iconAction(
  //           Icons.delete_outline_rounded,
  //           AppColors.kColorDanger,
  //           () => _showDeleteDialog(
  //             booking.id,
  //             "${booking.apartment.governorate}, ${booking.apartment.city}",
  //             AppColors.bgCard(widget.isDark),
  //             AppColors.fontColor(widget.isDark),
  //           ),
  //         ),
  //       ],
  //     );
  //   } else if (booking.status == 'completed') {
  //     return ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: AppColors.primary(widget.isDark),
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //       ),
  //       onPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => RatingScreen(
  //               isDark: widget.isDark,
  //               apartmentModel: booking.apartment,
  //             ),
  //           ),
  //         );
  //       },
  //       child: const Text(
  //         "Rate Now",
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 12,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     );
  //   }
  //   return Text(
  //     "--",
  //     style: TextStyle(color: AppColors.subFontColor(widget.isDark)),
  //   );
  // }

  Widget _buildActionButtons(HistoryModel booking) {
    final String status = booking.status.toLowerCase();
    final bool isLiving = _isCurrentlyLiving(
      booking.fromDate,
      booking.toDate,
      booking.status,
    );

    // 1. Logic for showing Edit and/or Cancel
    // We show this row if the booking is not finalized (completed, canceled, or declined)
    // AND the user is not currently in the "Living" period.
    if (status != 'completed' &&
        status != 'canceled' &&
        status != 'declined' &&
        !isLiving) {
      return Row(
        children: [
          // EDIT BUTTON: Strictly only for 'accepted' status
          if (status == 'accepted')
            _iconAction(
              Icons.edit_note_rounded,
              AppColors.primary(widget.isDark),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditRequestScreen(
                      isDark: widget.isDark,
                      bookingId: booking.id,
                      houseName: booking.apartment.city,
                      initialDate: booking.fromDate,
                      toDate: booking.toDate,
                    ),
                  ),
                ).then((_) {
                  if (mounted) {
                    context.read<HistoryCubit>().fetchHistory();
                  }
                });
              },
            ),

          // Add spacing only if the edit button was shown
          if (status == 'accepted') const SizedBox(width: 10),

          // CANCEL BUTTON: Available for both 'pending' and 'accepted'
          _iconAction(
            Icons.delete_outline_rounded,
            AppColors.kColorDanger,
            () => _showDeleteDialog(
              booking.id,
              "${booking.apartment.governorate}, ${booking.apartment.city}",
              AppColors.bgCard(widget.isDark),
              AppColors.fontColor(widget.isDark),
            ),
          ),
        ],
      );
    }
    // 2. Logic for Rating (Completed bookings only)
    else if (status == 'completed') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(widget.isDark),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RatingScreen(
                isDark: widget.isDark,
                apartmentModel: booking.apartment,
              ),
            ),
          );
        },
        child: const Text(
          "Rate Now",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // 3. Fallback: No actions for Canceled, Declined, or "Living" status
    return Text(
      "No actions",
      style: TextStyle(color: AppColors.subFontColor(widget.isDark)),
    );
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
