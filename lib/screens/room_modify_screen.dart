import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:umich_msa/apis/firebase_db.dart';
import 'package:umich_msa/apis/firebase_storage.dart';
import 'package:umich_msa/models/room.dart';
import 'package:umich_msa/msa_router.dart';
import 'package:umich_msa/constants.dart';
import 'package:umich_msa/models/coordinates.dart';
import 'package:umich_msa/screens/components/error_dialog_component.dart';
import 'package:umich_msa/screens/components/pleasewait_dialog_component.dart';
import 'package:uuid/uuid.dart';

class RoomModifyScreen extends StatefulWidget {
  const RoomModifyScreen({Key? key}) : super(key: key);
  static String routeName = 'roomModifyScreen';

  static bool _isEdit = false;
  static late Room _room;

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
  File? _file;
  dynamic _pickImageError;
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
  late bool mCardRequired;

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
      mCardRequired = _room.mCard;
    } else {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _roomController = TextEditingController();
      _addressController = TextEditingController();
      _longitudeController = TextEditingController();
      _latitudeController = TextEditingController();
      selectedCampus = 'North';
      mCardRequired = true;
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
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
                          validator: (value) {
                            if (value!.length > 40) {
                              return 'Description must not exceed 40 characters';
                            } else {
                              return null;
                            }
                          },
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
                          Checkbox(
                              value: mCardRequired,
                              onChanged: (value) {
                                setState(() {
                                  mCardRequired = value!;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a room number';
                            } else if (value.length < 3) {
                              return 'Room number must be atleast 3 characters';
                            } else if (value.length > 20) {
                              return 'Room number must not exceed 20 characters';
                            } else {
                              return null;
                            }
                          },
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.-]'))
                              ],
                              controller: _longitudeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Longitude';
                                } else {
                                  return null;
                                }
                              },
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.-]'))
                              ],
                              controller: _latitudeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Latitude';
                                } else {
                                  return null;
                                }
                              },
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
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Picture'),
                  content: Column(
                    children: <Widget>[
                      Center(
                        child: previewImage(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            fixedSize: const Size(150, 20)),
                        onPressed: () {
                          uploadImage(ImageSource.gallery);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.upload_file_outlined),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text("Upload Image"),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber,
                          ),
                          Text(
                            """ Max uploadable image size is: \n  ${MSAConstants.imageDimensions.width.toInt()} x ${MSAConstants.imageDimensions.height.toInt()} (${MSAConstants.maxImageSize / 1024} kB)""",
                          )
                        ],
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2
        ? setState(() => _currentStep += 1)
        : saveReflectionRoom().then((value) => null);
  }

  cancel() {
    _currentStep == 0
        ? MsaRouter.instance.pop()
        : _currentStep > 0
            ? setState(() => _currentStep -= 1)
            : null;
  }

  void setImageFileFromFile(File? file) {
    _file = file;
  }

  Widget previewImage() {
    if (_file != null) {
      return SizedBox(
        height: 200,
        child: Image.file(
          File(_file!.path),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else if (_isEdit) {
      return Column(
        children: [
          const Text(
            'You need to pick a new image to continue.',
            style: TextStyle(
              color: Colors.red,
            ),
            textAlign: TextAlign.left,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          const Text(
            'This is the current image.',
            style: TextStyle(
              color: Colors.orange,
            ),
            textAlign: TextAlign.left,
          ),
          CachedNetworkImage(
            placeholder: (context, url) => const CircularProgressIndicator(),
            imageUrl: _room.imageUrl,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline_outlined),
          ),
        ],
      );
    } else {
      return Column(
        children: const [
          Text(
            'You need to pick an image.',
            style: TextStyle(
              color: Colors.red,
            ),
            textAlign: TextAlign.left,
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      );
    }
  }

  Future<void> uploadImage(ImageSource source) async {
    try {
      File? pickedFile = await ImagePicker.pickImage(
        source: source,
        maxWidth: MSAConstants.imageDimensions.width,
        maxHeight: MSAConstants.imageDimensions.height,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        int fileSize = await pickedFile.length();
        print('** picked fileSize ' + fileSize.toString());
        if (fileSize <= MSAConstants.maxImageSize) {
          setState(() {
            setImageFileFromFile(pickedFile);
          });
        } else {
          setImageFileFromFile(null);
          _pickImageError = 'File too large';
        }
      }
      print('** object picked: ' + pickedFile.toString());
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print('** object picked exception: ' + e.toString());
    }
  }

  saveReflectionRoom() async {
    print('** Starting saving Reflection Room');

    bool formValid =
        false || (_formKey.currentState!.validate() && _file != null);

    if (formValid) {
      showPleaseWaitDialog(context);
      bool response = false;

      String roomId; // room Id is same as room image name
      String? reflectionRoomImageUrl;
      if (_isEdit) {
        roomId = _room.roomId;
      } else {
        roomId = Uuid().v4();
      }

      reflectionRoomImageUrl = await uploadReflectionRoomImage(_file!, roomId);

      if (reflectionRoomImageUrl != null) {
        response = await modifyRoom(
          Room.params(
            roomId,
            _addressController.text,
            Coordinates.params(
              double.parse(_latitudeController.text),
              double.parse(_longitudeController.text),
            ),
            _descriptionController.text,
            reflectionRoomImageUrl,
            mCardRequired,
            _nameController.text,
            _roomController.text,
            selectedCampus,
          ),
        );
      }

      if (response) {
        MsaRouter.instance.popUntil('homeScreen');
      } else {
        MsaRouter.instance.popUntil('roomModifyScreen');
        showErrorDialog(context,
            "Error while saving the reflection room. Make sure you have the internet access!");
      }
    } else {
      showErrorDialog(context, "Please make sure the form is valid!");
    }
  }
}
