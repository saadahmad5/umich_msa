import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/quicklink.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/confirmation_dialog_component.dart';
import 'package:umich_msa/screens/components/error_dialog_component.dart';
import 'package:uuid/uuid.dart';

class QuickLinkModifyScreen extends StatefulWidget {
  const QuickLinkModifyScreen({Key? key}) : super(key: key);
  static String routeName = 'quickLinkModifyScreen';

  static bool _isEdit = false;
  static QuickLink _quickLink = QuickLink.noparams();

  static Route<QuickLinkModifyScreen> routeForAdd() {
    _isEdit = false;

    return MaterialPageRoute<QuickLinkModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const QuickLinkModifyScreen(),
    );
  }

  static Route<QuickLinkModifyScreen> routeForEdit(QuickLink quickLink) {
    _isEdit = true;
    _quickLink = quickLink;

    return MaterialPageRoute<QuickLinkModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const QuickLinkModifyScreen(),
    );
  }

  @override
  _QuickLinkModifyScreenState createState() => _QuickLinkModifyScreenState();
}

class _QuickLinkModifyScreenState extends State<QuickLinkModifyScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isEdit;

  late QuickLink _quickLink;
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  late TextEditingController _descriptionController;
  late String _iconType;

  @override
  void initState() {
    super.initState();
    _isEdit = QuickLinkModifyScreen._isEdit;
    if (_isEdit) {
      _quickLink = QuickLinkModifyScreen._quickLink;
      _titleController = TextEditingController(text: _quickLink.title);
      _descriptionController =
          TextEditingController(text: _quickLink.description);
      _linkController = TextEditingController(text: _quickLink.linkUrl);
      _iconType = _quickLink.icon;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _linkController = TextEditingController();
      _iconType = 'link';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        middle: Text(_isEdit ? 'Modify the Link' : 'Add a new Link'),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            //padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                ),
                Container(
                  padding: MSAConstants.textBoxPadding,
                  child: TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      } else if (value.length < 5) {
                        return 'Title must be atleast 5 characters';
                      } else if (value.length > 20) {
                        return 'Title must not exceed 20 characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: MSAConstants.textBoxPadding,
                      filled: true,
                      fillColor: MSAConstants.grayTextBoxBackgroundColor,
                      border: InputBorder.none,
                      labelText: 'Title',
                      hintText: "MSA Link",
                    ),
                  ),
                ),
                Container(
                  padding: MSAConstants.textBoxPadding,
                  child: TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      contentPadding: MSAConstants.textBoxPadding,
                      filled: true,
                      fillColor: MSAConstants.grayTextBoxBackgroundColor,
                      border: InputBorder.none,
                      labelText: 'Description (optional)',
                      hintText: "Link Info/ Details",
                    ),
                  ),
                ),
                Container(
                  padding: MSAConstants.textBoxPadding,
                  child: TextFormField(
                    controller: _linkController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input the URL';
                      } else if (value.startsWith("https://")) {
                        return null;
                      }
                      return 'Invalid URL';
                    },
                    decoration: InputDecoration(
                      contentPadding: MSAConstants.textBoxPadding,
                      filled: true,
                      fillColor: MSAConstants.grayTextBoxBackgroundColor,
                      border: InputBorder.none,
                      labelText: 'Link',
                      hintText: "https://msa-quick-link-url.com/",
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 20.0)),
                    const Text('Link Type: '),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                    ),
                    DropdownButton(
                      value: _iconType,
                      onTap: () {},
                      onChanged: (String? newValue) {
                        setState(() {
                          _iconType = newValue.toString();
                        });
                      },
                      items: MSAConstants.iconTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      heroTag: 'save',
                      child: const Icon(Icons.done),
                      onPressed: () {
                        bool formValid =
                            false || _formKey.currentState!.validate();

                        if (formValid) {
                          showConfirmationDialog(
                            context,
                            'Confirm changes?',
                            'Are you sure want to save these changes?',
                            'Save',
                            Colors.green,
                            () => {
                              modifyQuickLinks(
                                QuickLink.params(
                                  _isEdit ? _quickLink.id : Uuid().v4(),
                                  _iconType,
                                  _linkController.text,
                                  _titleController.text,
                                  0,
                                  _descriptionController.text,
                                ),
                              ),
                            },
                          );
                        } else {
                          showErrorDialog(
                              context, 'Please enter the required fields');
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.blue,
                      heroTag: 'back',
                      child: const Icon(Icons.undo_outlined),
                      onPressed: () {
                        MsaRouter.instance.pop();
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 60.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
