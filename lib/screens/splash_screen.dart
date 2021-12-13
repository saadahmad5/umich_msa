import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/home_screen.dart';
import 'package:umich_msa/screens/signin_screen.dart';
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
    return Padding(
      padding: EdgeInsets.only(top: 500),
      child: SpinKitChasingDots(
        color: Color.fromARGB(230, 252, 210, 12),
        size: 60.0,
      ),
    );
  }

  Widget UnauthenticatedWidgets() {
    return Padding(
      padding: EdgeInsets.only(top: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () {
              showAuthOptionsDialog(context);
            },
            child: Row(
              children: [
                Icon(Icons.people_outlined),
                SizedBox(
                  width: 8.0,
                ),
                Text("MSA Admin"),
              ],
            ),
            color: Colors.green[900],
            textColor: Colors.white,
          ),
          SizedBox(
            width: 16.0,
          ),
          RaisedButton(
            onPressed: () {
              MsaRouter.instance.pushAndRemoveUntil(HomeScreen.route());
            },
            child: Row(
              children: [
                Icon(Icons.public_outlined),
                SizedBox(
                  width: 8.0,
                ),
                Text("MSA Member"),
              ],
            ),
            color: Colors.green[500],
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          image: DecorationImage(
            image: AssetImage("assets/images/half.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: isAuth ? AuthenticatedWidgets() : UnauthenticatedWidgets());
  }

  showAuthOptionsDialog(BuildContext context) {
    // set up the buttons
    Widget signInButton = TextButton(
      child: Text(
        "Sign-In",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        MsaRouter.instance.pushReplacement(SignInScreen.route());
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget signUpButton = TextButton(
      child: Text(
        "Sign-Up",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        MsaRouter.instance.pushReplacement(SignUpScreen.route());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Authentication"),
      content: Text("Do you want to Sign-In or Sign-Up?"),
      actions: [
        cancelButton,
        signInButton,
        signUpButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
