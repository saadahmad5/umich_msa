import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umich_msa/apis/firebase_auth.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/boardmember.dart';
import 'package:umich_msa/models/quicklink.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/admin_screen.dart';
import 'package:umich_msa/screens/boardmember_modify_screen.dart';
import 'package:umich_msa/screens/components/confirmation_dialog_component.dart';
import 'package:umich_msa/screens/quicklink_modify_screen.dart';
import 'package:umich_msa/screens/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfoWidget extends StatefulWidget {
  const MoreInfoWidget({Key? key}) : super(key: key);

  @override
  _MoreInfoWidgetState createState() => _MoreInfoWidgetState();
}

class _MoreInfoWidgetState extends State<MoreInfoWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String displayName = '';
  late String userName = '';
  late bool isAdmin = false;
  List<BoardMember> boardMembers = <BoardMember>[];
  List<QuickLink> quicklinks = <QuickLink>[];
  Map<String, dynamic> socialMediaLinks = <String, String>{};

  @override
  void initState() {
    super.initState();

    loadQuickLinks();
    loadSocialMediaLinks();
    loadBoardMembers();

    _prefs.then((SharedPreferences prefs) {
      setState(() {
        displayName = prefs.getString('displayName') ?? 'pleaseWait';
        userName = prefs.getString('userName') ?? 'pleaseWait';
        isAdmin = prefs.getBool('isAdmin') ?? false;
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

  void loadQuickLinks() async {
    await getQuickLinks().then((value) => {
          setState(() {
            quicklinks = value;
          }),
          quicklinks
              .sort((first, second) => second.order.compareTo(first.order))
        });
  }

  void loadSocialMediaLinks() async {
    await getSocialMediaLinks().then((value) => {
          setState(() {
            socialMediaLinks = value;
          })
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
            Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green[700],
                heroTag: 'add',
                tooltip: 'Add Quick Link',
                child: const Icon(Icons.add),
                onPressed: () {
                  showAddQuickLinkScreen();
                },
              ),
              body: Column(
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
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cronos-Pro'),
                                children: <TextSpan>[
                                  isAdmin
                                      ? const TextSpan(text: "MSA admin: ")
                                      : const TextSpan(text: "MSA member: "),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (isAdmin)
                              (ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue),
                                child: const Text(
                                  'Admin Panel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  showAdminScreen();
                                },
                              )),
                            const SizedBox(width: 8),
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
                              padding:
                                  const EdgeInsets.fromLTRB(40.0, 0, 0, 8.0),
                              child: RichText(
                                text: TextSpan(
                                  text: displayName,
                                  style:
                                      const TextStyle(color: Colors.blueGrey),
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
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(const Duration(seconds: 1), () {
                          loadQuickLinks();
                          loadSocialMediaLinks();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Refreshed contents!"),
                            ),
                          );
                        });
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            ...quicklinks.isEmpty
                                ? {
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 20.0)),
                                    const Text('Nothing here!'),
                                  }
                                : {
                                    ...quicklinks.map(
                                      (element) => Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Icon(
                                                      returnIcon(element.icon)),
                                                ),
                                                Text(element.title),
                                                const Spacer(),
                                                if (isAdmin)
                                                  IconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                      color: Colors.orange,
                                                    ),
                                                    tooltip: 'Edit Quick Link',
                                                    onPressed: () {
                                                      showEditQuickLinkScreen(
                                                        element,
                                                      );
                                                    },
                                                  ),
                                                if (isAdmin)
                                                  IconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    icon: const Icon(
                                                      Icons
                                                          .delete_forever_outlined,
                                                      color: Colors.red,
                                                    ),
                                                    tooltip:
                                                        'Delete Quick Link',
                                                    onPressed: () {
                                                      showDeleteQuickLinkDialog(
                                                        element,
                                                      );
                                                    },
                                                  ),
                                                IconButton(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  tooltip: 'Link',
                                                  onPressed: () async {
                                                    await launch(
                                                      element.linkUrl,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            if (element.description != null)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: RichText(
                                                  maxLines: 3,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    text: element.description
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontFamily: 'Cronos-Pro',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  }
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      IconButton(
                        onPressed: () async {
                          await launch(socialMediaLinks['facebook']);
                        },
                        icon: Image.asset(
                          'assets/images/facebook_icon.png',
                          scale: 2,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await launch(socialMediaLinks['venmo']);
                        },
                        icon: Image.asset(
                          'assets/images/venmo_48.png',
                          scale: 2,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await launch(socialMediaLinks['instagram']);
                        },
                        icon: Image.asset(
                          'assets/images/instagram_icon.png',
                          scale: 2,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await launch(socialMediaLinks['linktree']);
                        },
                        icon: Image.asset(
                          'assets/images/linktree_icon.png',
                          scale: 2,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showTheAboutDialog();
                        },
                        icon: const Icon(
                          CupertinoIcons.question_circle,
                          color: Colors.blue,
                        ),
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
            ),
            // When we swipe towards right in More Info

            Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green[700],
                heroTag: 'add',
                tooltip: 'Add Board Member',
                child: const Icon(Icons.add),
                onPressed: () {
                  showAddBoardMemberScreen();
                },
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 1), () {
                    loadBoardMembers();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Refreshed Board Members info!"),
                      ),
                    );
                  });
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                          child: Text(
                            "MSA Board Members",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ...boardMembers.isEmpty
                          ? {
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20.0)),
                              const Text('Nothing here!'),
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
                                          title: Row(
                                            children: [
                                              Text(
                                                member.name,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              if (isAdmin)
                                                IconButton(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.orange,
                                                  ),
                                                  tooltip: 'Edit Member',
                                                  onPressed: () {
                                                    showEditBoardMemberScreen(
                                                      member,
                                                    );
                                                  },
                                                ),
                                              if (isAdmin)
                                                IconButton(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  icon: const Icon(
                                                    Icons
                                                        .delete_forever_outlined,
                                                    color: Colors.red,
                                                  ),
                                                  tooltip: 'Delete Member',
                                                  onPressed: () {
                                                    showDeleteBoardMemberDialog(
                                                      member,
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                member.position,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                              Row(
                                                children: [
                                                  RichText(
                                                    text: const TextSpan(
                                                      text: "Email: ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Cronos-Pro',
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                                ScaffoldMessenger.of(
                                                                        context)
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
                                                        fontFamily:
                                                            'Cronos-Pro',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData returnIcon(String iconName) {
    switch (iconName) {
      case "chat":
        return CupertinoIcons.conversation_bubble;
      case "spreadsheet":
        return CupertinoIcons.doc_chart;
      case "info":
        return Icons.info_outline;
      case "form":
        return CupertinoIcons.doc_checkmark;
    }
    return Icons.link_outlined;
  }

  void showAdminScreen() {
    MsaRouter.instance.push(AdminScreen.route());
  }

  void logout() async {
    _prefs.then((SharedPreferences prefs) {
      prefs.remove('isAuthenticated');
      prefs.remove('userName');
      prefs.remove('displayName');
      prefs.remove('isAdmin');
    });
    await logOut();
    MsaRouter.instance.pushReplacement(SplashScreen.route());
  }

  showTheAboutDialog() async {
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

  showAddQuickLinkScreen() async {
    MsaRouter.instance
        .push(
          QuickLinkModifyScreen.routeForAdd(),
        )
        .then((value) => loadQuickLinks());
  }

  showEditQuickLinkScreen(QuickLink quickLink) {
    MsaRouter.instance
        .push(
          QuickLinkModifyScreen.routeForEdit(quickLink),
        )
        .then((value) => loadQuickLinks());
  }

  showDeleteQuickLinkDialog(QuickLink quickLink) {
    showConfirmationDialog(
      context,
      'Confirm delete?',
      'Are you sure want to delete this Quick Link?',
      'Delete',
      Colors.red,
      () => removeQuickLink(quickLink),
    ).then((value) => loadQuickLinks());
  }

  showAddBoardMemberScreen() async {
    MsaRouter.instance
        .push(
          BoardMemberModifyScreen.routeForAdd(),
        )
        .then((value) => loadBoardMembers());
  }

  showEditBoardMemberScreen(BoardMember boardMember) {
    MsaRouter.instance
        .push(
          BoardMemberModifyScreen.routeForEdit(boardMember),
        )
        .then((value) => loadBoardMembers());
  }

  showDeleteBoardMemberDialog(BoardMember boardMember) {
    showConfirmationDialog(
      context,
      'Confirm delete?',
      'Are you sure want to delete this Board Member info?',
      'Delete',
      Colors.red,
      () => removeBoardMember(boardMember),
    ).then((value) => loadBoardMembers());
  }
}
