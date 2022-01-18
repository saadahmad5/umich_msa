import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/icons/mosque_icons.dart';
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
                            const TextSpan(text: "MSA member: "),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Quick Links",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(CupertinoIcons.conversation_bubble),
                      ),
                      const Text('MSA Updates Chat'),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: const Text(
                          'Link',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.chat_outlined),
                      ),
                      const Text('UM Salaah Group'),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: const Text(
                          'Link',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(CupertinoIcons.doc_chart),
                      ),
                      const Text('Quran Khatam Spreadsheet'),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: const Text(
                          'Link',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/facebook_icon.png',
                        scale: 2,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/twitter_icon.png',
                        scale: 2,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/instagram_icon.png',
                        scale: 2,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/linktree_icon.png',
                        scale: 2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: MSAConstants.blueColor,
                          onPrimary: MSAConstants.yellowColor),
                      onPressed: () {
                        showAboutDialog();
                      },
                      child: const Text("About MSA"),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
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

  showAboutDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationIcon: const Image(
          image: AssetImage('assets/images/logoHalf.png'),
          height: 32.0,
        ),
        applicationName: MSAConstants.appName,
        applicationVersion: 'Version: ' + MSAConstants.appVersion,
        children: [
          Container(
            //padding: const EdgeInsets.only(top: 20.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Cronos-Pro'),
                children: <TextSpan>[
                  TextSpan(
                    text: MSAConstants.aboutMessage,
                  ),
                  TextSpan(
                    text: MSAConstants.developersEmail,
                    style: const TextStyle(
                        color: Colors.blueAccent, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
