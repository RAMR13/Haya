import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/Events/EventPage.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../navigatorbarUser/NavigationBar.dart';

import 'dart:async';
import 'dart:ui';

class MyEvents extends StatefulWidget {
  var address;
  String link;

  MyEvents(this.address, this.link);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  String Address = "";
  String link = "";

  @override
  void initState() {
    link = widget.link;
    Address = widget.address;
    super.initState();
  }

  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return DefaultTabController(
        initialIndex: widget.address == "1" ? 1 : 0,
        length: 2,
        child: WillPopScope(
          onWillPop: () async {
            if (shouldPop)
              Navigator.pushReplacement<void, void>(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: MainScreenUser("eventpage"),
                ),
              );
            return shouldPop;
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement<void, void>(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: MainScreenUser("eventpage"),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: height * 0.036,
                    ),
                  ),
                  Text(
                    "Events",
                    style: TextStyle(fontSize: height * 0.03),
                  ),
                  Icon(
                    Icons.arrow_back_ios,
                    size: height * 0.036,
                    color: Colors.transparent,
                  ),
                ],
              ),
              bottom: TabBar(
                  indicatorColor: Colors.deepOrange,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 5,
                  labelColor: Colors.deepOrange,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      text: "Create events",
                    ),
                    Tab(
                      text: "My events",
                    ),
                  ]),
            ),
            body: TabBarView(children: [
              CreateEvent(
                  "", Address, link, "", "", "", "", "", "", "", "", ""),
              // "", "", "", "", "", "", "", "", ""

              const MyuserEvent(),
            ]),
          ),
        ));
  }
}

class MyuserEvent extends StatefulWidget {
  const MyuserEvent({super.key});

  @override
  State<MyuserEvent> createState() => _MyuserEventState();
}

class _MyuserEventState extends State<MyuserEvent> {
  List<DocumentSnapshot> UserEventList = [];
  List<DocumentSnapshot> Users = [];

  List<Future<int>> queryFutures = [];
  List<int> isJoined = [];
  List<int> countList = [];
  List<expanded> isExpanded = [];
  List<Future<void>> futures = [];

  String FilterLocationString(String value) {
    if (value.toString().split(",")[0].length > 20) {
      return "${value.toString().substring(0, 15)}...";
    }
    return value.toString().split(",")[0];
  }

  @override
  void initState() {
    getData1();
    super.initState();
  }

  deleteItem(var id) async {
    await FirebaseFirestore.instance
        .collection("Events")
        .doc("E4AoboJAGVZzQtD8VuLB")
        .collection("UserEvent")
        .doc(id)
        .delete();
  }

  var UserId;

