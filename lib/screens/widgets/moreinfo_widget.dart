import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/splash_screen.dart';

class MoreInfoWidget extends StatefulWidget {
  const MoreInfoWidget({Key? key}) : super(key: key);

  @override
  _MoreInfoWidgetState createState() => _MoreInfoWidgetState();
}

class _MoreInfoWidgetState extends State<MoreInfoWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String userName = '';

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName') ?? 'pleaseWait';
      });
    });
    if (userName == 'pleaseWait') throw Exception('Unhandled Exception');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: MSAConstants.blueColor,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline)),
            Tab(icon: Icon(Icons.people_alt_outlined)),
          ],
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Card(
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.info_rounded),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontFamily: 'Cronos-Pro'),
                          children: <TextSpan>[
                            const TextSpan(text: "Logged in as: "),
                            TextSpan(
                              text: userName,
                              style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          logout();
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
            Icon(Icons.people_alt_rounded)
          ],
        ),
      ),
    );
  }

  void logout() {
    _prefs.then((SharedPreferences prefs) {
      prefs.remove('isAuthenticated');
      prefs.remove('userName');
    });
    MsaRouter.instance.pushReplacement(SplashScreen.route());
  }
}
