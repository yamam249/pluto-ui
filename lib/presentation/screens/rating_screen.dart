// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/rating_cubit/cubit/rating_cubit.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/models/apartment_model.dart';

// class RatingScreen extends StatefulWidget {
//   final bool isDark;
//   final ApartmentModel apartmentModel;

//   const RatingScreen({
//     super.key,
//     required this.isDark,
//     required this.apartmentModel,
//   });

//   @override
//   State<RatingScreen> createState() => _RatingScreenState();
// }

// class _RatingScreenState extends State<RatingScreen> {
//   // Current rating value (1 to 5)
//   double _currentRating = 3.0;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = widget.isDark;
//     final bg = AppColors.bgMain(isDark);
//     final cardColor = AppColors.bgCard(isDark);
//     final fontColor = AppColors.fontColor(isDark);
//     final primaryColor = AppColors.primary(isDark);

//     return Scaffold(
//       backgroundColor: bg,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: cardColor,
//         title: Text(
//           "Rate Your Stay",
//           style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: IconThemeData(color: fontColor),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<RatingCubit, RatingState>(
//         listener: (context, state) {
//           if (state is RatingSuccess) {
//             // 1. Show Success Snackbar
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.kColorSuccess,
//                 behavior: SnackBarBehavior.floating,
//               ),
//             );
//             // 2. Return to History Screen
//             Navigator.of(context).pop();
//           } else if (state is RatingError) {
//             // Show Error Snackbar
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.kColorDanger,
//                 behavior: SnackBarBehavior.floating,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 // 1. Property Details Card
//                 _buildPropertyDetails(cardColor, fontColor),

//                 const SizedBox(height: 40),

//                 // 2. Question Text
//                 Text(
//                   "How was your experience?",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: fontColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),

//                 // 3. Interactive Rating Stars
//                 _buildRatingStars(primaryColor),

//                 const SizedBox(height: 50),

//                 // 4. Submit Button with Loading State
//                 _buildSubmitButton(primaryColor, state),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildPropertyDetails(Color cardColor, Color fontColor) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Apartment Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               widget.apartmentModel.imageUrl,
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 width: 80,
//                 height: 80,
//                 color: AppColors.primary(widget.isDark).withOpacity(0.1),
//                 child: Icon(
//                   Icons.home_work_rounded,
//                   color: AppColors.primary(widget.isDark),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 15),
//           // Apartment Location
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.apartmentModel.governorate,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: AppColors.subFontColor(widget.isDark),
//                   ),
//                 ),
//                 Text(
//                   widget.apartmentModel.city,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: fontColor,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRatingStars(Color primaryColor) {
//     return Center(
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: List.generate(5, (index) {
//           return IconButton(
//             icon: Icon(
//               index < _currentRating
//                   ? Icons.star_rounded
//                   : Icons.star_outline_rounded,
//               color: primaryColor,
//               size: 48,
//             ),
//             onPressed: () {
//               setState(() {
//                 _currentRating = index + 1.0;
//               });
//             },
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildSubmitButton(Color primaryColor, RatingState state) {
//     bool isLoading = state is RatingLoading;

//     return ElevatedButton(
//       onPressed: isLoading
//           ? null
//           : () {
//               context.read<RatingCubit>().submitRating(
//                 widget.apartmentModel.id,
//                 _currentRating,
//               );
//             },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         disabledBackgroundColor: primaryColor.withOpacity(0.6),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         elevation: 0,
//       ),
//       child: isLoading
//           ? const SizedBox(
//               height: 24,
//               width: 24,
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2.5,
//               ),
//             )
//           : const Text(
//               "Submit Rating",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/rating_cubit/cubit/rating_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:easy_localization/easy_localization.dart';

class RatingScreen extends StatefulWidget {
  final ApartmentModel apartmentModel;

  const RatingScreen({super.key, required this.apartmentModel});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // Current rating value (1 to 5)
  double _currentRating = 3.0;

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
        elevation: 0,
        backgroundColor: theme.cardColor,
        title: Text(
          "Rate Your Stay".tr(),
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: fontColor),
        centerTitle: true,
      ),
      body: BlocConsumer<RatingCubit, RatingState>(
        listener: (context, state) {
          if (state is RatingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.kColorSuccess,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is RatingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.kColorDanger,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildPropertyDetails(theme, fontColor, subFontColor),

                const SizedBox(height: 40),

                Text(
                  "How was your experience?".tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                _buildRatingStars(theme.primaryColor),

                const SizedBox(height: 50),

                _buildSubmitButton(theme.primaryColor, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyDetails(
    ThemeData theme,
    Color? fontColor,
    Color? subFontColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.apartmentModel.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: theme.primaryColor.withOpacity(0.1),
                child: Icon(Icons.home_work_rounded, color: theme.primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.apartmentModel.governorate,
                  style: TextStyle(fontSize: 14, color: subFontColor),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.apartmentModel.city,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(Color primaryColor) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            icon: Icon(
              index < _currentRating
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: primaryColor,
              size: 48,
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

  Widget _buildSubmitButton(Color primaryColor, RatingState state) {
    bool isLoading = state is RatingLoading;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              context.read<RatingCubit>().submitRating(
                widget.apartmentModel.id,
                _currentRating,
              );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        disabledBackgroundColor: primaryColor.withOpacity(0.6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          :  Text(
              "Submit Rating".tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
