import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/home_screen.dart';
import 'package:umich_msa/screens/splash_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static String routeName = 'signUpScreen';
  static Route<SignUpScreen> route() {
    return MaterialPageRoute<SignUpScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const SignUpScreen(),
    );
  }

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset("assets/images/icon64.png"), onPressed: null),
        iconTheme: IconThemeData(color: Colors.yellow),
        backgroundColor: const Color.fromARGB(255, 30, 48, 96),
        title: const Text(
          'Welcome to UMICH\'s MSA',
          style: TextStyle(
            color: Color.fromARGB(255, 252, 210, 12),
          ),
        ),
        //automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                  fontFamily: "Cronos-Pro",
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: Color.fromARGB(255, 30, 48, 96)),
                ),
                child: Stepper(
                  type: StepperType.vertical,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: Text('Account Set-up'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'UMICH\'s Email Address',
                                hintText: "uniqname@umich.edu"),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cronos-Pro'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "An email with a passcode will be sent to "),
                                  TextSpan(
                                    text: "msa-eboard@umich.edu",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  TextSpan(text: " for verification"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: new Text('Verification'),
                      content: Column(
                        children: <Widget>[
                          Container(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cronos-Pro'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "Please enter the passcode sent to "),
                                  TextSpan(
                                    text: "msa-eboard@umich.edu",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  TextSpan(text: " for verification"),
                                ],
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Passcode',
                              hintText: '123456',
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                  onPressed: () {},
                                  child: Text('Re-send Email')),
                            ],
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: new Text('Password Set-up'),
                      content: Column(
                        children: <Widget>[
                          Row(
                            children: const [
                              Text(
                                "Set up a new password for your MSA account",
                                textAlign: TextAlign.left,
                                textDirection: TextDirection.ltr,
                              ),
                            ],
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'supersecret!',
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'supersecret!',
                            ),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2
        ? setState(() => _currentStep += 1)
        : MsaRouter.instance.pushAndRemoveUntil(HomeScreen.route());
  }

  cancel() {
    _currentStep == 0
        ? MsaRouter.instance.pushReplacement(SplashScreen.route())
        : _currentStep > 0
            ? setState(() => _currentStep -= 1)
            : null;
  }
}
