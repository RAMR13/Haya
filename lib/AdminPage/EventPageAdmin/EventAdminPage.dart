import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/AdminPage/navigatorbarAdmin/NavigationBar.dart';
import 'package:hayaproject/SpecialistPage/MyUserPage/MyUserPage.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';
import '../../FlutterAppIcons.dart';
import '../../SharedPrefrences.dart';
import '../../UserPages/Events/EventPage.dart';
import 'dart:async';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/AdminPage/navigatorbarAdmin/NavigationBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../FlutterAppIcons.dart';
import '../../UserPages/Events/EventPage.dart';
import '../../UserPages/FirstPages/auth/WelcomePage.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class eventpageAdmin extends StatefulWidget {
  const eventpageAdmin({Key? key}) : super(key: key);

  @override
  State<eventpageAdmin> createState() => _testState();
}

class _testState extends State<eventpageAdmin> {
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
                  child: MainScreenAdmin(''), type: PageTransitionType.fade));
        return shouldPop;
      },
      child: DefaultTabController(
          length: 2,
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
                        PopupMenuButton<String>(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                          position: PopupMenuPosition.under,
                          onSelected: (String result) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7))),
                                    width: width * 0.8,
                                    height: height * 0.16,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(14),
                                          child: Container(
                                              child: Text(
                                            "Are you sure you want to Logout?",
                                            style: TextStyle(
                                                fontSize: height * 0.024,
                                                color: Color(0xFF2C2C2C),
                                                fontFamily: 'UbuntuREG'),
                                          )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Color.fromARGB(
                                                                        90,
                                                                        255,
                                                                        119,
                                                                        56))),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF2C2C2C),
                                                            fontFamily:
                                                                'UbuntuREG',
                                                            fontSize: height *
                                                                0.018))),
                                              ),
                                              TextButton(
                                                  style: ButtonStyle(
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .all(Color
                                                                  .fromARGB(
                                                                      90,
                                                                      255,
                                                                      119,
                                                                      56))),
                                                  onPressed: () async {
                                                    await SetBoolean(
                                                        "IsLogin", false);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        PageTransition(
                                                            child: IntroHome(),
                                                            type:
                                                                PageTransitionType
                                                                    .fade));
                                                  },
                                                  child: Text("Logout",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF2C2C2C),
                                                          fontFamily:
                                                              'UbuntuREG',
                                                          fontSize:
                                                              height * 0.018)))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },

                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              height: height * 0.04,
                              value: 'Delete',
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                    color: Color(0xFF2C2C2C),
                                    fontSize: height * 0.017),
                              ),
                            ),
                          ],
                          child: Icon(
                            MyFlutterApp.profile,
                            color: const Color(0xFF2C2C2C),
                            size: height * 0.032,
                          ), // The icon to display for the menu button (Icon person)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Events",
                            style: TextStyle(
                                fontSize: height * 0.03,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2C2C2C)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFFFFFFF),
              elevation: 1.5,
            ),
            body: Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  child: const TabBarView(children: [
                    AdminUserevent(),
                    AdminExpertEvent(),
                  ]),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 3),
                    height: height * 0.055, //43,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ],
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(50),
                            right: Radius.circular(50))),
                    width: width * 0.95,
                    child: TabBar(
                      labelColor: const Color(0xFF2C2C2C),
                      unselectedLabelColor: const Color(0xFF898989),
                      isScrollable: false,
                      indicator: const UnderlineTabIndicator(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(50),
                              right: Radius.circular(50)),
                          borderSide: BorderSide(
                              width: 3.5,
                              color: Color.fromARGB(255, 255, 123, 15))),
                      indicatorColor: const Color.fromARGB(255, 255, 123, 15),
                      indicatorSize: TabBarIndicatorSize.label,
                      onTap: (value) {
                        if (!mounted) return;
                        setState(() {});
                      },
                      tabs: const [
                        Tab(
                          child: Text(
                            "User",
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Expert",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class AdminUserevent extends StatefulWidget {
  const AdminUserevent({Key? key}) : super(key: key);

  @override
  State<AdminUserevent> createState() => _AdminUsereventState();
}

class _AdminUsereventState extends State<AdminUserevent> {
  late StreamSubscription _subscription;
  List<DocumentSnapshot> AdminImage = [];
  List<int> countList = [];
  List<Future<int>> queryFutures = [];
  List<DocumentSnapshot> UserEventList = [];
  List<Future<void>> futures = [];
  getCount() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Events")
        .doc("E4AoboJAGVZzQtD8VuLB")
        .collection("UserEvent")
        .get();
    UserEventList.addAll(qs.docs);

    for (int i = 0; i < UserEventList.length; i++) {
      Future<int> queryFuture = FirebaseFirestore.instance
          .collection("Events")
          .doc("E4AoboJAGVZzQtD8VuLB")
          .collection("UserEvent")
          .doc(UserEventList[i].id)
          .collection('subscribtion')
          .get()
          .then((QuerySnapshot qs2) => qs2.docs.length);
      queryFutures.add(queryFuture);
    }
    await Future.wait(futures);
    countList = await Future.wait(queryFutures);
    if (!mounted) return;
    setState(() {});
  }

  getDataImage() async {
    QuerySnapshot qs1 = await FirebaseFirestore.instance
        .collection("Events")
        .doc("E4AoboJAGVZzQtD8VuLB")
        .collection("Admin2Image")
        .get();
    AdminImage.addAll(qs1.docs);
    if (!mounted) return;
    setState(() {});
  }

  late String Marathon = AdminImage[0]["image"].toString();

  @override
  void initState() {
    getCount();
    getDataImage();
    startColorChangeLoop();
    super.initState();
  }

  bool isFirst = true;

  startColorChangeLoop() {
    _subscription = Stream.periodic(const Duration(seconds: 10), (count) {
      return count;
    }).listen((count) {
      if (!mounted) return;
      setState(() {
        isFirst = isFirst == true ? false : true;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel the stream subscription

    super.dispose();
  }

  List<Color> activated = [
    const Color.fromARGB(255, 92, 255, 165),
    const Color.fromARGB(255, 45, 138, 145),
    const Color(0xFF2B5378)
  ];
  List<Color> notActivated = [
    const Color(0xFFFFAA5C),
    const Color.fromARGB(255, 255, 114, 89),
    const Color.fromARGB(255, 255, 69, 13)
  ];
  List<Color> pointerColor = [
    const Color(0xFFFFAA5C),
    const Color.fromARGB(255, 255, 114, 89),
    const Color.fromARGB(255, 255, 69, 13)
  ];
  String join = 'Join';

  deleteItem(var id) async {
    await FirebaseFirestore.instance
        .collection("Events")
        .doc("E4AoboJAGVZzQtD8VuLB")
        .collection("UserEvent")
        .doc(id)
        .delete();
  }

  CollectionReference UserEventControll = FirebaseFirestore.instance
      .collection("Events")
      .doc("E4AoboJAGVZzQtD8VuLB")
      .collection("UserEvent");

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Widget loadingEvent() {
      return Container(
        height: height,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => index == 0
              ? Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.065, bottom: 3, right: 3.5, left: 3.5),
                  child: Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 221, 221, 221),
                    highlightColor: Colors.grey.shade200,
                    child: Container(
                      height: height * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                  ))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 3.5),
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
                                      shape: BoxShape.circle,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Container(
                                    height: height * 0.033,
                                    width: width * 0.5,
                                    decoration:
                                        BoxDecoration(color: Colors.black),
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
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 0, 0),
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
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 6, 0, 0),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 6, 0, 0),
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
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

    TextStyle txtstyle = TextStyle(
      overflow: TextOverflow.ellipsis,
      letterSpacing: -0.28,
      fontSize: height * 0.0156,
      fontWeight: FontWeight.normal,
      fontFamily: 'UbuntuREG',
      color: const Color(0xFFE7E7E7),
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 220),
        child: countList.length == 0
            ? loadingEvent()
            : StreamBuilder(
                stream: UserEventControll.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: height,
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            try {
                              if (index == 0) {
                                return Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 4,
                                            offset: const Offset(0, 4))
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(7))),
                                  width: width,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        3.5, height * 0.065, 3.5, 3),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: height * 0.3,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 4))
                                              ],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7))),
                                          child: SizedBox(
                                            width: width,
                                            height: height * 0.4,
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: AnimatedCrossFade(
                                                firstChild: AdminImage[index]
                                                            ["imgtype"] ==
                                                        "as"
                                                    ? Image.asset(
                                                        AdminImage[1]["image"]
                                                            .toString(),
                                                      )
                                                    : Image.network(
                                                        AdminImage[1]["image"]
                                                            .toString(),
                                                      ),
                                                secondChild: AdminImage[index]
                                                            ["imgtype"] ==
                                                        "as"
                                                    ? Image.asset(
                                                        AdminImage[0]["image"]
                                                            .toString(),
                                                      )
                                                    : Image.network(
                                                        AdminImage[0]["image"]
                                                            .toString(),
                                                      ),
                                                crossFadeState: isFirst
                                                    ? CrossFadeState.showFirst
                                                    : CrossFadeState.showSecond,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                reverseDuration:
                                                    Duration(milliseconds: 400),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            PopupMenuButton<String>(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              position: PopupMenuPosition.under,
                                              onSelected: (String result) {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: EditUserImage(),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                              surfaceTintColor: Colors.white,
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  height: height * 0.04,
                                                  value: 'Edit',
                                                  child: Text('Edit'),
                                                ),
                                              ],
                                              icon: Icon(
                                                Icons.more_vert_outlined,
                                                color: Colors.white,
                                                size: height * 0.03,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                index = index - 1;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 3.5),
                                  child: Container(
                                    width: width,
                                    height: height * 0.23,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            blurRadius: 4,
                                            offset: const Offset(0, 3))
                                      ],
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.4),
                                                BlendMode.darken),
                                            child: Image.asset(
                                              "${snapshot.data?.docs[index]["image"]}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 6, 0, 15),
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              MyFlutterApp
                                                                  .profile,
                                                              color: const Color(
                                                                  0xFFE7E7E7),
                                                              size: height *
                                                                  0.026),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 7),
                                                            child: Text(
                                                                "${snapshot.data?.docs[index]["title"]}",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'UbuntuREG',
                                                                  fontSize:
                                                                      height *
                                                                          0.031,
                                                                  color: const Color(
                                                                      0xFFE7E7E7),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          snapshot.data?.docs[
                                                                          index]
                                                                      [
                                                                      "gender"] !=
                                                                  'All Gender'
                                                              ? DecoratedIcon(
                                                                  icon: Icon(
                                                                    snapshot.data?.docs[index]["gender"] ==
                                                                            'Male'
                                                                        ? MyFlutterApp
                                                                            .mars
                                                                        : MyFlutterApp
                                                                            .venus,
                                                                    color: Colors
                                                                        .transparent,
                                                                    size: height *
                                                                        0.035,
                                                                  ),
                                                                  decoration: IconDecoration(
                                                                      border: IconBorder(
                                                                          width:
                                                                              1,
                                                                          color: snapshot.data?.docs[index]["gender"] == 'Male'
                                                                              ? Color.fromARGB(255, 145, 215, 253).withOpacity(0.8)
                                                                              : Color.fromARGB(255, 255, 162, 193).withOpacity(0.8))),
                                                                )
                                                              : Container(),
                                                          PopupMenuButton<
                                                              String>(
                                                            elevation: 3,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7))),
                                                            position:
                                                                PopupMenuPosition
                                                                    .under,
                                                            onSelected: (String
                                                                result) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Center(
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(7))),
                                                                      width:
                                                                          width *
                                                                              0.8,
                                                                      height:
                                                                          height *
                                                                              0.18,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.all(14),
                                                                            child: Container(
                                                                                child: Text(
                                                                              "Are you sure you want to delete this event?",
                                                                              style: TextStyle(fontSize: height * 0.024, color: Color(0xFF2C2C2C), fontFamily: 'UbuntuREG'),
                                                                            )),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 12),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(right: 8),
                                                                                  child: TextButton(
                                                                                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Color.fromARGB(90, 255, 119, 56))),
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text("Cancel", style: TextStyle(color: Color(0xFF2C2C2C), fontFamily: 'UbuntuREG', fontSize: height * 0.018))),
                                                                                ),
                                                                                TextButton(
                                                                                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Color.fromARGB(90, 255, 119, 56))),
                                                                                    onPressed: () {
                                                                                      deleteItem(snapshot.data?.docs[index].id);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text("Delete", style: TextStyle(color: Color(0xFF2C2C2C), fontFamily: 'UbuntuREG', fontSize: height * 0.018)))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },

                                                            itemBuilder: (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                              PopupMenuItem<
                                                                  String>(
                                                                height: height *
                                                                    0.04,
                                                                value: 'Delete',
                                                                child: Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF2C2C2C),
                                                                      fontSize:
                                                                          height *
                                                                              0.017),
                                                                ),
                                                              ),
                                                            ],
                                                            icon: Icon(
                                                              Icons
                                                                  .more_vert_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size:
                                                                  height * 0.03,
                                                            ), // The icon to display for the menu button (Icon person)
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4, 0, 0, 0),
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        width: width * 0.85,
                                                        child: Text(
                                                            "${snapshot.data?.docs[index]["desc"]}",
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: txtstyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        height *
                                                                            0.017)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(7, 0, 0,
                                                      7), ////////////fffffffffffffffffff
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Row(children: [
                                                        Icon(
                                                            MyFlutterApp.note_1,
                                                            color: const Color(
                                                                0xFFE7E7E7),
                                                            size:
                                                                height * 0.020),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 3),
                                                          child: Text(
                                                              "${snapshot.data?.docs[index]["first date"]}" ==
                                                                      "${snapshot.data?.docs[index]["last date"]}"
                                                                  ? "${snapshot.data?.docs[index]["first date"]}"
                                                                  : "${snapshot.data?.docs[index]["first date"]}-${snapshot.data?.docs[index]["last date"]} ",
                                                              style: txtstyle),
                                                        ),
                                                      ]),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 3),
                                                        child: Row(children: [
                                                          Icon(
                                                              Icons.access_time,
                                                              color: const Color(
                                                                  0xFFE7E7E7),
                                                              size: height *
                                                                  0.020),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 3),
                                                            child: Text(
                                                                "${snapshot.data?.docs[index]["first time"]}" +
                                                                    " - " +
                                                                    "${snapshot.data?.docs[index]["last time"]}",
                                                                style:
                                                                    txtstyle),
                                                          ),
                                                        ]),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Container(
                                                          height:
                                                              height * 0.032,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7)),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Color(0xFFD4145A)
                                                                      .withOpacity(
                                                                          0.45),
                                                                  Color(0xFFFBB03B)
                                                                      .withOpacity(
                                                                          0.45)
                                                                ]),
                                                          ),
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .location_on_outlined,
                                                                    //location_on_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                    size: height *
                                                                        0.020),
                                                                Container(
                                                                  width: width *
                                                                      0.14,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            3),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        Future<void>
                                                                            _launchUrl() async {
                                                                          if (!await launchUrl(Uri.parse(snapshot
                                                                              .data
                                                                              ?.docs[index]["locationLink"]))) {
                                                                            throw Exception('Could not launch the link');
                                                                          }
                                                                        }

                                                                        _launchUrl();
                                                                      },
                                                                      child: Text(
                                                                          maxLines:
                                                                              1,
                                                                          '${snapshot.data?.docs[index]["location"]}'.length > 9
                                                                              ? '${snapshot.data?.docs[index]["location"]}'
                                                                              : '${snapshot.data?.docs[index]["location"]}',
                                                                          style:
                                                                              txtstyle.copyWith(color: Colors.white)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 7,
                                                      top: 0,
                                                      bottom: 7),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7)),
                                                        child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 4,
                                                                  sigmaY: 4),
                                                          child: Container(
                                                            width: width * 0.14,
                                                            height:
                                                                height * 0.032,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.40),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${countList[index]}/${snapshot.data?.docs[index]["limit"]}',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFDEDEDE),
                                                            fontSize:
                                                                height * 0.016,
                                                            fontFamily:
                                                                'UbuntuREG'),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              Container(
                                child: Text(e.toString()),
                              );
                            }

                            return Container();
                          },
                          itemCount: snapshot.data!.docs.length + 1,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    Future.delayed(const Duration(microseconds: 2), () {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("error"),
                          );
                        },
                      );
                    });
                  }
                  return Container();
                }),
      ),
    );
  }
}

