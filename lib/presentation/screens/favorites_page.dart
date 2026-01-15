import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/favorite_cubit/cubit/favorite_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/screens/apartment_details_screen.dart';
import 'package:pluto_ui/presentation/widgets/place_card.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        title: Text(
          "Favorites".tr(),
          style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: fontColor),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          } else if (state is FavoriteLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return Center(
                child: Text(
                  "No favorite houses yet".tr(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            final sortedFavorites = List.from(state.favorites)
              ..sort((a, b) => b.id.compareTo(a.id));

            return RefreshIndicator(
              color: theme.primaryColor,
              backgroundColor: theme.cardColor,
              onRefresh: () => context.read<FavoriteCubit>().refreshFavorites(),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: sortedFavorites.length,
                itemBuilder: (context, index) {
                  final apartment = sortedFavorites[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ApartmentDetailsScreen(apartmentId: apartment.id),
                        ),
                      ),
                      child: PlaceCard(place: apartment),
                    ),
                  );
                },
              ),
            );
          } else if (state is FavoriteError) {
            print(state.message);

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppTheme.kColorDanger,
                  ),
                  const SizedBox(height: 16),
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
