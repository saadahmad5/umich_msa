import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:umich_msa/screens/components/admin_dialog_component.dart';
import 'package:umich_msa/screens/components/social_media_dialog_component.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  static String routeName = 'adminScreen';
  static Route<AdminScreen> route() {
    return MaterialPageRoute<AdminScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const AdminScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Admin Screen'),
      ),
      child: CupertinoApp(
        useInheritedMediaQuery: true,
        home: ListView(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                showAdminDialog(
                  context,
                  'Add a new MSA Admin',
                  'Please enter the UMICH email address of the new MSA admin',
                  'Add',
                  Colors.green,
                );
              },
              child: const Card(
                margin: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 0,
                ),
                child: ListTile(
                  leading: Icon(Icons.person_add_alt_1_outlined),
                  title: Text('Add a new Admin'),
                  subtitle: Text(
                    'This option lets you to add a new MSA admin user who can manage the app',
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                showSocialMediaDialog(context);
              },
              child: const Card(
                margin: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 0,
                ),
                child: ListTile(
                  leading: Icon(Icons.insert_link_outlined),
                  title: Text('Modify Social Media Links'),
                  subtitle: Text(
                    'This option lets you to modify the MSA Social Media Links',
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