class AdminExpertEvent extends StatefulWidget {
  const AdminExpertEvent({super.key});

  @override
  State<AdminExpertEvent> createState() => _AdminExpertEventState();
}

class _AdminExpertEventState extends State<AdminExpertEvent> {
  List<DocumentSnapshot> AdminImage = [];
  List<int> countList = [];
  List<Future<int>> queryFutures = [];
  List<DocumentSnapshot> UserEventList = [];
  List<Future<void>> futures = [];
  getCount() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Events")
        .doc("E4AoboJAGVZzQtD8VuLB")
        .collection("ExpetEvent")
        .get();
    UserEventList.addAll(qs.docs);

    for (int i = 0; i < UserEventList.length; i++) {
      Future<int> queryFuture = FirebaseFirestore.instance
          .collection("Events")
          .doc("E4AoboJAGVZzQtD8VuLB")
          .collection("ExpetEvent")
          .doc(UserEventList[i].id)
          .collection('subscribtion')
          .get()
          .then((QuerySnapshot qs2) => qs2.docs.length);
      queryFutures.add(queryFuture);
    }
    await Future.wait(futures);
    countList = await Future.wait(queryFutures);
    if (!mounted) return;
    setState(() {});
  }

  deleteItem(var id) async {
    await FirebaseFirestore.instance
        .collection("Events")
        .doc("E4AoboJAGVZzQtD8VuLB")
        .collection("ExpetEvent")
        .doc(id)
        .delete();
  }

  @override
  void initState() {
    getCount();
    super.initState();
  }

  CollectionReference SpecEventControll = FirebaseFirestore.instance
      .collection("Events")
      .doc("E4AoboJAGVZzQtD8VuLB")
      .collection("ExpetEvent");

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Widget loadingEvent() {
      return Container(
        height: height,
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.065),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 0, 0),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 6, 0, 0),
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
        ),
      );
    }

    TextStyle txtstyle = TextStyle(
      overflow: TextOverflow.ellipsis,
      letterSpacing: -0.28,
      fontSize: height * 0.0156,
      fontWeight: FontWeight.normal,
      fontFamily: 'UbuntuREG',
      color: const Color(0xFFE7E7E7),
    );

    return Scaffold(
        body: StreamBuilder(
      stream: SpecEventControll.snapshots(),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 220),
          child: countList.length == 0
              ? loadingEvent()
              : Container(
                  height: height,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                              3.5, index == 0 ? 55 : 3, 3.5, 3),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: width,
                            height: height * 0.23,
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
                                      "${snapshot.data?.docs[index]["image"]}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 6, 0, 15),
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(MyFlutterApp.profile,
                                                      color: const Color(
                                                          0xFFE7E7E7),
                                                      size: height * 0.026),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 7),
                                                    child: Text(
                                                        "${snapshot.data?.docs[index]["title"]}",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'UbuntuREG',
                                                          fontSize:
                                                              height * 0.031,
                                                          color: const Color(
                                                              0xFFE7E7E7),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      snapshot.data?.docs[index]
                                                                  ["gender"] !=
                                                              'All Gender'
                                                          ? DecoratedIcon(
                                                              icon: Icon(
                                                                snapshot.data?.docs[index]
                                                                            [
                                                                            "gender"] ==
                                                                        'Male'
                                                                    ? MyFlutterApp
                                                                        .mars
                                                                    : MyFlutterApp
                                                                        .venus,
                                                                color: Colors
                                                                    .transparent,
                                                                size: height *
                                                                    0.035,
                                                              ),
                                                              decoration: IconDecoration(
                                                                  border: IconBorder(
                                                                      width: 1,
                                                                      color: snapshot.data?.docs[index]["gender"] ==
                                                                              'Male'
                                                                          ? Color.fromARGB(255, 145, 215, 253).withOpacity(
                                                                              0.8)
                                                                          : Color.fromARGB(255, 255, 162, 193)
                                                                              .withOpacity(0.8))),
                                                            )
                                                          : Container(),
                                                      PopupMenuButton<String>(
                                                        elevation: 3,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7))),
                                                        position:
                                                            PopupMenuPosition
                                                                .under,
                                                        onSelected:
                                                            (String result) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Center(
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(7))),
                                                                  width: width *
                                                                      0.8,
                                                                  height:
                                                                      height *
                                                                          0.18,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                          padding: EdgeInsets.all(
                                                                              14),
                                                                          child:
                                                                              Text(
                                                                            "Are you sure you want to delete this event?",
                                                                            style: TextStyle(
                                                                                fontSize: height * 0.024,
                                                                                color: Color(0xFF2C2C2C),
                                                                                fontFamily: 'UbuntuREG'),
                                                                          )),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 12),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: 8),
                                                                              child: TextButton(
                                                                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Color.fromARGB(90, 255, 119, 56))),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text("Cancel", style: TextStyle(color: Color(0xFF2C2C2C), fontFamily: 'UbuntuREG', fontSize: height * 0.018))),
                                                                            ),
                                                                            TextButton(
                                                                                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Color.fromARGB(90, 255, 119, 56))),
                                                                                onPressed: () {
                                                                                  deleteItem(snapshot.data?.docs[index].id);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text("Delete", style: TextStyle(color: Color(0xFF2C2C2C), fontFamily: 'UbuntuREG', fontSize: height * 0.018)))
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        surfaceTintColor:
                                                            Colors.white,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                          PopupMenuItem<String>(
                                                            height:
                                                                height * 0.04,
                                                            value: 'Delete',
                                                            child:
                                                                Text('Delete'),
                                                          ),
                                                        ],
                                                        icon: Icon(
                                                          Icons
                                                              .more_vert_outlined,
                                                          color: Colors.white,
                                                          size: height * 0.03,
                                                        ), // The icon to display for the menu button (Icon person)
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 0, 0, 0),
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                width: width * 0.85,
                                                child: Text(
                                                    "${snapshot.data?.docs[index]["desc"]}",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: txtstyle.copyWith(
                                                        fontSize:
                                                            height * 0.017)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              7,
                                              0,
                                              0,
                                              7), ////////////fffffffffffffffffff
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(children: [
                                                Icon(MyFlutterApp.note_1,
                                                    color:
                                                        const Color(0xFFE7E7E7),
                                                    size: height * 0.020),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 3),
                                                  child: Text(
                                                      "${snapshot.data?.docs[index]["first date"]}" ==
                                                              "${snapshot.data?.docs[index]["last date"]}"
                                                          ? "${snapshot.data?.docs[index]["first date"]}"
                                                          : "${snapshot.data?.docs[index]["first date"]}-${snapshot.data?.docs[index]["last date"]} ",
                                                      style: txtstyle),
                                                ),
                                              ]),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3),
                                                child: Row(children: [
                                                  Icon(Icons.access_time,
                                                      color: const Color(
                                                          0xFFE7E7E7),
                                                      size: height * 0.020),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3),
                                                    child: Text(
                                                        "${snapshot.data?.docs[index]["first time"]}" +
                                                            " - " +
                                                            "${snapshot.data?.docs[index]["last time"]}",
                                                        style: txtstyle),
                                                  ),
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Container(
                                                  height: height * 0.032,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(7)),
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      Color(0xFFD4145A)
                                                          .withOpacity(0.45),
                                                      Color(0xFFFBB03B)
                                                          .withOpacity(0.45)
                                                    ]),
                                                  ),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            //location_on_outlined,
                                                            color: Colors.white,
                                                            size:
                                                                height * 0.020),
                                                        Container(
                                                          width: width * 0.14,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 3),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                Future<void>
                                                                    _launchUrl() async {
                                                                  if (!await launchUrl(Uri.parse(snapshot
                                                                          .data
                                                                          ?.docs[index]
                                                                      [
                                                                      "locationLink"]))) {
                                                                    throw Exception(
                                                                        'Could not launch the link');
                                                                  }
                                                                }

                                                                _launchUrl();
                                                              },
                                                              child: Text(
                                                                  maxLines: 1,
                                                                  '${snapshot.data?.docs[index]["location"]}'
                                                                              .length >
                                                                          9
                                                                      ? '${snapshot.data?.docs[index]["location"]}'
                                                                      : '${snapshot.data?.docs[index]["location"]}',
                                                                  style: txtstyle
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.white)),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 7, top: 0, bottom: 7),
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
                                                      padding:
                                                          EdgeInsets.all(5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${countList[index]}/${snapshot.data?.docs[index]["limit"]}',
                                                style: TextStyle(
                                                    color: Color(0xFFDEDEDE),
                                                    fontSize: height * 0.016,
                                                    fontFamily: 'UbuntuREG'),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data?.docs.length,
                    ),
                  ),
                ),
        );
      },
    ));
  }
}

