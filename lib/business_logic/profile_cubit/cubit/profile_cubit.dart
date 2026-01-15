import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/profile_model.dart';
import 'package:pluto_ui/data/repositories/profile_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    try {
      final ProfileModel profile = await profileRepo.getUserProfile();

      emit(ProfileLoaded(profile));
    } on ApiException catch (e) {
      emit(ProfileError(e.message));
    } catch (e) {
      emit(ProfileError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
