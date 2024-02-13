import 'dart:ffi';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/Loading.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:intl/intl.dart';

class ProfileSpec extends StatefulWidget {
  List<QueryDocumentSnapshot<Object?>> Reviewlist;
  DocumentSnapshot<Object?> specialist;

  ProfileSpec(this.Reviewlist, this.specialist);

  @override
  State<ProfileSpec> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileSpec> {
  List<Map<dynamic, dynamic>> list = [];
  List<DocumentSnapshot> specialist = [];
  List<QueryDocumentSnapshot<Object?>> review = [];
  List<DocumentSnapshot> user = [];
  List<DocumentSnapshot> mySpec = [];
  bool isloading = true;
  List<DocumentSnapshot> specUser = [];
  var UserId;
  int lock = 0;

  mySpecialist() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .doc(user[0].id)
        .collection("my specialist")
        .get();
    mySpec.addAll(await qs.docs);
    setState(() {});
  }

  getSpecialistUsers() async {
    QuerySnapshot qs1 = await FirebaseFirestore.instance
        .collection("specialist")
        .doc(specialist[0].id)
        .collection("my user")
        .where('User_id', isEqualTo: UserId)
        .get();
    specUser.addAll(qs1.docs);
    print("DDDDD" + "${specUser.length}");
  }

  getDatausers() async {
    QuerySnapshot s = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: UserId)
        // .where("User_id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    user.addAll(s.docs);

