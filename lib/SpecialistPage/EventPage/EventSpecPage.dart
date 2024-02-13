import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/SpecialistPage/EventPage/CreateSpecEvent.dart';
import 'package:hayaproject/SpecialistPage/MorePage/MorePage.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';
import 'package:hayaproject/UserPages/Events/EventPage.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecEventPage extends StatefulWidget {
  const SpecEventPage();
  @override
  State<SpecEventPage> createState() => _SpecEventPageState();
}

class _SpecEventPageState extends State<SpecEventPage> {
  List<DocumentSnapshot> SpecEventList = [];
  List<int> countList = [];
  List<Future<int>> queryFutures = [];
  var specId;
  getData() async {
    await Prefs.getString("Id").then(
      (value) {
        specId = value;
      },
    );
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Events")
        .doc("E4AoboJAGVZzQtD8VuLB")
        .collection("ExpetEvent")
        .where('Spec id', isEqualTo: specId)
        .get();
    SpecEventList.addAll(qs.docs);

    for (int i = 0; i < SpecEventList.length; i++) {
      Future<int> queryFuture = FirebaseFirestore.instance
          .collection("Events")
          .doc("E4AoboJAGVZzQtD8VuLB")
          .collection("ExpetEvent")
          .doc(SpecEventList[i].id)
          .collection('subscribtion')
          .get()
          .then((QuerySnapshot qs2) => qs2.docs.length);

      queryFutures.add(queryFuture);
    }
    countList = await Future.wait(queryFutures);

    if (!mounted) return;
    setState(() {});
  }

  bool isloading = true;

