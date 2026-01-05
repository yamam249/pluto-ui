import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final ApartmentRepo apartmentRepo;

  RatingCubit(this.apartmentRepo) : super(RatingInitial());

  Future<void> submitRating(int apartmentId, double rating) async {
    emit(RatingLoading());

    try {
      final message = await apartmentRepo.rateApartment(apartmentId, rating);
      emit(RatingSuccess(message));
    } on ApiException catch (e) {
      emit(RatingError(e.message));
    } catch (e) {
      emit(
        const RatingError("An unexpected error occurred. Please try again."),
      );
    }
  }
}
