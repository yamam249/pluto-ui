import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Data Layer Imports
import 'package:pluto_ui/data/web_services/signup_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';
import 'package:pluto_ui/data/repositories/signup_repo.dart';
import 'package:pluto_ui/data/repositories/login_auth_repo.dart';
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';

// Business Logic Layer Imports
import 'package:pluto_ui/business_logic/sign_up_cubit/cubit/sign_up_cubit.dart';
import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';

// Presentation Layer Imports
import 'package:pluto_ui/presentation/screens/root_layout.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart';
import 'package:pluto_ui/presentation/screens/home_screen.dart';
import 'package:pluto_ui/presentation/screens/log_in_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure the app stays in portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    fn,
  ) {
    runApp(PlutoApp());
  });
}

class PlutoApp extends StatelessWidget {
  // Services/APIs
  final SignupApi signupApi = SignupApi();
  final LoginApi loginApi = LoginApi();
  final SecureStorageService secureStorageService = SecureStorageService();

  // Repositories (Injecting Services)
  late final SignupRepo signupRepo = SignupRepo(signupApi);
  late final LoginAuthRepo loginAuthRepo = LoginAuthRepo(
    loginApi,
    secureStorageService,
  );

  @override
  Widget build(BuildContext context) {
    // Use MultiBlocProvider to provide all top-level BLoCs/Cubits
    return MultiBlocProvider(
      providers: [
        // 1. SignUp Cubit Provider
        BlocProvider<SignUpCubit>(create: (context) => SignUpCubit(signupRepo)),
        // 2. Login Cubit Provider (with Auth check upon creation)
        BlocProvider<LoginCubit>(
          create: (context) {
            final cubit = LoginCubit(loginAuthRepo);
            // Check auth status immediately on app start
            cubit.checkAuthStatus();
            return cubit;
          },
        ),
      ],
      // The RootLayout should handle checking the auth state and navigating
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return child!;
        },
        home: const LoginScreen(),
      ),
    );
  }
}
