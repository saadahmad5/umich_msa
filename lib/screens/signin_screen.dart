import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:umich_msa/screens/splash_screen.dart';

import 'package:umich_msa/msa_router.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 40),
              child:
                  SvgPicture.asset('assets/images/MSA LOGO.svg', height: 200),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Material(
                child: TextField(
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 238, 238, 238),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 8.0,
                    ),
                    border: InputBorder.none,
                    labelText: 'Email',
                    hintText: 'uniqname@umich.edu',
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
              child: Material(
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 238, 238, 238),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 8.0,
                    ),
                    border: InputBorder.none,
                    labelText: 'Password',
                    hintText: 'supersecret!',
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
