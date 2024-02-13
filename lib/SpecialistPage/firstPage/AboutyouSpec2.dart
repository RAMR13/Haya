import 'dart:collection';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as og;
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/SpecialistPage/firstPage/WaitPage.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/login.dart';
import 'package:hayaproject/UserPages/FirstPages/signup/OnTapVoidFN.dart';
import 'package:page_transition/page_transition.dart';

class SpeAboutTwo extends StatefulWidget {
  var Email;
  var Imgurl;
  var Password;
  var fname;
  var lname;
  var gender;
  var date;
  var uni;
  var occ;
  SpeAboutTwo(
    this.Email,
    this.Password,
    this.Imgurl,
    this.fname,
    this.lname,
    this.gender,
    this.date,
    this.uni,
    this.occ,
  );

  @override
  State<SpeAboutTwo> createState() => _SpeAboutState();
}

class StateModel {
  const StateModel(this.name, this.code);

  final String code;
  final String name;

  @override
  String toString() => name;
}

Date date = Date(DateTime.now().day, DateTime.now().month, DateTime.now().year,
    false, 'Birthdate');

class _SpeAboutState extends State<SpeAboutTwo> {
  var Email;

  var Password;
  var Imgurl;

  @override
  void initState() {
    Email = widget.Email;
    Password = widget.Password;
    Imgurl = widget.Imgurl;
    super.initState();
  }

  TextEditingController TextEditingControllerFname = TextEditingController();
  TextEditingController TextEditingControllerLname = TextEditingController();
  TextEditingController TextEditingControllerUniversity =
      TextEditingController();
  TextEditingController TextEditingControllerOccupation =
      TextEditingController();
  late DateTime selectedDate = DateTime.now();
  String selectedDateString = '';
  List<String> SpecialtyItems = ['Nutritionist', 'Trainer'];
  String selectedValueofSpecialty = "";
  bool IsClickSpecialty = false;
  TimeOfDay _selectedStartTime = TimeOfDay(hour: -1, minute: 00);
  TimeOfDay _selectedEndTime = TimeOfDay(hour: -1, minute: 00);
  bool showerrorFile = false;
  bool showerrorSpeciality = false;
  var fileBytes;
  String? fileName;
  int? filesize;
  String downloadlink = "";
  int lock = 0;
  nameValidata(String value) {
    if (value.isEmpty || value.length > 15) {
      return true;
    }
    return false;
  }

  OccupationValidata(String value) {
    if (value.isEmpty || value.length > 25) {
      return true;
    }
    return false;
  }

  UniversityValidata(String value) {
    if (value.isEmpty || value.length > 25) {
      return true;
    }
    return false;
  }

  FilePickerResult? resultCheck;
  pickfile1() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      resultCheck = result;
      fileBytes = result.files.first.path;
      fileName = result.files.first.name;
      filesize = result.files.first.size;
      // print(result.files.first.name);
      // print(result.files.first.size);
      // print(result.files.first.extension);
      if (!mounted) return;
      setState(() {});
      final reference = FirebaseStorage.instance.ref('uploads/$fileName');
      final UploadTask = reference.putFile(File(fileBytes!));
      await UploadTask.whenComplete(() {});

