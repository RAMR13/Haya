import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/Loading.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';
import 'package:page_transition/page_transition.dart';
import '../../UserPages/MorePage/settings.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class More extends StatefulWidget {
  var Page_name;

  More(this.Page_name);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  List<DocumentSnapshot> specialist = [];
  var specId;

  getData() async {
    await Prefs.getString("Id").then(
      (value) {
        specId = value;
      },
    );
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("specialist")
        .where("Specialist ID", isEqualTo: specId)
        .get();
    specialist.addAll(qs.docs);
    if (!mounted) return;
    setState(() {});
  }

  bool isloading = true;

  @override
  void initState() {
    getData();

    super.initState();
  }

  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (shouldPop) if (widget.Page_name == "")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenSpec(""), type: PageTransitionType.fade));
        if (widget.Page_name == "Myworkout")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenSpec("Myworkout"),
                  type: PageTransitionType.fade));
        if (widget.Page_name == "SpecEventPage")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenSpec("SpecEventPage"),
                  type: PageTransitionType.fade));
        if (widget.Page_name == "CustomFood")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenSpec("CustomFood"),
                  type: PageTransitionType.fade));

        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    if (widget.Page_name == "")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenSpec(""),
                              type: PageTransitionType.fade));
                    if (widget.Page_name == "Myworkout")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenSpec("Myworkout"),
                              type: PageTransitionType.fade));
                    if (widget.Page_name == "SpecEventPage")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenSpec("SpecEventPage"),
                              type: PageTransitionType.fade));
                    if (widget.Page_name == "CustomFood")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenSpec("CustomFood"),
                              type: PageTransitionType.fade));
                  },
                  icon: Icon(Icons.arrow_back_ios,
                      size: height * 0.035, color: const Color(0xFF2C2C2C))),
              Text('More',
                  style: TextStyle(
                      fontSize: height * 0.03, color: const Color(0xFF2C2C2C))),
            ],
          ),
          automaticallyImplyLeading: false,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),

        /////////// body ///////////////
        backgroundColor: const Color(0xFFF9F9F9),
        body: specialist.isEmpty
            ? test1(height, width)
            : Column(
                children: [
                  Container(
                    width: width,
                    margin: EdgeInsets.only(
                        bottom: height * 0.02,
                        left: 12,
                        right: 12,
                        top: height * 0.03),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(-1, 2)),
                        const BoxShadow(
                            color: Colors.white,
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(4, -4)),
                      ],
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement<void, void>(
                            context,
                            PageTransition(
                                child: Profile(
                                    widget.Page_name, specialist, false),
                                type: PageTransitionType.rightToLeftWithFade));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: height * 0.09,
                                width: height * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 3,
                                          offset: const Offset(0, 2))
                                    ]),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    "${specialist[0]["image"]}",
                                    fit: BoxFit.cover,
                                  ),
                                  margin: const EdgeInsets.all(3.5),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 2,
                                          offset: const Offset(0, 2))
                                    ],
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                    "${specialist[0]["first name"]} "
                                    "${specialist[0]["last name"]}",
                                    style: TextStyle(
                                      color: const Color(0xFF2C2C2C),
                                      fontSize: height * 0.027,
                                    )),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: height * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ////////////////////setting container
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                            child: const Setting(),
                            type: PageTransitionType.rightToLeftWithFade,
                          ));
                    },
                    child: Container(
                      width: width,
                      height: height * 0.09,
                      margin: const EdgeInsets.only(right: 12, left: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(-1, 2)),
                          const BoxShadow(
                              color: Colors.white,
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(4, -4)),
                        ],
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Row(children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color.fromARGB(255, 255, 99, 26)
                                          .withOpacity(0.7),
                                      const Color(0xFFFF3666).withOpacity(0.9)
                                    ],
                                    stops: [
                                      0.4,
                                      1
                                    ]).createShader(bounds),
                                child: Icon(
                                  Icons.settings,
                                  color: const Color(0xFFFFAA5C),
                                  size: height * 0.045,
                                ),
                              ),
                              Text("  Settings",
                                  style: TextStyle(
                                    color: const Color(0xFF2C2C2C),
                                    fontSize: height * 0.026,
                                  )),
                            ]),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////

