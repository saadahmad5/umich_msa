import 'package:flutter/material.dart';
import 'package:umich_msa/screens/splash_screen.dart';

import '../msa_router.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen();

  static String routeName = 'signInScreen';
  static Route<SignInScreen> route() {
    return MaterialPageRoute<SignInScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const SignInScreen(),
    );
  }

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 238, 238, 238),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Center(
                  child: Container(
                    child: Image(
                      image: AssetImage('assets/images/quarter.png'),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Material(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 6.0,
                      ),
                      border: InputBorder.none,
                      labelText: 'Email',
                      hintText: 'uniqname@umich.edu',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              child: Material(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 6.0,
                      ),
                      border: InputBorder.none,
                      labelText: 'Password',
                      hintText: 'supersecret!',
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  child: FlatButton(
                    onPressed: () {
                      MsaRouter.instance.pushAndRemoveUntil(HomeScreen.route());
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                Container(
                  height: 32,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: FlatButton(
                    onPressed: () {
                      MsaRouter.instance.pushReplacement(SplashScreen.route());
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 300)),
          ],
        ),
      ),
    );
  }
}
