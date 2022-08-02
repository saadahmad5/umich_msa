import 'package:flutter/material.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/error_dialog_component.dart';
import 'package:umich_msa/screens/components/pleasewait_dialog_component.dart';

Future<void> showSocialMediaDialog(BuildContext context) async {
  Map<String, dynamic> currentLinks = await getSocialMediaLinks();

  TextEditingController _facebookTextEditingController =
      TextEditingController(text: currentLinks['facebook'].toString());
  TextEditingController _venmoTextEditingController =
      TextEditingController(text: currentLinks['venmo'].toString());
  TextEditingController _instagramTextEditingController =
      TextEditingController(text: currentLinks['instagram'].toString());
  TextEditingController _linktreeTextEditingController =
      TextEditingController(text: currentLinks['linktree'].toString());

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Manage Social Media Links'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Here you can modify the Social Media links'),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              TextFormField(
                controller: _facebookTextEditingController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  contentPadding: MSAConstants.textBoxPadding,
                  filled: true,
                  fillColor: MSAConstants.grayTextBoxBackgroundColor,
                  border: InputBorder.none,
                  labelText: 'Facebook Link',
                  hintText: "https://www.facebook.com/",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              TextFormField(
                controller: _venmoTextEditingController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  contentPadding: MSAConstants.textBoxPadding,
                  filled: true,
                  fillColor: MSAConstants.grayTextBoxBackgroundColor,
                  border: InputBorder.none,
                  labelText: 'Venmo Link',
                  hintText: "https://www.venmo.com/",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              TextFormField(
                controller: _instagramTextEditingController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  contentPadding: MSAConstants.textBoxPadding,
                  filled: true,
                  fillColor: MSAConstants.grayTextBoxBackgroundColor,
                  border: InputBorder.none,
                  labelText: 'Instagram Link',
                  hintText: "https://www.instagram.com/",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              TextFormField(
                controller: _linktreeTextEditingController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  contentPadding: MSAConstants.textBoxPadding,
                  filled: true,
                  fillColor: MSAConstants.grayTextBoxBackgroundColor,
                  border: InputBorder.none,
                  labelText: 'LinkTree Link',
                  hintText: "https://www.linktree.com/",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            onPressed: () async {
              String facebook = _facebookTextEditingController.text;
              String venmo = _venmoTextEditingController.text;
              String instagram = _instagramTextEditingController.text;
              String linktree = _linktreeTextEditingController.text;
              if (facebook.startsWith('https://') &&
                  venmo.startsWith('https://') &&
                  instagram.startsWith('https://') &&
                  linktree.startsWith('https://')) {
                showPleaseWaitDialog(context);
                bool response = await updateSocialMediaLinks(
                    facebook, venmo, instagram, linktree);
                if (response) {
                  MsaRouter.instance.popUntil('adminScreen');
                } else {
                  showErrorDialog(context,
                      """Please make sure you entered the correct URL(s) in the textboxes""");
                }
              } else {
                showErrorDialog(context,
                    """Please make sure you entered the correct URL(s) in the textboxes""");
              }
            },
          ),
          TextButton(
            child: const Text(
              'Back',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
