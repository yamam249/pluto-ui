import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/place_data.dart';
import 'package:pluto_ui/presentation/widgets/place_card.dart';
import 'package:pluto_ui/data/models/place_model.dart';

class FavoritesPage extends StatelessWidget {
  final bool isDark;
  final ApartmentModel apartmentModel;

  const FavoritesPage({
    super.key,
    required this.isDark,
    required this.apartmentModel,
  });

  @override
  Widget build(BuildContext context) {
    // // قائمة البيوت المعمول لها Favorite
    // final favoritePlaces = mockPlaces
    //     .where((place) => place.isFavorite == true)
    //     .toList();

    final List<PlaceModel> favoritePlaces = mockPlaces
        .where((place) => place.isFavorite)
        .toList();

    final bg = AppColors.bgMain(isDark);
    final cardColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardColor,
        // 🛑 تم التصحيح: نقل fontWeight داخل الـ TextStyle
        title: Text(
          "Favorites",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: fontColor),
      ),

      // body: favoritePlaces.isEmpty
      //     ? const Center(
      //         child: Text(
      //           "No favorite houses yet",
      //           style: TextStyle(
      //             color: Colors.grey,
      //             fontSize: 18,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         ),
      //       )
      //     : ListView.builder(
      //         padding: const EdgeInsets.all(16),
      //         itemCount: favoritePlaces.length,
      //         itemBuilder: (context, index) {
      //           return Padding(
      //             padding: const EdgeInsets.only(bottom: 16),
      //             // child: PlaceCard(place: favoritePlaces[index]),
      //           );
      //         },
      //       ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: favoritePlaces.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PlaceCard(place: apartmentModel, isDark: isDark),
          );
        },
      ),
    );
  }
}
