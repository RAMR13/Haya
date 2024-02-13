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
import 'package:hayaproject/AdminPage/EventPageAdmin/EventAdminPage.dart';
import 'package:hayaproject/SpecialistPage/firstPage/AboutyouSpec2.dart';
import 'package:hayaproject/SpecialistPage/firstPage/WaitPage.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/login.dart';
import 'package:hayaproject/UserPages/FirstPages/signup/OnTapVoidFN.dart';
import 'package:page_transition/page_transition.dart';

class SpeAbout extends StatefulWidget {
  var Email;
  var Imgurl;
  var Password;

  SpeAbout(this.Email, this.Password, this.Imgurl);

  @override
  State<SpeAbout> createState() => _SpeAboutState();
}

class StateModel {
  const StateModel(this.name, this.code);
  final String code;
  final String name;
  @override
  String toString() => name;
}

class _SpeAboutState extends State<SpeAbout> {
  var Email;
  bool Isclick = false;
  var Password;
  var Imgurl;

  @override
  void initState() {
    Email = widget.Email;
    Password = widget.Password;
    Imgurl = widget.Imgurl;
    super.initState();
  }

  Date Bdate = Date(DateTime.now().day, DateTime.now().month,
      DateTime.now().year, false, 'Birthdate');
  TextEditingController Fname = TextEditingController();
  TextEditingController Lname = TextEditingController();
  TextEditingController Uni = TextEditingController();
  TextEditingController Occu = TextEditingController();
  late DateTime selectedDate = DateTime.now();
  String selectedDateString = '';
  List<String> SpecialtyItems = ['Nutritionist', 'Trainer'];
  String selectedValueofSpecialty = "";
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  ///////////////////error/////
  bool fNameError = false;
  bool lNameError = false;
  bool genderError = false;
  bool dateError = false;
  bool uniError = false;
  bool occuError = false;
  ///////////////////error/////

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

  String selectedValueofGender = '';
  String FnameErrortxt = '';
  String LnameErrortxt = '';
  String selectedValue = "";
  String uniErrortxt = '';
  String occErrorTxt = '';
  bool IsClickGender = false;
  var DropdownSelectedGender = null;

