import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/create_booking_model.dart';
import 'package:pluto_ui/data/repositories/booking_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';

part 'create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  final BookingRepo _bookingRepo;

  CreateBookingCubit(this._bookingRepo) : super(CreateBookingInitial());

  Future<void> submitBooking(CreateBookingModel bookingData) async {
    emit(CreateBookingLoading());

    try {
      final successMessage = await _bookingRepo.createBooking(bookingData);
      emit(CreateBookingSuccess(successMessage));
    } on ValidationException catch (e) {
      emit(CreateBookingValidationError(e.errors));
    } on ApiException catch (e) {
      emit(CreateBookingError(e.message));
    } catch (e) {
      emit(const CreateBookingError("An unexpected error occurred."));
    }
  }

  void clearErrors() {
    if (state is CreateBookingValidationError || state is CreateBookingError) {
      emit(CreateBookingInitial());
    }
  }
}
