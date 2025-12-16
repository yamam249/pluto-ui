part of 'apartment_details_cubit.dart';

@immutable
sealed class ApartmentDetailsState extends Equatable {
  const ApartmentDetailsState();

  @override
  List<Object> get props => [];
}

final class ApartmentDetailsInitial extends ApartmentDetailsState {}

final class ApartmentDetailsLoading extends ApartmentDetailsState {}

final class ApartmentDetailsLoaded extends ApartmentDetailsState {
  final ApartmentModel apartment;

  const ApartmentDetailsLoaded(this.apartment);

  @override
  List<Object> get props => [apartment];
}

final class ApartmentDetailsError extends ApartmentDetailsState {
  final String message;

  const ApartmentDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