  List<String> genderItems = ['Male', 'Female'];
  static const String _imageUrl =
      'https://www.pixel4k.com/preview.php?src=https://www.pixel4k.com/wp-content/uploads/2018/10/sun-in-clouds-sea-nature-4k_1540139445.jpg&w=240&h=320';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (Bdate.isClicked) {
      dateError = false;
    }
    if (selectedValueofGender != '') {
      genderError = false;
    }
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
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.032),
                        child: Container(
                          alignment: Alignment.center,
                          width: width * 0.8,
                          child: Text(
                            'About you',
                            style: TextStyle(
                                fontSize: height * 0.03,
                                color: Color(0xFF2C2C2C)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ///////////////////////////////FirstName//////////////////
                            TextField(
                              cursorColor: Color(0xFF2C2C2C),
                              onChanged: (value) {
                                setState(() {
                                  if (Fname.text.length > 15) {
                                    FnameErrortxt =
                                        "First name must be less than 15 characters";
                                    fNameError = true;
                                  } else
                                    fNameError = false;
                                });
                              },
                              controller: Fname,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                label: Text("First name"),
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
                                      Radius.circular(
                                          7.0)), // Sets border radius
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 2, top: 2, bottom: 8),
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
                                    opacity: fNameError ? 1 : 0,
                                  ),
                                ),
                              ),
                            ),
                            //////////////////////FirstName///////////////////////
                            TextField(
                              cursorColor: Color(0xFF2C2C2C),
                              onChanged: (value) {
                                setState(() {
                                  if (Lname.text.length > 15) {
                                    LnameErrortxt =
                                        "First name must be less than 15 characters";
                                    lNameError = true;
                                  } else
                                    lNameError = false;
                                });
                              },
                              controller: Lname,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                label: Text("Last name"),
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
                                      Radius.circular(
                                          7.0)), // Sets border radius
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 2, top: 2, bottom: 8),
                              child: Align(
                                //////////error email
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: width * 0.8,
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 120),
                                    child: Text("$LnameErrortxt",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: height * 0.016)),
                                    opacity: lNameError ? 1 : 0,
                                  ),
                                ),
                              ),
                            ),
                            //////////////////////SecondName////////////////////////////
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: width * 0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DropdownButtonFormField2<String>(
                                            style: TextStyle(
                                              fontFamily: 'UbuntuREG',
                                              fontSize: height * 0.019,
                                              color: Color.fromARGB(
                                                  255, 94, 94, 94),
                                            ),
                                            isExpanded: true,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7)),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 119, 119, 119),
                                                    width: 0.9,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color:
                                                      Colors.deepOrangeAccent,
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        7.0)), // Sets border radius
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7)),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 119, 119, 119),
                                                    width: 0.9,
                                                  )),
                                            ),
                                            hint: Text(
                                              'Gender',
                                              style: TextStyle(
                                                fontFamily: 'UbuntuREG',
                                                fontSize: height * 0.019,
                                                color: Color.fromARGB(
                                                    255, 94, 94, 94),
                                              ),
                                            ),
                                            items: genderItems
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                          fontSize:
                                                              height * 0.019,
                                                          color: Color.fromARGB(
                                                              255, 94, 94, 94),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            onMenuStateChange: (isOpen) {
                                              setState(() {
                                                isOpen == true
                                                    ? IsClickGender = true
                                                    : IsClickGender = false;
                                              });
                                            },
                                            onChanged: (value) {
                                              selectedValueofGender =
                                                  value.toString();
                                            },
                                            onSaved: (value) {
                                              setState(() {
                                                selectedValueofGender =
                                                    value.toString();
                                              });
                                            },
                                            buttonStyleData:
                                                const ButtonStyleData(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                            ),
                                            iconStyleData: IconStyleData(
                                                icon: AnimatedRotation(
                                              turns: IsClickGender == false
                                                  ? 1
                                                  : 0.5,
                                              duration:
                                                  Duration(milliseconds: 120),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: height * 0.03,
                                                color: Color.fromARGB(
                                                    255, 94, 94, 94),
                                              ),
                                            )),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.25),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2))
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 2, top: 2, bottom: 8),
                                            child: Align(
                                              //////////error email
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                width: width * 0.4,
                                                child: AnimatedOpacity(
                                                  duration: Duration(
                                                      milliseconds: 120),
                                                  child: Text("Required",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize:
                                                              height * 0.016)),
                                                  opacity: genderError ? 1 : 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        newMethodBD(height, width, Bdate,
                                            Context(context));
                                      },
                                      // ignore: sort_child_properties_last
                                      child: Container(
                                        width: width * 0.4,
                                        child: DropdownButtonFormField2<String>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7)),
                                                borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 119, 119, 119),
                                                  width: 0.9,
                                                )),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.deepOrangeAccent,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      7.0)), // Sets border radius
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7)),
                                                borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 119, 119, 119),
                                                  width: 0.9,
                                                )),
                                          ),
                                          hint: Text(
                                            Bdate.text,
                                            style: TextStyle(
                                              fontFamily: 'UbuntuREG',
                                              fontSize: height * 0.019,
                                              color: Color.fromARGB(
                                                  255, 94, 94, 94),
                                            ),
                                          ),
                                          items: [],
                                          buttonStyleData:
                                              const ButtonStyleData(
                                            padding: EdgeInsets.only(right: 8),
                                          ),
                                          iconStyleData: IconStyleData(
                                              icon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: height * 0.03,
                                            color:
                                                Color.fromARGB(255, 94, 94, 94),
                                          )),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 2, top: 2, bottom: 8),
                                      child: Align(
                                        //////////error email
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: width * 0.4,
                                          child: AnimatedOpacity(
                                            duration:
                                                Duration(milliseconds: 120),
                                            child: Text("Required",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: height * 0.016)),
                                            opacity: dateError ? 1 : 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            TextField(
                              cursorColor: Color(0xFF2C2C2C),
                              onChanged: (value) {
                                setState(() {
                                  if (Uni.text.length > 20) {
                                    uniErrortxt =
                                        "University must be less than 20 characters";
                                    uniError = true;
                                  } else
                                    uniError = false;
                                });
                              },
                              controller: Uni,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                label: Text("University"),
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
                                      Radius.circular(
                                          7.0)), // Sets border radius
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 2, top: 2, bottom: 8),
                              child: Align(
                                //////////error email
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: width * 0.8,
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 120),
                                    child: Text(uniErrortxt,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: height * 0.016)),
                                    opacity: uniError ? 1 : 0,
                                  ),
                                ),
                              ),
                            ),

                            TextField(
                              cursorColor: Color(0xFF2C2C2C),
                              onChanged: (value) {
                                setState(() {
                                  if (Occu.text.length > 20) {
                                    occErrorTxt =
                                        "Occupation must be less than 20 characters";
                                    occuError = true;
                                  } else
                                    occuError = false;
                                });
                              },
                              controller: Occu,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                label: Text("Occupation"),
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
                                      Radius.circular(
                                          7.0)), // Sets border radius
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 2, top: 2, bottom: 8),
                              child: Align(
                                //////////error email
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: width * 0.8,
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 120),
                                    child: Text(occErrorTxt,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: height * 0.016)),
                                    opacity: occuError ? 1 : 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Hero(
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
                          setState(() {
                            fNameError = false;
                            lNameError = false;
                            genderError = false;
                            dateError = false;
                            uniError = false;
                            occuError = false;
                          });
                          if (Fname.text == null || Fname.text.isEmpty) {
                            FnameErrortxt = "Please enter your first name";
                            fNameError = true;
                          }
                          if (Fname.text.length > 15) {
                            FnameErrortxt =
                                "First name must be less than 15 characters";
                            fNameError = true;
                          }
                          if (Lname.text == null || Lname.text.isEmpty) {
                            LnameErrortxt = "Please enter your last name";
                            lNameError = true;
                          }
                          if (Lname.text.length > 15) {
                            LnameErrortxt =
                                "Last name must be less than 15 characters";
                            lNameError = true;
                          }
                          if (selectedValueofGender == '') {
                            genderError = true;
                          }
                          if (Bdate.text == 'Birthdate') {
                            dateError = true;
                          }
                          if (Uni.text == null || Uni.text.isEmpty) {
                            uniErrortxt = "Please enter your university";
                            uniError = true;
                          }

                          if (Uni.text.length > 20) {
                            uniErrortxt =
                                "University must be less than 20 characters";
                            uniError = true;
                          }
                          if (Occu.text == null || Occu.text.isEmpty) {
                            occErrorTxt = "Please enter your occupation";
                            occuError = true;
                          }

                          if (Occu.text.length > 15) {
                            occErrorTxt =
                                "Occupation must be less than 15 characters";
                            occuError = true;
                          }
                          if (fNameError == false &&
                              lNameError == false &&
                              genderError == false &&
                              dateError == false &&
                              uniError == false &&
                              occuError == false) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: SpeAboutTwo(
                                        Email.toString(),
                                        Password.toString(),
                                        Imgurl.toString(),
                                        Fname.text,
                                        Lname.text,
                                        selectedValueofGender,
                                        Bdate.text,
                                        Uni.text,
                                        Occu.text),
                                    type: PageTransitionType
                                        .rightToLeftWithFade));
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(350))),
                          margin: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