class Profile extends StatefulWidget {
  var Page_name;
  bool fromEdit;
  List<DocumentSnapshot> specialist;

  Profile(this.Page_name, this.specialist, this.fromEdit);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double rating = 0;
  List<DocumentSnapshot> specialist = [];
  List<DocumentSnapshot> review = [];
  double avg = 0.0;
  num sum = 0;
  double s = 0.0;

  Future<double> reviewclo() async {
    for (int i = 0; i < review.length; i++) {
      sum += await num.parse(review[i]["stars number"]);
    }
    avg = (sum / review.length);
    s = review.isEmpty ? 0 : (sum / review.length);
    return review.isEmpty ? 0 : (sum / review.length);
  }

  var specId;

  getDataReview() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("specialist")
        .doc(specialist[0].id)
        .collection("review")
        .get();

    review.addAll(qs.docs);
    if (!mounted) return;
    setState(() {
      reviewclo();
    });
  }

  bool isloading = true;

  getData() async {
    specialist = widget.specialist;
    getDataReview();
  }

  var SpecId;

  getData0() async {
    await Prefs.getString("Id").then(
      (value) {
        SpecId = value;
      },
    );
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("specialist")
        .where("Specialist ID", isEqualTo: SpecId)
        .get();
    specialist.addAll(qs.docs);

    setState(() {});
    getDataReview();
  }

  void initState() {
    if (widget.fromEdit) {
      getData0();
    } else
      getData();

    super.initState();
  }

  double reviewVal = 0;
  int lock = 0;
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: More(widget.Page_name),
                  type: PageTransitionType.fade));
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
                  Navigator.pushReplacement<void, void>(
                      context,
                      PageTransition(
                          child: More(widget.Page_name),
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
                      'Images/Specialist_Background.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  ///////first container /////////

                  Container(
                    width: width,
                    height: height * 0.53,
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        Container(
                          ////////////////shadowwww
                          height: height * 0.36,
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
                              height: height * 0.36,
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
                                    Text(
                                        specialist.length == 0
                                            ? ""
                                            : "${specialist[0]["first name"]} "
                                                "${specialist[0]["last name"]}",
                                        style: TextStyle(
                                            fontFamily: 'UbuntuREG',
                                            color: const Color(0xFF2C2C2C),
                                            fontSize: height * 0.031 //25,
                                            )),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.09, 0, width * 0.09, 0),
                                      child: Container(
                                          child: Text(
                                        specialist.length == 0
                                            ? ""
                                            : "${specialist[0]["expert desc"]}",
                                        maxLines: 4,
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
                                                Icons.school_outlined,
                                                color: const Color(0xFF5F5F5F),
                                                size: height * 0.027,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 7),
                                                child: Text(
                                                  specialist.length == 0
                                                      ? ""
                                                      : "${specialist[0]["University"]}",
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
                                                Icon(
                                                  Icons.access_time,
                                                  color:
                                                      const Color(0xFF5F5F5F),
                                                  size: height * 0.027,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Text(
                                                    specialist.length == 0
                                                        ? ""
                                                        : "${specialist[0]["Work Hours"]}",
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
                                                  Icons.work_outline,
                                                  color:
                                                      const Color(0xFF5F5F5F),
                                                  size: height * 0.027,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7),
                                                  child: Text(
                                                    specialist.length == 0
                                                        ? ""
                                                        : "${specialist[0]["occupation"]}",
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
                    padding: EdgeInsets.only(
                        top: height * 0.18, right: width * 0.08),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: EditName(widget.Page_name,
                                      specialist[0].id, specialist),
                                  type: PageTransitionType.fade));
                        },
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.3,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: height * 0.03,
                                  color: const Color(0xFF5F5F5F),
                                ),
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontFamily: 'UbuntuREG',
                                    fontSize: height * 0.018,
                                    color: const Color(0xFF5F5F5F),
                                  ),
                                )
                              ]),
                        ),
                      ),
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
                            child: specialist.length == 0
                                ? Container()
                                : Image.network(
                                    "${specialist[0]["image"]}",
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
                                child: Text(
                                  "Reviews (${review.length.toString()})",
                                  style: TextStyle(
                                    fontFamily: 'UbuntuREG',
                                    fontSize: height * 0.021,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Row(
                                  children: [
                                    IgnorePointer(
                                      child: RatingBar.builder(
                                        initialRating: s,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemBuilder: (context, index) {
                                          return Icon(
                                            Icons.star,
                                            color: Colors.deepOrangeAccent
                                                .withOpacity(0.8),
                                          );
                                        },
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Container(
                                        width: width * 0.09,
                                        height: height * 0.023,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        child: Center(
                                            child: Text(
                                                "${s}"
                                                    .toString()
                                                    .substring(0, 3),
                                                style: TextStyle(
                                                  fontSize: height * 0.016,
                                                  color: Colors.white,
                                                ))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /////////////////
                              const Divider(
                                color: Colors.black54,
                              ),
                              ////////////////////////
                              SizedBox(
                                width: width * 0.9,
                                height: height * 0.3,
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: ListView.builder(
                                      itemCount: review.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: width * 0.9,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 7, bottom: 4),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      MyFlutterApp.profile,
                                                      size: height * 0.028,
                                                      color: const Color(
                                                          0xFF2C2C2C),
                                                    ),
                                                    Text(
                                                        "  ${review[index]["user name"]}",
                                                        style: TextStyle(
                                                          fontSize:
                                                              height * 0.0158,
                                                          color: const Color(
                                                              0xFF2C2C2C),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 7, bottom: 4),
                                                child: Row(
                                                  children: [
                                                    IgnorePointer(
                                                      child: RatingBar.builder(
                                                        initialRating: review
                                                                    .length ==
                                                                0
                                                            ? 0
                                                            : double.parse(NumberFormat(
                                                                    "#.#")
                                                                .format(double
                                                                    .parse(review[
                                                                            index]
                                                                        [
                                                                        'stars number']))
                                                                .toString()),
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 15,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Icon(
                                                            Icons.star,
                                                            color: Colors
                                                                .deepOrangeAccent
                                                                .withOpacity(
                                                                    0.8),
                                                          );
                                                        },
                                                        onRatingUpdate:
                                                            (rating) {},
                                                      ),
                                                    ),
                                                    Text(
                                                        "  ${review[index]['date']}",
                                                        style: TextStyle(
                                                          fontSize:
                                                              height * 0.015,
                                                          color: Colors.black54,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 7),
                                                child: Container(
                                                  width: width * 0.92,
                                                  child: Text(
                                                    "${review[index]['desc']}",
                                                    //maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize:
                                                            height * 0.018,
                                                        color: const Color(
                                                            0xFF2C2C2C),
                                                        fontFamily:
                                                            'UbuntuREG'),
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                color: Colors.black54,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    top: 6, bottom: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "View more",
                                      style: TextStyle(
                                          fontSize: height * 0.016,
                                          color: Colors.black54),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: height * 0.016,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ////////////////// third container//////////////
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class EditName extends StatefulWidget {
  var Page_name;
  var DocId;
  var push;

  EditName(this.Page_name, this.DocId, this.push);

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController TextEditingControllerOccupation =
      TextEditingController();
  bool isloading = false;
  bool showErrorFile = false;

  bool showerrorOccupation = false;
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  OccupationValidata(String value) {
    if (value.isEmpty || value.length > 25) {
      return true;
    }
    return false;
  }

  File? file;
  String? Imageurl;
  bool ImageError = false;
  bool shouldPop = true;

  pickercamera(ImageSource imageSource) async {
    final myfile = await ImagePicker().pickImage(source: imageSource);
    if (myfile != null) {
      file = File(myfile.path);
      if (!mounted) return;
      setState(() {});
      String imagename = basename(myfile!.path);
      var refStorage = FirebaseStorage.instance.ref("UserImage/$imagename");
      await refStorage.putFile(file!);
      Imageurl = await refStorage.getDownloadURL();
      if (!mounted) return;
      setState(() {});
    } else if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: Profile(widget.Page_name, widget.push, false),
                  type: PageTransitionType.fade));
        return shouldPop;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Image.asset(
              'Images/Colored.png',
              height: height * .1,
              width: width * .1,
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Profile(widget.Page_name, widget.push, false),
                          type: PageTransitionType.fade));
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: height * 0.036,
                )),
          ),
          body: isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width: width * 0.88,
                      child: Column(
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
                                margin: EdgeInsets.only(top: height * 0.007),
                                width: height * 0.14,
                                height: height * 0.14,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
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
                                                    .withOpacity(0.25),
                                                blurRadius: 4,
                                                offset: Offset(0, 3))
                                          ],
                                          shape: BoxShape.circle),
                                      child: file != null
                                          ? Imageurl == null
                                              ? Container(
                                                  width: height * 0.04,
                                                  height: height * 0.04,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.deepOrange,
                                                      strokeWidth: 2.5,
                                                    ),
                                                  ),
                                                )
                                              : Image.file(
                                                  file!,
                                                  fit: BoxFit.cover,
                                                )
                                          : Icon(
                                              Icons.camera_alt,
                                              ////////////////////////////////////////////////////////
                                              size: height * 0.05,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                    ),
                                    file != null
                                        ? Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              width: height * 0.035,
                                              height: height * 0.035,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        blurRadius: 3,
                                                        offset: Offset(0, 2.5))
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
                                'Edit profile photo',
                                style: TextStyle(
                                  fontSize: height * 0.019,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: AnimatedOpacity(
                                duration: Duration(milliseconds: 120),
                                opacity: showErrorFile && file == null ? 1 : 0,
                                child: Center(
                                  child: Text(
                                    "Please upload a profile photo",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            child: TextFormField(
                              onChanged: (value) {
                                if (!mounted) return;
                                setState(() {
                                  showerrorOccupation = false;
                                });
                                if (OccupationValidata(
                                    TextEditingControllerOccupation.text)) {
                                  showerrorOccupation = true;
                                }
                              },
                              controller: TextEditingControllerOccupation,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  hintText: 'Occupation',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.orange, width: 2),
                                      borderRadius: BorderRadius.circular(5)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Visibility(
                              child: const Text("Occupation Text Error",
                                  style: TextStyle(color: Colors.red)),
                              visible: showerrorOccupation,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height * 0.008,
                                            left: 6,
                                            top: 4),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Work hours",
                                            style: TextStyle(
                                              fontSize: height * 0.016,
                                              color: Color.fromARGB(
                                                  255, 119, 119, 119),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height * 0.013),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _selectStartTime(context);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
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
                                                        BorderRadius.circular(
                                                            7)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        7),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        7)),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .clock,
                                                            size:
                                                                height * 0.027,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    119,
                                                                    119,
                                                                    119),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0),
                                                            child: Container(
                                                              width:
                                                                  width * 0.2,
                                                              child: Text(
                                                                _selectedStartTime
                                                                            .hour ==
                                                                        -1
                                                                    ? "Start time"
                                                                    : "${_selectedStartTime.format(context)}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      height *
                                                                          0.016,
                                                                  color: Color
                                                                      .fromARGB(
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
                                                      Icons
                                                          .arrow_forward_ios_outlined,
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
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
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
                                                        BorderRadius.circular(
                                                            7)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        12)),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .clock,
                                                            size:
                                                                height * 0.027,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    119,
                                                                    119,
                                                                    119),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              _selectedEndTime
                                                                          .hour ==
                                                                      -1
                                                                  ? "End time"
                                                                  : "${_selectedEndTime.format(context)}",
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        119,
                                                                        119,
                                                                        119),
                                                                fontSize:
                                                                    height *
                                                                        0.016,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
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
                                  padding: EdgeInsets.only(
                                      left: 2, top: 2, bottom: 8),
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
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              width: width * 0.88,
                              height: height * 0.12,
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                top: height * 0.02,
                              ),
                              child: TextField(
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                controller: _textController,
                                textAlign: TextAlign.start,
                                onTap: () {
                                  if (!mounted) return;
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  if (!mounted) return;
                                  setState(() {
                                    showErrorbasic = false;
                                  });
                                  if (validateDescbaseic(
                                      _textController.text)) {
                                    showErrorbasic = true;
                                  }
                                },
                                decoration: const InputDecoration(
                                    hintMaxLines: 2,
                                    hintText:
                                        "Add basic Description about yourself.",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              12.0)), // Sets border radius
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    errorText: null),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: showErrorbasic,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: width * 0.8,
                                child: const Text(
                                    "must be a Description By 70 letter at least",
                                    style: TextStyle(color: Colors.red)),
                              )),
                          Container(
                            height: height * 0.1,
                          ),
                          Container(
                            decoration:
                                const BoxDecoration(shape: BoxShape.rectangle),
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.fromLTRB(30, 60, 30, 20),
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
                                  if (!mounted) return;
                                  setState(() {
                                    showerrorDateorTime = false;
                                    showerrorOccupation = false;
                                    showErrorbasic = false;
                                    showErrorFile = false;

                                    ImageError = false;
                                  });
                                  if (OccupationValidata(
                                      TextEditingControllerOccupation.text)) {
                                    showerrorOccupation = true;
                                  }
                                  if (validateTime(
                                    _selectedStartTime,
                                    _selectedEndTime,
                                  )) {
                                    showerrorDateorTime = true;
                                  }
                                  if (file == null) {
                                    showErrorFile = true;

                                    ImageError = true;
                                  }
                                  if (validateDescbaseic(
                                      _textController.text)) {
                                    showErrorbasic = true;
                                  }
                                  if (showErrorbasic == false &&
                                      showerrorOccupation == false &&
                                      showerrorDateorTime == false &&
                                      showErrorFile == false &&
                                      ImageError == false) {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.rightSlide,
                                      title: 'warning',
                                      btnOk: TextButton(
                                          child: const Text('yes'),
                                          onPressed: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('specialist')
                                                  .doc(widget.DocId)
                                                  .update({
                                                "image": Imageurl.toString(),
                                                "Work Hours":
                                                    "${_selectedStartTime.format(context)} - ${_selectedEndTime.format(context)}",
                                                "occupation":
                                                    TextEditingControllerOccupation
                                                        .text,
                                                "expert desc":
                                                    _textController.text,
                                              });

                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: Profile(
                                                          widget.Page_name,
                                                          widget.push,
                                                          true),
                                                      type: PageTransitionType
                                                          .fade));
                                              if (!mounted) return;
                                              setState(() {});
                                            } catch (e) {}
                                          }),
                                      btnCancel: TextButton(
                                        child: const Text('cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (!mounted) return;
                                          setState(() {});
                                        },
                                      ),
                                      desc:
                                          'are you sure you want to update your information',
                                    ).show();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  // ignore: sort_child_properties_last
                                  child: ShaderMask(
                                    child: const Text(
                                      'Update',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    shaderCallback: (rect) {
                                      return const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.orange,
                                            Colors.red
                                          ]).createShader(rect);
                                    },
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(350))),
                                  margin: const EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  TextEditingController _textController = TextEditingController();
  bool showErrorbasic = false;

  bool validateDescbaseic(String value) {
    if (value.length < 70 || value.length > 90) {
      return true;
    }

    return false;
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange,
            colorScheme: const ColorScheme.light(primary: Colors.orange),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedStartTime) {
      if (!mounted) return;
      setState(() {
        _selectedStartTime = picked;
        _selectedStartTime.format(context);
      });
    }
    showerrorDateorTime = false;

    if (validateTime(
      _selectedStartTime,
      _selectedEndTime,
    )) {
      showerrorDateorTime = true;
    }
  }

  bool showerrorDateorTime = false;

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange,
            colorScheme: const ColorScheme.light(primary: Colors.orange),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedEndTime) {
      if (!mounted) return;
      setState(() {
        _selectedEndTime = picked;
      });
    }
    showerrorDateorTime = false;

    if (validateTime(
      _selectedStartTime,
      _selectedEndTime,
    )) {
      showerrorDateorTime = true;
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
