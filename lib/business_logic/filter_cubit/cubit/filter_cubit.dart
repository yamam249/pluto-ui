import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/governorate_model.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  final ApartmentRepo apartmentRepo;
  List<GovernorateModel> cachedGovernorates = [];
  Future<void> Function()? _lastFailedAction;
  FilterCubit(this.apartmentRepo) : super(FilterInitial());

  Future<void> retryLastAction() async {
    if (_lastFailedAction != null) await _lastFailedAction!();
  }

  void getGovernorates() async {
    _lastFailedAction = () => Future.sync(() => getGovernorates());
    emit(FilterLoadingGovernorates());
    try {
      cachedGovernorates = await apartmentRepo.getGovernorates();

      emit(FilterGovernoratesLoaded(cachedGovernorates));
      _lastFailedAction = null;
    } catch (e) {
      emit(FilterError(e.toString()));
    }
  }

  void getCities(int governorateId) async {
    _lastFailedAction = () => Future.sync(() => getCities(governorateId));
    emit(FilterLoadingCities(cachedGovernorates));
    try {
      final cities = await apartmentRepo.getCities(governorateId);

      emit(FilterCitiesLoaded(cities, cachedGovernorates));
      _lastFailedAction = null;
    } catch (e) {
      emit(FilterError(e.toString()));
    }
  }
}