  String FilterLocationString(String value) {
    if (value.toString().split(",")[0].length > 20) {
      return "${value.toString().substring(0, 15)}...";
    }
    return value.toString().split(",")[0];
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool shouldPop = true;
  double FabOpacity = 1;
  int lock = 1;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    TextStyle txtstyle = TextStyle(
      overflow: TextOverflow.ellipsis,
      letterSpacing: -0.28,
      fontSize: height * 0.0156,
      fontWeight: FontWeight.normal,
      fontFamily: 'UbuntuREG',
      color: const Color(0xFFE7E7E7),
    );
    Widget loadingEvent() {
      return Container(
        height: height,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3.5),
            child: Container(
              width: width,
              height: height * 0.22,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 214, 214, 214),
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 6, 0, 15),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Container(
                            height: height * 0.033,
                            width: height * 0.033,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Container(
                              height: height * 0.033,
                              width: width * 0.5,
                              decoration: BoxDecoration(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  width: width * 0.85,
                                  child: Container(
                                    height: height * 0.026,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: width * 0.85,
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    height: height * 0.026,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  width: width * 0.3,
                                  child: Container(
                                    height: height * 0.026,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 6, 0, 0),
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      width: width * 0.3,
                                      child: Container(
                                        height: height * 0.026,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Container(
                                      width: width * 0.15,
                                      height: height * 0.035,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          itemCount: 4,
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenSpec(""), type: PageTransitionType.fade));
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              child: More("SpecEventPage"),
                              type: PageTransitionType.fade),
                        );
                      },
                      child: Icon(
                        MyFlutterApp.profile,
                        color: Color(0xFF2C2C2C),
                        size: height * 0.032,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Events",
                        style: TextStyle(
                            fontSize: height * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 3,
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: height * 0.07),
          child: IgnorePointer(
            ignoring: FabOpacity == 0 ? true : false,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 150),
              opacity: FabOpacity,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFFFAA5C),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: MySpecEvent("", ""),
                          type: PageTransitionType.fade));
                },
                child: Container(
                  width: 60,
                  height: 60,
                  child: DecoratedIcon(
                    icon: Icon(
                      MyFlutterApp.note_1,
                      size: height * 0.035,
                      color: const Color(0xFFE7E7E7),
                    ),
                  ),
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          tileMode: TileMode.decal,
                          focal: Alignment.topCenter,
                          stops: const [
                        0.2,
                        0.75,
                        1
                      ],
                          colors: [
                        const Color(0xFFFFAA5C).withOpacity(0.25),
                        const Color.fromARGB(255, 255, 114, 89)
                            .withOpacity(0.5),
                        const Color.fromARGB(255, 255, 60, 0).withOpacity(0.6),
                      ])),
                ),
              ),
            ),
          ),
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: AnimatedCrossFade(
            crossFadeState: SpecEventList.isEmpty
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 220),
            firstChild: loadingEvent(),
            secondChild: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification.metrics.pixels < height / 20) {
                  if (lock == 1)
                    setState(() {
                      lock = 0;
                      FabOpacity = 1;
                    });
                }
                if (notification.metrics.pixels > height / 20) {
                  if (lock == 0)
                    setState(() {
                      lock = 1;
                      FabOpacity = 0;
                    });
                }
                return true;
              },
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3, horizontal: 3.5),
                    child: Container(
                      width: width,
                      height: height * 0.22,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7.0),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken),
                              child: Image.asset(
                                "${SpecEventList[index]["image"]}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 6, 0, 15),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(MyFlutterApp.profile,
                                                color: const Color(0xFFE7E7E7),
                                                size: height * 0.026),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 7),
                                              child: Text(
                                                  "${SpecEventList[index]["title"]}",
                                                  style: TextStyle(
                                                    fontFamily: 'UbuntuREG',
                                                    fontSize: height * 0.031,
                                                    color:
                                                        const Color(0xFFE7E7E7),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 7),
                                          child: SpecEventList[index]
                                                      ["gender"] !=
                                                  'All Gender'
                                              ? DecoratedIcon(
                                                  icon: Icon(
                                                    SpecEventList[index]
                                                                ["gender"] ==
                                                            'Male'
                                                        ? MyFlutterApp.mars
                                                        : MyFlutterApp.venus,
                                                    color: Colors.transparent,
                                                    size: height * 0.035,
                                                  ),
                                                  decoration: IconDecoration(
                                                    border: IconBorder(
                                                      width: 1,
                                                      color: SpecEventList[
                                                                      index]
                                                                  ["gender"] ==
                                                              'Male'
                                                          ? Color.fromARGB(255,
                                                                  145, 215, 253)
                                                              .withOpacity(0.8)
                                                          : Color.fromARGB(255,
                                                                  255, 162, 193)
                                                              .withOpacity(0.8),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          width: width * 0.85,
                                          child: Text(
                                            "${SpecEventList[index]["desc"]}",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: txtstyle.copyWith(
                                                fontSize: height * 0.017),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 0, 0,
                                    10), ////////////fffffffffffffffffff
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(children: [
                                          Icon(MyFlutterApp.note_1,
                                              color: const Color(0xFFE7E7E7),
                                              size: height * 0.020),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3),
                                            child: Text(
                                                "${SpecEventList[index]["first date"]}" ==
                                                        "${SpecEventList[index]["last date"]}"
                                                    ? "${SpecEventList[index]["first date"]}"
                                                    : "${SpecEventList[index]["first date"]}-${SpecEventList[index]["last date"]} ",
                                                style: txtstyle),
                                          ),
                                        ]),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Row(children: [
                                            Icon(Icons.access_time,
                                                color: const Color(0xFFE7E7E7),
                                                size: height * 0.020),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(
                                                  "${SpecEventList[index]["first time"]}" +
                                                      " - " +
                                                      "${SpecEventList[index]["last time"]}",
                                                  style: txtstyle),
                                            ),
                                          ]),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Container(
                                            height: height * 0.032,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7)),
                                              gradient: LinearGradient(colors: [
                                                Color(0xFFD4145A)
                                                    .withOpacity(0.45),
                                                Color(0xFFFBB03B)
                                                    .withOpacity(0.45)
                                              ]),
                                            ),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      //location_on_outlined,
                                                      color: Colors.white,
                                                      size: height * 0.020),
                                                  Container(
                                                    width: width * 0.14,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          Future<void>
                                                              _launchUrl() async {
                                                            if (!await launchUrl(
                                                                Uri.parse(SpecEventList[
                                                                        index][
                                                                    "locationLink"]))) {
                                                              throw Exception(
                                                                  'Could not launch the link');
                                                            }
                                                          }

                                                          _launchUrl();
                                                        },
                                                        child: Text(
                                                            maxLines: 1,
                                                            '${SpecEventList[index]["location"]}'
                                                                        .length >
                                                                    9
                                                                ? FilterLocationString(
                                                                    '${SpecEventList[index]["location"]}')
                                                                : '${SpecEventList[index]["location"]}',
                                                            style: txtstyle
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white)),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 7, top: 0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 4, sigmaY: 4),
                                              child: Container(
                                                width: width * 0.14,
                                                height: height * 0.032,
                                                color: Colors.white
                                                    .withOpacity(0.40),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${countList.length != 0 ? countList[index] : 0}/${SpecEventList[index]["limit"]}',
                                            style: TextStyle(
                                                color: Color(0xFFDEDEDE),
                                                fontSize: height * 0.016,
                                                fontFamily: 'UbuntuREG'),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: SpecEventList.length,
              ),
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
