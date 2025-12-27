import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';

part 'all_cities_state.dart';

class AllCitiesCubit extends Cubit<AllCitiesState> {
  final ApartmentRepo apartmentRepo;

  AllCitiesCubit(this.apartmentRepo) : super(AllCitiesInitial());

  Future<void> getAllCities() async {
    emit(AllCitiesLoading());
    try {
      final cities = await apartmentRepo.getAllCities();
      emit(AllCitiesLoaded(cities));
    } catch (e) {
      emit(AllCitiesError(e.toString()));
    }
  }
}
