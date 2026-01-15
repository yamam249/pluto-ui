import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;

part 'apartment_state.dart';

class ApartmentCubit extends Cubit<ApartmentState> {
  final ApartmentRepo apartmentRepo;
  ApartmentCubit(this.apartmentRepo) : super(ApartmentInitial());

  void updateApartmentFavoriteStatus(int apartmentId, bool isFavorite) {
    if (state is ApartmentLoaded) {
      final currentApartments = (state as ApartmentLoaded).apartments;

      final updatedList = currentApartments.map((apt) {
        if (apt.id == apartmentId) {
          apt.isFavorite = isFavorite;
          return apt;
        }
        return apt;
      }).toList();

      emit(ApartmentLoaded(updatedList));
    }
  }

  Future<void> fetchApartments({Map<String, dynamic>? filters}) async {
    emit(ApartmentLoading());

    try {
      final List<ApartmentModel> apartments;

      if (filters == null || filters.isEmpty) {
        apartments = await apartmentRepo.getAllApartments();
      } else {
        apartments = await apartmentRepo.getFilteredApartments(filters);
      }

      emit(ApartmentLoaded(apartments));
    } on ApiException catch (e) {
      emit(ApartmentError(e.message));
    } catch (e) {
      emit(ApartmentError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
