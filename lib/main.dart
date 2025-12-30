import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/app_router.dart';

import 'package:pluto_ui/data/web_services/signup_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';
import 'package:pluto_ui/data/web_services/apartment_api.dart';
import 'package:pluto_ui/data/web_services/profile_api.dart';
import 'package:pluto_ui/data/web_services/post_apartment_api.dart';
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';

import 'package:pluto_ui/data/repositories/signup_repo.dart';
import 'package:pluto_ui/data/repositories/login_auth_repo.dart';
import 'package:pluto_ui/data/repositories/apartment_repo.dart';
import 'package:pluto_ui/data/repositories/profile_repo.dart';
import 'package:pluto_ui/data/repositories/post_apartment_repo.dart';

import 'package:pluto_ui/business_logic/sign_up_cubit/cubit/sign_up_cubit.dart';
import 'package:pluto_ui/business_logic/login_cubit/cubit/login_cubit.dart';
import 'package:pluto_ui/business_logic/all_cities_cubit/cubit/all_cities_cubit.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/business_logic/apartment_details_cubit/cubit/apartment_details_cubit.dart';
import 'package:pluto_ui/business_logic/favorite_cubit/cubit/favorite_cubit.dart';
import 'package:pluto_ui/business_logic/filter_cubit/cubit/filter_cubit.dart';
import 'package:pluto_ui/business_logic/post_apartment_cubit/cubit/post_apartment_cubit.dart';
import 'package:pluto_ui/business_logic/profile_cubit/cubit/profile_cubit.dart';

import 'package:pluto_ui/presentation/screens/log_in_screen.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart';
<<<<<<< HEAD
import 'package:pluto_ui/root_layout.dart';
=======
import 'package:pluto_ui/presentation/screens/splash_screen.dart';
>>>>>>> 9b71d552938f3de898942bb93ff9f270071317b3

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(PlutoApp());
  });
}

class PlutoApp extends StatelessWidget {
  PlutoApp({super.key});


  void _showErrorSnackBar(BuildContext context, String message, VoidCallback onRetry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.kColorDanger,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "RETRY",
          textColor: Colors.white,
          onPressed: onRetry,
        ),
      ),
    );
  }
  final SignupApi signupApi = SignupApi();
  final LoginApi loginApi = LoginApi();
  final ApartmentApi apartmentApi = ApartmentApi();
  final SecureStorageService secureStorageService = SecureStorageService();
  final ProfileApi profileApi = ProfileApi();
  final PostApartmentApi postApartmentApi = PostApartmentApi();

  late final SignupRepo signupRepo = SignupRepo(signupApi);
  late final LoginAuthRepo loginAuthRepo = LoginAuthRepo(loginApi, secureStorageService);
  late final ApartmentRepo apartmentRepo = ApartmentRepo(apartmentApi, secureStorageService);
  late final ProfileRepo profileRepo = ProfileRepo(profileApi, secureStorageService);
  late final PostApartmentRepo postApartmentRepo = PostApartmentRepo(postApartmentApi, secureStorageService);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignUpCubit(signupRepo)),
        BlocProvider(
          create: (_) {
            final cubit = LoginCubit(loginAuthRepo);
            cubit.checkAuthStatus();
            return cubit;
          },
        ),
        BlocProvider<ApartmentCubit>(
          create: (context) => ApartmentCubit(apartmentRepo)..fetchApartments(),
        ),
        BlocProvider<ApartmentDetailsCubit>(
          create: (context) => ApartmentDetailsCubit(apartmentRepo),
        ),
        BlocProvider<FavoriteCubit>(
          create: (context) => FavoriteCubit(apartmentRepo, context.read<ApartmentCubit>()),
        ),
        BlocProvider<FilterCubit>(
          create: (context) => FilterCubit(apartmentRepo),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepo),
        ),
        BlocProvider<AllCitiesCubit>(
          create: (context) => AllCitiesCubit(apartmentRepo)..getAllCities(),
        ),
        BlocProvider<PostApartmentCubit>(
          create: (context) => PostApartmentCubit(postApartmentRepo),
        ),
      ],
