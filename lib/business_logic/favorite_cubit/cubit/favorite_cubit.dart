import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final ApartmentRepo apartmentRepo;
  final ApartmentCubit apartmentCubit;

  FavoriteCubit(this.apartmentRepo, this.apartmentCubit)
    : super(FavoriteInitial());

  Future<void> getFavorites() async {
    emit(FavoriteLoading());

    try {
      final favorites = await apartmentRepo.getFavoriteApartments();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> refreshFavorites() async {
    try {
      final favorites = await apartmentRepo.getFavoriteApartments();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> toggleFavoriteStatus(ApartmentModel apartment) async {
    final int apartmentId = apartment.id;
    final bool wasFavorite = apartment.isFavorite;

    final previousState = state;

    try {
      apartmentCubit.updateApartmentFavoriteStatus(apartmentId, !wasFavorite);

      apartment.isFavorite = !wasFavorite;

      if (wasFavorite) {
        await apartmentRepo.removeFromFavorites(apartmentId);
      } else {
        await apartmentRepo.addToFavorites(apartmentId);
      }

      if (state is FavoriteLoaded) {
        await refreshFavorites();
      } else {
        await getFavorites();
      }
    } catch (e) {
      apartment.isFavorite = wasFavorite;

      apartmentCubit.updateApartmentFavoriteStatus(apartmentId, wasFavorite);

      emit(FavoriteError(e.toString()));

      if (previousState is FavoriteLoaded) {
        emit(FavoriteLoaded(previousState.favorites));
      } else {
        emit(FavoriteInitial());
      }
    }
  }
}
