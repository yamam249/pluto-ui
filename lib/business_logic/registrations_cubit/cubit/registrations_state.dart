part of 'registrations_cubit.dart';

sealed class RegistrationsState extends Equatable {
  const RegistrationsState();

  @override
  List<Object> get props => [];
}

final class RegistrationsInitial extends RegistrationsState {}

final class RegistrationsLoading extends RegistrationsState {}

final class RegistrationsLoaded extends RegistrationsState {
  final List<RegistrationModel> registrations;

  const RegistrationsLoaded(this.registrations);

  @override
  List<Object> get props => [registrations];
}

final class RegistrationsError extends RegistrationsState {
  final String message;

  const RegistrationsError(this.message);

  @override
  List<Object> get props => [message];
}
