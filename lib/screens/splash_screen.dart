import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  static String routeName = 'splashScreen';
  static Route<SplashScreen> route() {
    return MaterialPageRoute<SplashScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => SplashScreen(),
    );
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 30, 48, 96),
        image: DecorationImage(
          image: AssetImage("assets/images/splashScreen.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 500),
        child: SpinKitChasingDots(
          color: Color.fromARGB(230, 252, 210, 12),
          size: 60.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        MsaRouter.instance.pushReplacement(HomeScreen.route());
      },
    );
  }
}
