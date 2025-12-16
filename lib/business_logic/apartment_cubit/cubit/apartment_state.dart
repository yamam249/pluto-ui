part of 'apartment_cubit.dart';

@immutable
sealed class ApartmentState extends Equatable {
  const ApartmentState();

  @override
  List<Object> get props => [];
}

final class ApartmentInitial extends ApartmentState {}

final class ApartmentLoading extends ApartmentState {}

final class ApartmentLoaded extends ApartmentState {
  final List<ApartmentModel> apartments;

  const ApartmentLoaded(this.apartments);

  @override
  List<Object> get props => [apartments];
}

final class ApartmentError extends ApartmentState {
  final String message;

  const ApartmentError(this.message);

  @override
  List<Object> get props => [message];
}
