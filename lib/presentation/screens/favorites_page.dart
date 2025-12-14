// lib/presentation/screens/favorites_page.dart

import 'package:flutter/material.dart';
import 'package:pluto_ui/data/place_data.dart';
import 'package:pluto_ui/presentation/widgets/place_card.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة البيوت المعمول لها Favorite
    final favoritePlaces =
    mockPlaces.where((place) => place.isFavorite == true).toList();

    return Scaffold(
      backgroundColor: kBgMain,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Color(0xFF2E5070),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: favoritePlaces.isEmpty
          ? const Center(
        child: Text(
          "No favorite houses yet",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoritePlaces.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PlaceCard(place: favoritePlaces[index]),
          );
        },
      ),
    );
  }
}
