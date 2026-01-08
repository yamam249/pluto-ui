import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_ui/business_logic/create_booking_cubit/cubit/create_booking_cubit.dart';
import 'package:pluto_ui/business_logic/history_cubit/cubit/history_cubit.dart';
import 'package:pluto_ui/business_logic/rating_cubit/cubit/rating_cubit.dart';
import 'package:pluto_ui/business_logic/registrations_cubit/cubit/registrations_cubit.dart';
import 'package:pluto_ui/business_logic/theme_cubit.dart';
import 'package:pluto_ui/business_logic/update_booking_cubit/cubit/update_booking_cubit.dart';
import 'package:pluto_ui/business_logic/update_registrations_cubit/cubit/update_registrations_cubit.dart';

import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/repositories/booking_repo.dart';
import 'package:pluto_ui/data/web_services/booking_api.dart';
// import 'package:pluto_ui/app_router.dart';

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
import 'package:pluto_ui/presentation/screens/mode_screen.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart';
import 'package:pluto_ui/root_layout.dart';
import 'package:pluto_ui/presentation/screens/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(PlutoApp());
  });
}

class PlutoApp extends StatelessWidget {
  PlutoApp({super.key});

  void _showErrorSnackBar(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.kColorDanger,
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
  final BookingApi bookingApi = BookingApi();

  late final SignupRepo signupRepo = SignupRepo(signupApi);
  late final LoginAuthRepo loginAuthRepo = LoginAuthRepo(
    loginApi,
    secureStorageService,
  );
  late final ApartmentRepo apartmentRepo = ApartmentRepo(
    apartmentApi,
    secureStorageService,
  );
  late final ProfileRepo profileRepo = ProfileRepo(
    profileApi,
    secureStorageService,
  );
  late final PostApartmentRepo postApartmentRepo = PostApartmentRepo(
    postApartmentApi,
    secureStorageService,
  );
  late final BookingRepo bookingRepo = BookingRepo(
    bookingApi,
    secureStorageService,
  );

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
          create: (context) =>
              FavoriteCubit(apartmentRepo, context.read<ApartmentCubit>()),
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
        BlocProvider<CreateBookingCubit>(
          create: (context) => CreateBookingCubit(bookingRepo),
        ),
        BlocProvider<HistoryCubit>(
          create: (context) => HistoryCubit(bookingRepo),
        ),
        BlocProvider<RatingCubit>(
          create: (context) => RatingCubit(apartmentRepo),
        ),
        BlocProvider<UpdateBookingCubit>(
          create: (context) => UpdateBookingCubit(bookingRepo),
        ),
        BlocProvider<RegistrationsCubit>(
          create: (context) => RegistrationsCubit(bookingRepo),
        ),
        BlocProvider<UpdateRegistrationsCubit>(
          create: (context) => UpdateRegistrationsCubit(bookingRepo),
        ),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,

                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: mode, // This links the Cubit state to the UI

                initialRoute: '/',
                routes: {
                  '/': (context) => SplashScreen(),
                  '/login': (context) => LoginScreen(),
                  '/signup': (context) => const SignUpScreen(),
                  '/app_router': (context) => RootLayout(),
                  '/mode': (context) => ModeScreen(),
                },
                builder: (context, widget) {
                  return MultiBlocListener(
                    listeners: [
                      BlocListener<FavoriteCubit, FavoriteState>(
                        listenWhen: (p, c) => c is FavoriteError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as FavoriteError).message,
                          () => context.read<FavoriteCubit>().retryLastAction(),
                        ),
                      ),
                      BlocListener<ApartmentCubit, ApartmentState>(
                        listenWhen: (p, c) => c is ApartmentError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as ApartmentError).message,
                          () =>
                              context.read<ApartmentCubit>().retryLastAction(),
                        ),
                      ),
                      BlocListener<
                        ApartmentDetailsCubit,
                        ApartmentDetailsState
                      >(
                        listenWhen: (p, c) => c is ApartmentDetailsError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as ApartmentDetailsError).message,
                          () => context
                              .read<ApartmentDetailsCubit>()
                              .retryLastAction(),
                        ),
                      ),
                      BlocListener<FilterCubit, FilterState>(
                        listenWhen: (p, c) => c is FilterError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as FilterError).message,
                          () => context.read<FilterCubit>().retryLastAction(),
                        ),
                      ),
                      BlocListener<ProfileCubit, ProfileState>(
                        listenWhen: (p, c) => c is ProfileError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as ProfileError).message,
                          () => context.read<ProfileCubit>().retryLastAction(),
                        ),
                      ),
                      BlocListener<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LogoutSuccess) {
                            navigatorKey.currentState?.pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
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
                      BlocListener<CreateBookingCubit, CreateBookingState>(
                        listenWhen: (p, c) => c is CreateBookingError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as CreateBookingError).message,
                          () {},
                        ),
                      ),
                      BlocListener<HistoryCubit, HistoryState>(
                        listenWhen: (p, c) => c is HistoryError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as HistoryError).message,
                          () => context.read<HistoryCubit>().fetchHistory(),
                        ),
                      ),
                      BlocListener<RatingCubit, RatingState>(
                        listenWhen: (p, c) => c is RatingError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as RatingError).message,
                          () {},
                        ),
                      ),
                      BlocListener<UpdateBookingCubit, UpdateBookingState>(
                        listenWhen: (p, c) => c is UpdateBookingFailure,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as UpdateBookingFailure).error,
                          () {},
                        ),
                      ),
                      BlocListener<RegistrationsCubit, RegistrationsState>(
                        listenWhen: (p, c) => c is RegistrationsError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as RegistrationsError).message,
                          () => context
                              .read<RegistrationsCubit>()
                              .fetchRegistrations(),
                        ),
                      ),
                      BlocListener<
                        UpdateRegistrationsCubit,
                        UpdateRegistrationsState
                      >(
                        listenWhen: (p, c) => c is UpdateRegistrationsError,
                        listener: (context, state) => _showErrorSnackBar(
                          context,
                          (state as UpdateRegistrationsError).message,
                          () => context
                              .read<UpdateRegistrationsCubit>()
                              .fetchUpdateRequests(),
                        ),
                      ),
                    ],
                    child: widget!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
