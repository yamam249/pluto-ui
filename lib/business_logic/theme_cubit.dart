import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SecureStorageService _storageService;
  ThemeCubit(this._storageService) : super(ThemeMode.light);

  Future<void> loadTheme() async {
    final savedTheme = await _storageService.getTheme();
    if (savedTheme == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
      _storageService.saveTheme('dark');
    } else {
      emit(ThemeMode.light);
      _storageService.saveTheme('light');
    }
  }
}
