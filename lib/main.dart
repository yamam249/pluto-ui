// void main() {
//   WidgetsFlutterBinding.ensureInitialized(); // thess lines for locking the device orientation
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
//     fn,
//   ) {
//     runApp(PlutoApp());
//   });
// }

// class PlutoApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: SignUpScreen());
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; //
import 'package:pluto_ui/business_logic/sign_up_cubit/cubit/sign_up_cubit.dart';
import 'package:pluto_ui/data/repositories/signup_repo.dart';
import 'package:pluto_ui/data/web_services/signup_api.dart';
import 'package:pluto_ui/presentation/screens/log_in_screen.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    fn,
  ) {
    runApp(PlutoApp());
  });
}

class PlutoApp extends StatelessWidget {
  final SignupApi signupApi = SignupApi();
  late final SignupRepo signupRepo = SignupRepo(signupApi);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(signupRepo),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignUpScreen(),
      ),
    );
  }
}
