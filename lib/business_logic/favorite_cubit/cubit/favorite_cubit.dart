import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final ApartmentRepo apartmentRepo;
  final ApartmentCubit apartmentCubit;
  // This stores the function that failed so we can call it again

  FavoriteCubit(this.apartmentRepo, this.apartmentCubit)
    : super(FavoriteInitial());

  /// Universal Retry Method
  /// This will execute whatever action previously failed.

  /// Fetches the favorites list from the API
  Future<void> getFavorites() async {
    // Save this action in case it fails

    emit(FavoriteLoading());

    try {
      final favorites = await apartmentRepo.getFavoriteApartments();
      emit(FavoriteLoaded(favorites));

      // Clear the fail reference on success
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  /// Refresh the list without showing a full-screen loader
  Future<void> refreshFavorites() async {
    try {
      final favorites = await apartmentRepo.getFavoriteApartments();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  /// Adds or Removes based on current favorite status
  Future<void> toggleFavoriteStatus(ApartmentModel apartment) async {
    // 1. Capture the initial state and ID immediately
    final int apartmentId = apartment.id;
    final bool wasFavorite = apartment.isFavorite;

    // Save the retry action

    final previousState = state;

    try {
      // 2. OPTIMISTIC UI: Update both Cubits immediately
      // Update the ApartmentCubit (Home Screen)
      apartmentCubit.updateApartmentFavoriteStatus(apartmentId, !wasFavorite);

      // Update the local object property so the logic below uses the new value
      apartment.isFavorite = !wasFavorite;

      // 3. Perform the API call based on the ORIGINAL state
      if (wasFavorite) {
        // If it was a favorite, we are removing it
        await apartmentRepo.removeFromFavorites(apartmentId);
      } else {
        // If it was NOT a favorite, we are adding it
        await apartmentRepo.addToFavorites(apartmentId);
      }

      // 4. Sync the Favorites Screen list
      if (state is FavoriteLoaded) {
        await refreshFavorites();
      } else {
        await getFavorites();
      }
    } catch (e) {
      // 5. REVERT on failure
      // Revert the local object
      apartment.isFavorite = wasFavorite;

      // Revert the Home Screen
      apartmentCubit.updateApartmentFavoriteStatus(apartmentId, wasFavorite);

      emit(FavoriteError(e.toString()));

      // Revert Favorites Page state
      if (previousState is FavoriteLoaded) {
        emit(FavoriteLoaded(previousState.favorites));
      } else {
        emit(FavoriteInitial());
      }
    }
  }
}