    setState(() {
      print(UserId);
      print(user[0].id.toString() + "sssssssssssssss");
    });
    await mySpecialist();
    await getSpecialistUsers();
  }

  double avg = 0.0;
  num sum = 0;

  double reviewAvg(List<QueryDocumentSnapshot<Object?>> docs) {
    print(docs[0]["stars number"]);
    double sum = 0;
    for (int i = 0; i < review.length; i++) {
      sum += double.parse(docs[i]['stars number']);
    }
    return sum / review.length;
  }

  bool iscolored = false;

  String txtSubButton() {
    if (specUser.isNotEmpty) {
      if (specUser[0]['accept'] == "accept") {
        setState(() {});
        iscolored = false;
        return "Subscribed";
      } else if (specUser[0]['accept'] != "accept") {
        iscolored = false;
        setState(() {});
        return "Request sent";
      }
    } else if (mySpec.length == 2) {
      setState(() {});
      iscolored = false;
      return "You have two Specialist Already";
    } else if (mySpec.length == 1) {
      setState(() {});
      if (mySpec[0]["type"] == specialist[0]['type']) {
        setState(() {});
        iscolored = false;
        return "You're already subscribed to a ${specialist[0]["type"]}";
      }
      // if (specialist[0]['type'] == 'trainer' && mySpec[0]["type"]==specialist[0]['type']) {
      //   setState(() {});
      //   iscolored = false;
      //   return "You're already subscribed to a trainer";
      // } else if (specialist[0]['type'] == 'nutritionist' && mySpec[0]["type"]==specialist[0]['type']) {
      //   setState(() {});
      //   iscolored = false;
      //   return "You're already subscribed to a nutritionist";
      // }
      else {
        setState(() {});
        iscolored = true;
        return "Subscribe";
      }
    } else {
      setState(() {});
      iscolored = true;
      return "Subscribe";
    }
    return "";
  }

  String subtxt = 'Subscribe';

  @override
  void initState() {
    review = widget.Reviewlist;
    specialist.add(widget.specialist);
    Prefs.getString("Id").then(
      (value) async {
        UserId = await value;
        await getDatausers();

        subtxt = await txtSubButton();
      },
    );

    super.initState();
  }

  double rating = 0;
  double reviewVal = 0;
  int locks = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Widget includesRows(IconData icon, String text) {
      return Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(colors: [
              Colors.orange,
              Colors.deepOrangeAccent,
              Colors.deepOrange,
            ], stops: [
              0.2,
              0.6,
              1.0
            ]).createShader(bounds),
            child: Icon(
              icon,
              color: Colors.white,
              size: height * 0.04,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'UbuntuREG',
                fontSize: height * 0.028,
              ),
            ),
          )
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
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
                  decoration: BoxDecoration(
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
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            boxShadow: [
                              CustomBoxShadow(
                                  blurStyle: BlurStyle.outer,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(0, 4),
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
                                    offset: Offset(0, 4),
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
                                      "${specialist[0]["first name"]} "
                                      "${specialist[0]["last name"]}",
                                      style: TextStyle(
                                          fontFamily: 'UbuntuREG',
                                          color: Color(0xFF2C2C2C),
                                          fontSize: height * 0.031 //25,
                                          )),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.09, 0, width * 0.09, 0),
                                    child: Container(
                                        child: Text(
                                      "${specialist[0]["expert desc"]}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'UbuntuREG',
                                          fontSize: height * 0.021),
                                    )),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 7, bottom: 5),
                                    child: Column(
                                      ////////////////////////INFOOO
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.school_outlined,
                                              color: Color(0xFF5F5F5F),
                                              size: height * 0.027,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Text(
                                                "${specialist[0]["University"]}",
                                                style: TextStyle(
                                                    fontFamily: 'UbuntuREG',
                                                    fontSize: height * 0.0175,
                                                    color: Color(0xFF5F5F5F)),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Color(0xFF5F5F5F),
                                                size: height * 0.027,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 7),
                                                child: Text(
                                                  "${specialist[0]["Work Hours"]}",
                                                  style: TextStyle(
                                                    fontFamily: 'UbuntuREG',
                                                    fontSize: height * 0.0175,
                                                    color: Color(0xFF5F5F5F),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.work_outline,
                                                color: Color(0xFF5F5F5F),
                                                size: height * 0.027,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 7),
                                                child: Text(
                                                  "${specialist[0]["occupation"]}",
                                                  style: TextStyle(
                                                    fontFamily: 'UbuntuREG',
                                                    fontSize: height * 0.0175,
                                                    color: Color(0xFF5F5F5F),
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
                              offset: Offset(0, 1))
                        ],
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            "${specialist[0]["image"]}",
                            fit: BoxFit.cover,
                          ),
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 3,
                                offset: Offset(0, 1))
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),

              ////////secound container////////////////
              Padding(
                padding: EdgeInsets.only(top: 13),
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
                              padding: EdgeInsets.only(top: 5, left: 7),
                              child: Text(
                                review.isEmpty
                                    ? 'Reviews ( )'
                                    : "Reviews (${review.length.toString()})",
                                style: TextStyle(
                                  fontFamily: 'UbuntuREG',
                                  fontSize: height * 0.021,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
                                  IgnorePointer(
                                    child: RatingBar.builder(
                                      initialRating: review.length == 0
                                          ? 0
                                          : double.parse(NumberFormat("#.#")
                                              .format(reviewAvg(review))
                                              .toString()),
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
                                    padding: EdgeInsets.only(left: 7),
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      child: Center(
                                          child: Text(
                                              review.length == 0
                                                  ? ''
                                                  : review.length == 0
                                                      ? "0 "
                                                      : "${NumberFormat("#.##").format(reviewAvg(review))} ",
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
                            //////////////////////
                            SizedBox(
                              width: width * 0.9,
                              height: height * 0.22,
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
                                              padding: EdgeInsets.only(
                                                  left: 7, bottom: 4),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    MyFlutterApp.profile,
                                                    size: height * 0.028,
                                                    color: Color(0xFF2C2C2C),
                                                  ),
                                                  Text(
                                                      review.isEmpty
                                                          ? ''
                                                          : " ${review[index]['user name']}",
                                                      style: TextStyle(
                                                        fontSize:
                                                            height * 0.0158,
                                                        color:
                                                            Color(0xFF2C2C2C),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
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
                                                              .withOpacity(0.8),
                                                        );
                                                      },
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    ),
                                                  ),
                                                  Text(
                                                      review.isEmpty
                                                          ? ''
                                                          : "  ${review[index]['date']}",
                                                      style: TextStyle(
                                                        fontSize:
                                                            height * 0.015,
                                                        color: Colors.black54,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Container(
                                                width: width * 0.92,
                                                child: Text(
                                                  review.isEmpty
                                                      ? ''
                                                      : "${review[index]['desc']}",
                                                  //maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: height * 0.018,
                                                      color: Color(0xFF2C2C2C),
                                                      fontFamily: 'UbuntuREG'),
                                                ),
                                              ),
                                            ),
                                            Divider(
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
                              padding:
                                  EdgeInsetsDirectional.only(top: 6, bottom: 6),
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

              //////////////// third container//////////////
              Container(
                padding: const EdgeInsets.only(top: 13),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text("${specialist[0]['price']} JOD",
                                    style: TextStyle(
                                      color: Color(0xFF2C2C2C),
                                      fontSize: height * 0.018,
                                    )),
                              ),
                              //"/month"
                              Text("/Month",
                                  style: TextStyle(
                                    fontSize: height * 0.018,
                                    color: Color(0xFF2C2C2C),
                                  )),
                            ],
                          ),
                        ),
                      ),

                      IgnorePointer(
                        ignoring: !iscolored,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14))),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: height * 0.5,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                  onTap: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_back_ios_new_rounded,
                                                      size: height * 0.036,
                                                      color: Color(0xFF2C2C2C),
                                                    ),
                                                  )),
                                              Text(
                                                textAlign: TextAlign.center,
                                                "Subscription includes",
                                                style: TextStyle(
                                                  color: Color(0xFF2C2C2C),
                                                  fontSize: height * 0.03,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5),
                                                child: Icon(
                                                  Icons
                                                      .arrow_back_ios_new_rounded,
                                                  size: height * 0.036,
                                                  color: Colors.transparent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Container(
                                            height: height * 0.23,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                includesRows(
                                                    Icons.emoji_events,
                                                    specialist.length != 0
                                                        ? specialist[0]
                                                                    ['type'] ==
                                                                'nutritionist'
                                                            ? 'Personalized meal plans'
                                                            : 'Personalized coaching'
                                                        : ''),
                                                includesRows(
                                                  Icons.event,
                                                  'Special events',
                                                ),
                                                includesRows(
                                                    Icons.help, 'Q&A sessions'),
                                                includesRows(
                                                    Icons.checklist_rounded,
                                                    'Progress tracking'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Container(
                                            height: 50,
                                            margin: const EdgeInsets.fromLTRB(
                                                15, 30, 15, 10),
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 173, 50),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color(0xFFFF2214),
                                                      blurRadius: 20,
                                                      inset: true,
                                                      offset: Offset(0, -10)),
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          71, 0, 0, 0),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 1))
                                                ],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(350))),
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (locks == 0 &&
                                                    specUser.length == 0) {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    locks++;
                                                  });

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("specialist")
                                                      .doc(specialist[0].id)
                                                      .collection("my user")
                                                      .add({
                                                    "image":
                                                        "${user[0]["images"]}",
                                                    "UserDocId":
                                                        "${user[0].id}",
                                                    "FirstName":
                                                        "${user[0]['FirstName']}",
                                                    "email":
                                                        "${user[0]['email']}",
                                                    "LastName":
                                                        "${user[0]['LastName']}",
                                                    "User_id":
                                                        "${user[0]['User_id']}",
                                                    "accept": "pend"
                                                  });
                                                  await getDatausers();
                                                  subtxt = await txtSubButton();
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                // ignore: sort_child_properties_last
                                                child: ShaderMask(
                                                  child: const Text(
                                                    'Send a subscription request',
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
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
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                350))),
                                                margin: const EdgeInsets.all(5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(71, 0, 0, 0),
                                      blurRadius: 4,
                                      offset: Offset(0, 1)),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(350)),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(350)),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    ///////////////////herreee
                                    user.isEmpty || !iscolored == true
                                        ? Colors.grey
                                        : Colors.transparent,
                                    BlendMode.saturation,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 173, 50),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xFFFF2214),
                                              blurRadius: 12,
                                              inset: true,
                                              offset: Offset(0, -7)),
                                          BoxShadow(
                                              color:
                                                  Color.fromARGB(71, 0, 0, 0),
                                              blurRadius: 4,
                                              offset: Offset(0, 1))
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(350))),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(350))),
                                      margin: const EdgeInsets.all(3.5),
                                      child: ShaderMask(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            subtxt,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: height * 0.02,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        shaderCallback: (rect) {
                                          return LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.orange,
                                                Colors.red
                                              ]).createShader(rect);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      //  mySpec.length == 1
                      //       ? mySpec[0]['type'] == specialist[0]['type']
                      //           ? Container()
                      //           : Container()  : Container(
                      //           width: width * 0.9,
                      //           child: Text(
                      //             textAlign: TextAlign.center,
                      //             "You have two Specialist Already",
                      //             maxLines: 2,
                      //             overflow: TextOverflow.ellipsis,
                      //             style:
                      //                 TextStyle(fontSize: height * 0.016),
                      //           )),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
