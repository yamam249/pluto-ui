import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:pluto_ui/data/models/profile_model.dart';
import 'package:pluto_ui/data/repositories/profile_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  // Stores the last function that failed to allow for a 'Retry' button in the UI
  Future<void> Function()? _lastFailedAction;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  /// Retries the last action that resulted in an error
  Future<void> retryLastAction() async {
    if (_lastFailedAction != null) await _lastFailedAction!();
  }

  Future<void> fetchProfile() async {
    _lastFailedAction = () => fetchProfile();
    emit(ProfileLoading());

    try {
      final ProfileModel profile = await profileRepo.getUserProfile();

      emit(ProfileLoaded(profile));
      _lastFailedAction = null; // Clear on success
    } on ApiException catch (e) {
      emit(ProfileError(e.message));
    } catch (e) {
      emit(ProfileError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
