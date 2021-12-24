import 'package:umich_msa/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class MsaRouter {
  factory MsaRouter() => _router;
  MsaRouter._();
  static final MsaRouter _router = MsaRouter._();
  static MsaRouter get instance => _router;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Widget homeAsSplashScreen = const SplashScreen();

  Future<T?> push<T extends Object>(Route<T> route) async {
    return navigatorKey.currentState!.push(route);
  }

  Future<T?> pushReplacement<T extends Object>(Route<T> route) async {
    return navigatorKey.currentState!.pushReplacement(route);
  }

  Future<T?> pushAndRemoveUntil<T extends Object>(
    Route<T> route, {
    String? untilRoute,
  }) async {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      route,
      (Route<dynamic> _route) {
        return untilRoute == _route.settings.name;
      },
    );
  }

  void pop() {
    navigatorKey.currentState!.pop();
  }

  void popUntil(String route) {
    return navigatorKey.currentState!.popUntil(ModalRoute.withName(route));
  }

  /// Page route builder with forced fade in / out transition.
  static PageRouteBuilder<Widget> fadeTransition(
    RouteSettings settings, {
    required Widget screen,
  }) {
    return PageRouteBuilder<Widget>(
      settings: settings,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return screen;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Page route builder with forced slide in from top
  static PageRouteBuilder<Widget> fromTopTransition(
    RouteSettings settings, {
    required Widget screen,
  }) {
    return PageRouteBuilder<Widget>(
      settings: settings,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return screen;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
