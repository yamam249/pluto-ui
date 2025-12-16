import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/business_logic/apartment_details_cubit/cubit/apartment_details_cubit.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';
import 'package:pluto_ui/data/web_services/apartment_api.dart';

// Data
import 'package:pluto_ui/data/web_services/signup_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';
import 'package:pluto_ui/data/repositories/signup_repo.dart';
import 'package:pluto_ui/data/repositories/login_auth_repo.dart';
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';

// Cubits
import 'package:pluto_ui/business_logic/sign_up_cubit/cubit/sign_up_cubit.dart';
import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';
import 'package:pluto_ui/presentation/screens/apartment_details_screen.dart';

// Screens
import 'package:pluto_ui/presentation/screens/log_in_screen.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart';
import 'package:pluto_ui/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(PlutoApp());
  });
}

class PlutoApp extends StatelessWidget {
  // Services/APIs
  final SignupApi signupApi = SignupApi();
  final LoginApi loginApi = LoginApi();
  final ApartmentApi apartmentApi = ApartmentApi();
  final SecureStorageService secureStorageService = SecureStorageService();

  // Repositories (Injecting Services)
  late final SignupRepo signupRepo = SignupRepo(signupApi);
  late final LoginAuthRepo loginAuthRepo = LoginAuthRepo(
    loginApi,
    secureStorageService,
  );
  late final ApartmentRepo apartmentRepo = ApartmentRepo(
    apartmentApi,
    secureStorageService,
  );

  @override
  Widget build(BuildContext context) {
    final signupRepo = SignupRepo(SignupApi());
    final loginRepo = LoginAuthRepo(LoginApi(), SecureStorageService());

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignUpCubit(signupRepo)),
        BlocProvider(
          create: (_) {
            final cubit = LoginCubit(loginRepo);
            cubit.checkAuthStatus();
            return cubit;
          },
        ),

        // 3. Apartment Cubit Provider
        BlocProvider<ApartmentCubit>(
          create: (context) {
            final cubit = ApartmentCubit(apartmentRepo);
            // 💡 CRITICAL: Fetch apartments immediately upon creation for the Home Screen
            cubit.fetchApartments();
            return cubit;
          },
        ),

        BlocProvider<ApartmentDetailsCubit>(
          create: (context) => ApartmentDetailsCubit(apartmentRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        /// ✅ هنا الراوتر
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/app_router': (context) =>
              RootLayout(isDark: false, onThemeChanged: (_) {}),
        },
      ),
    );
  }
}
