import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/update_booking_request_model.dart';
import 'package:pluto_ui/data/repositories/booking_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';

part 'update_booking_state.dart';

class UpdateBookingCubit extends Cubit<UpdateBookingState> {
  final BookingRepo _bookingRepo;

  UpdateBookingCubit(this._bookingRepo) : super(UpdateBookingInitial());

  Future<void> submitUpdate(
    UpdateBookingRequestModel request,
    int bookingId,
  ) async {
    emit(UpdateBookingLoading());

    try {
      final message = await _bookingRepo.updateBooking(bookingId, request);
      emit(UpdateBookingSuccess(message));
    } on ValidationException catch (e) {
      emit(UpdateBookingValidationError(e.errors));
    } on ApiException catch (e) {
      emit(UpdateBookingFailure(e.message));
    } catch (e) {
      emit(const UpdateBookingFailure("An unexpected error occurred."));
    }
  }
}
