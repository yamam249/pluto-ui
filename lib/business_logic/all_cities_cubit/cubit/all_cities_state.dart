part of 'all_cities_cubit.dart';

abstract class AllCitiesState extends Equatable {
  const AllCitiesState();

  @override
  List<Object?> get props => [];
}

class AllCitiesInitial extends AllCitiesState {}

class AllCitiesLoading extends AllCitiesState {}

class AllCitiesLoaded extends AllCitiesState {
  final List<CityModel> cities;

  const AllCitiesLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class AllCitiesError extends AllCitiesState {
  final String message;

  const AllCitiesError(this.message);

  @override
  List<Object?> get props => [message];
}
