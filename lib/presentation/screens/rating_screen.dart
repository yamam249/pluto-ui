import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart'; 


class RatingScreen extends StatefulWidget {
  final bool isDark;
  final ApartmentModel apartmentModel; 

  const RatingScreen({
    super.key,
    required this.isDark,
    required this.apartmentModel,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // متغير لتخزين قيمة التقييم الحالية (من 1 إلى 5)
  double _currentRating = 3.0; 
  
  // 🛑 تم حذف: final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    // 🛑 تم حذف: _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. جلب الألوان المعتمدة على الثيم
    final isDark = widget.isDark;
    final bg = AppColors.bgMain(isDark);
    final cardColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);
    final primaryColor = AppColors.primary(isDark);
    // 🛑 تم حذف: final fontHintColor = AppColors.fontColor(isDark).withOpacity(0.7);


    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: Text(
          "Rate Your Stay",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 2. تفاصيل العقار
            _buildPropertyDetails(context, cardColor, fontColor),

            const SizedBox(height: 30),

            // 3. قسم النجوم (Rating Stars)
            Text(
              "How was your experience?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: fontColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),

            _buildRatingStars(primaryColor),

            // 🛑 تم حذف: const SizedBox(height: 20),

            // 🛑 تم حذف: حقل كتابة المراجعة
            // 🛑 تم حذف: _buildReviewField(cardColor, fontColor, primaryColor, fontHintColor),

            const SizedBox(height: 30),
            
            // 4. زر الإرسال
            _buildSubmitButton(primaryColor),
          ],
        ),
      ),
    );
  }
  
  // دالة بناء تفاصيل العقار (لم تتغير)
  Widget _buildPropertyDetails(BuildContext context, Color cardColor, Color fontColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // صورة العقار
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(widget.apartmentModel.imageUrl ?? "https://via.placeholder.com/150"), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            // اسم العقار
            Expanded(
              child: Text(
                '${widget.apartmentModel.governorate ?? "Unknown Governorate"}, ${widget.apartmentModel.city ?? "Unknown City"}', 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: fontColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                ),
            ),
          ],
        ),
      ),
    );
    }
  
  // دالة بناء النجوم (لم تتغير)
  Widget _buildRatingStars(Color primaryColor) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return IconButton(
            icon: Icon(
              index < _currentRating ? Icons.star : Icons.star_border,
              color: primaryColor,
              size: 40,
            ),
            onPressed: () {
              setState(() {
                _currentRating = index + 1.0; 
              });
            },
          );
        }),
      ),
    );
  }
  
  // 🛑 تم حذف: دالة _buildReviewField بالكامل

  // دالة بناء زر الإرسال
  Widget _buildSubmitButton(Color primaryColor) {
    return ElevatedButton(
      onPressed: () {
        // تنفيذ منطق إرسال التقييم هنا
        final ratingData = {
          'propertyId': widget.apartmentModel.id,
          'rating': _currentRating,
          // 🛑 تم حذف: 'review': _reviewController.text,
        };
        print('Submitting Rating: $ratingData');
        
        // إغلاق الشاشة بعد الإرسال
        Navigator.of(context).pop(); 
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Submit Rating",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}