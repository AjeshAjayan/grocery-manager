import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_manager/app/app_home_screen.dart';
import 'package:grocery_manager/app/models/user_model.dart';
import 'package:grocery_manager/app_theme.dart';
import 'package:grocery_manager/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {

          // Check for errors
          if (snapshot.hasError) {
            return Center(
              child: Text("error"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // some massage
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: AppTheme.textTheme,
                platform: TargetPlatform.iOS,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: AppHomeScreen(),
              // home: Login(),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center();
        });
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
