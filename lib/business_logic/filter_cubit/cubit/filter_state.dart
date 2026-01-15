part of 'filter_cubit.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object?> get props => [];
}

class FilterInitial extends FilterState {}

class FilterLoadingGovernorates extends FilterState {}

class FilterGovernoratesLoaded extends FilterState {
  final List<GovernorateModel> governorates;

  const FilterGovernoratesLoaded(this.governorates);

  @override
  List<Object?> get props => [governorates];
}

class FilterError extends FilterState {
  final String message;

  const FilterError(this.message);

  @override
  List<Object?> get props => [message];
}

class FilterCitiesLoaded extends FilterState {
  final List<CityModel> cities;
  final List<GovernorateModel> governorates;
  const FilterCitiesLoaded(this.cities, this.governorates);
  @override
  List<Object> get props => [cities, governorates];
}

class FilterLoadingCities extends FilterState {
  final List<GovernorateModel> governorates;
  const FilterLoadingCities(this.governorates);

  @override
  List<Object> get props => [governorates];
}
