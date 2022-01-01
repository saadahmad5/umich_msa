import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> isAuthenticated;
  bool isAuth = false;
  bool showAuthButtons = false;

  Widget authButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          onPressed: () {
            showAuthOptionsDialog(context);
          },
          child: Row(
            children: const [
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
        const SizedBox(
          width: 16.0,
        ),
        RaisedButton(
          onPressed: () {
            showMemberSignInDialog(context);
          },
          child: Row(
            children: const [
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
    if (isAuth) {
      Future.delayed(
        const Duration(milliseconds: 2000),
        () {
          MsaRouter.instance.pushAndRemoveUntil(HomeScreen.route());
        },
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/logoHalf.png"),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 24.0)),
          showAuthButtons
              ? authButtons()
              : SpinKitChasingDots(
                  color: MSAConstants.yellowColor,
                  size: 60.0,
                ),
        ],
      ),
    );
  }

  showAuthOptionsDialog(BuildContext context) {
    // set up the buttons
    Widget signInButton = TextButton(
      child: const Text(
        "Sign-In",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        MsaRouter.instance.pushReplacement(SignInScreen.route());
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget signUpButton = TextButton(
      child: const Text(
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
      content: const Text("Do you want to Sign-In or Sign-Up?"),
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
    isAuthenticated = _prefs.then((SharedPreferences prefs) {
      setState(() {
        isAuth = prefs.getBool('isAuthenticated') ?? false;
        if (!isAuth) {
          showAuthButtons = true;
        }
      });
      return isAuth;
    });
  }
}
