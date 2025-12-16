import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;

part 'apartment_details_state.dart';

class ApartmentDetailsCubit extends Cubit<ApartmentDetailsState> {
  final ApartmentRepo apartmentRepo;

  ApartmentDetailsCubit(this.apartmentRepo) : super(ApartmentDetailsInitial());

  Future<void> fetchApartmentDetails(int apartmentId) async {
    emit(ApartmentDetailsLoading());

    try {
      final ApartmentModel apartment = await apartmentRepo.getApartmentDetails(
        apartmentId,
      );

      emit(ApartmentDetailsLoaded(apartment));
    } on ApiException catch (e) {
      emit(ApartmentDetailsError(e.message));
    } catch (e) {
      emit(
        ApartmentDetailsError('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
