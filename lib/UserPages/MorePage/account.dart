import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/AdminPage/EventPageAdmin/EventAdminPage.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/MorePage/edit.dart';
import 'package:hayaproject/UserPages/MorePage/screen1.dart';
import 'package:page_transition/page_transition.dart';
import '../../AdminPage/ExpertPageAdmin/ExpertAdminPage.dart';
import 'dart:io';
import 'dart:ui';

class Account extends StatefulWidget {
  var Page_name;
  bool isEdit;
  List<DocumentSnapshot> Users;

  Account(this.Page_name, this.Users, this.isEdit);

  @override
  State<Account> createState() => _ProfileState();
}

class _ProfileState extends State<Account> {
  List<DocumentSnapshot> Users = [];
  List<DocumentSnapshot> assess = [];

  var UserId;

  getData1() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: UserId)
        .
        // .where("User_id",isEqualTo: FirebaseAuth.instance.currentUser!.uid).
        get();
    Users.addAll(qs.docs);
    if (widget.isEdit) {
      await getAssessment();
    }
    if (!mounted) return;
    setState(() {});
  }

  getAssessment() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.isEdit ? Users[0].id : widget.Users[0].id)
        .collection("assessment")
        .get();

    assess.addAll(qs.docs);

    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    if (widget.isEdit)
      Prefs.getString("Id").then(
        (value) async {
          UserId = await value;
          await getData1();
        },
      );
    else {
      Users = widget.Users;
      getAssessment();
    }
    super.initState();
  }

  int calculateAge(String birthdate) {
    List<String> parts = birthdate.split('-');
    if (parts.length != 3) {
      return -1;
    }

    int day = int.parse(parts[2]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[0]);

    DateTime today = DateTime.now();
    DateTime birthday = DateTime(year, month, day);

    int age = today.year - birthday.year;

    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  bool shouldPop = true;
  String checkBody(List assess) {
    List bodyParts = [];
    String allBody = '';
    if (assess[0]['arm'] == 1)
      bodyParts.add('arm');
    else
      bodyParts.add('');
    if (assess[0]['chest'] == 1)
      bodyParts.add('chest');
    else
      bodyParts.add('');
    if (assess[0]['abs'] == 1)
      bodyParts.add('abs');
    else
      bodyParts.add('');

    if (assess[0]['leg'] == 1)
      bodyParts.add('leg');
    else
      bodyParts.add('');

    for (int i = 0; i < bodyParts.length; i++) {
      if (bodyParts[i] != '') {
        if (i == bodyParts.length - 1)
          allBody = allBody + '${bodyParts[i]}.';
        else
          allBody = allBody + '${bodyParts[i]}, ';
      }
    }

    return allBody.substring(0, 1).toUpperCase() + allBody.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (shouldPop) if (widget.Page_name == "chat page") {
          Navigator.pop(context);
        } else
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: Screen1(widget.Page_name),
                  type: PageTransitionType.leftToRightWithFade));

        return shouldPop;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {
                  if (widget.Page_name == "chat page") {
                    Navigator.pop(context);
                  } else
                    Navigator.pushReplacement<void, void>(
                        context,
                        PageTransition(
                            child: Screen1(widget.Page_name),
                            type: PageTransitionType.leftToRightWithFade));
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: height * 0.038,
                  color: Colors.white,
                ))),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///////////// outer stack//////
                Stack(children: [
                  Container(
                    height: height * 0.43,
                    width: width,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Image.asset(
                      'Moreimages/Picture1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  ///////first container /////////
                  Container(
                    width: width,
                    height: height * 0.48,
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        Container(
                          ////////////////shadowwww
                          height: height * 0.31,
                          width: width * 0.92,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              boxShadow: [
                                CustomBoxShadow(
                                    blurStyle: BlurStyle.outer,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 6)
                              ]),
                        ),
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: width * 0.92,
                              height: height * 0.31,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  CustomBoxShadow(
                                      blurStyle: BlurStyle.outer,
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 4)
                                ],
                                color: Colors.white.withOpacity(0.78),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: height * 0.094),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: width * 0.8,
                                      child: Center(
                                        child: Text(
                                            Users.isEmpty
                                                ? ''
                                                : "${Users[0]["FirstName"]} ${Users[0]["LastName"]}",
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: 'UbuntuREG',
                                                color: const Color(0xFF2C2C2C),
                                                fontSize: height * 0.031 //25,
                                                )),
                                      ),
                                    ),
                                    widget.Page_name == "chat page"
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.09,
                                                0,
                                                width * 0.09,
                                                0),
                                            child: Container(
                                                child: Text(
                                              "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'UbuntuREG',
                                                  fontSize: height * 0.021),
                                            )),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                top: height * 0.012),
                                            child: Container(
                                              height: height * 0.04,
                                              width: width * 0.25,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 255, 173, 50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            Color(0xFFFF2214),
                                                        blurRadius: 12,
                                                        inset: true,
                                                        offset: Offset(0, -7)),
                                                    BoxShadow(
                                                        color: Color.fromARGB(
                                                            71, 0, 0, 0),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 1))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              350))),
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                350))),
                                                margin: const EdgeInsets.all(3),
                                                child: ShaderMask(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                child: EditInfo(
                                                                    widget
                                                                        .Page_name,
                                                                    Users[0],
                                                                    false),
                                                                type: PageTransitionType
                                                                    .rightToLeftWithFade));
                                                      }, /////////Do it
                                                      child: Text(
                                                        'Edit',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize:
                                                              height * 0.02,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  shaderCallback: (rect) {
                                                    return const LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.orange,
                                                          Colors.red
                                                        ]).createShader(rect);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.09, 0, width * 0.09, 0),
                                      child: Container(
                                          child: Text(
                                        "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'UbuntuREG',
                                            fontSize: height * 0.021),
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 7, bottom: 5),
                                      child: Column(
                                        ////////////////////////INFOOO
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                MyFlutterApp.vector_1,
                                                color: const Color(0xFF5F5F5F),
                                                size: height * 0.027,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 7),
                                                child: Text(
                                                  Users.length == 0
                                                      ? ''
                                                      : "${Users[0]["weight"]} KG",
                                                  style: TextStyle(
                                                      fontFamily: 'UbuntuREG',
                                                      fontSize: height * 0.0175,
                                                      color: const Color(
                                                          0xFF5F5F5F)),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                Transform.rotate(
                                                  angle: 2,
                                                  child: Icon(
                                                    Icons.straighten_rounded,
                                                    color: const Color.fromARGB(
                                                        255, 95, 95, 95),
                                                    size: height * 0.027,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Text(
                                                    Users.length == 0
                                                        ? ""
                                                        : "${Users[0]["height"]} CM",
                                                    style: TextStyle(
                                                      fontFamily: 'UbuntuREG',
                                                      fontSize: height * 0.0175,
                                                      color: const Color(
                                                          0xFF5F5F5F),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Users.length == 0
                                                      ? MyFlutterApp.venus
                                                      : Users[0]['gender'] ==
                                                              'Female'
                                                          ? MyFlutterApp.venus
                                                          : MyFlutterApp.mars,
                                                  color: Users.length == 0
                                                      ? Color.fromARGB(
                                                          255, 107, 142, 202)
                                                      : Users[0]['gender'] ==
                                                              'Female'
                                                          ? const Color
                                                              .fromARGB(255,
                                                              189, 102, 131)
                                                          : const Color
                                                              .fromARGB(255,
                                                              107, 142, 202),

                                                  //  Color.fromARGB(255,
                                                  // 140, 179, 247),
                                                  size: height * 0.027,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Text(
                                                    Users.length == 0
                                                        ? ""
                                                        : "${calculateAge(Users[0]["date"])}",
                                                    style: TextStyle(
                                                      fontFamily: 'UbuntuREG',
                                                      fontSize: height * 0.0175,
                                                      color: const Color(
                                                          0xFF5F5F5F),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.095),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: height * 0.16,
                        width: height * 0.16,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 1))
                          ],
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            child: Users.length == 0
                                ? Container()
                                : Image.network(
                                    Users[0]['images'],
                                    fit: BoxFit.cover,
                                  ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1))
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),

                //////////secound container////////////////
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.92,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            const BoxShadow(
                                color: Color.fromARGB(95, 117, 116, 116),
                                blurRadius: 5,
                                offset: Offset(-3, 3)),
                            const BoxShadow(
                                color: Color.fromARGB(95, 219, 217, 217),
                                blurRadius: 5,
                                offset: Offset(3, -3)),
                          ],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 5, left: 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 7),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Medical information",
                                      style: TextStyle(
                                        fontFamily: 'UbuntuREG',
                                        fontSize: height * 0.018,
                                      ),
                                    ),
                                    widget.Page_name == "chat page"
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.09,
                                                0,
                                                width * 0.09,
                                                0),
                                            child: Container(
                                                child: Text(
                                              "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'UbuntuREG',
                                                  fontSize: height * 0.021),
                                            )),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: MedicalInfoEdit(
                                                          widget.Page_name,
                                                          Users),
                                                      type: PageTransitionType
                                                          .rightToLeftWithFade));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 7),
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 255, 102, 0),
                                                    fontFamily: 'UbuntuREG',
                                                    fontSize: height * 0.016),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 7,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * 0.9,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF9F9F9),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 3)),
                                              const BoxShadow(
                                                  color: Colors.white,
                                                  blurRadius: 1,
                                                  offset: Offset(1, -2))
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(7))),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              7, 14, 7, 14),
                                          child: Text(
                                            'Chronic disease: ${Users.length == 0 ? "" : Users[0]["chronicdisease"]}.',
                                            style: TextStyle(
                                                fontSize: height * 0.019,
                                                fontFamily: 'UbuntuREG '),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: height * 0.01),
                                        child: Container(
                                          width: width * 0.9,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFF9F9F9),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 3),
                                                ),
                                                const BoxShadow(
                                                    color: Colors.white,
                                                    blurRadius: 1,
                                                    offset: Offset(1, -2))
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(7))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                7, 14, 7, 14),
                                            child: Text(
                                              'Injuries: ${Users.length == 0 ? "" : Users[0]["injuries"]}.',
                                              style: TextStyle(
                                                  fontSize: height * 0.019,
                                                  fontFamily: 'UbuntuREG '),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: height * 0.01),
                                        child: Container(
                                          width: width * 0.9,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFF9F9F9),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 3)),
                                                const BoxShadow(
                                                    color: Colors.white,
                                                    blurRadius: 1,
                                                    offset: Offset(1, -2))
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(7))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                7, 14, 7, 14),
                                            child: Text(
                                              'Medications: ${Users.length == 0 ? "" : Users[0]['medications']}.',
                                              style: TextStyle(
                                                  fontSize: height * 0.019,
                                                  fontFamily: 'UbuntuREG '),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: height * 0.01),
                                        child: Container(
                                          width: width * 0.9,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFF9F9F9),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 3)),
                                                const BoxShadow(
                                                    color: Colors.white,
                                                    blurRadius: 1,
                                                    offset: Offset(1, -2))
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(7))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                7, 14, 7, 14),
                                            child: Text(
                                              'Allergies: ${Users.length == 0 ? "" : Users[0]['allergies']}. ',
                                              style: TextStyle(
                                                  fontSize: height * 0.019,
                                                  fontFamily: 'UbuntuREG '),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: height * 0.01, bottom: 7),
                                        child: Container(
                                          width: width * 0.9,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFF9F9F9),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 3)),
                                                const BoxShadow(
                                                    color: Colors.white,
                                                    blurRadius: 1,
                                                    offset: Offset(1, -2))
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(7))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                7, 14, 0, 14),
                                            child: Row(children: [
                                              Text(
                                                // '${Users[0]['diagnosis']}',
                                                "Diagnosis: ",
                                                style: TextStyle(
                                                    fontSize: height * 0.019,
                                                    fontFamily: 'UbuntuREG'),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7)),
                                                  color: Color.fromARGB(
                                                      255, 235, 235, 235),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: height * 0.025,
                                                        child: Image.asset(
                                                          "Images/pdfimages.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          final url =
                                                              '${Users[0]['diagnosis']}';
                                                          final file =
                                                              await PDFApi
                                                                  .loadNetwork(
                                                                      url);
                                                          openPDF(
                                                              context, file);
                                                        },
                                                        child: Text(
                                                          " diagnosis.pdf",
                                                          style: TextStyle(
                                                              fontSize: height *
                                                                  0.018,
                                                              fontFamily:
                                                                  'UbuntuREG'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ///////////////////Third container///////////////
                assess.length == 0
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 13, bottom: 13),
                        child: Column(
                          children: [
                            Container(
                              width: width * 0.92,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  const BoxShadow(
                                      color: Color.fromARGB(95, 117, 116, 116),
                                      blurRadius: 5,
                                      offset: Offset(-3, 3)),
                                  const BoxShadow(
                                      color: Color.fromARGB(95, 219, 217, 217),
                                      blurRadius: 5,
                                      offset: Offset(3, -3)),
                                ],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(top: 5, left: 2),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Assessment",
                                            style: TextStyle(
                                              fontFamily: 'UbuntuREG',
                                              fontSize: height * 0.018,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                          horizontal: 7,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width * 0.9,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF9F9F9),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.25),
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 3)),
                                                    const BoxShadow(
                                                        color: Colors.white,
                                                        blurRadius: 1,
                                                        offset: Offset(1, -2))
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        7, 14, 7, 14),
                                                child: Text(
                                                  'Goal: ${Users.length == 0 ? "" : assess[0]["goal choice"] == 1 ? 'Lose weight.' : assess[0]["goal choice"] == 2 ? 'Gain muscle.' : assess[0]["goal choice"] == 3 ? 'Keep fit.' : ''}',
                                                  style: TextStyle(
                                                      fontSize: height * 0.019,
                                                      fontFamily: 'UbuntuREG '),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: height * 0.01),
                                              child: Container(
                                                width: width * 0.9,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFF9F9F9),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.25),
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 3),
                                                      ),
                                                      const BoxShadow(
                                                          color: Colors.white,
                                                          blurRadius: 1,
                                                          offset: Offset(1, -2))
                                                    ],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          7, 14, 7, 14),
                                                  child: Text(
                                                    'Targeted areas: ${checkBody(assess)}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            height * 0.019,
                                                        fontFamily:
                                                            'UbuntuREG '),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: height * 0.01),
                                              child: Container(
                                                width: width * 0.9,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFF9F9F9),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              0, 3)),
                                                      const BoxShadow(
                                                          color: Colors.white,
                                                          blurRadius: 1,
                                                          offset: Offset(1, -2))
                                                    ],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          7, 14, 7, 14),
                                                  child: Text(
                                                    'Actvity rate: ${Users.length == 0 ? "" : assess[0]["active choice"] == 1 ? 'Lightly active.' : assess[0]["active choice"] == 2 ? 'Moderately active.' : assess[0]["active choice"] == 3 ? 'Very active.' : ''}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            height * 0.019,
                                                        fontFamily:
                                                            'UbuntuREG '),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: height * 0.01,
                                                  bottom: 7),
                                              child: Container(
                                                width: width * 0.9,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFF9F9F9),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              0, 3)),
                                                      const BoxShadow(
                                                          color: Colors.white,
                                                          blurRadius: 1,
                                                          offset: Offset(1, -2))
                                                    ],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          7, 14, 7, 14),
                                                  child: Text(
                                                    'Weekly goal: ${Users.length == 0 ? "" : assess[0]["week goal"]} days a week.',
                                                    style: TextStyle(
                                                        fontSize:
                                                            height * 0.019,
                                                        fontFamily:
                                                            'UbuntuREG '),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])
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
        ),
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        PageTransition(
            child: PDFViewerPage(
              file: file,
            ),
            type: PageTransitionType.fade),
      );
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
