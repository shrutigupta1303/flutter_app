import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_test_app/app_constant/text_field.dart';
import 'package:flutter_test_app/database/sqlite_database.dart';
import 'package:flutter_test_app/model/customer_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:intl/intl.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  TextEditingController iMeiController = TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController dateOfbirthController = new TextEditingController();
  TextEditingController passportController = new TextEditingController();

  DateTime _date = new DateTime.now();
  DateTime selectedDate = DateTime.now();
  String iMEIVal;
  String uuidVal;
  String deviceName;
  Position _currentPosition;
  String latitude;
  String longitude;
  File _image;
  bool isShowPassport = false;

  @override
  void initState() {
    super.initState();
    fetchLocation();
    fetchIMEI();
    fetchDeviceName();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(child: Text("Registration Form")),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showImagePicker(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 55,
                      child: _image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.file(
                          _image,
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(75)),
                        width: 150,
                        height: 150,
                        child: Image.asset("assets/profile_placeholder.png",height: 150,width :150),
                      ),
                    ),
                  ),
                ),
                CustomTextField(
                  backGroundColor: Color(0xfff2f2f4),
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    textValid(value);
                  },
                  newFontColor: Colors.black,
                  autoFocus: true,
                  padding: EdgeInsets.fromLTRB(7.5, 15, 7.5, 10),
                  newHintText: "IMEI Number",
                  newFontWeight: FontWeight.w700,
                  inputType: TextInputType.text,
                  boxDecoration: BoxDecoration(
                      shape: BoxShape.rectangle, color: Color(0xfff2f2f4)),
                  controller: iMeiController,
                  borderRadius: 0,
                ),

                CustomTextField(
                  backGroundColor: Color(0xfff2f2f4),
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    textValid(value);
                  },
                  newFontColor: Colors.black,
                  autoFocus: true,
                  padding: EdgeInsets.fromLTRB(7.5, 15, 7.5, 10),
                  newHintText: "Enter Your First Name",
                  newFontWeight: FontWeight.w700,
                  inputType: TextInputType.text,
                  boxDecoration: BoxDecoration(
                      shape: BoxShape.rectangle, color: Color(0xfff2f2f4)),
                  controller: firstNameController,
                  borderRadius: 0,
                ),
                CustomTextField(
                  backGroundColor: Color(0xfff2f2f4),
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    textValid(value);
                  },
                  newFontColor: Colors.black,
                  autoFocus: true,
                  padding: EdgeInsets.fromLTRB(7.5, 15, 7.5, 10),
                  newHintText: "Enter Your Last Name",
                  newFontWeight: FontWeight.w700,
                  inputType: TextInputType.text,
                  boxDecoration: BoxDecoration(
                      shape: BoxShape.rectangle, color: Color(0xfff2f2f4)),
                  controller: lastNameController,
                  borderRadius: 0,
                ),
                CustomTextField(
                  backGroundColor: Color(0xfff2f2f4),
                  controller: dateOfbirthController,
                  autoFocus: false,
                  padding: EdgeInsets.fromLTRB(7.5, 15, 7.5, 10),
                  boxDecoration: BoxDecoration(
                      shape: BoxShape.rectangle, color: Color(0xfff2f2f4)),
                  newHintText: "Enter Your DOB",
                  newFontWeight: FontWeight.w700,
                  newFontColor: Colors.black,
                  cursorEnabled: false,
                  readOnlyEnabled: true,
                  suffixIconPresent: true,
                  newSuffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                  ),
                  onClicked: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    final DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate: new DateTime(1900),
                        lastDate: new DateTime.now());
                    if (picked != null && picked != _date) {
                      print("${picked.toString().split(" ")[0]}");
                      dateOfbirthController.text=  DateFormat("dd/MM/yyyy").format(DateTime.parse(picked.toString())).toString();

                      int yearDiff = _date.year - picked.year;
                      int monthDiff = _date.month - picked.month;
                      int dayDiff = _date.day - picked.day;

                      bool ischeckDOB =  yearDiff > 18 || yearDiff == 18 && monthDiff >= 0 && dayDiff >= 0;

                      if (ischeckDOB) {
                        setState(() {
                          isShowPassport = true;
                        });
                      } else {
                        setState(() {
                          isShowPassport = false;
                        });
                      }
                    }
                  },
                  borderRadius: 0,
                ),
                CustomTextField(
                  backGroundColor: Color(0xfff2f2f4),

                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    if (validEmail(value.trim()) == 2 && value.toString().isNotEmpty) {
                      showToast("Please enter your valid email",context:context);

                    }
                    return null;
                  },
                  cursorEnabled: true,
                  newFontColor: Colors.black,
                  autoFocus: true,
                  padding: EdgeInsets.fromLTRB(7.5, 15, 7.5, 10),
                  newHintText: "Enter Your Email",
                  newFontWeight: FontWeight.w700,
                  inputType: TextInputType.emailAddress,
                  boxDecoration: BoxDecoration(
                      shape: BoxShape.rectangle, color: Color(0xfff2f2f4)),
                  controller: emailController,
                  borderRadius: 0,

                ),
                isShowPassport
                    ? CustomTextField(
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    textValid(value);
                  },
                  newFontColor: Colors.black,
                  autoFocus: true,
                  backGroundColor: Color(0xfff2f2f4),
                  padding: EdgeInsets.fromLTRB(7.5, 15, 7.5, 10),
                  newHintText: "Enter Your Passport",
                  newFontWeight: FontWeight.w700,
                  inputType: TextInputType.text,
                  boxDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xfff2f2f4)),
                  controller: passportController,
                  borderRadius: 0,
                )
                    : Container(),
                saveButtonWidget()
              ],
            ),
          ),
        ));
  }

  //save button widget
  Widget saveButtonWidget() {
    return Padding(
      padding:  EdgeInsets.only(top: 30),
      child: Center(
        child: Container(
          height: 50,
          width: 250,
          child: RaisedButton(
            color: Colors.blue,
            disabledColor: Colors.white,
            child: Text(
              "REGISTER",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            onPressed: () {
              if (firstNameController.value.text.isEmpty ||
                  lastNameController.value.text.isEmpty ||
                  dateOfbirthController.value.text.isEmpty) {
                showToast("Please enter all details",context:context);
              }
              else if (_image == null) {
                showToast("Please add image",context:context);
              }
              else {
                CustomerDetails customerData = CustomerDetails(
                    uDID: Platform.isIOS ? uuidVal : "",
                    iMEI: iMEIVal,
                    firstName: firstNameController.value.text,
                    lastName: lastNameController.value.text,
                    email: emailController.value.text,
                    dob: dateOfbirthController.value.text,
                    image: _image.toString(),
                    passport: passportController.value.text,
                    device: deviceName,
                    latitude: latitude,
                    longitude: longitude);

                SqliteDatabase().insertCustomerData(customerData);
                showToast("Your details saved successfully",context:context);
              }
            },
          ),
        ),
      ),
    );
  }

  imageFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 70);

    setState(() {
      _image = image;
    });
  }


  imageFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);

    setState(() {
      _image = image;
    });
  }


  // image picker
  void _showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  int validEmail(String input) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(input))
      return 2;
    else
      return 0;
  }


  textValid(String input) {
    if (input.isEmpty) {
      showToast("Please enter your details",context:context);
    }
  }


  fetchIMEI() async {
    String imei = await ImeiPlugin.getImei();
    String uuid = await ImeiPlugin.getId();
    iMEIVal = imei;
    uuidVal = uuid;
    iMeiController.value = TextEditingValue(text: iMEIVal);
  }


  fetchLocation() {
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
    if (_currentPosition != null) {
      latitude = _currentPosition.latitude.toString();
      longitude = _currentPosition.longitude.toString();

      print("latitude is ${latitude}");
      print("longitude is ${longitude}");

    }
  }

  fetchDeviceName() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceName = androidInfo.model;
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceName = iosInfo.model;
  }
}
