import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/history_model.dart';
import 'package:pluto_ui/data/repositories/booking_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final BookingRepo bookingRepo;

  HistoryCubit(this.bookingRepo) : super(HistoryInitial());

  Future<void> fetchHistory() async {
    emit(HistoryLoading());
    try {
      final history = await bookingRepo.getBookingHistory();
      emit(HistoryLoaded(history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    final currentState = state;

    emit(HistoryActionLoading());
    try {
      final message = await bookingRepo.cancelBooking(bookingId);

      emit(HistoryActionSuccess(message));

      await fetchHistory();
    } on ApiException catch (e) {
      emit(HistoryError(e.message));
      if (currentState is HistoryLoaded) emit(currentState);
    } catch (e) {
      emit(const HistoryError("Failed to cancel booking."));
      if (currentState is HistoryLoaded) emit(currentState);
    }
  }
}
