import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:pluto_ui/firebase_options.dart';
import 'package:pluto_ui/presentation/screens/log_in_screen.dart';
import 'package:pluto_ui/presentation/screens/mode_screen.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart';
import 'package:pluto_ui/root_layout.dart';
import 'package:pluto_ui/presentation/screens/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        child: PlutoApp(),
      ),
    );
  });
}

class PlutoApp extends StatefulWidget {
  PlutoApp({super.key});

  @override
  State<PlutoApp> createState() => _PlutoAppState();
}

class _PlutoAppState extends State<PlutoApp> {
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
  void initState() {
    super.initState();
    _initPushNotifications();
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _initPushNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description:
          'This channel is used for important apartment booking updates.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    String? token = await messaging.getToken();
    if (token != null) {
      await secureStorageService.saveFcmToken(token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
              fullScreenIntent: true,
              styleInformation: const DefaultStyleInformation(true, true),
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });
  }

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
        BlocProvider(
          create: (_) => ThemeCubit(secureStorageService)..loadTheme(),
        ),
      ],

      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (stateContext, mode) {
                return MaterialApp(
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,

                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: mode,

                  initialRoute: '/',
                  routes: {
                    '/': (context) => SplashScreen(),
                    '/login': (context) => LoginScreen(),
                    '/signup': (context) => const SignUpScreen(),
                    '/app_router': (context) => RootLayout(),
                    '/mode': (context) => ModeScreen(),
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
