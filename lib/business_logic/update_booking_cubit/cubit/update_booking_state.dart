part of 'update_booking_cubit.dart';

sealed class UpdateBookingState extends Equatable {
  const UpdateBookingState();

  @override
  List<Object?> get props => [];
}

final class UpdateBookingInitial extends UpdateBookingState {}

final class UpdateBookingLoading extends UpdateBookingState {}

final class UpdateBookingSuccess extends UpdateBookingState {
  final String message;
  const UpdateBookingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class UpdateBookingValidationError extends UpdateBookingState {
  final Map<String, List<String>> errors;
  const UpdateBookingValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}

final class UpdateBookingFailure extends UpdateBookingState {
  final String error;
  const UpdateBookingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
