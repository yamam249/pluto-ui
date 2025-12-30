import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'rental_request.dart';

enum RequestStatus { pending, accepted, declined }

class NotificationModel {
  final int id;
  final int requestId;
  final String title;
  final String body;
  bool isRead;
  RequestStatus status;
  bool hasUpdate;
  final String? tenantName;
  final String? oldDate;
  final String? newDate;

  NotificationModel({
    required this.id,
    required this.requestId,
    required this.title,
    required this.body,
    this.isRead = false,
    this.status = RequestStatus.pending,
    this.hasUpdate = false,
    this.tenantName,
    this.oldDate,
    this.newDate,
  });
}

class NotificationScreen extends StatefulWidget {
  final bool isDark;
  const NotificationScreen({super.key, required this.isDark});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      requestId: 101,
      title: "Damascus Villa Booking",
      body: "Rental request from Ahmad Mohammad",
      tenantName: "Ahmad Mohammad",
      status: RequestStatus.accepted,
      hasUpdate: true,
      oldDate: "2024-04-18",
      newDate: "2025-02-15",
    ),
    NotificationModel(
      id: 2,
      requestId: 102,
      title: "New Request",
      body: "Sara Hasan sent a booking request",
      tenantName: "Sara Hasan",
      status: RequestStatus.pending,
      hasUpdate: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final fontColor = AppColors.fontColor(widget.isDark);
    final bgColor = AppColors.bgMain(widget.isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: fontColor, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.bgCard(widget.isDark),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: notifications.isEmpty
          ? Center(child: Text("No notifications yet", style: TextStyle(color: fontColor)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) => _buildNotificationItem(notifications[index]),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel item) {
    final primary = AppColors.primary(widget.isDark);
    final cardBg = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final subFontColor = AppColors.subFontColor(widget.isDark);
    final isAccepted = item.status == RequestStatus.accepted;

    return GestureDetector(
      onTap: () {
        setState(() => item.isRead = true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentalRequestScreen(
              isDark: widget.isDark,
              isEditRequest: item.hasUpdate,
              isAlreadyAccepted: isAccepted,
              tenantName: item.tenantName ?? "Guest",
              oldDate: item.oldDate,
              newDate: item.newDate,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(widget.isDark ? 0.2 : 0.05), blurRadius: 10)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isAccepted ? AppColors.kColorSuccess : primary).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isAccepted ? Icons.check_circle_outline : Icons.notifications_none,
                      color: isAccepted ? AppColors.kColorSuccess : primary,
                      size: 24,
                    ),
                  ),
                  if (item.hasUpdate)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                        child: const Icon(Icons.edit, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: TextStyle(color: fontColor, fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      item.hasUpdate ? "Tenant requested a change" : item.body,
                      style: TextStyle(color: subFontColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (!item.isRead)
                Container(width: 8, height: 8, decoration: BoxDecoration(color: primary, shape: BoxShape.circle)),
            ],
          ),
        ),
      ),
    );
  }
}