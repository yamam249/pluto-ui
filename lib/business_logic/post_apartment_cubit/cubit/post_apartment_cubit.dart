import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/post_apartment_model.dart';
import 'package:pluto_ui/data/repositories/post_apartment_repo.dart';

part 'post_apartment_state.dart';

class PostApartmentCubit extends Cubit<PostApartmentState> {
  final PostApartmentRepo postApartmentRepo;

  PostApartmentCubit(this.postApartmentRepo) : super(PostApartmentInitial());

  Future<void> createApartment(PostApartmentModel apartment) async {
    emit(PostApartmentLoading());

    try {
      final result = await postApartmentRepo.createApartment(apartment);

      if (result is String && result == "Apartment created successfully") {
        emit(PostApartmentSuccess(result));
      } else if (result is Map<String, dynamic>) {
        emit(PostApartmentError(result));
      } else {
        emit(PostApartmentError(result.toString()));
      }
    } catch (e) {
      emit(PostApartmentError("unexpected error occured ${e.toString()}"));
    }
  }
}
