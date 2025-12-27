import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/presentation/screens/rating_screen.dart';
import 'package:pluto_ui/presentation/screens/rental_request.dart'; 


enum NotificationType { rating, newRequest }

class NotificationModel {
  final int id;
  String title;
  String body;
  bool isRead;
  final NotificationType type;
  final int? apartmentId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.type,
    this.apartmentId,
  });
}

class NotificationScreen extends StatefulWidget {
  final bool isDark;

  const NotificationScreen({super.key, required this.isDark});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // قائمة الإشعارات
  final List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      title: "Rating Required",
      body: "Please rate your experience at Apartment #456.",
      type: NotificationType.rating,
      apartmentId: 456,
    ),
    NotificationModel(
      id: 2,
      title: "New Rental Request",
      body: "Someone is interested in renting your apartment in Amman.",
      type: NotificationType.newRequest,
      isRead: false,
    ),
  ];

  void _handleTap(int index) {
    final notification = notifications[index];
    
    // تحديث حالة الإشعار إلى "مقروء"
    setState(() {
      notification.isRead = true;
    });

    // المنطق الخاص بالانتقال بناءً على نوع الإشعار
    if (notification.type == NotificationType.rating && notification.apartmentId != null) {
      // 1. الانتقال لواجهة التقييم
      final ApartmentModel dummyApartment = ApartmentModel(
        id: notification.apartmentId!,
        governorate: 'Amman',
        city: 'Jabal Al Weibdeh',
        rate: 4.5,
        photo: "https://via.placeholder.com/150",
        price: '500',
        area: 120,
        rooms: 3,
        floor: 2,
        description: 'Great Place to stay',
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RatingScreen(
            isDark: widget.isDark,
            apartmentModel: dummyApartment,
          ),
        ),
      );
    } 
    else if (notification.type == NotificationType.newRequest) {
      // 2. الانتقال لواجهة طلب الإيجار (RentalRequestScreen)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RentalRequestScreen(
            isDark: widget.isDark,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bgColor = AppColors.bgMain(isDark);
    final cardColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: notifications.isEmpty 
          ? Center(child: Text("No notifications yet", style: TextStyle(color: fontColor)))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(notification, cardColor, fontColor, isDark, index);
              },
            ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, Color cardColor, Color fontColor, bool isDark, int index) {
    final activeColor = AppColors.bgActive(isDark);
    
    IconData iconData;
    Color iconColor;// تحديد الأيقونة واللون بناءً على النوع
    switch (notification.type) {
      case NotificationType.rating:
        iconData = Icons.star_border;
        iconColor = AppColors.kColorDanger;
        break;
      case NotificationType.newRequest:
        iconData = Icons.description_outlined; 
        iconColor = AppColors.primary(isDark);
        break;
    }

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          // إظهار حدود ملونة إذا كان الإشعار غير مقروء
          border: notification.isRead ? null : Border.all(color: activeColor, width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      color: fontColor,
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: fontColor.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // نقطة زرقاء صغيرة للإشعارات غير المقروءة
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}