      downloadlink = await reference.getDownloadURL();
      if (!mounted) return;
      setState(() {});
    }
  }

  String selectedValueofGender = '';
  bool showErrorFname = false;
  bool showErrorLname = false;
  bool genderError = false;
  String FnameErrortxt = '';
  String selectedValue = "";
  bool IsClickGender = false;
  bool ErrorDesc = false;
  var DropdownSelectedGender = null;
  List<String> genderItems = ['Male', 'Female'];
  TextEditingController desc = TextEditingController();
  TextEditingController sub = TextEditingController();
  String subErrortxt = '';
  bool errorSub = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Hero(
                  tag: 'arrow',
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Color(0xFF2C2C2C),
                    size: height * 0.036,
                  ),
                )),
            Hero(
              tag: 'haya',
              child: Image.asset(
                "Images/Colored.png",
                height: height * 0.056,
              ),
            ),
            Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.transparent,
              size: height * 0.036,
            )
          ],
        ),
      ),
      body: Container(
        decoration: og.BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('Images/Login.png'),
              opacity: 0.6,
              fit: BoxFit.cover),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height * 0.032),
                  child: Container(
                    alignment: Alignment.center,
                    width: width * 0.8,
                    child: Text(
                      'Professional Bio',
                      style: TextStyle(
                          fontSize: height * 0.03, color: Color(0xFF2C2C2C)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Container(
                    width: width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(0, 2.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: height * 0.008, left: 6, top: 4),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Work hours",
                                    style: TextStyle(
                                      fontSize: height * 0.016,
                                      color: Color.fromARGB(255, 119, 119, 119),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: height * 0.013),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _selectStartTime(context);
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        width: width * 0.4,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.white),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(7),
                                                        topLeft:
                                                            Radius.circular(7)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.clock,
                                                    size: height * 0.027,
                                                    color: Color.fromARGB(
                                                        255, 119, 119, 119),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Container(
                                                      width: width * 0.2,
                                                      child: Text(
                                                        _selectedStartTime
                                                                    .hour ==
                                                                -1
                                                            ? "Start time"
                                                            : "${_selectedStartTime.format(context)}",
                                                        style: TextStyle(
                                                          fontSize:
                                                              height * 0.016,
                                                          color: Color.fromARGB(
                                                              255,
                                                              119,
                                                              119,
                                                              119),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: height * 0.02,
                                              color: Color.fromARGB(
                                                  255, 119, 119, 119),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _selectEndTime(context);
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        width: width * 0.4,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2))
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.white),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                        topLeft:
                                                            Radius.circular(
                                                                12)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.clock,
                                                    size: height * 0.027,
                                                    color: Color.fromARGB(
                                                        255, 119, 119, 119),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      _selectedEndTime.hour ==
                                                              -1
                                                          ? "End time"
                                                          : "${_selectedEndTime.format(context)}",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 119, 119, 119),
                                                        fontSize:
                                                            height * 0.016,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Color.fromARGB(
                                                  255, 119, 119, 119),
                                              size: height * 0.02,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2, top: 2, bottom: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 120),
                              child: Text("Error in work hours",
                                  style: TextStyle(color: Colors.red)),
                              opacity: showerrorDateorTime ? 1 : 0,
                            ),
                          ),
                        ),
                        DropdownButtonFormField2<String>(
                          style: TextStyle(
                              fontFamily: 'UbuntuREG',
                              color: Color.fromARGB(255, 94, 94, 94),
                              fontSize: height * 0.019),
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontFamily: 'UbuntuREG',
                                color: Color.fromARGB(255, 94, 94, 94),
                                fontSize: height * 0.019),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 119, 119, 119),
                                width: 0.9,
                              ),
                            ),
                            suffixIconColor: Color.fromARGB(255, 119, 119, 119),
                            suffixIcon: AnimatedRotation(
                              duration: Duration(milliseconds: 120),
                              turns: IsClickSpecialty ? 0.5 : 1,
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepOrange,
                                width: 1.0,
                              ),

                              borderRadius: BorderRadius.all(
                                  Radius.circular(7.0)), // Sets border radius
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                          ),
                          hint: Text(
                            'Speciality',
                            style: TextStyle(
                                fontFamily: 'UbuntuREG',
                                color: Color.fromARGB(255, 94, 94, 94),
                                fontSize: height * 0.019),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ],
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          items: SpecialtyItems.map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Padding(
                                padding: EdgeInsets.only(left: 7),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      fontFamily: 'UbuntuREG',
                                      color: Color.fromARGB(255, 94, 94, 94),
                                      fontSize: height * 0.019),
                                ),
                              ),
                            ),
                          ).toList(),
                          onMenuStateChange: (isOpen) {
                            setState(() {
                              isOpen == true
                                  ? IsClickSpecialty = true
                                  : IsClickSpecialty = false;
                            });
                          },
                          onChanged: (value) {
                            selectedValueofSpecialty = value.toString();
                            setState(() {
                              showerrorSpeciality = false;
                            });
                            if (selectedValueofSpecialty == "") {
                              showerrorSpeciality = true;
                            }
                          },
                          onSaved: (value) {
                            selectedValueofSpecialty = value.toString();
                          },
                          buttonStyleData:
                              ButtonStyleData(padding: EdgeInsets.all(0)),
                          iconStyleData: IconStyleData(icon: Container()),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.all(0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2, top: 2, bottom: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 120),
                              child: Text("Required",
                                  style: TextStyle(color: Colors.red)),
                              opacity: showerrorSpeciality ? 1 : 0,
                            ),
                          ),
                        ),
                        TextField(
                          minLines: 1,
                          maxLines: 3,
                          cursorColor: Color(0xFF2C2C2C),
                          onChanged: (value) {
                            setState(() {
                              if (desc.text.length > 70) {
                                FnameErrortxt =
                                    "Description must be less than 70 characters";
                                ErrorDesc = true;
                              } else
                                ErrorDesc = false;
                            });
                          },
                          controller: desc,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            label: Text("Description"),
                            labelStyle: TextStyle(
                                fontFamily: 'UbuntuREG',
                                color: Color.fromARGB(255, 94, 94, 94),
                                fontSize: height * 0.019),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 119, 119, 119),
                                  width: 0.9,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepOrangeAccent,
                                width: 1.0,
                              ),

                              borderRadius: BorderRadius.all(
                                  Radius.circular(7.0)), // Sets border radius
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2, top: 2, bottom: 8),
                          child: Align(
                            //////////error email
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: width * 0.8,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 120),
                                child: Text("$FnameErrortxt",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: height * 0.016)),
                                opacity: ErrorDesc ? 1 : 0,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          cursorColor: Color(0xFF2C2C2C),
                          onChanged: (value) {
                            setState(() {
                              if (double.tryParse(sub.text) == null) {
                                subErrortxt =
                                    "Subscribtion cost must be a number";
                                errorSub = true;
                              } else if (double.parse(sub.text) > 200) {
                                subErrortxt =
                                    "Subscribtion cost must be less than 200\$";
                                errorSub = true;
                              } else
                                errorSub = false;
                            });
                          },
                          controller: sub,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.attach_money),
                            prefixIconColor: Color.fromARGB(255, 94, 94, 94),
                            label: Text("Subscribtion cost"),
                            labelStyle: TextStyle(
                                fontFamily: 'UbuntuREG',
                                color: Color.fromARGB(255, 119, 119, 119),
                                fontSize: height * 0.019),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 119, 119, 119),
                                  width: 0.9,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepOrangeAccent,
                                width: 1.0,
                              ),

                              borderRadius: BorderRadius.all(
                                  Radius.circular(7.0)), // Sets border radius
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2, top: 2, bottom: 8),
                          child: Align(
                            //////////error email
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: width * 0.8,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 120),
                                child: Text("$subErrortxt",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: height * 0.016)),
                                opacity: errorSub ? 1 : 0,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pickfile1();
                          },
                          child: TextField(
                            enabled: false,
                            cursorColor: Color(0xFF2C2C2C),
                            decoration: InputDecoration(
                              label: Row(
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    color: Color.fromARGB(255, 94, 94, 94),
                                  ),
                                  resultCheck != null
                                      ? downloadlink == ""
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Container(
                                                width: height * 0.03,
                                                height: height * 0.03,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.deepOrange,
                                                    strokeWidth: 2.5,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: width * 0.75,
                                              child: Text(
                                                "  $fileName",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                      : Text("  Upload certificate")
                                ],
                              ),
                              labelStyle: TextStyle(
                                  fontFamily: 'UbuntuREG',
                                  color: Color.fromARGB(255, 94, 94, 94),
                                  fontSize: height * 0.019),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 119, 119, 119),
                                    width: 0.9,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 119, 119, 119),
                                    width: 0.9,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepOrangeAccent,
                                  width: 1.0,
                                ),

                                borderRadius: BorderRadius.all(
                                    Radius.circular(7.0)), // Sets border radius
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                            ),
                          ),
                        ),
                        downloadlink == ""
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: 2, top: 2, bottom: 8),
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 120),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                        "Please upload your certificate",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                  opacity: showerrorFile ? 1 : 0,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.173),
              child: Hero(
                tag: 'next',
                child: Container(
                  height: height * 0.06,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 173, 50),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFFFF2214),
                            blurRadius: 20,
                            inset: true,
                            offset: Offset(0, -10)),
                        BoxShadow(
                            color: Color.fromARGB(71, 0, 0, 0),
                            blurRadius: 4,
                            offset: Offset(0, 1))
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(350))),
                  child: GestureDetector(
                    onTap: () async {
                      if (lock == 0) {
                        setState(() {
                          showerrorDateorTime = false;
                          showerrorFile = false;
                          showerrorSpeciality = false;
                          ErrorDesc = false;
                          errorSub = false;
                        });
                        if (sub.text == null || sub.text.isEmpty) {
                          subErrortxt = "Please enter a subscribtion cost";
                          errorSub = true;
                        }
                        if (desc.text == null || desc.text.isEmpty) {
                          FnameErrortxt = "Please enter a description";
                          ErrorDesc = true;
                        }
                        if (desc.text.length > 70) {
                          FnameErrortxt =
                              "Description must be less than 70 characters";
                          ErrorDesc = true;
                        }

                        if (selectedValueofSpecialty == "") {
                          showerrorSpeciality = true;
                        }
                        if (downloadlink == "") {
                          showerrorFile = true;
                        }

                        if (validateTime(
                          _selectedStartTime,
                          _selectedEndTime,
                        )) {
                          showerrorDateorTime = true;
                        }
                        if (showerrorDateorTime == false &&
                            showerrorFile == false &&
                            showerrorSpeciality == false &&
                            errorSub == false &&
                            downloadlink != "") {
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: Email,
                              password: Password,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'The account already exists for that email.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'The account already exists for that email.',
                              ).show();
                            }
                          } catch (e) {
                            print(e);
                          }

                          await FirebaseFirestore.instance
                              .collection("specialist")
                              .add({
                            "PdfFile": downloadlink.toString(),
                            "certificate": downloadlink.toString(),
                            "Work Hours":
                                "${_selectedStartTime.format(context) + " "} - ${" " + _selectedEndTime.format(context)}",
                            "expert desc": desc.text,
                            "image": widget.Imgurl.toString(),
                            "Specialist ID":
                                FirebaseAuth.instance.currentUser!.uid,
                            "email": widget.Email.toString(),
                            "password": widget.Password.toString(),
                            "first name": widget.fname,
                            "last name": widget.lname,
                            "University": widget.uni,
                            "occupation": widget.occ,
                            "type": selectedValueofSpecialty
                                .toString()
                                .toLowerCase(),
                            "Birthday": widget.date,
                            "gender": widget.gender,
                            "price": sub.text,
                            'status': false,
                            "fileName": fileName,
                            'filesize': filesize,
                          });
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Login(),
                                  type: PageTransitionType.fade));
                        }
                        ;
                        lock++;
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      // ignore: sort_child_properties_last
                      child: ShaderMask(
                        child: Material(
                          color: Colors.transparent,
                          child: const Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        shaderCallback: (rect) {
                          return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.orange, Colors.red])
                              .createShader(rect);
                        },
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(350))),
                      margin: const EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController _textController = TextEditingController();

  bool showerrorDateorTime = false;

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepOrangeAccent,
            colorScheme:
                const ColorScheme.light(primary: Colors.deepOrangeAccent),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked.hour != -1) {
      setState(() {
        _selectedStartTime = picked;

        showerrorDateorTime =
            validateTime(_selectedStartTime, _selectedEndTime);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepOrangeAccent,
            colorScheme:
                const ColorScheme.light(primary: Colors.deepOrangeAccent),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != -1) {
      setState(() {
        _selectedEndTime = picked;
        showerrorDateorTime =
            validateTime(_selectedStartTime, _selectedEndTime);
        ;
      });
    }
  }

  bool validateTime(
    TimeOfDay s,
    TimeOfDay e,
  ) {
    if (s.hour == -1 || e.hour == -1) {
      return true;
    } else if (s.hour + s.minute == e.hour + s.minute) {
      return true;
    } else {
      return false;
    } // if (s.period.index == e.period.index) {
    //   if (s.hour.toInt() == e.hour.toInt() || s.hour.toInt() < e.hour.toInt())
    //     return true;
    // }
    // if (s.period.index == 1 && e.period.index == 0) {
    //   return true;
    // }
  }
}
