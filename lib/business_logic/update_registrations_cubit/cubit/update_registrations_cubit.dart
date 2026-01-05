import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/update_registration_model.dart';
import 'package:pluto_ui/data/repositories/booking_repo.dart';

part 'update_registrations_state.dart';

class UpdateRegistrationsCubit extends Cubit<UpdateRegistrationsState> {
  final BookingRepo _bookingRepo;

  UpdateRegistrationsCubit(this._bookingRepo)
    : super(UpdateRegistrationsInitial());

  Future<void> fetchUpdateRequests() async {
    emit(UpdateRegistrationsLoading());
    try {
      final requests = await _bookingRepo.getUpdateRequests();
      emit(UpdateRegistrationsLoaded(requests));
    } catch (e) {
      emit(UpdateRegistrationsError(e.toString()));
    }
  }

  Future<void> acceptUpdate(int requestId) async {
    try {
      await _bookingRepo.acceptUpdate(requestId);

      await fetchUpdateRequests();
    } catch (e) {
      emit(UpdateRegistrationsError(e.toString()));
    }
  }

  Future<void> deleteUpdate(int requestId) async {
    try {
      await _bookingRepo.deleteUpdate(requestId);

      await fetchUpdateRequests();
    } catch (e) {
      emit(UpdateRegistrationsError(e.toString()));
    }
  }
}
