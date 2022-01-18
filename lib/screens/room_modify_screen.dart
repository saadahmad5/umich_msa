import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/constants.dart';

class RoomModifyScreen extends StatefulWidget {
  const RoomModifyScreen({Key? key}) : super(key: key);
  static String routeName = 'roomModifyScreen';
  static Route<RoomModifyScreen> route() {
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        middle: Text('Modify the Reflection Room'),
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: MSAConstants.textBoxPadding,
                          filled: true,
                          fillColor: MSAConstants.grayTextBoxBackgroundColor,
                          border: InputBorder.none,
                          labelText: 'Title',
                          hintText: "Michigan Union",
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
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
                    Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
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
                        const Text('MCard Required?'),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        Checkbox(value: true, onChanged: (value) {}),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('At '),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        DropdownButton(
                          value: 'Central',
                          onTap: () {},
                          onChanged: (String? newValue) {},
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
                    )
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Location'),
                content: Column(
                  children: <Widget>[],
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
