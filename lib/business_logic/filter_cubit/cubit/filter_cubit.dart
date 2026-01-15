import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/governorate_model.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  final ApartmentRepo apartmentRepo;
  List<GovernorateModel> cachedGovernorates = [];
  FilterCubit(this.apartmentRepo) : super(FilterInitial());

  void getGovernorates() async {
    emit(FilterLoadingGovernorates());
    try {
      cachedGovernorates = await apartmentRepo.getGovernorates();

      emit(FilterGovernoratesLoaded(cachedGovernorates));
    } catch (e) {
      emit(FilterError(e.toString()));
    }
  }

  void getCities(int governorateId) async {
    emit(FilterLoadingCities(cachedGovernorates));
    try {
      final cities = await apartmentRepo.getCities(governorateId);

      emit(FilterCitiesLoaded(cities, cachedGovernorates));
    } catch (e) {
      emit(FilterError(e.toString()));
    }
  }
}
