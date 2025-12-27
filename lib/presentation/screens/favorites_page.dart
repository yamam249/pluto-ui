// import 'package:flutter/material.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/models/apartment_model.dart';
// import 'package:pluto_ui/data/place_data.dart';
// import 'package:pluto_ui/presentation/widgets/place_card.dart';
// import 'package:pluto_ui/data/models/place_model.dart';

// class FavoritesPage extends StatelessWidget {
//   final bool isDark;
//   final ApartmentModel apartmentModel;

//   const FavoritesPage({
//     super.key,
//     required this.isDark,
//     required this.apartmentModel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // // قائمة البيوت المعمول لها Favorite
//     // final favoritePlaces = mockPlaces
//     //     .where((place) => place.isFavorite == true)
//     //     .toList();

//     final List<PlaceModel> favoritePlaces = mockPlaces
//         .where((place) => place.isFavorite)
//         .toList();

//     final bg = AppColors.bgMain(isDark);
//     final cardColor = AppColors.bgCard(isDark);
//     final fontColor = AppColors.fontColor(isDark);

//     return Scaffold(
//       backgroundColor: bg,
//       appBar: AppBar(
//         backgroundColor: cardColor,
//         // 🛑 تم التصحيح: نقل fontWeight داخل الـ TextStyle
//         title: Text(
//           "Favorites",
//           style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
//         ),
//         elevation: 1,
//         iconTheme: IconThemeData(color: fontColor),
//       ),

//       // body: favoritePlaces.isEmpty
//       //     ? const Center(
//       //         child: Text(
//       //           "No favorite houses yet",
//       //           style: TextStyle(
//       //             color: Colors.grey,
//       //             fontSize: 18,
//       //             fontWeight: FontWeight.w500,
//       //           ),
//       //         ),
//       //       )
//       //     : ListView.builder(
//       //         padding: const EdgeInsets.all(16),
//       //         itemCount: favoritePlaces.length,
//       //         itemBuilder: (context, index) {
//       //           return Padding(
//       //             padding: const EdgeInsets.only(bottom: 16),
//       //             // child: PlaceCard(place: favoritePlaces[index]),
//       //           );
//       //         },
//       //       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: favoritePlaces.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: PlaceCard(place: apartmentModel, isDark: isDark),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/favorite_cubit/cubit/favorite_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/widgets/place_card.dart';

class FavoritesPage extends StatefulWidget {
  final bool isDark;

  const FavoritesPage({super.key, required this.isDark});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch the data from the API as soon as the page loads
    context.read<FavoriteCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.bgMain(widget.isDark);
    final cardColor = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: Text(
          "Favorites",
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.kFontColorDark),
            );
          } else if (state is FavoriteLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return const Center(
                child: Text(
                  "No favorite houses yet",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.kFontColorDark,
              backgroundColor: AppColors.kBgMain,
              onRefresh: () => context.read<FavoriteCubit>().refreshFavorites(),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PlaceCard(
                      place:
                          favorites[index], // Now using real ApartmentModel data
                      isDark: widget.isDark,
                    ),
                  );
                },
              ),
            );
          } else if (state is FavoriteError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error: ${state.message}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: fontColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FavoriteCubit>().getFavorites(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bgActive(widget.isDark),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
