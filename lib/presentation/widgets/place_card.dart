// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/favorite_cubit/cubit/favorite_cubit.dart';
// import 'package:pluto_ui/data/models/apartment_model.dart';

// import 'package:pluto_ui/constants/app_colors.dart';

// class PlaceCard extends StatefulWidget {
//   final ApartmentModel place;
//   final bool isDark;

//   const PlaceCard({super.key, required this.place, required this.isDark});

//   @override
//   State<PlaceCard> createState() => _PlaceCardState();
// }

// class _PlaceCardState extends State<PlaceCard> {
//   bool _isProcessing = false;

//   @override
//   void didUpdateWidget(covariant PlaceCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // If the apartment object changes (e.g., favorite status updated in Cubit),
//     // this ensures the State object recognizes the new data.
//     if (oldWidget.place.isFavorite != widget.place.isFavorite) {
//       // You don't necessarily need to call setState here because
//       // the build method will run immediately after this.
//     }
//   }

//   Widget _buildRatingStars(double rating) {
//     List<Widget> stars = [];
//     int full = rating.floor();
//     bool half = (rating - full) >= 0.5;

//     final primaryColor = AppColors.primary(
//       widget.isDark,
//     ); // 🛑 تم إضافة متغير اللون الأساسي

//     for (int i = 0; i < 5; i++) {
//       if (i < full) {
//         stars.add(
//           Icon(Icons.star, color: primaryColor, size: 16),
//         ); // 🛑 تم التصحيح
//       } else if (i == full && half) {
//         stars.add(
//           Icon(Icons.star_half, color: primaryColor, size: 16),
//         ); // 🛑 تم التصحيح
//       } else {
//         stars.add(
//           Icon(
//             Icons.star_border,
//             color: AppColors.bgActive(widget.isDark),
//             size: 16,
//           ),
//         );
//       }
//     }
//     return Row(children: stars);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bgCard = AppColors.bgCard(widget.isDark);
//     final fontColor = AppColors.fontColor(widget.isDark);
//     final subColor = AppColors.subFontColor(widget.isDark);

//     return Card(
//       color: bgCard,
//       // ملاحظة: يُفضل ترك الـ margin الخارجي في الـ Padding/ListView.builder المحيط
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                       image: NetworkImage(widget.place.imageUrl),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),

//                 IconButton(
//                   icon: _isProcessing
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: AppColors.kFontColorDark,
//                           ),
//                         )
//                       : Icon(
//                           widget.place.isFavorite
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           color: widget.place.isFavorite
//                               ? AppColors.danger(widget.isDark)
//                               : AppColors.bgActive(widget.isDark),
//                         ),
//                   onPressed: _isProcessing
//                       ? null
//                       : () async {
//                           setState(() => _isProcessing = true);

//                           // Trigger the API call via the Cubit
//                           await context
//                               .read<FavoriteCubit>()
//                               .toggleFavoriteStatus(widget.place);

//                           // Update the local heart color for immediate feedback
//                           // setState(() {
//                           //   widget.place.isFavorite = !widget.place.isFavorite;
//                           //   _isProcessing = false;
//                           // });

//                           if (mounted) {
//                             setState(() {
//                               _isProcessing = false;
//                             });
//                           }

//                           //  Show feedback
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 widget.place.isFavorite
//                                     ? "Added to favorites"
//                                     : "Removed from favorites",
//                               ),
//                               duration: const Duration(seconds: 1),
//                             ),
//                           );
//                         },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Location',
//                       style: TextStyle(color: subColor, fontSize: 14),
//                     ),

//                     Text(
//                       '${widget.place.governorate}, ${widget.place.city}',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: fontColor,
//                       ),
//                     ),
//                   ],
//                 ),

//                 _buildRatingStars(widget.place.rate),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/favorite_cubit/cubit/favorite_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';

class PlaceCard extends StatefulWidget {
  final ApartmentModel place;

  const PlaceCard({super.key, required this.place});

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  bool _isProcessing = false;

  @override
  void didUpdateWidget(covariant PlaceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.place.isFavorite != widget.place.isFavorite) {}
  }

  Widget _buildRatingStars(double rating, ThemeData theme) {
    List<Widget> stars = [];
    int full = rating.floor();
    bool half = (rating - full) >= 0.5;

    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.secondary.withOpacity(0.5);

    for (int i = 0; i < 5; i++) {
      if (i < full) {
        stars.add(Icon(Icons.star, color: activeColor, size: 16));
      } else if (i == full && half) {
        stars.add(Icon(Icons.star_half, color: activeColor, size: 16));
      } else {
        stars.add(Icon(Icons.star_border, color: inactiveColor, size: 16));
      }
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgCard = theme.cardColor;
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
    final subColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.7);

    return Card(
      color: bgCard,
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

                IconButton(
                  icon: _isProcessing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.primaryColor,
                          ),
                        )
                      : Icon(
                          widget.place.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.place.isFavorite
                              ? AppTheme.kColorDanger
                              : theme.colorScheme.secondary,
                        ),

                  onPressed: _isProcessing
                      ? null
                      : () async {
                          setState(() => _isProcessing = true);
                          await context
                              .read<FavoriteCubit>()
                              .toggleFavoriteStatus(widget.place);

                          if (mounted) {
                            setState(() => _isProcessing = false);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppTheme.kColorSuccess,
                              content: Text(
                                widget.place.isFavorite
                                    ? "Added to favorites"
                                    : "Removed from favorites",
                                textAlign: TextAlign.center,
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
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
                _buildRatingStars(widget.place.rate, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
