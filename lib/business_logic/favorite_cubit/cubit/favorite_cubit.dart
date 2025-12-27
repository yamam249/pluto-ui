// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:pluto_ui/data/models/apartment_model.dart';
// import 'package:pluto_ui/data/repositories/apartment_repo.dart';

// part 'favorite_state.dart';

// class FavoriteCubit extends Cubit<FavoriteState> {
//   final ApartmentRepo apartmentRepo;

//   FavoriteCubit(this.apartmentRepo) : super(FavoriteInitial());

//   /// Method to fetch the favorites list from the API
//   Future<void> getFavorites() async {
//     emit(FavoriteLoading());

//     try {
//       final favorites = await apartmentRepo.getFavoriteApartments();
//       emit(FavoriteLoaded(favorites));
//     } catch (e) {
//       // We catch the ApiException thrown by the repo/api layer
//       emit(FavoriteError(e.toString()));
//     }
//   }

//   ///  Method to refresh the list without showing a full-screen loader
//   Future<void> refreshFavorites() async {
//     try {
//       final favorites = await apartmentRepo.getFavoriteApartments();
//       emit(FavoriteLoaded(favorites));
//     } catch (e) {
//       emit(FavoriteError(e.toString()));
//     }
//   }

//   // /// Logic to either Add or Remove based on current favorite status
//   // Future<void> toggleFavoriteStatus(ApartmentModel apartment) async {
//   //   try {
//   //     if (apartment.isFavorite) {
//   //       // If it is already a favorite, we call the DELETE repo method
//   //       await apartmentRepo.removeFromFavorites(apartment.id);
//   //     } else {
//   //       // If it is NOT a favorite, we call the POST repo method
//   //       await apartmentRepo.addToFavorites(apartment.id);
//   //     }

//   //     // Sync the state: refresh the favorites list so the UI updates
//   //     if (state is FavoriteLoaded) {
//   //       await refreshFavorites();
//   //     } else {
//   //       await getFavorites();
//   //     }
//   //   } catch (e) {
//   //     // If the API fails, we emit an error so the UI can show a SnackBar
//   //     emit(FavoriteError(e.toString()));
//   //   }
//   // }

//   /// Logic to either Add or Remove based on current favorite status
//   Future<void> toggleFavoriteStatus(ApartmentModel apartment) async {
//     // We keep a reference to the state before the error
//     // so we can revert to it if the API call fails.
//     final previousState = state;

//     try {
//       if (apartment.isFavorite) {
//         // If it is already a favorite (red heart), we call DELETE
//         await apartmentRepo.removeFromFavorites(apartment.id);
//       } else {
//         // If it is NOT a favorite (border heart), we call POST
//         await apartmentRepo.addToFavorites(apartment.id);
//       }

//       // Sync the state: refresh the list so the Favorites Page is updated
//       if (state is FavoriteLoaded) {
//         await refreshFavorites();
//       } else {
//         await getFavorites();
//       }
//     } catch (e) {
//       // 1. Emit the error state to trigger the BlocListener SnackBar
//       emit(FavoriteError(e.toString()));

//       // 2. Immediately revert to the previous loaded state.
//       // This "resets" the Cubit so that the next error can be detected
//       // by the BlocListener, and ensures the UI doesn't get stuck on an error screen.
//       if (previousState is FavoriteLoaded) {
//         emit(FavoriteLoaded(previousState.favorites));
//       } else {
//         // If we weren't in a loaded state, just go back to Initial
//         emit(FavoriteInitial());
//       }
//     }
//   }
// }

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
  Future<void> Function()? _lastFailedAction;

  FavoriteCubit(this.apartmentRepo, this.apartmentCubit)
    : super(FavoriteInitial());

  /// Universal Retry Method
  /// This will execute whatever action previously failed.
  Future<void> retryLastAction() async {
    if (_lastFailedAction != null) {
      await _lastFailedAction!();
    }
  }

  /// Fetches the favorites list from the API
  Future<void> getFavorites() async {
    // Save this action in case it fails
    _lastFailedAction = () => getFavorites();

    emit(FavoriteLoading());

    try {
      final favorites = await apartmentRepo.getFavoriteApartments();
      emit(FavoriteLoaded(favorites));

      // Clear the fail reference on success
      _lastFailedAction = null;
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  /// Refresh the list without showing a full-screen loader
  Future<void> refreshFavorites() async {
    _lastFailedAction = () => refreshFavorites();
    try {
      final favorites = await apartmentRepo.getFavoriteApartments();
      emit(FavoriteLoaded(favorites));
      _lastFailedAction = null;
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  //   /// Adds or Removes based on current favorite status
  //   Future<void> toggleFavoriteStatus(ApartmentModel apartment) async {
  //     // Save this action in case it fails
  //     _lastFailedAction = () => toggleFavoriteStatus(apartment);

  //     final previousState = state;

  //     try {
  //       if (apartment.isFavorite) {
  //         await apartmentRepo.removeFromFavorites(apartment.id);
  //       } else {
  //         await apartmentRepo.addToFavorites(apartment.id);
  //       }

  //       if (state is FavoriteLoaded) {
  //         await refreshFavorites();
  //       } else {
  //         await getFavorites();
  //       }

  //       _lastFailedAction = null;
  //     } catch (e) {
  //       emit(FavoriteError(e.toString()));

  //       // Revert to maintain UI continuity
  //       if (previousState is FavoriteLoaded) {
  //         emit(FavoriteLoaded(previousState.favorites));
  //       } else {
  //         emit(FavoriteInitial());
  //       }
  //     }
  //   }

  // /// Adds or Removes based on current favorite status
  // Future<void> toggleFavoriteStatus(ApartmentModel apartment) async {
  //   // Save this action in case it fails
  //   _lastFailedAction = () => toggleFavoriteStatus(apartment);

  //   final previousState = state;
  //   // Keep track of the old favorite status to revert if API fails
  //   final bool originalFavoriteStatus = apartment.isFavorite;

  //   try {
  //     // 1. Update the ApartmentCubit IMMEDIATELY (Optimistic UI)
  //     // This changes the heart color on the Home Screen instantly
  //     apartmentCubit.updateApartmentFavoriteStatus(
  //       apartment.id,
  //       !originalFavoriteStatus,
  //     );

  //     if (originalFavoriteStatus) {
  //       await apartmentRepo.removeFromFavorites(apartment.id);
  //     } else {
  //       await apartmentRepo.addToFavorites(apartment.id);
  //     }

  //     // 2. Refresh the Favorites list
  //     if (state is FavoriteLoaded) {
  //       await refreshFavorites();
  //     } else {
  //       await getFavorites();
  //     }

  //     _lastFailedAction = null;
  //   } catch (e) {
  //     // 3. REVERT: If API fails, set the heart back to its original state on Home Screen
  //     apartmentCubit.updateApartmentFavoriteStatus(
  //       apartment.id,
  //       originalFavoriteStatus,
  //     );

  //     emit(FavoriteError(e.toString()));

  //     // Revert Favorites Page state
  //     if (previousState is FavoriteLoaded) {
  //       emit(FavoriteLoaded(previousState.favorites));
  //     } else {
  //       emit(FavoriteInitial());
  //     }
  //   }
  // }

  /// Adds or Removes based on current favorite status
  Future<void> toggleFavoriteStatus(ApartmentModel apartment) async {
    // 1. Capture the initial state and ID immediately
    final int apartmentId = apartment.id;
    final bool wasFavorite = apartment.isFavorite;

    // Save the retry action
    _lastFailedAction = () => toggleFavoriteStatus(apartment);

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

      _lastFailedAction = null;
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
