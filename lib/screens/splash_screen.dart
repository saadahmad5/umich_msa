import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/member_dialog_component.dart';
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

  Widget authenticatedWidgets() {
    return SpinKitChasingDots(
      color: MSAConstants.yellowColor,
      size: 60.0,
    );
  }

  Widget unauthenticatedWidgets() {
    return Row(
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
          color: Colors.blue[800],
          textColor: Colors.white,
        ),
        SizedBox(
          width: 16.0,
        ),
        RaisedButton(
          onPressed: () {
            showMemberSignInDialog(context);
            //MsaRouter.instance.pushAndRemoveUntil(HomeScreen.route());
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
          color: Colors.green[700],
          textColor: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/MSA LOGO.svg', height: 240),
          const Padding(padding: EdgeInsets.symmetric(vertical: 24.0)),
          isAuth ? authenticatedWidgets() : unauthenticatedWidgets(),
        ],
      ),
    );
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