  getData1() async {
    Prefs.getString("Id").then(
      (value) {
        UserId = value;
      },
    );
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: UserId)
        .
        // .where("User_id",isEqualTo: FirebaseAuth.instance.currentUser!.uid).
        get();
    Users.addAll(qs.docs);
    if (!mounted) return;
    setState(() {});
    getData();
  }

  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Events")
        .doc("E4AoboJAGVZzQtD8VuLB")
        .collection("UserEvent")
        .where("user id", isEqualTo: UserId)
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
    for (int i = 0; i < UserEventList.length; i++) {
      print(isJoined.length);
      if (isJoined.contains(i))
        isExpanded.add(expanded(false, true));
      else
        isExpanded.add(expanded(false, false));
    }
    if (!mounted) return;
    setState(() {});
  }

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
      color: const Color(0xFFE7E7E7).withOpacity(0.85),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: UserEventList.isEmpty
          ? ListView.builder(
              key: const ValueKey<int>(0),
              itemBuilder: (context, index) {
                if (index == 0)
                  return Padding(
                    padding: EdgeInsets.only(
                        top: height * 0, bottom: 3, right: 3.5, left: 3.5),
                    child: Container(
                      height: height * 0.18,
                      width: width,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 221, 221, 221),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 185, 185, 185),
                        highlightColor: Colors.grey.shade200,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 7, top: 7, right: 7),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      width: height * 0.045,
                                      height: height * 0.04,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Container(
                                        color: Colors.black,
                                        width: width * 0.4,
                                        height: height * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black,
                                  width: width * 0.75,
                                  height: height * 0.03,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Colors.black,
                                            width: width * 0.3,
                                            height: height * 0.02,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Container(
                                              color: Colors.black,
                                              width: width * 0.3,
                                              height: height * 0.02,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Container(
                                              color: Colors.black,
                                              width: width * 0.3,
                                              height: height * 0.02,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          color: Colors.black,
                                          width: width * 0.13,
                                          height: height * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 3.5),
                  child: Container(
                    height: height * 0.18,
                    width: width,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 185, 185, 185),
                      highlightColor: Colors.grey.shade200,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 7, top: 7, right: 7),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    width: height * 0.045,
                                    height: height * 0.04,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Container(
                                      color: Colors.black,
                                      width: width * 0.4,
                                      height: height * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black,
                                width: width * 0.75,
                                height: height * 0.03,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.black,
                                          width: width * 0.3,
                                          height: height * 0.02,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            color: Colors.black,
                                            width: width * 0.3,
                                            height: height * 0.02,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            color: Colors.black,
                                            width: width * 0.3,
                                            height: height * 0.02,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                        color: Colors.black,
                                        width: width * 0.13,
                                        height: height * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 5,
            )
          : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 3.5),
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
                              "${UserEventList[index]["image"]}",
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(MyFlutterApp.profile,
                                              color: const Color(0xFFE7E7E7),
                                              size: height * 0.026),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 7),
                                            child: Text(
                                                "${UserEventList[index]["title"]}",
                                                style: TextStyle(
                                                  fontFamily: 'UbuntuREG',
                                                  fontSize: height * 0.031,
                                                  color:
                                                      const Color(0xFFE7E7E7),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          UserEventList[index]["gender"] !=
                                                  'All Gender'
                                              ? DecoratedIcon(
                                                  icon: Icon(
                                                    UserEventList[index]
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
                                                      color: UserEventList[
                                                                      index]
                                                                  ["gender"] ==
                                                              'Male'
                                                          ? const Color
                                                                  .fromARGB(255,
                                                                  145, 215, 253)
                                                              .withOpacity(0.8)
                                                          : const Color
                                                                  .fromARGB(255,
                                                                  255, 162, 193)
                                                              .withOpacity(0.8),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                          PopupMenuButton<String>(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7))),
                                            position: PopupMenuPosition.under,
                                            onSelected: (String result) {
                                              if (result == "Delete")
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Center(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 1,
                                                                    top: 2),
                                                            child: Text(
                                                              "Are you sure you want to delete this event?",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      height *
                                                                          0.024,
                                                                  color: Color(
                                                                      0xFF2C2C2C),
                                                                  fontFamily:
                                                                      'UbuntuREG'),
                                                            )),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        TextButton(
                                                            onPressed: () {
                                                              deleteItem(
                                                                  UserEventList[
                                                                          index]
                                                                      .id);
                                                              UserEventList
                                                                  .removeAt(
                                                                      index);
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "yes",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ))
                                                      ],
                                                    );
                                                  },
                                                );
                                              else if (result == "Edit")
                                                Navigator.pushReplacement<void,
                                                        void>(
                                                    context,
                                                    PageTransition(
                                                        child: CreateEvent(
                                                            UserEventList[index]
                                                                .id,
                                                            UserEventList[index]
                                                                ["location"],
                                                            UserEventList[index]
                                                                [
                                                                "locationLink"],
                                                            UserEventList[index]
                                                                ["desc"],
                                                            UserEventList[index]
                                                                ["gender"],
                                                            UserEventList[index]
                                                                ["image"],
                                                            UserEventList[index]
                                                                ["limit"],
                                                            UserEventList[index]
                                                                ["title"],
                                                            UserEventList[index]
                                                                ["last time"],
                                                            UserEventList[index]
                                                                ["first time"],
                                                            UserEventList[index]
                                                                ["first date"],
                                                            UserEventList[index]
                                                                ["last date"]),
                                                        type: PageTransitionType
                                                            .fade));
                                            },
                                            surfaceTintColor: Colors.white,
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                height: height * 0.04,
                                                value: 'Delete',
                                                child: Text('Delete'),
                                              ),
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
                                            ), // The icon to display for the menu button (Icon person)
                                          ),
                                        ],
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
                                        padding: const EdgeInsets.only(left: 5),
                                        width: width * 0.85,
                                        child: Text(
                                          "${UserEventList[index]["desc"]}",
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
                              padding: const EdgeInsets.fromLTRB(
                                  7, 0, 0, 10), ////////////fffffffffffffffffff
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
                                              "${UserEventList[index]["first date"]}" ==
                                                      "${UserEventList[index]["last date"]}"
                                                  ? "${UserEventList[index]["first date"]}"
                                                  : "${UserEventList[index]["first date"]}-${UserEventList[index]["last date"]} ",
                                              style: txtstyle),
                                        ),
                                      ]),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(children: [
                                          Icon(Icons.access_time,
                                              color: const Color(0xFFE7E7E7),
                                              size: height * 0.020),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3),
                                            child: Text(
                                                "${UserEventList[index]["first time"]}" +
                                                    " - " +
                                                    "${UserEventList[index]["last time"]}",
                                                style: txtstyle),
                                          ),
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Container(
                                          height: height * 0.032,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(7)),
                                            gradient: LinearGradient(colors: [
                                              const Color(0xFFD4145A)
                                                  .withOpacity(0.45),
                                              const Color(0xFFFBB03B)
                                                  .withOpacity(0.45)
                                            ]),
                                          ),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.location_on_outlined,
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
                                                              Uri.parse(
                                                                  UserEventList[
                                                                          index]
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
                                                          '${UserEventList[index]["location"]}'
                                                                      .length >
                                                                  9
                                                              ? FilterLocationString(
                                                                  '${UserEventList[index]["location"]}')
                                                              : '${UserEventList[index]["location"]}',
                                                          style:
                                                              txtstyle.copyWith(
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
                                        const EdgeInsets.only(right: 7, top: 0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(7)),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 4, sigmaY: 4),
                                            child: Container(
                                              width: width * 0.14,
                                              height: height * 0.032,
                                              color: Colors.white
                                                  .withOpacity(0.40),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${countList.length != 0 ? countList[index] : 0}/${UserEventList[index]["limit"]}',
                                          style: TextStyle(
                                              color: const Color(0xFFDEDEDE),
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
              itemCount: UserEventList.length,
            ),
    );
  }
}

