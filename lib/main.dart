import 'package:flutter/material.dart';
import 'package:pluto_ui/presentation/screens/log_in_screen.dart';
import 'package:pluto_ui/presentation/screens/sign_up_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // thess lines for locking the device orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    fn,
  ) {
    runApp(PlutoApp());
  });
}

class PlutoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SignUpScreen());
  }
}
