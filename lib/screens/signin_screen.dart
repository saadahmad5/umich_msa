import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umich_msa/apis/firebase_auth.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/apis/mcommunity.dart';
import 'package:umich_msa/models/user.dart';
import 'package:umich_msa/screens/components/error_dialog_component.dart';
import 'package:umich_msa/screens/components/pleasewait_dialog_component.dart';
import 'package:umich_msa/screens/components/welcome_dialog_component.dart';
import 'package:umich_msa/screens/splash_screen.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/home_screen.dart';

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _memberEmailAddressController =
      TextEditingController();
  final TextEditingController _memberPasswordController =
      TextEditingController();
  late String username;
  late String password;

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
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 40),
                child:
                    SvgPicture.asset('assets/images/MSA LOGO.svg', height: 200),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Material(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your UMICH email';
                      } else if (value
                          .contains(RegExp(r"^[a-z]+@umich.edu$"))) {
                        var splittedEmailAddrs = value.split("@");
                        if (splittedEmailAddrs[0].length <= 8) {
                          return null;
                        }
                        return 'Uniqname must be less than 8 characters';
                      }
                      return 'Invalid UMICH email address';
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _memberEmailAddressController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 10),
                child: Material(
                  child: TextFormField(
                    obscureText: true,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length >= 6) {
                        return null;
                      }
                      return 'Password must be atleast 6 characters';
                    },
                    controller: _memberPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
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
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () async {
                        bool formValid =
                            false || _formKey.currentState!.validate();
                        if (formValid) {
                          setState(() {
                            username = _memberEmailAddressController.text;
                            password = _memberPasswordController.text;
                          });
                          _formKey.currentState!.reset();
                          showPleaseWaitDialog(context);
                          bool response = await hasGoodConnectivity();
                          if (response) {
                            SignIn login = await signIn(username, password);
                            switch (login) {
                              case SignIn.error:
                                {
                                  Navigator.pop(context);
                                  showErrorDialog(context,
                                      'Please make sure you have a working internet connection or contact MSA Admin');
                                  break;
                                }
                              case SignIn.invalidUsername:
                                {
                                  Navigator.pop(context);
                                  showErrorDialog(context,
                                      'This email address is not signed up for MSA admin access');
                                  break;
                                }
                              case SignIn.wrongPassword:
                                {
                                  Navigator.pop(context);
                                  showErrorDialog(context,
                                      'The credentials are wrong for this email address');
                                  break;
                                }
                              case SignIn.successful:
                                {
                                  var uniqname = username.split("@");
                                  User? user =
                                      await getUserDetails(uniqname[0]);
                                  if (user == null) {
                                    Navigator.pop(context);
                                    showErrorDialog(context,
                                        'Please make sure your uniqname is correct');
                                  } else {
                                    await addUsers(uniqname[0], true);
                                    final SharedPreferences prefs =
                                        await _prefs;
                                    await prefs.setBool(
                                        'isAuthenticated', true);
                                    await prefs.setBool('isAdmin', true);
                                    await prefs.setString(
                                        'userName', uniqname[0]);
                                    await prefs.setString(
                                        'displayName', user.displayName);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    MsaRouter.instance
                                        .pushReplacement(HomeScreen.route());
                                    showWelcomeDialog(context, user);
                                  }
                                  break;
                                }
                              default:
                                {
                                  Navigator.pop(context);
                                  showErrorDialog(context,
                                      'An unhandled exception has occured');
                                  break;
                                }
                            }
                          } else {
                            Navigator.pop(context);
                            showErrorDialog(context,
                                'Please make sure you have a working internet connection or contact MSA Admin');
                          }
                        } else {
                          showErrorDialog(context,
                              'Please make sure you entered your valid uniqname/ email and password');
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () {
                        String emailAddress =
                            _memberEmailAddressController.text.toString();
                        if (emailAddress
                            .contains(RegExp(r"^[a-z]+@umich.edu$"))) {
                          passwordResetThruEmail(emailAddress);
                          showErrorDialog(context,
                              'Reset Password link sent successfully to your email. Please check the spam folder just in case if you do not get it.',
                              title: 'Reset Password');
                        } else {
                          showErrorDialog(context,
                              'Please make sure you entered your valid email address');
                        }
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                  onPressed: () {
                    MsaRouter.instance.pushReplacement(SplashScreen.route());
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 300)),
            ],
          ),
        ),
      ),
    );
  }
}
