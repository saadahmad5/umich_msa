import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/boardmember.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/screens/components/confirmation_dialog_component.dart';
import 'package:umich_msa/screens/components/error_dialog_component.dart';
import 'package:uuid/uuid.dart';

class BoardMemberModifyScreen extends StatefulWidget {
  const BoardMemberModifyScreen({Key? key}) : super(key: key);
  static String routeName = 'boardMemberModifyScreen';

  static bool _isEdit = false;
  static BoardMember _boardMember = BoardMember.noparams();

  static Route<BoardMemberModifyScreen> routeForAdd() {
    _isEdit = false;

    return MaterialPageRoute<BoardMemberModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const BoardMemberModifyScreen(),
    );
  }

  static Route<BoardMemberModifyScreen> routeForEdit(BoardMember boardMember) {
    _isEdit = true;
    _boardMember = boardMember;

    return MaterialPageRoute<BoardMemberModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const BoardMemberModifyScreen(),
    );
  }

  @override
  _ModifyScreenState createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<BoardMemberModifyScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isEdit;

  late BoardMember _boardMember;
  late TextEditingController _nameController;
  late TextEditingController _emailAddressController;
  late TextEditingController _detailsController;
  late String _position;

  @override
  void initState() {
    super.initState();
    _isEdit = BoardMemberModifyScreen._isEdit;
    if (_isEdit) {
      _boardMember = BoardMemberModifyScreen._boardMember;
      _nameController = TextEditingController(text: _boardMember.name);
      _detailsController = TextEditingController(text: _boardMember.details);
      _emailAddressController =
          TextEditingController(text: _boardMember.emailAddress);
      _position = _boardMember.position;
    } else {
      _nameController = TextEditingController();
      _detailsController = TextEditingController();
      _emailAddressController = TextEditingController();
      _position = 'Other';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _emailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        middle: Text(_isEdit ? 'Modify Board Member' : 'Add a Board Member'),
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
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      } else if (value.length < 3) {
                        return 'Name must be atleast 3 characters';
                      } else if (value.length > 20) {
                        return 'Name must not exceed 20 characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: MSAConstants.textBoxPadding,
                      filled: true,
                      fillColor: MSAConstants.grayTextBoxBackgroundColor,
                      border: InputBorder.none,
                      labelText: 'Name',
                      hintText: "Muhammad Ali",
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 20.0)),
                    const Text('Position: '),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                    ),
                    DropdownButton(
                      value: _position,
                      onTap: () {},
                      onChanged: (String? newValue) {
                        setState(() {
                          _position = newValue.toString();
                        });
                      },
                      items: MSAConstants.positions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Container(
                  padding: MSAConstants.textBoxPadding,
                  child: TextFormField(
                    controller: _emailAddressController,
                    keyboardType: TextInputType.emailAddress,
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
                    decoration: InputDecoration(
                      contentPadding: MSAConstants.textBoxPadding,
                      filled: true,
                      fillColor: MSAConstants.grayTextBoxBackgroundColor,
                      border: InputBorder.none,
                      labelText: 'Email Address',
                      hintText: "uniqname@umich.edu",
                    ),
                  ),
                ),
                Container(
                  padding: MSAConstants.textBoxPadding,
                  child: TextFormField(
                    controller: _detailsController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      contentPadding: MSAConstants.textBoxPadding,
                      filled: true,
                      fillColor: MSAConstants.grayTextBoxBackgroundColor,
                      border: InputBorder.none,
                      labelText: 'Details (optional)',
                      hintText: "Position details/ responsibilities...",
                    ),
                  ),
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
                              modifyBoardMember(
                                BoardMember.params(
                                  _isEdit ? _boardMember.id : Uuid().v4(),
                                  _nameController.text,
                                  _position,
                                  _emailAddressController.text,
                                  _detailsController.text,
                                  MSAConstants.positions.indexOf(_position),
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
