import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/registration_model.dart';
import 'package:pluto_ui/data/repositories/booking_repo.dart';

part 'registrations_state.dart';

class RegistrationsCubit extends Cubit<RegistrationsState> {
  final BookingRepo _repo;

  RegistrationsCubit(this._repo) : super(RegistrationsInitial());

  Future<void> fetchRegistrations() async {
    emit(RegistrationsLoading());

    try {
      final data = await _repo.getRegistrations();
      emit(RegistrationsLoaded(data));
    } catch (e) {
      emit(RegistrationsError(e.toString()));
    }
  }

  Future<void> acceptBooking(int bookingId) async {
    try {
      await _repo.acceptBooking(bookingId);

      await fetchRegistrations();
    } catch (e) {
      emit(RegistrationsError(e.toString()));
    }
  }

  Future<void> declineBooking(int bookingId) async {
    try {
      await _repo.declineBooking(bookingId);

      await fetchRegistrations();
    } catch (e) {
      emit(RegistrationsError(e.toString()));
    }
  }
}
