import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umich_msa/models/room.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/constants.dart';

class RoomModifyScreen extends StatefulWidget {
  const RoomModifyScreen({Key? key}) : super(key: key);
  static String routeName = 'roomModifyScreen';

  static bool _isEdit = false;
  static Room _room = Room.noparams();

  static Route<RoomModifyScreen> routeForAdd() {
    _isEdit = false;

    return MaterialPageRoute<RoomModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const RoomModifyScreen(),
    );
  }

  static Route<RoomModifyScreen> routeForEdit(Room room) {
    _isEdit = true;
    _room = room;

    return MaterialPageRoute<RoomModifyScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const RoomModifyScreen(),
    );
  }

  @override
  _RoomModifyScreenState createState() => _RoomModifyScreenState();
}

class _RoomModifyScreenState extends State<RoomModifyScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  late bool _isEdit;
  late Room _room;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _roomController;
  late TextEditingController _addressController;
  late TextEditingController _longitudeController;
  late TextEditingController _latitudeController;
  late String selectedCampus;

  @override
  void initState() {
    super.initState();
    _isEdit = RoomModifyScreen._isEdit;
    if (_isEdit) {
      _room = RoomModifyScreen._room;
      _nameController = TextEditingController(text: _room.name);
      _descriptionController = TextEditingController(text: _room.description);
      _roomController = TextEditingController(text: _room.room);
      _addressController = TextEditingController(text: _room.address);
      _longitudeController = TextEditingController(
          text: _room.coordinates.longitude.toStringAsFixed(5));
      _latitudeController = TextEditingController(
          text: _room.coordinates.latitude.toStringAsFixed(5));
      selectedCampus = _room.whereAt;
    } else {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _roomController = TextEditingController();
      _addressController = TextEditingController();
      _longitudeController = TextEditingController();
      _latitudeController = TextEditingController();
      selectedCampus = 'North';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _roomController.dispose();
    _addressController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        middle: Text(
            _isEdit ? 'Modify the Reflection Room' : 'Add Reflection Room'),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stepper(
            type: StepperType.vertical,
            physics: const ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
            steps: <Step>[
              Step(
                title: const Text('Details'),
                content: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: MSAConstants.textBoxPadding,
                          filled: true,
                          fillColor: MSAConstants.grayTextBoxBackgroundColor,
                          border: InputBorder.none,
                          labelText: 'Name',
                          hintText: "Michigan Union",
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: MSAConstants.textBoxPadding,
                          filled: true,
                          fillColor: MSAConstants.grayTextBoxBackgroundColor,
                          border: InputBorder.none,
                          labelText: 'Description',
                          hintText: "Michigan Union Ref. Room",
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Text('MCard Required?'),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        Checkbox(value: true, onChanged: (value) {}),
                      ],
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Location'),
                content: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _roomController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: MSAConstants.textBoxPadding,
                          filled: true,
                          fillColor: MSAConstants.grayTextBoxBackgroundColor,
                          border: InputBorder.none,
                          labelText: 'Room Number',
                          hintText: "Room 1234, 1st Floor",
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.2,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _longitudeController,
                            decoration: InputDecoration(
                              contentPadding: MSAConstants.textBoxPadding,
                              filled: true,
                              fillColor:
                                  MSAConstants.grayTextBoxBackgroundColor,
                              border: InputBorder.none,
                              labelText: 'Longitude',
                              hintText: MSAConstants.defaultLongitude
                                  .toStringAsFixed(5),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.2,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _latitudeController,
                            decoration: InputDecoration(
                              contentPadding: MSAConstants.textBoxPadding,
                              filled: true,
                              fillColor:
                                  MSAConstants.grayTextBoxBackgroundColor,
                              border: InputBorder.none,
                              labelText: 'Latitude',
                              hintText: MSAConstants.defaultLatitude
                                  .toStringAsFixed(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _addressController,
                        decoration: InputDecoration(
                          contentPadding: MSAConstants.textBoxPadding,
                          filled: true,
                          fillColor: MSAConstants.grayTextBoxBackgroundColor,
                          border: InputBorder.none,
                          labelText: 'Building Address',
                          hintText: "500 S. State St., Ann Arbor, MI",
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Text('At the'),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        DropdownButton(
                          value: selectedCampus,
                          onTap: () {},
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCampus = newValue.toString();
                            });
                          },
                          items: MSAConstants.campusLocations
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        const Text(' campus'),
                      ],
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: new Text('Picture'),
                content: Column(
                  children: <Widget>[],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
            ],
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : () {};
  }

  cancel() {
    _currentStep == 0
        ? MsaRouter.instance.pop()
        : _currentStep > 0
            ? setState(() => _currentStep -= 1)
            : null;
  }
}
