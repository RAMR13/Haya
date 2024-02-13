// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/SpecialistPage/firstPage/AboutyouSpec.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../UserPages/FirstPages/auth/login.dart';

//create account
// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as og;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/login.dart';
import 'package:hayaproject/UserPages/FirstPages/signup/about_you.dart';
import 'package:hayaproject/UserPages/WorkoutPage/WorkoutHomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';

class SpeCreateaccount extends StatefulWidget {
  const SpeCreateaccount({super.key});

  @override
  State<SpeCreateaccount> createState() => _SpeCreateaccountState();
}

class _SpeCreateaccountState extends State<SpeCreateaccount> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isvisible = true;
  bool visible = false;

  var o = Colors.orange;

  bool passwordvisibile = true;
  String? Function(String?)? validatoremail;
  String? Function(String?)? validatorpass;
  final _form = GlobalKey<FormState>();
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);

    if (em.isEmpty)
      return false;
    else
      return regExp.hasMatch(em);
  }

  _saveForm() {
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  }

  String passError = '';
  bool showErrorPassword = false;
  bool showErrorEmail = false;
  bool showErrorFile = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
            image: AssetImage("Images/Login.png"),
            fit: BoxFit.cover,
            opacity: 0.75,
          ),
        ),
        child: Form(
          key: _form,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Login.png"),
                fit: BoxFit.cover,
                opacity: 1,
              ),
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
                            padding: EdgeInsets.only(top: height * 0.03),
                            child: Container(
                              width: width,
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Create your account',
                                  style: TextStyle(
                                      fontSize: height * 0.03,
                                      color: Color(0xFF2C2C2C)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          file;
                                        });
                                        pickercamera(ImageSource.gallery);
                                      },
                                      child: Center(
                                        child: Container(
                                          width: height * 0.14,
                                          height: height * 0.14,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          padding: EdgeInsets.all(10),
                                          child: Stack(
                                            children: [
                                              Container(
                                                clipBehavior: Clip.antiAlias,
                                                width: height * 0.12,
                                                height: height * 0.12,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                          blurRadius: 4,
                                                          offset: Offset(0, 3))
                                                    ],
                                                    shape: BoxShape.circle),
                                                child: file != null
                                                    ? Imageurl == null
                                                        ? Container(
                                                            width:
                                                                height * 0.04,
                                                            height:
                                                                height * 0.04,
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .deepOrange,
                                                                strokeWidth:
                                                                    2.5,
                                                              ),
                                                            ),
                                                          )
                                                        : Image.file(
                                                            file!,
                                                            fit: BoxFit.cover,
                                                          )
                                                    : Icon(
                                                        Icons
                                                            .camera_alt, ////////////////////////////////////////////////////////
                                                        size: height * 0.05,
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                              ),
                                              file != null
                                                  ? Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                        width: height * 0.035,
                                                        height: height * 0.035,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                  blurRadius: 3,
                                                                  offset:
                                                                      Offset(0,
                                                                          2.5))
                                                            ]),
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: height * 0.021,
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Text(
                                          'Add profile photo',
                                          style: TextStyle(
                                            fontSize: height * 0.019,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 120),
                                          opacity: showErrorFile && file == null
                                              ? 1
                                              : 0,
                                          child: Center(
                                            child: Text(
                                              "Please upload a profile photo",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextField(
                                      cursorColor: Color(0xFF2C2C2C),
                                      onChanged: (value) {
                                        setState(() {
                                          showErrorEmail = false;
                                        });
                                      },
                                      controller: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        label: Text("Email"),
                                        labelStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 94, 94, 94),
                                            fontFamily: 'UbuntuREG',
                                            fontSize: height * 0.019),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 119, 119, 119),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7))),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 2, top: 2, bottom: 8),
                                      child: Align(
                                        //////////error email
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: width * 0.8,
                                          child: AnimatedOpacity(
                                            duration:
                                                Duration(milliseconds: 120),
                                            child: Text("Enter your email",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: height * 0.016)),
                                            opacity: showErrorEmail ? 1 : 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      cursorColor: Color(0xFF2C2C2C),
                                      onChanged: (value) {
                                        setState(() {
                                          showErrorPassword = false;
                                        });
                                      },
                                      controller: _password,
                                      obscureText: passwordvisibile,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              passwordvisibile =
                                                  !passwordvisibile;
                                            });
                                          },
                                          icon: Icon(passwordvisibile
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined),
                                          color: Colors.grey,
                                        ),
                                        label: Text("Password"),
                                        labelStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 94, 94, 94),
                                            fontFamily: 'UnuntuREG',
                                            fontSize: height * 0.019),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 119, 119, 119),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7))),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2, top: 2),
                                      child: Align(
                                        //////////error email
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: width * 0.8,
                                          child: AnimatedOpacity(
                                            duration:
                                                Duration(milliseconds: 120),
                                            child: Text("$passError",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: height * 0.016)),
                                            opacity: showErrorPassword ? 1 : 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /////////////////////////////////////////////////////

                      ////////////////////////////////////////////////

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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(350))),
                          child: GestureDetector(
                            onTap: () async {
                              _saveForm();
                              setState(() {
                                ImageError = false;
                              });
                              if (file == null) showErrorFile = true;
                              if (_password.text == null ||
                                  _password.text.isEmpty) {
                                passError = "Please enter a password ";
                                showErrorPassword = true;
                              } else if (_password.text.length < 8 &&
                                  _password.text.isNotEmpty) {
                                passError = "Password must have 8 characters";
                                showErrorPassword = true;
                              } else if (!_password.text
                                  .contains(RegExp(r'[A-Z]'))) {
                                showErrorPassword = true;
                                passError = "Password must have an uppercase";
                              } else if (!_password.text
                                  .contains(RegExp(r'[0-9]'))) {
                                showErrorPassword = true;
                                passError = "Password must have a digit";
                              } else if (!_password.text
                                  .contains(RegExp(r'[a-z]'))) {
                                showErrorPassword = true;
                                passError = "Password must have a lowercase";
                              } else if (!_password.text.contains(
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                showErrorPassword = true;
                                passError =
                                    "Password must have a special character";
                              }
                              if (file == null) {
                                ImageError = true;
                              }
                              if (_email.text == null || _email.text.isEmpty) {
                                showErrorEmail = true;
                              } else if (!isEmail(_email.text)) {
                                showErrorEmail = true;
                              }
                              if (_form.currentState!.validate() &&
                                  showErrorEmail == false &&
                                  ImageError == false &&
                                  Imageurl != null &&
                                  showErrorPassword == false) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: SpeAbout(
                                            _email.text,
                                            _password.text,
                                            Imageurl.toString()),
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
        ),
      ),
    );
  }

  File? file;
  String? Imageurl;
  bool ImageError = false;

  pickercamera(ImageSource imageSource) async {
    final myfile = await ImagePicker().pickImage(source: imageSource);
    if (myfile != null) {
      file = File(myfile.path);
      if (!mounted) return;
      setState(() {});
      String imagename = basename(myfile!.path);
      var refStorage =
          FirebaseStorage.instance.ref("EventFirstTwopage/$imagename");
      await refStorage.putFile(file!);
      Imageurl = await refStorage.getDownloadURL();
      if (!mounted) return;
      setState(() {});
    } else if (!mounted) return;
    setState(() {});
  }
}
