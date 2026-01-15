import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SecureStorageService _storageService;
  ThemeCubit(this._storageService) : super(ThemeMode.light);

  // Load saved theme on app startup
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

// class ThemeCubit extends Cubit<ThemeMode> {
//   final SecureStorageService _storageService;
//   String? _currentUserId; // Keep track of who is logged in

//   ThemeCubit(this._storageService) : super(ThemeMode.light);

//   // Call this after successful login or during splash check
//   Future<void> loadThemeForUser(String userId) async {
//     _currentUserId = userId;
//     final savedTheme = await _storageService.getUserTheme(userId);
//     emit(savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light);
//   }

//   void toggleTheme() {
//     if (_currentUserId == null) return; // Don't save if no user is logged in

//     final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     emit(newMode);

//     _storageService.saveUserTheme(
//       _currentUserId!,
//       newMode == ThemeMode.dark ? 'dark' : 'light',
//     );
//   }
// }