<<<<<<< HEAD
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        // home: RootLayout(isDark: false, onThemeChanged: (_) {}),
        // /// ✅ هنا الراوتر
        initialRoute: '/login',
        // initialRoute: '/app_router',

        // // The builder ensures this listener stays active across all routes/screens
        // builder: (context, child) {
        //   return BlocListener<FavoriteCubit, FavoriteState>(
        //     listenWhen: (previous, current) => current is FavoriteError,
        //     listener: (context, state) {
        //       if (state is FavoriteError) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(
        //             content: Text(state.message),
        //             backgroundColor: AppColors.kColorDanger,
        //             behavior: SnackBarBehavior.floating,
        //             action: SnackBarAction(
        //               label: "RETRY",
        //               textColor: Colors.white,
        //               onPressed: () {
        //                 // Trigger the universal retry logic
        //                 context.read<FavoriteCubit>().retryLastAction();
        //               },
        //             ),
        //           ),
        //         );
        //       }
        //     },
        //     child: child!, // This represents the screens of your app
        //   );
        // },
=======
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
>>>>>>> 9b71d552938f3de898942bb93ff9f270071317b3
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',

            routes: {
              '/': (context) => const SplashScreen(isDark: false),
              '/login': (context) => LoginScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/app_router': (context) => RootLayout(isDark: false, onThemeChanged: (_) {}),
            },

            builder: (context, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<FavoriteCubit, FavoriteState>(
                    listenWhen: (p, c) => c is FavoriteError,
                    listener: (context, state) => _showErrorSnackBar(
                      context, (state as FavoriteError).message,
                          () => context.read<FavoriteCubit>().retryLastAction(),
                    ),
                  ),
                  BlocListener<ApartmentCubit, ApartmentState>(
                    listenWhen: (p, c) => c is ApartmentError,
                    listener: (context, state) => _showErrorSnackBar(
                      context, (state as ApartmentError).message,
                          () => context.read<ApartmentCubit>().retryLastAction(),
                    ),
                  ),
                  BlocListener<ApartmentDetailsCubit, ApartmentDetailsState>(
                    listenWhen: (p, c) => c is ApartmentDetailsError,
                    listener: (context, state) => _showErrorSnackBar(
                      context, (state as ApartmentDetailsError).message,
                          () => context.read<ApartmentDetailsCubit>().retryLastAction(),
                    ),
                  ),
                  BlocListener<FilterCubit, FilterState>(
                    listenWhen: (p, c) => c is FilterError,
                    listener: (context, state) => _showErrorSnackBar(
                      context, (state as FilterError).message,
                          () => context.read<FilterCubit>().retryLastAction(),
                    ),
                  ),
                  BlocListener<ProfileCubit, ProfileState>(
                    listenWhen: (p, c) => c is ProfileError,
                    listener: (context, state) => _showErrorSnackBar(
                      context, (state as ProfileError).message,
                          () => context.read<ProfileCubit>().retryLastAction(),
                    ),
                  ),
                  BlocListener<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LogoutSuccess) {
                        navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
                      }
                    },
                  ),
                  BlocListener<PostApartmentCubit, PostApartmentState>(
                    listenWhen: (p, c) => c is PostApartmentError,
                    listener: (context, state) {
                      final error = (state as PostApartmentError).error;
                      if (error is String) {
                        _showErrorSnackBar(context, error, () {});
                      }
                    },
                  ),
                ],
                child: child!,
              );
            },
          );
        },
<<<<<<< HEAD

        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/app_router': (context) =>
              RootLayout(isDark: false, onThemeChanged: (_) {}),
        },
=======
>>>>>>> 9b71d552938f3de898942bb93ff9f270071317b3
      ),
    );
  }
}