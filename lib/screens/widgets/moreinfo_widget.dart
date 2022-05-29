import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/boardmember.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/splash_screen.dart';

class MoreInfoWidget extends StatefulWidget {
  const MoreInfoWidget({Key? key}) : super(key: key);

  @override
  _MoreInfoWidgetState createState() => _MoreInfoWidgetState();
}

class _MoreInfoWidgetState extends State<MoreInfoWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String displayName = '';
  late String userName = '';
  List<BoardMember> boardMembers = <BoardMember>[];

  @override
  void initState() {
    super.initState();
    loadBoardMembers();

    _prefs.then((SharedPreferences prefs) {
      setState(() {
        displayName = prefs.getString('displayName') ?? 'pleaseWait';
        userName = prefs.getString('userName') ?? 'pleaseWait';
      });
    });
  }

  void loadBoardMembers() async {
    await getBoardMemberInfo().then((value) => {
          setState(() {
            boardMembers = value;
          }),
          boardMembers
              .sort((first, second) => first.order.compareTo(second.order))
        });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.info_rounded),
                          ),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Cronos-Pro'),
                              children: <TextSpan>[
                                TextSpan(text: "MSA member: "),
                              ],
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
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
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40.0, 0, 0, 8.0),
                            child: RichText(
                              text: TextSpan(
                                text: displayName,
                                style: const TextStyle(color: Colors.blueGrey),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' ($userName)',
                                    style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                const Spacer(),
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
            // When we swipe towards right in More Info

            SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "MSA Board Members",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...boardMembers.isEmpty
                      ? {
                          const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                          const Text('Please wait!'),
                        }
                      : {
                          ...boardMembers.map(
                            (member) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      isThreeLine: true,
                                      title: Text(
                                        member.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member.position,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                          Row(
                                            children: [
                                              RichText(
                                                text: const TextSpan(
                                                  text: "Email: ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cronos-Pro',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Clipboard.setData(
                                                          ClipboardData(
                                                              text: member
                                                                  .emailAddress))
                                                      .then((value) => {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    "Email address copied to clipboard"),
                                                              ),
                                                            ),
                                                          });
                                                },
                                                child: Text(
                                                  member.emailAddress,
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontFamily: 'Cronos-Pro',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'Cronos-Pro'),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: member.details,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        }
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout() {
    _prefs.then((SharedPreferences prefs) {
      prefs.remove('isAuthenticated');
      prefs.remove('userName');
      prefs.remove('displayName');
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
          RichText(
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
        ],
      ),
    );
  }
}
