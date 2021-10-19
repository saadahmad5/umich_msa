import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/home_screen.dart';
import 'package:umich_msa/screens/signup_screen.dart';

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
  bool isAuth = false;

  Widget AuthenticatedWidgets() {
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
          )),
    );
  }

  Widget UnauthenticatedWidgets() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 30, 48, 96),
        image: DecorationImage(
          image: AssetImage("assets/images/splashScreen.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
          padding: EdgeInsets.only(top: 500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  MsaRouter.instance.pushReplacement(SignUpScreen.route());
                },
                child: Row(
                  children: [
                    Icon(Icons.person_add_alt_1_outlined),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("Sign Up"),
                  ],
                ),
                color: Colors.blue[900],
                textColor: Colors.white,
              ),
              SizedBox(
                width: 16.0,
              ),
              RaisedButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.person_outlined),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("Sign In"),
                  ],
                ),
                color: Colors.green[500],
                textColor: Colors.white,
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? AuthenticatedWidgets() : UnauthenticatedWidgets();
  }

  @override
  void initState() {
    super.initState();
    if (isAuth) {
      Future.delayed(
        const Duration(milliseconds: 2000),
        () {
          MsaRouter.instance.pushReplacement(HomeScreen.route());
        },
      );
    }
  }
}
