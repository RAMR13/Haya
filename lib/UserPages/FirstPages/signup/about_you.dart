import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as og;
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:hayaproject/UserPages/FirstPages/signup/OnTapVoidFN.dart';
import 'package:hayaproject/UserPages/FirstPages/signup/medical_info.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:page_transition/page_transition.dart';

class AboutYou extends StatefulWidget {
  var email;
  var password;
  var Imageurl;
  AboutYou(this.email, this.password, this.Imageurl) {}
  @override
  State<AboutYou> createState() => _AboutYoutState();
}

class _AboutYoutState extends State<AboutYou> {
  var email;
  var password;
  var Imageurl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = widget.email;
    password = widget.password;
    Imageurl = widget.Imageurl;
  }

  TextEditingController Fname = TextEditingController();
  TextEditingController Lname = TextEditingController();

  final _form = GlobalKey<FormState>();
  _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
  }

  UserHeight _userHeight = new UserHeight(150, false, 'Height');
  UserWeight _userWeight = new UserWeight(55, 0.1, false, 'Weight');
  late DateTime selectedDate = DateTime.now();
  String selectedDateString = '';

  bool Heighterror = false;
  bool Weighterror = false;
  bool dateError = false;
  var o = Colors.orange;
  var _selectedHeight = 0;
  var _selectedWeight = 0;
  bool IsClickGender = false;

  Date date = Date(DateTime.now().day, DateTime.now().month,
      DateTime.now().year, false, 'Birthdate');

  String? selectedValueofActivity;
  final List<String> genderItems = ['Male', 'Female'];

  String selectedValueofGender = '';
  bool showErrorFname = false;
  bool showErrorLname = false;
  bool genderError = false;
  String FnameErrortxt = '';
  String LnameErrortxt = '';
  int lock = 0;
  @override
  Widget build(BuildContext context) {
    if (_userHeight.isClicked) {
      Heighterror = false;
    }
    if (_userWeight.isClicked) {
      Weighterror = false;
    }
    if (date.isClicked) {
      dateError = false;
    }
    if (selectedValueofGender != '') {
      genderError = false;
    }
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Widget info(String name) {
      return Container(
        width: width * 0.4,
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 119, 119, 119),
                  width: 0.9,
                )),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepOrangeAccent,
                width: 2.0,
              ),
              borderRadius:
                  BorderRadius.all(Radius.circular(7.0)), // Sets border radius
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 119, 119, 119),
                  width: 0.9,
                )),
          ),
          hint: Text(
            name,
            style: TextStyle(
              fontFamily: 'UbuntuREG',
              fontSize: height * 0.019,
              color: Color.fromARGB(255, 94, 94, 94),
            ),
          ),
          items: [],
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          iconStyleData: IconStyleData(
              icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            size: height * 0.03,
            color: Color.fromARGB(255, 94, 94, 94),
          )),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              opacity: 0.75,
              fit: BoxFit.cover),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    /////////////////text
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
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          width: width * 0.8,
                          child: Text(
                            'This information helps Haya estimate the number of calories burned during your activity, and provides you with personalized coaching.',
                            style: TextStyle(
                                fontSize: height * 0.0165,
                                color: Color(0xFF434343),
                                fontFamily: 'UbuntuREG'),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          //////////////////////First name and password
                          children: [
                            TextField(
                              cursorColor: Color(0xFF2C2C2C),
                              onChanged: (value) {
                                setState(() {
                                  if (Fname.text.length > 15) {
                                    FnameErrortxt =
                                        "First name must be less than 15 characters";
                                    showErrorFname = true;
                                  } else
                                    showErrorFname = false;
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
                                    opacity: showErrorFname ? 1 : 0,
                                  ),
                                ),
                              ),
                            ),
                            /////////////////////////////////////////////////////////
                            TextField(
                              cursorColor: Color(0xFF2C2C2C),
                              onChanged: (value) {
                                setState(() {
                                  if (Lname.text.length > 15) {
                                    LnameErrortxt =
                                        "Last name must be less than 15 characters";
                                    showErrorLname = true;
                                  } else
                                    showErrorLname = false;
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
                                    opacity: showErrorLname ? 1 : 0,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              newMethodHeight(
                                                  height,
                                                  width,
                                                  _userHeight,
                                                  Context(context));

                                              // showMaterialNumberPicker(
                                              //   context: context,
                                              //   title:
                                              //       'Your Height is ${_selectedHeight}',
                                              //   maxNumber: 250,
                                              //   minNumber: 0,
                                              //   step: 1,
                                              //   headerColor: Colors.white,
                                              //   backgroundColor: Colors.white,
                                              //   cancelText: 'Cancel',
                                              //   confirmText: 'Done',
                                              //   headerTextColor: Colors.black,
                                              //   selectedNumber: _selectedHeight,
                                              //   onChanged: (value) => setState(
                                              //       () => _selectedHeight = value),
                                              // );
                                            },
                                            // ignore: sort_child_properties_last

                                            child: info(_userHeight.isClicked
                                                ? '${_userHeight.text} CM'
                                                : '${_userHeight.text}')),
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
                                                        fontSize:
                                                            height * 0.016)),
                                                opacity: Heighterror ? 1 : 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              newMethodWeight(
                                                  height,
                                                  width,
                                                  _userWeight,
                                                  Context(context));
                                              // showMaterialNumberPicker(
                                              //   context: context,
                                              //   title:
                                              //       'Your Weight is  ${_selectedWeight}',
                                              //   maxNumber: 250,
                                              //   minNumber: 0,
                                              //   headerTextColor: Colors.black,
                                              //   step: 1,
                                              //   headerColor: Colors.white,
                                              //   backgroundColor: Colors.white,
                                              //   cancelText: 'Cancel',
                                              //   confirmText: 'Done',
                                              //   selectedNumber: _selectedWeight,
                                              //   onChanged: (value) => setState(
                                              //       () => _selectedWeight = value),
                                              // );
                                            },
                                            // ignore: sort_child_properties_last
                                            child: info(_userWeight.isClicked
                                                ? '${_userWeight.text} KG'
                                                : '${_userWeight.text}')),
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
                                                        fontSize:
                                                            height * 0.016)),
                                                opacity: Weighterror ? 1 : 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                newMethodBD(height, width, date,
                                                    Context(context));
                                                // DatePickerBdaya.showDatePicker(
                                                //     context,
                                                //     showTitleActions: true,
                                                //     minTime: DateTime(1900, 1, 1),
                                                //     maxTime: DateTime(2300, 1, 1),
                                                //     theme:
                                                //         const DatePickerThemeBdaya(
                                                //       headerColor: Colors.white,
                                                //       backgroundColor:
                                                //           Color.fromARGB(
                                                //               255, 255, 255, 255),
                                                //       itemStyle: TextStyle(
                                                //           color: Colors.black,
                                                //           fontWeight:
                                                //               FontWeight.bold,
                                                //           fontSize: 18),
                                                //       doneStyle: TextStyle(
                                                //           color: Color.fromARGB(
                                                //               255, 68, 68, 68),
                                                //           fontSize: 16),
                                                //     ), onChanged: (date) {
                                                //   debugPrint(
                                                //       'change $date in time zone ${date.timeZoneOffset.inHours}');
                                                // }, onConfirm: (date) {
                                                //   selectedDate = date;
                                                //   selectedDateString =
                                                //       '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
                                                //   debugPrint(
                                                //       'yoooooooooo $selectedDateString');
                                                // },
                                                //     currentTime: DateTime.now(),
                                                //     locale: LocaleType.en);
                                              },
                                              // ignore: sort_child_properties_last
                                              child: info(date.text)),
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
                                                  opacity: dateError ? 1 : 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                icon: IsClickGender == false
                                                    ? Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        size: height * 0.03,
                                                        color: Color.fromARGB(
                                                            255, 94, 94, 94),
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .keyboard_arrow_up_outlined,
                                                        size: height * 0.03,
                                                        color: Color.fromARGB(
                                                            255, 94, 94, 94),
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
                                    ////////////////////////////////////////////////////////////

                                    //////////////////////////////////////////////////
                                  ],
                                ),
                              ],
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
                            Heighterror = false;
                            Weighterror = false;
                            dateError = false;
                          });
                          if (selectedValueofGender == '') {
                            genderError = true;
                          }
                          if (Fname.text == null || Fname.text.isEmpty) {
                            FnameErrortxt = "Please enter your first name";
                            showErrorFname = true;
                          }

                          if (Fname.text.length > 15) {
                            FnameErrortxt =
                                "First name must be less than 15 characters";
                            showErrorFname = true;
                          }
                          if (Lname.text == null || Lname.text.isEmpty) {
                            LnameErrortxt = "Please enter your last name";
                            showErrorLname = true;
                          }
                          if (Lname.text.length > 15) {
                            LnameErrortxt =
                                "Last name must be less than 15 characters";
                            showErrorLname = true;
                          }
                          if (_userHeight.text == 'Height' ||
                              _userHeight.isClicked == false) {
                            Heighterror = true;
                          }
                          if (_userWeight.text == 'Weight' ||
                              _userWeight.isClicked == false) {
                            Weighterror = true;
                          }
                          if (date.text == 'Birthdate' ||
                              date.isClicked == false) {
                            dateError = true;
                          }

                          if (showErrorFname == false &&
                              showErrorLname == false &&
                              Weighterror == false &&
                              Heighterror == false &&
                              dateError == false &&
                              genderError == false) {
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: MedicalInfo(
                                    email: email,
                                    ImageUrl: Imageurl.toString(),
                                    password: password,
                                    firstName: Fname.text,
                                    lastName: Lname.text,
                                    date: date.text, //new
                                    gender: selectedValueofGender,
                                    height: _userHeight.text, //new
                                    weight: _userWeight.text, //new
                                  ),
                                  type: PageTransitionType.rightToLeftWithFade),
                            );
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
          ],
        ),
      ),
    );
  }
}
