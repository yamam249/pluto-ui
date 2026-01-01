part of 'create_booking_cubit.dart';

sealed class CreateBookingState extends Equatable {
  const CreateBookingState();

  @override
  List<Object?> get props => [];
}

final class CreateBookingInitial extends CreateBookingState {}

final class CreateBookingLoading extends CreateBookingState {}

final class CreateBookingSuccess extends CreateBookingState {
  final String message;
  const CreateBookingSuccess(this.message);

  @override
  List<Object> get props => [message];
}

// For 402, 409, and general errors
final class CreateBookingError extends CreateBookingState {
  final String message;
  const CreateBookingError(this.message);

  @override
  List<Object> get props => [message];
}

// Specifically for 422 Validation Errors
final class CreateBookingValidationError extends CreateBookingState {
  final Map<String, List<String>> errors;
  const CreateBookingValidationError(this.errors);

  @override
  List<Object> get props => [errors];
}
