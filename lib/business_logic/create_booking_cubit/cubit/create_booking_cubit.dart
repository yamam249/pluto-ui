// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'create_booking_state.dart';

// class CreateBookingCubit extends Cubit<CreateBookingState> {
//   CreateBookingCubit() : super(CreateBookingInitial());
// }

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/create_booking_model.dart';
import 'package:pluto_ui/data/repositories/booking_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart'; // To access the Exceptions

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
      // Handles 422 errors specifically
      emit(CreateBookingValidationError(e.errors));
    } on ApiException catch (e) {
      // Handles 402, 409, 401, etc.
      emit(CreateBookingError(e.message));
    } catch (e) {
      emit(const CreateBookingError("An unexpected error occurred."));
    }
  }

  // Optional: Method to reset state when user changes dates
  void clearErrors() {
    if (state is CreateBookingValidationError || state is CreateBookingError) {
      emit(CreateBookingInitial());
    }
  }
}
