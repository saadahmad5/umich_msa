import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'msa_router.dart';

const bool isInDebugMode = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded<Future<void>>(() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(MaterialApp(
      themeMode: ThemeMode.system,
      title: "UMICH MSA",
      navigatorKey: MsaRouter.instance.navigatorKey,
      home: MsaRouter.instance.home,
    ));
  }, (error, stackTrace) async {
    print('error: $error');
    print('stackTrace: $stackTrace');
  });

  // You only need to call this method if you need the binding to be initialized before calling runApp.
  WidgetsFlutterBinding.ensureInitialized();
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    final dynamic exception = details.exception;
    final StackTrace? stackTrace = details.stack;
    if (isInDebugMode) {
      print('Caught Framework Error!');
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone
      Zone.current.handleUncaughtError(exception, stackTrace!);
    }
  };
}
