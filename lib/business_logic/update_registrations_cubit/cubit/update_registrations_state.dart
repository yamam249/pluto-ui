part of 'update_registrations_cubit.dart';

sealed class UpdateRegistrationsState extends Equatable {
  const UpdateRegistrationsState();

  @override
  List<Object> get props => [];
}

final class UpdateRegistrationsInitial extends UpdateRegistrationsState {}

final class UpdateRegistrationsLoading extends UpdateRegistrationsState {}

final class UpdateRegistrationsLoaded extends UpdateRegistrationsState {
  final List<UpdateRegistrationModel> updateRequests;

  const UpdateRegistrationsLoaded(this.updateRequests);

  @override
  List<Object> get props => [updateRequests];
}

final class UpdateRegistrationsError extends UpdateRegistrationsState {
  final String message;

  const UpdateRegistrationsError(this.message);

  @override
  List<Object> get props => [message];
}