class CreateEvent extends StatefulWidget {
  var address;
  String link;
  var DocId;
  var desc;
  var gender;
  var imagename;
  var limittime;
  var title;
  var last_time;
  var first_time;
  var first_date;
  var last_date;

  CreateEvent(
      this.DocId,
      this.address,
      this.link,
      this.desc,
      this.gender,
      this.imagename,
      this.limittime,
      this.title,
      this.last_time,
      this.first_time,
      this.first_date,
      this.last_date);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  bool showerrorDateorTime = false;
  DateTime _selectedEndDate = DateTime.now();
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  var UserId;

  @override
  void initState() {
    Prefs.getString("Id").then(
      (value) {
        UserId = value;
      },
    );
    super.initState();
    if (widget.DocId != "") {
      DesTextEditingController.text = widget.desc;
      selectedValueofGender = widget.gender.toString();
      TitleTextEditingController.text = widget.title;
      LimitTextEditingController.text = widget.limittime;
      Imagename = widget.imagename;
      selectedValueofActivity = widget.imagename == "Images/Football.png"
          ? "Football"
          : widget.imagename == "Images/basketball.png"
              ? "Basketball"
              : widget.imagename == "Images/basketball.png"
                  ? "Basketball"
                  : widget.imagename == "Images/Cyling.jpg"
                      ? "Cyling"
                      : widget.imagename == "Images/running.jpg"
                          ? "running"
                          : widget.imagename == "Images/hiking.png"
                              ? "Hiking"
                              : "not work";
      Address = widget.address;
      _selectedStartTime = TimeOfDay(
          hour: int.parse(widget.first_time.toString().split(":")[0].length == 1
              ? widget.first_time.toString().substring(0, 1)
              : widget.first_time.toString().substring(0, 2)),
          minute: int.parse(
              widget.first_time.toString().split(":")[0].length == 1
                  ? widget.first_time.toString().substring(2, 4)
                  : widget.first_time.toString().substring(3, 5)));
      _selectedEndTime = TimeOfDay(
          hour: int.parse(widget.last_time.toString().split(":")[0].length == 1
              ? widget.last_time.toString().substring(0, 1)
              : widget.last_time.toString().substring(0, 2)),
          minute: int.parse(
              widget.last_time.toString().split(":")[0].length == 1
                  ? widget.last_time.toString().substring(2, 4)
                  : widget.last_time.toString().substring(3, 5)));
      _selectedStartDate = DateTime(
          DateTime.now().year,
          1 +
              months.lastIndexWhere((element) =>
                  element == widget.first_date.toString().split(" ")[0]),
          int.parse(widget.first_date.toString().substring(
              widget.first_date.toString().split(" ")[0].length + 1,
              widget.first_date.toString().length)));
      _selectedEndDate = DateTime(
          DateTime.now().year,
          1 +
              months.lastIndexWhere((element) =>
                  element == widget.last_date.toString().split(" ")[0]),
          int.parse(widget.last_date.toString().substring(
              widget.last_date.toString().split(" ")[0].length + 1,
              widget.last_date.toString().length)));
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: widget.DocId != ""
          ? _selectedEndDate
          : DateTime.now().subtract(Duration(hours: 1)),
      lastDate: DateTime(_selectedEndDate.year + 100),
      helpText: 'Select a date',
      cancelText: 'Cancel',
      confirmText: 'Done',
      errorFormatText: 'Invalid date format',
      errorInvalidText: 'Invalid date',
      fieldLabelText: 'Date',
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

    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        setState(() {
          showerrorDateorTime = false;

          if (validateTime(_selectedStartTime, _selectedEndTime,
              _selectedStartDate, _selectedEndDate)) {
            showerrorDateorTime = true;
          }
        });
      });
    }
  }

  DateTime _selectedStartDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: widget.DocId != ""
          ? _selectedStartDate
          : DateTime.now().subtract(Duration(hours: 1)),
      lastDate: DateTime(_selectedStartDate.year + 100),
      helpText: 'Select a date',
      cancelText: 'Cancel',
      confirmText: 'Done',
      errorFormatText: 'Invalid date format',
      errorInvalidText: 'Invalid date',
      fieldLabelText: 'Date',
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

    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
    showerrorDateorTime = false;
    if (validateTime(_selectedStartTime, _selectedEndTime, _selectedStartDate,
        _selectedEndDate)) {
      showerrorDateorTime = true;
    }
  }

  bool showerrorStartTime = false;
  bool showerrorEndTime = false;

  TimeOfDay _selectedEndTime = TimeOfDay.now();

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
      setState(() {
        _selectedEndTime = picked;
      });
    }
    showerrorDateorTime = false;

    if (validateTime(_selectedStartTime, _selectedEndTime, _selectedStartDate,
        _selectedEndDate)) {
      showerrorDateorTime = true;
    }
  }

  TimeOfDay _selectedStartTime = TimeOfDay.now();

  // Function to show the time picker
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
      setState(() {
        _selectedStartTime = picked;
      });
    }
    showerrorDateorTime = false;

    if (validateTime(_selectedStartTime, _selectedEndTime, _selectedStartDate,
        _selectedEndDate)) {
      showerrorDateorTime = true;
    }
  }

  TextEditingController DesTextEditingController = TextEditingController();
  TextEditingController LimitTextEditingController = TextEditingController();

  TextEditingController TitleTextEditingController = TextEditingController();
  bool IsClickActivity = false;
  bool IsClickGender = false;
  String? Firstdate;
  bool showErrortitle = false;
  bool showErrorDesc = false;

  final List<String> ActivityItems = [
    "Football",
    "Basketball",
    "Cyling",
    "running",
    "Hiking"
  ];

  bool validateNull(String value) {
    if (value.length == 0 || value.length > 15) {
      return true;
    }
    return false;
  }

  bool validateDesc(String value) {
    if (value.length < 40 || value.length > 70) {
      return true;
    }

    return false;
  }

  PageController pc = PageController();
  int index = 0;
  bool islocation = true;
  String Address = "";
  var specId;
  String link = "";

  var lat = 31.68220522116382;
  var long = 36.31571848199336;
  String Imagename = "";
  bool activityVal = false;
  bool LimitError = false;
  bool GenderVal = false;
  String selectedValueofActivity = '';
  final List<String> genderItems = ['Male', 'Female', 'All Gender'];

  String selectedValueofGender = '';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: widget.DocId != ""
          ? AppBar(
              backgroundColor: Colors.white,
              title: Center(
                  child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "Edit Events",
                  style: TextStyle(fontSize: height * 0.03),
                ),
              )),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.DocId != "") {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: MyEvents("1", ""),
                              type: PageTransitionType.fade));
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: height * 0.04,
                  )),
            )
          : AppBar(toolbarHeight: 0),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          if (widget.DocId != "") {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: MyEvents("1", ""), type: PageTransitionType.fade));
          }
          return Future.value(false);
        },
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pc,
          onPageChanged: (value) {
            index = value;
            if (!mounted) return;
            setState(() {});
          },
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: widget.DocId != "" ? height * 0.13 : height * 0.02),
              child: Container(
                width: width,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: height * 0.01),
                      width: width * 0.84,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: height * 0.062,
                                child: TextField(
                                  cursorColor: const Color(0xFF2C2C2C),
                                  onChanged: (value) {
                                    setState(() {
                                      showErrortitle = false;
                                      if (validateNull(
                                          TitleTextEditingController.text)) {
                                        showErrortitle = true;
                                      }
                                    });
                                  },
                                  controller: TitleTextEditingController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    label: const Text("Title"),
                                    labelStyle: TextStyle(
                                        color: const Color(0xFF2C2C2C),
                                        fontSize: height * 0.019),
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 119, 119, 119),
                                          width: 0.9,
                                        )),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 1.0,
                                      ),

                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              7.0)), // Sets border radius
                                    ),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, top: 2, bottom: 4),
                                child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 120),
                                    opacity: showErrortitle ? 1 : 0,
                                    child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Enter a title",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(7)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2)),
                                    ]),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text("Start time",
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 70, 70, 70),
                                                fontFamily: 'UbuntuREG',
                                                fontSize: height * 0.018,
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: InkWell(
                                                    onTap: () {
                                                      _selectStartDate(context);
                                                    },
                                                    child: Align(
                                                      child: Text(
                                                        "${_formatDate(_selectedStartDate)}",
                                                        style: TextStyle(
                                                          fontSize:
                                                              height * 0.018,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    _selectStartTime(context);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          ('${_selectedStartTime.hourOfPeriod}:${_selectedStartTime.minute.toString().padLeft(2, '0')} ${_selectedStartTime.period.index == 0 ? 'AM' : 'PM'}'),
                                                          style: TextStyle(
                                                            fontSize:
                                                                height * 0.018,
                                                          )),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                        size: height * 0.02,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text("End time",
                                                style: TextStyle(
                                                    fontSize: height * 0.018,
                                                    color: const Color.fromARGB(
                                                        255, 70, 70, 70),
                                                    fontFamily: 'UbuntuREG')),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      _selectEndDate(context);
                                                    },
                                                    child: Text(
                                                      "${_formatDate(_selectedEndDate)}",
                                                      style: TextStyle(
                                                        fontSize:
                                                            height * 0.018,
                                                      ),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: InkWell(
                                                    onTap: () {
                                                      _selectEndTime(context);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            ('${_selectedEndTime.hourOfPeriod}:${_selectedEndTime.minute.toString().padLeft(2, '0')} ${_selectedEndTime.period.index == 0 ? 'AM' : 'PM'}'),
                                                            style: TextStyle(
                                                              fontSize: height *
                                                                  0.018,
                                                            )),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_outlined,
                                                          size: height * 0.02,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ])
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2, top: 2, bottom: 4),
                                  child: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 120),
                                      opacity: showerrorDateorTime ? 1 : 0,
                                      child: const Text(
                                        "Error in time or Date",
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (!mounted) return;
                                  setState(() {
                                    index = 1;
                                    pc.animateToPage(index,
                                        duration:
                                            const Duration(milliseconds: 350),
                                        curve: Curves.easeInOutCubic);
                                  });
                                },
                                child: Container(
                                  height: height * 0.062,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.9,
                                        color: const Color.fromARGB(
                                            255, 119, 119, 119),
                                      ),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: height * 0.024,
                                              color: const Color(0xFF2C2C2C),
                                            ),
                                            Text(
                                              "Location",
                                              style: TextStyle(
                                                  fontSize: height * 0.019,
                                                  color:
                                                      const Color(0xFF2C2C2C)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: InkWell(
                                            child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: height * 0.02,
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2, top: 2, bottom: 15),
                                  child: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 120),
                                      opacity: 1,
                                      child: islocation == false &&
                                              Address == ""
                                          ? const Text(
                                              "Choose a location",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : Text(
                                              maxLines: 1,
                                              "${Address}",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )),
                                ),
                              ),
                              Container(
                                height: height * 0.062,
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      LimitError = false;
                                      if (int.tryParse(
                                                  LimitTextEditingController
                                                      .text) ==
                                              null ||
                                          LimitTextEditingController
                                                  .text.length >
                                              3) {
                                        LimitError = true;
                                      }
                                    });
                                  },
                                  controller: LimitTextEditingController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7)),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        // Sets the border color when focused
                                        width:
                                            1.0, // Sets the border width when focused
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              7.0)), // Sets border radius
                                    ),
                                    labelStyle: TextStyle(
                                        color: const Color(0xFF2C2C2C),
                                        fontSize: height * 0.019),
                                    labelText: "Attendee limit",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, top: 2, bottom: 4),
                                child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 120),
                                    opacity: LimitError ? 1 : 0,
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Enter a limit",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: width * 0.5,
                                  height: height * 0.062,
                                  child: Center(
                                    child: DropdownButtonFormField2<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.deepOrangeAccent,
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
                                              BorderRadius.circular(7),
                                        ),
                                        // Add more decoration..
                                      ),
                                      hint: Text(
                                        selectedValueofActivity == ''
                                            ? 'Activity'
                                            : selectedValueofActivity
                                                .toString(),
                                        style: TextStyle(
                                            color: const Color(0xFF2C2C2C),
                                            fontSize: height * 0.019),
                                      ),
                                      items: ActivityItems.map(
                                          (item) => DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )).toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'select an Activity';
                                        }
                                        return null;
                                      },
                                      onMenuStateChange: (isOpen) {
                                        setState(() {
                                          isOpen == true
                                              ? IsClickActivity = true
                                              : IsClickActivity = false;
                                        });
                                      },
                                      onChanged: (value) {
                                        selectedValueofActivity =
                                            value.toString();
                                        if (selectedValueofActivity ==
                                            "Football") {
                                          Imagename = "Images/Football.png";
                                        }
                                        if (selectedValueofActivity ==
                                            "Basketball") {
                                          Imagename = "Images/basketball.png";
                                        }
                                        if (selectedValueofActivity ==
                                            "Cyling") {
                                          Imagename = "Images/Cyling.jpg";
                                        }
                                        if (selectedValueofActivity ==
                                            "running") {
                                          Imagename = "Images/running.jpg";
                                        }
                                        if (selectedValueofActivity ==
                                            "Hiking") {
                                          Imagename = "Images/hiking.png";
                                        }
                                        activityVal = false;
                                      },
                                      onSaved: (value) {
                                        selectedValueofActivity =
                                            value.toString();
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.only(right: 8),
                                      ),
                                      iconStyleData: IconStyleData(
                                          icon: AnimatedRotation(
                                        turns:
                                            IsClickActivity == false ? 0 : 0.5,
                                        duration:
                                            const Duration(milliseconds: 120),
                                        child: const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 24),
                                      )),
                                      dropdownStyleData: DropdownStyleData(
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(inset: true)
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
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, top: 2, bottom: 4),
                                child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 120),
                                    opacity: activityVal ? 1 : 0,
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Please choose a Activity",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: width * 0.5,
                                  height: height * 0.062,
                                  child: Center(
                                    child: DropdownButtonFormField2<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.deepOrangeAccent,
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
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                      hint: Text(
                                        selectedValueofGender == ''
                                            ? 'Gender'
                                            : selectedValueofGender.toString(),
                                        style: TextStyle(
                                            color: const Color(0xFF2C2C2C),
                                            fontSize: height * 0.019),
                                      ),
                                      items: genderItems
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select gender.';
                                        }
                                        return null;
                                      },
                                      onMenuStateChange: (isOpen) {
                                        setState(() {
                                          isOpen == true
                                              ? IsClickGender = true
                                              : IsClickGender = false;
                                        });
                                      },
                                      onChanged: (value) {
                                        GenderVal = false;
                                        selectedValueofGender =
                                            value.toString();
                                      },
                                      onSaved: (value) {
                                        selectedValueofGender =
                                            value.toString();
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.only(right: 8),
                                      ),
                                      iconStyleData: IconStyleData(
                                          icon: AnimatedRotation(
                                        turns: IsClickGender == false ? 0 : 0.5,
                                        duration:
                                            const Duration(milliseconds: 120),
                                        child: const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 24),
                                      )),
                                      dropdownStyleData: DropdownStyleData(
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(inset: true)
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
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, top: 2, bottom: 4),
                                child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 120),
                                    opacity: GenderVal ? 1 : 0,
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Please choose a Gender",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    showErrorDesc = false;

                                    if (validateDesc(
                                        DesTextEditingController.text)) {
                                      showErrorDesc = true;
                                    }
                                  });
                                },
                                maxLines: 3,
                                minLines: 1,
                                controller: DesTextEditingController,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: "Description",
                                  label: const Text("Description"),
                                  labelStyle: TextStyle(
                                      color: const Color(0xFF2C2C2C),
                                      fontSize: height * 0.019),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            7.0)), // Sets border radius
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 2, top: 2, bottom: height * 0.05),
                                child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 120),
                                    opacity: showErrorDesc ? 1 : 0,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: width * 0.8,
                                          child: const Text(
                                            "must be more than 40 and less than 70 letter",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height * 0.03),
                            child: Container(
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
                                        inset: true,
                                        offset: Offset(0, 1))
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(350))),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    LimitError = false;
                                    showErrorDesc = false;
                                    showErrortitle = false;
                                    activityVal = false;
                                    GenderVal = false;
                                    showerrorDateorTime = false;
                                  });
                                  if (int.tryParse(LimitTextEditingController
                                              .text) ==
                                          null ||
                                      LimitTextEditingController.text.length >
                                          3) {
                                    LimitError = true;
                                  }
                                  if (validateTime(
                                      _selectedStartTime,
                                      _selectedEndTime,
                                      _selectedStartDate,
                                      _selectedEndDate)) {
                                    showerrorDateorTime = true;
                                  }
                                  if (selectedValueofActivity == '') {
                                    activityVal = true;
                                  }
                                  if (selectedValueofGender == '') {
                                    GenderVal = true;
                                  }
                                  if (validateNull(
                                      TitleTextEditingController.text)) {
                                    showErrortitle = true;
                                  }
                                  if (validateDesc(
                                      DesTextEditingController.text)) {
                                    showErrorDesc = true;
                                  }
                                  if (LimitError == false &&
                                      showErrortitle == false &&
                                      showerrorDateorTime == false &&
                                      showErrorDesc == false &&
                                      GenderVal == false &&
                                      activityVal == false &&
                                      Address != "") {
                                    setState(() {});
                                    try {
                                      if (widget.DocId != "") {
                                        await FirebaseFirestore.instance
                                            .collection("Events")
                                            .doc("E4AoboJAGVZzQtD8VuLB")
                                            .collection("UserEvent")
                                            .doc(widget.DocId.toString())
                                            .update({
                                          "user id": UserId,
                                          "desc": DesTextEditingController.text,
                                          "first date": _getMonthName(
                                                  _selectedStartDate.month) +
                                              " " +
                                              _selectedStartDate.day.toString(),
                                          "first time": _selectedStartTime
                                              .format(context),
                                          "gender":
                                              selectedValueofGender.toString(),
                                          "image": Imagename.toString(),
                                          "last date": _getMonthName(
                                                  _selectedEndDate.month) +
                                              " " +
                                              _selectedEndDate.day.toString(),
                                          "last time":
                                              _selectedEndTime.format(context),
                                          "limit":
                                              LimitTextEditingController.text,
                                          "location": Address,
                                          "locationLink": link,
                                          "title":
                                              TitleTextEditingController.text
                                        });
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection("Events")
                                            .doc("E4AoboJAGVZzQtD8VuLB")
                                            .collection("UserEvent")
                                            .add({
                                          "user id": UserId,
                                          "desc": DesTextEditingController.text,
                                          "first date": _getMonthName(
                                                  _selectedStartDate.month) +
                                              " " +
                                              _selectedStartDate.day.toString(),
                                          "first time": _selectedStartTime
                                              .format(context),
                                          "gender":
                                              selectedValueofGender.toString(),
                                          "image": Imagename.toString(),
                                          "last date": _getMonthName(
                                                  _selectedEndDate.month) +
                                              " " +
                                              _selectedEndDate.day.toString(),
                                          "last time":
                                              _selectedEndTime.format(context),
                                          "limit":
                                              LimitTextEditingController.text,
                                          "location": Address,
                                          "locationLink": link,
                                          "title":
                                              TitleTextEditingController.text
                                        });
                                      }
                                      // ignore: use_build_context_synchronously
                                      if (widget.DocId != "") {
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: MyEvents("1", ""),
                                                type: PageTransitionType.fade));
                                      } else
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child:
                                                    MainScreenUser("eventpage"),
                                                type: PageTransitionType.fade));
                                    } catch (e) {}
                                  } else {
                                    print("ssss");
                                    // print(_selectedStartTime.toString());
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  // ignore: sort_child_properties_last
                                  child: ShaderMask(
                                    child: Text(
                                      'Create',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: height * 0.024,
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
                ),
              ),
            ),
            Center(
              child: OpenStreetMapSearchAndPick(

                  // latitude! ,   longitude! to get your current location displayed on the map
                  center: LatLong(lat, long),
                  currentLocationIcon: Icons.my_location,
                  zoomInIcon: Icons.zoom_in_map,
                  zoomOutIcon: Icons.zoom_out_map,
                  buttonColor: Colors.deepOrange.shade800,
                  buttonText: 'Set Current Location',
                  buttonTextColor: Colors.white,
                  locationPinIconColor: Colors.black,
                  locationPinTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  onPicked: (pickedData) {
                    setState(() {
                      lat = pickedData.latLong.latitude;
                      long = pickedData.latLong.longitude;
                      link = "http://www.google.com/maps/place/$lat,$long";
                      Address = pickedData.addressName;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Container(
                              width: width * 0.8,
                              child: const Text("Select this Location?"),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "No",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    if (!mounted) return;
                                    setState(() {
                                      Navigator.pop(context);

                                      index = 0;
                                      pc.animateToPage(index,
                                          duration:
                                              const Duration(milliseconds: 350),
                                          curve: Curves.easeInOutCubic);
                                    });
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.black),
                                  ))
                            ],
                          );
                        },
                      );
                    });

                    // print(pickedData.latLong.latitude);
                    // print(pickedData.latLong.longitude);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool validateTime(TimeOfDay s, TimeOfDay e, DateTime Ds, DateTime De) {
    if (Ds.day == De.day) {
      if (s.period.index == e.period.index) {
        if (s.hour.toInt() == e.hour.toInt() || s.hour.toInt() > e.hour.toInt())
          return true;
      }
      if (s.period.index == 1 && e.period.index == 0) {
        return true;
      }
    }

    if (Ds.month > De.month || Ds.day > De.day) {
      return true;
    }

    return false;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    return months[month - 1];
  }
}
