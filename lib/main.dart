import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:umich_msa/constants.dart';
import 'msa_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded<Future<void>>(() async {
    await Firebase.initializeApp();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(MaterialApp(
      debugShowCheckedModeBanner: MSAConstants.isDebug,
      themeMode: ThemeMode.system,
      theme: ThemeData(fontFamily: "Cronos-Pro"),
      title: "UMICH MSA",
      navigatorKey: MsaRouter.instance.navigatorKey,
      home: MsaRouter.instance.homeAsSplashScreen,
    ));
  }, (error, stackTrace) async {
    // print('error: $error');
    // print('stackTrace: $stackTrace');
  });

  // You only need to call this method if you need the binding to be initialized before calling runApp.
  WidgetsFlutterBinding.ensureInitialized();
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    final dynamic exception = details.exception;
    final StackTrace? stackTrace = details.stack;
    if (MSAConstants.isDebug) {
      // print('Caught Framework Error!');
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone
      Zone.current.handleUncaughtError(exception, stackTrace!);
    }
  };
}