class EditUserImage extends StatefulWidget {
  const EditUserImage({super.key});

  @override
  State<EditUserImage> createState() => _EditUserImageState();
}

class _EditUserImageState extends State<EditUserImage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement<void, void>(
                    context,
                    PageTransition(
                        child: MainScreenAdmin("eventpage"),
                        type: PageTransitionType.fade));
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                size: height * 0.032,
              ),
            ),
            Text(
              "Advertisement",
              style:
                  TextStyle(fontSize: height * 0.028, color: Color(0xFF2C2C2C)),
            ),
            Icon(
              Icons.arrow_back_ios_new,
              size: height * 0.032,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: Offset(0, 2))
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5, top: 3),
                          child: Text('First image',
                              style: TextStyle(
                                  fontFamily: 'UbuntuREG',
                                  fontSize: height * 0.018)),
                        ),
                        Container(
                            width: width,
                            height: height * 0.13,
                            child: EditOne()),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade600,
                      thickness: 0.7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text('Second image',
                              style: TextStyle(
                                  fontFamily: 'UbuntuREG',
                                  fontSize: height * 0.018)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 7),
                          child: Container(
                              width: width,
                              height: height * 0.13,
                              child: EditTwo()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: width * 0.8,
              height: height * 0.06,
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
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
                onTap: () {
                  Navigator.pushReplacement<void, void>(
                      context,
                      PageTransition(
                          child: MainScreenAdmin("eventpage"),
                          type: PageTransitionType.fade));
                },
                child: Container(
                  alignment: Alignment.center,
                  // ignore: sort_child_properties_last
                  child: ShaderMask(
                    child: Text(
                      'Done',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: height * 0.026,
                        color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}

class EditOne extends StatefulWidget {
  const EditOne({super.key});

  @override
  State<EditOne> createState() => EditOneState();
}

class EditOneState extends State<EditOne> {
  CollectionReference Imageref = FirebaseFirestore.instance
      .collection("Events")
      .doc("E4AoboJAGVZzQtD8VuLB")
      .collection("Admin2Image");

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: Imageref.snapshots(),
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            file != null
                ? Imageurl == null
                    ? Container(
                        width: width * 0.4,
                        height: height * 0.12,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepOrange,
                            strokeWidth: 3.5,
                          ),
                        ),
                      )
                    : Container(
                        width: width * 0.4,
                        height: height * 0.13,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Image.file(
                          file!,
                          fit: BoxFit.cover,
                        ),
                      )
                : Container(
                    width: width * 0.4,
                    height: height * 0.13,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: snapshot.data?.docs[0]["image"] == null
                        ? Icon(Icons.error_outline_outlined)
                        : snapshot.data?.docs[0]["imgtype"] == "as"
                            ? Image.asset(
                                snapshot.data?.docs[0]["image"],
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                snapshot.data?.docs[0]["image"],
                                fit: BoxFit.cover,
                              )),
            GestureDetector(
              onTap: () async {
                if (!mounted) return;
                setState(() {});
                await pickercamera(ImageSource.gallery);
                if (file != null) {
                  await FirebaseFirestore.instance
                      .collection("Events")
                      .doc("E4AoboJAGVZzQtD8VuLB")
                      .collection("Admin2Image")
                      .doc("1")
                      .update({
                    "image": Imageurl.toString(),
                    "imgtype": "net",
                  });
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: height * 0.023,
                    color: Colors.grey.shade600,
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: height * 0.023,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  File? file;
  String? Imageurl;

  Future pickercamera(ImageSource imageSource) async {
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

class EditTwo extends StatefulWidget {
  const EditTwo({super.key});

  @override
  State<EditTwo> createState() => _EditTwoState();
}

class _EditTwoState extends State<EditTwo> {
  CollectionReference Imageref = FirebaseFirestore.instance
      .collection("Events")
      .doc("E4AoboJAGVZzQtD8VuLB")
      .collection("Admin2Image");

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: Imageref.snapshots(),
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            file2 != null
                ? Imageurl2 == null
                    ? Container(
                        width: width * 0.4,
                        height: height * 0.12,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepOrange,
                            strokeWidth: 3.5,
                          ),
                        ),
                      )
                    : Container(
                        width: width * 0.4,
                        height: height * 0.13,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Image.file(
                          file2!,
                          fit: BoxFit.cover,
                        ),
                      )
                : Container(
                    width: width * 0.4,
                    height: height * 0.13,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: snapshot.data?.docs[1]["image"] == null
                        ? Icon(Icons.error_outline_outlined)
                        : snapshot.data?.docs[1]["imgtype"] == "as"
                            ? Image.asset(
                                snapshot.data?.docs[1]["image"],
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                snapshot.data?.docs[1]["image"],
                                fit: BoxFit.cover,
                              ),
                  ),
            GestureDetector(
              onTap: () async {
                if (!mounted) return;
                setState(() {});
                await pickercamera(ImageSource.gallery);
                if (file2 != null) {
                  await FirebaseFirestore.instance
                      .collection("Events")
                      .doc("E4AoboJAGVZzQtD8VuLB")
                      .collection("Admin2Image")
                      .doc("2")
                      .update({
                    "image": Imageurl2.toString(),
                    "imgtype": "net",
                  });
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: height * 0.023,
                    color: Colors.grey.shade600,
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: height * 0.023,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  File? file2;
  String? Imageurl2;

  Future pickercamera(ImageSource imageSource) async {
    final myfile = await ImagePicker().pickImage(source: imageSource);
    if (myfile != null) {
      file2 = File(myfile.path);
      if (!mounted) return;
      setState(() {});
      String imagename = basename(myfile!.path);
      var refStorage =
          FirebaseStorage.instance.ref("EventFirstTwopage/$imagename");
      await refStorage.putFile(file2!);
      Imageurl2 = await refStorage.getDownloadURL();
      if (!mounted) return;
      setState(() {});
    } else if (!mounted) return;
    setState(() {});
  }
}

SetBoolean(String key, bool value) async {
  await Prefs.setBoolean(key, value);
}

String FilterLocationString(String value) {
  if (value.toString().split(",")[0].length > 20) {
    return "${value.toString().substring(0, 15)}...";
  }
  return value.toString().split(",")[0];
}
