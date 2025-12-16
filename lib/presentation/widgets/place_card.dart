// // lib/presentation/widgets/place_card.dart

// import 'package:flutter/material.dart';
// import 'package:pluto_ui/data/models/place_model.dart';
// import 'package:pluto_ui/constants/app_colors.dart'; // ✅ استيراد الألوان

// // تحويلها إلى Stateful Widget للتعامل مع حالة القلب
// class PlaceCard extends StatefulWidget {
//   final PlaceModel place;

//   const PlaceCard({Key? key, required this.place}) : super(key: key);

//   @override
//   State<PlaceCard> createState() => _PlaceCardState();
// }

// class _PlaceCardState extends State<PlaceCard> {
//   // دالة صغيرة لبناء صف النجوم
//   Widget _buildRatingStars(double rating) {
//     List<Widget> stars = [];
//     int fullStars = rating.floor();
//     bool hasHalfStar = (rating - fullStars) >= 0.5;

//     for (int i = 0; i < 5; i++) {
//       if (i < fullStars) {
//         stars.add(Icon(Icons.star, color: kPrimaryColor, size: 16)); // ✅ استخدام لون أساسي
//       } else if (i == fullStars && hasHalfStar) {
//         stars.add(Icon(Icons.star_half, color: kPrimaryColor, size: 16));
//       } else {
//         stars.add(Icon(Icons.star_border, color: kPrimaryColor, size: 16));
//       }
//     }
//     return Row(children: stars);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: kBgCard, // ✅ استخدام لون البطاقة
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 5,
//       // لا يمكن تطبيق SHADOW_SOFT كقيمة نصية مباشرة، نستخدم elevation

//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column( // ✅ التخطيط العمودي
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. الصورة وأيقونة القلب (في صف واحد بالصورة)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // الصورة
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     image: DecorationImage(
//                       image: AssetImage(widget.place.imagePath),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 // أيقونة القلب
//                 IconButton(
//                   icon: Icon(
//                     // ✅ تغيير الأيقونة بناءً على حالة المفضلة
//                     widget.place.isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color: widget.place.isFavorite ? kColorDanger : Colors.grey, // ✅ القلب أحمر عند الضغط
//                   ),
//                   onPressed: () {
//                     // ✅ تغيير حالة الـ Widget عند الضغط
//                     setState(() {
//                       widget.place.isFavorite = !widget.place.isFavorite;
//                     });
//                   },
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16.0), // فاصل بين الصورة والنص

//             // 2. نصوص الموقع والتقييم (تحت الصورة)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Location',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                     Text(
//                       widget.place.location,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: kFontColorDark, // ✅ استخدام لون الخط الداكن
//                       ),
//                     ),
//                   ],
//                 ),
//                 // التقييم (النجوم)
//                 _buildRatingStars(widget.place.rating),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/presentation/widgets/place_card.dart

// import 'package:flutter/material.dart';
// // 🛑 CHANGE 1: استيراد نموذج الشقة الجديد
// import 'package:pluto_ui/data/models/apartment_model.dart';
// import 'package:pluto_ui/constants/app_colors.dart';

// // 🛑 CHANGE 2: تحويلها إلى StatelessWidget لأن الـ Cubit يدير الحالة (مبدأ BLoC)
// class PlaceCard extends StatelessWidget {
//   // 🛑 استخدام ApartmentModel
//   final ApartmentModel place;
//   // 🛑 إضافة callback لتمرير ضغطة القلب للـ Cubit
//   // final VoidCallback onFavoriteToggle;

//   const PlaceCard({
//     Key? key,
//     required this.place,
//     // required this.onFavoriteToggle, // يجب تمريره عند الاستدعاء
//   }) : super(key: key);

import 'package:flutter/material.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';

import 'package:pluto_ui/constants/app_colors.dart';

class PlaceCard extends StatefulWidget {
  final ApartmentModel place;
  final bool isDark;

  const PlaceCard({super.key, required this.place, required this.isDark});

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int full = rating.floor();
    bool half = (rating - full) >= 0.5;

    final primaryColor = AppColors.primary(
      widget.isDark,
    ); // 🛑 تم إضافة متغير اللون الأساسي

    for (int i = 0; i < 5; i++) {
      if (i < full) {
        stars.add(
          Icon(Icons.star, color: primaryColor, size: 16),
        ); // 🛑 تم التصحيح
      } else if (i == full && half) {
        stars.add(
          Icon(Icons.star_half, color: primaryColor, size: 16),
        ); // 🛑 تم التصحيح
      } else {
        stars.add(
          Icon(
            Icons.star_border,
            color: AppColors.bgActive(widget.isDark),
            size: 16,
          ),
        );
      }
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    final bgCard = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final subColor = AppColors.subFontColor(widget.isDark);

    return Card(
      color: bgCard,
      // ملاحظة: يُفضل ترك الـ margin الخارجي في الـ Padding/ListView.builder المحيط
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.place.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // أيقونة القلب
                //     IconButton(
                //       icon: Icon(
                //         // 🛑 استخدام isFavorite من ApartmentModel
                //         place.isFavorite ? Icons.favorite : Icons.favorite_border,
                //         color: place.isFavorite ? kColorDanger : Colors.grey,
                //       ),
                //       // 🛑 تمرير الضغطة إلى الـ callback
                //       onPressed: onFavoriteToggle,
                //     ),
                //   ],
                // ),
                // 🛑 CHANGE: Simplified Heart Icon
                // IconButton(
                //   icon: Icon(
                //     Icons.favorite_border, // Show un-interactable border heart
                //     color: Colors.grey,
                //   ),
                //   onPressed: () {
                // 🛑 DISABLED INTERACTION: Do nothing for now
                IconButton(
                  icon: Icon(
                    widget.place.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.place.isFavorite
                        ? AppColors.danger(widget.isDark)
                        : AppColors.bgActive(widget.isDark),
                  ),
                  onPressed: () {
                    // يجب عليك هنا تحديث الحالة في الـ model
                    setState(() {
                      widget.place.isFavorite = !widget.place.isFavorite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(color: subColor, fontSize: 14),
                    ),

                    Text(
                      '${widget.place.governorate}, ${widget.place.city}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: fontColor,
                      ),
                    ),
                  ],
                ),

                _buildRatingStars(widget.place.rate),
                // =======
                //                     Text("Location", style: TextStyle(color: subColor, fontSize: 14)),
                //                     Text(widget.place.location,
                //                         style: TextStyle(
                //                             fontSize: 20, fontWeight: FontWeight.bold, color: fontColor)),
                //                   ],
                //                 ),
                //                 _buildRatingStars(widget.place.rating),
                // >>>>>>> origin/masa
              ],
            ),
          ],
        ),
      ),
    );
  }
}
