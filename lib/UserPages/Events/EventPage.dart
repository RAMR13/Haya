import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/Events/CreateEvent.dart';
import 'package:hayaproject/UserPages/MorePage/screen1.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class eventpage extends StatefulWidget {
  const eventpage({Key? key}) : super(key: key);

  @override
  State<eventpage> createState() => _testState();
}

class _testState extends State<eventpage> with SingleTickerProviderStateMixin {
  bool shouldPop = true;
  List Users = [];
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    await Prefs.getString("Id").then(
      (value) async {
        QuerySnapshot qs0 = await FirebaseFirestore.instance
            .collection("users")
            .where('User_id', isEqualTo: await value)
            .get();
        Users.addAll(qs0.docs);
      },
    );
    if (!mounted) return;
    setState(() {});
  }

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
                  child: MainScreenUser(""), type: PageTransitionType.fade));
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
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement<void, void>(
                                context,
                                PageTransition(
                                    child: Screen1("eventpage"),
                                    type: PageTransitionType.fade));
                          },
                          child: Users.isNotEmpty
                              ? Container(
                                  height: height * 0.034,
                                  width: height * 0.034,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(Users[0]['images']),
                                        fit: BoxFit.cover),
                                  ))
                              : Icon(
                                  MyFlutterApp.profile,
                                  color: Color(0xFF2C2C2C),
                                  size: height * 0.032,
                                ),
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
                  child: TabBarView(children: [
                    UserEvent(),
                    ExpertEvent(),
                  ]),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 3),
                    height: height * 0.055,
                    //43,
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

class expanded {
  bool isExpanded;
  bool isjoined;

  expanded(this.isExpanded, this.isjoined);
}

class UserEvent extends StatefulWidget {
  UserEvent();

  @override
  State<UserEvent> createState() => _UserEventState();
}

class _UserEventState extends State<UserEvent> {
  late StreamSubscription _subscription;
  List<DocumentSnapshot> AdminImage = [];
  List<expanded> isExpanded = [];
  List<int> num = [];
  List<Future<void>> futures = [];

  Future<void> getDataImage() async {
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
  List<DocumentSnapshot> UserEventList = [];
  List<int> countList = [];
  var userID;
  var gender;
  List<Future<int>> queryFutures = [];
  List<int> isJoined = [];
  getData() async {
    await Prefs.getString("Id").then(
      (value) {
        userID = value;
      },
    );
    QuerySnapshot qs0 = await FirebaseFirestore.instance
        .collection("users")
        .where('User_id', isEqualTo: userID)
        .get();
    gender = qs0.docs[0]['gender'];

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
      Future<void> future = FirebaseFirestore.instance
          .collection("Events")
          .doc('E4AoboJAGVZzQtD8VuLB')
          .collection("UserEvent")
          .doc(UserEventList[i].id)
          .collection('subscribtion')
          .where('user id', isEqualTo: userID)
          .get()
          .then((QuerySnapshot qs) {
        if (qs.docs.isNotEmpty) {
          isJoined.add(i);
        } else
          isJoined.add(-1);
      });
      futures.add(future);
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

// .where("User_id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  deleteItem(var id) async {
    //////////////////////////////ارجع
    await FirebaseFirestore.instance
        .collection("Events")
        .doc('E4AoboJAGVZzQtD8VuLB')
        .collection("UserEvent")
        .doc(id)
        .collection('subscribtion')
        .where('user id', isEqualTo: userID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  List<DocumentSnapshot> Listss = [];
  int x = 0;

  List ids = [];

  addItem(var id, var userId) async {
    //////////////////////////////ارجع
    await FirebaseFirestore.instance
        .collection("Events")
        .doc('E4AoboJAGVZzQtD8VuLB')
        .collection("UserEvent")
        .doc(id)
        .collection('subscribtion')
        .add({'user id': userId.toString()});
  }

  @override
  void initState() {
    getData();
    startColorChangeLoop();
    getDataImage();
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

  String FilterLocationString(String value) {
    if (value.toString().split(",")[0].length > 20) {
      return "${value.toString().substring(0, 15)}...";
    }
    return value.toString().split(",")[0];
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
  int lock = 1;
  String join = 'Join';
  double FabOpacity = 1;

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
      color: Color(0xFFE7E7E7).withOpacity(0.85),
    );
    List<IconData> Arrowicon = [
      Icons.keyboard_arrow_down,
      Icons.keyboard_arrow_up_outlined
    ];
    return Scaffold(
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
                        child: MyEvents("", ""),
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
                        stops: [
                      0.2,
                      0.75,
                      1
                    ],
                        colors: [
                      const Color(0xFFFFAA5C).withOpacity(0.25),
                      const Color.fromARGB(255, 255, 114, 89).withOpacity(0.5),
                      const Color.fromARGB(255, 255, 60, 0).withOpacity(0.6),
                    ])),
              ),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification.metrics.pixels < height / 20) {
              if (lock == 1)
                setState(() {
                  lock = 0;
                  FabOpacity = 1;
                });
            } else {
              if (lock == 0)
                setState(() {
                  lock = 1;
                  FabOpacity = 0;
                });
            }
            return true;
          },
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 220),
            child: isExpanded.length == 0 ||
                    countList.length == 0 ||
                    UserEventList.length == 0 ||
                    AdminImage.length == 0
                ? ListView.builder(
                    key: ValueKey<int>(0),
                    itemBuilder: (context, index) {
                      if (index == 0)
                        return Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.065,
                                bottom: 3,
                                right: 3.5,
                                left: 3.5),
                            child: Shimmer.fromColors(
                              baseColor: Color.fromARGB(255, 221, 221, 221),
                              highlightColor: Colors.grey.shade200,
                              child: Container(
                                height: height * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                              ),
                            ));
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 3.5),
                        child: Container(
                          height: height * 0.18,
                          width: width,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 221, 221, 221),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 185, 185, 185),
                            highlightColor: Colors.grey.shade200,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 7, top: 7, right: 7),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                          width: height * 0.045,
                                          height: height * 0.04,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
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
                                      padding: EdgeInsets.only(bottom: 7),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                                    EdgeInsets.only(top: 5),
                                                child: Container(
                                                  color: Colors.black,
                                                  width: width * 0.3,
                                                  height: height * 0.02,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Container(
                                                  color: Colors.black,
                                                  width: width * 0.3,
                                                  height: height * 0.02,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
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
                    itemCount: 4,
                  )
                : ListView.builder(
                    key: ValueKey<int>(1),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.065,
                              bottom: 3,
                              right: 3.5,
                              left: 3.5),
                          child: Container(
                            height: height * 0.3,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 4,
                                      offset: Offset(0, 4))
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: AnimatedCrossFade(
                                firstChild: AdminImage[index]["imgtype"] == "as"
                                    ? Image.asset(
                                        AdminImage[1]["image"].toString(),
                                      )
                                    : Image.network(
                                        AdminImage[1]["image"].toString(),
                                      ),
                                secondChild:
                                    AdminImage[index]["imgtype"] == "as"
                                        ? Image.asset(
                                            AdminImage[0]["image"].toString(),
                                          )
                                        : Image.network(
                                            AdminImage[0]["image"].toString(),
                                          ),
                                crossFadeState: isFirst
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                duration: Duration(milliseconds: 400),
                                reverseDuration: Duration(milliseconds: 400),
                              ),
                            ),
                          ),
                        );
                      } else {
                        index = index - 1;
                        return UserEventList[index]['gender'] == gender ||
                                UserEventList[index]['gender'] == 'All Gender'
                            ? InkWell(
                                onTap: () {
                                  if (!mounted) return;
                                  setState(() {
                                    isExpanded[index].isExpanded =
                                        !isExpanded[index].isExpanded;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 3.5),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 120),
                                    width: width,
                                    height: isExpanded[index].isExpanded == true
                                        ? height * 0.23
                                        : height * 0.18,
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
                                              "${UserEventList[index]["image"]}",
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
                                                                "${UserEventList[index]["title"]}",
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
                                                          UserEventList[index][
                                                                      "user id"] ==
                                                                  userID
                                                              ? Padding(
                                                                  padding: EdgeInsets.only(
                                                                      right: UserEventList[index]["gender"] ==
                                                                              'All Gender'
                                                                          ? 0
                                                                          : 3),
                                                                  child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(7)),
                                                                        child:
                                                                            BackdropFilter(
                                                                          filter: ImageFilter.blur(
                                                                              sigmaX: 4,
                                                                              sigmaY: 4),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                width * 0.2,
                                                                            height:
                                                                                height * 0.032,
                                                                            color:
                                                                                Colors.white.withOpacity(0.40),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.all(5),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'Your event',
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFFDEDEDE),
                                                                            fontSize: height *
                                                                                0.017,
                                                                            fontFamily:
                                                                                'UbuntuREG'),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                                          //////////////////Your Event//////////

                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 7),
                                                            child: UserEventList[
                                                                            index]
                                                                        [
                                                                        "gender"] !=
                                                                    'All Gender'
                                                                ? DecoratedIcon(
                                                                    icon: Icon(
                                                                      UserEventList[index]["gender"] ==
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
                                                                            color: UserEventList[index]["gender"] == 'Male'
                                                                                ? Color.fromARGB(255, 145, 215, 253).withOpacity(0.8)
                                                                                : Color.fromARGB(255, 255, 162, 193).withOpacity(0.8))),
                                                                  )
                                                                : Container(),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4, 0, 0, 0),
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    width: isExpanded[index]
                                                            .isExpanded
                                                        ? width * 0.85
                                                        : width * 0.7,
                                                    child: AnimatedCrossFade(
                                                      crossFadeState:
                                                          isExpanded[index]
                                                                  .isExpanded
                                                              ? CrossFadeState
                                                                  .showFirst
                                                              : CrossFadeState
                                                                  .showSecond,
                                                      duration: Duration(
                                                          milliseconds: 120),
                                                      firstChild: Text(
                                                          "${UserEventList[index]["desc"]}",
                                                          maxLines: 5,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              txtstyle.copyWith(
                                                            fontSize:
                                                                height * 0.017,
                                                          )),
                                                      secondChild: Text(
                                                          "${UserEventList[index]["desc"]}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              txtstyle.copyWith(
                                                            fontSize:
                                                                height * 0.017,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            AnimatedPadding(
                                              duration:
                                                  Duration(milliseconds: 120),
                                              padding: EdgeInsets.fromLTRB(
                                                  7,
                                                  0,
                                                  0,
                                                  isExpanded[index].isExpanded
                                                      ? 20
                                                      : 4),
                                              ////////////fffffffffffffffffff
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Column(
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
                                                              "${UserEventList[index]["first date"]}" ==
                                                                      "${UserEventList[index]["last date"]}"
                                                                  ? "${UserEventList[index]["first date"]}"
                                                                  : "${UserEventList[index]["first date"]}-${UserEventList[index]["last date"]} ",
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
                                                                "${UserEventList[index]["first time"]}" +
                                                                    " - " +
                                                                    "${UserEventList[index]["last time"]}",
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
                                                                          if (!await launchUrl(Uri.parse(UserEventList[index]
                                                                              [
                                                                              "locationLink"]))) {
                                                                            throw Exception('Could not launch the link');
                                                                          }
                                                                        }

                                                                        _launchUrl();
                                                                      },
                                                                      child: Text(
                                                                          maxLines:
                                                                              1,
                                                                          '${UserEventList[index]["location"]}'.length > 9
                                                                              ? FilterLocationString(
                                                                                  '${UserEventList[index]["location"]}')
                                                                              : '${UserEventList[index]["location"]}',
                                                                          style:
                                                                              txtstyle.copyWith(color: Colors.white)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      ),
                                                    ], //
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 7, top: 0),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          7)),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter
                                                                .blur(
                                                                    sigmaX: 4,
                                                                    sigmaY: 4),
                                                            child: Container(
                                                              width:
                                                                  width * 0.14,
                                                              height: height *
                                                                  0.032,
                                                              color: Colors
                                                                  .white
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
                                                          '${countList[index]}/${UserEventList[index]["limit"]}',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFDEDEDE),
                                                              fontSize: height *
                                                                  0.016,
                                                              fontFamily:
                                                                  'UbuntuREG'),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            UserEventList[index]["user id"] !=
                                                    userID
                                                ? IgnorePointer(
                                                    ignoring: isExpanded[index]
                                                            .isExpanded
                                                        ? false
                                                        : true,
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (!mounted) return;
                                                        setState(() {
                                                          isExpanded[index]
                                                                  .isjoined =
                                                              !isExpanded[index]
                                                                  .isjoined;
                                                          !(isExpanded[index]
                                                                  .isjoined)
                                                              ? deleteItem(
                                                                  '${UserEventList[index].id}')
                                                              : addItem(
                                                                  '${UserEventList[index].id}',
                                                                  userID);
                                                        });
                                                      },
                                                      child: AnimatedOpacity(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    120),
                                                        opacity: isExpanded[
                                                                        index]
                                                                    .isExpanded ==
                                                                true
                                                            ? 1
                                                            : 0,
                                                        child:
                                                            AnimatedContainer(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            120),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: isExpanded[index].isjoined
                                                                              ? activated
                                                                              : notActivated,
                                                                          stops: [
                                                                            0.2,
                                                                            0.7,
                                                                            1
                                                                          ],
                                                                          begin:
                                                                              Alignment.topCenter,
                                                                          end: Alignment
                                                                              .bottomCenter,
                                                                        ),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                              blurRadius: 40,
                                                                              spreadRadius: 3)
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                30)),
                                                                width: width *
                                                                    0.18,
                                                                height: height *
                                                                    0.035,
                                                                child: Center(
                                                                    child: Text(
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w300,
                                                                      shadows: [
                                                                        Shadow(
                                                                            color: Colors.black.withOpacity(
                                                                                0.3),
                                                                            blurRadius:
                                                                                4,
                                                                            offset:
                                                                                const Offset(0, 3))
                                                                      ],
                                                                      color: const Color(0xFFE7E7E7),
                                                                      fontSize: height * 0.016),
                                                                  isExpanded[index]
                                                                          .isjoined
                                                                      ? 'Joined'
                                                                      : 'Join',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                ))),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            AnimatedRotation(
                                              turns:
                                                  isExpanded[index].isExpanded
                                                      ? 0
                                                      : 0.5,
                                              duration: const Duration(
                                                  milliseconds: 120),
                                              child: Icon(
                                                size: height * 0.03,
                                                Arrowicon.last,
                                                color: const Color(0xFFE7E7E7),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      }
                    },
                    itemCount: UserEventList.length + 1,
                  ),
          ),
        ),
      ),
    );
  }
}

class ExpertEvent extends StatefulWidget {
  const ExpertEvent();

  @override
  State<ExpertEvent> createState() => _ExpertEventState();
}

class _ExpertEventState extends State<ExpertEvent> {
  List<expanded> isExpanded = [];
  List<DocumentSnapshot> UserEventList = [];
  List<DocumentSnapshot> mySpec = [];
  List<DocumentSnapshot> Users = [];
  List<int> countList = [];
  List<Future<int>> queryFutures = [];
  List<int> isJoined = [];
  List<Future<void>> futures = [];
  var userID;
  var gender;
  var UserId;
  MyData() async {
    await Prefs.getString("Id").then(
      (value) {
        UserId = value;
      },
    );
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: UserId)
        // .where("User_id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    Users.addAll(qs.docs);
    await mySpecialist();
    if (!mounted) return;
    setState(() {
      print(
          Users.length.toString() + "dddssssssssssssssssssssssssssssssssssss");
    });
  }

  mySpecialist() async {
    if (Users.length > 0) {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection("users")
          .doc(Users[0].id)
          .collection("my specialist")
          .get();

      mySpec.addAll(qs.docs);
      if (!mounted) return;
      setState(() {
        //   print(mySpec[0]["Specialist ID"] + "sssssssssssssssssssssssss");
        print(mySpec.length.toString() + "sdsssssssssssssssssssss");
      });
    }
  }

  getData() async {
    await Prefs.getString("Id").then(
      (value) {
        userID = value;
      },
    );
    QuerySnapshot qs0 = await FirebaseFirestore.instance
        .collection("users")
        .where('User_id', isEqualTo: userID)
        .get();
    gender = qs0.docs[0]['gender'];
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
      Future<void> future = FirebaseFirestore.instance
          .collection("Events")
          .doc('E4AoboJAGVZzQtD8VuLB')
          .collection("ExpetEvent")
          .doc(UserEventList[i].id)
          .collection('subscribtion')
          .where('user id', isEqualTo: userID)
          .get()
          .then((QuerySnapshot qs) {
        if (qs.docs.isNotEmpty) {
          isJoined.add(i);
        } else
          isJoined.add(-1);
      });
      futures.add(future);
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

  List<int> num = [];

// .where("User_id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  deleteItem(var id) async {
    //////////////////////////////ارجع
    await FirebaseFirestore.instance
        .collection("Events")
        .doc('E4AoboJAGVZzQtD8VuLB')
        .collection("ExpetEvent")
        .doc(id)
        .collection('subscribtion')
        .where('user id', isEqualTo: userID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  List<DocumentSnapshot> Listss = [];
  int x = 0;
  List<int> counts = [];

  addItem(var id, var userId) async {
    //////////////////////////////ارجع
    await FirebaseFirestore.instance
        .collection("Events")
        .doc('E4AoboJAGVZzQtD8VuLB')
        .collection("ExpetEvent")
        .doc(id)
        .collection('subscribtion')
        .add({'user id': userId.toString()});
  }

  @override
  void initState() {
    getData();
    MyData();
    super.initState();
  }

  bool isFirst = true;

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
  int lock = 1;
  String join = 'Join';
  double FabOpacity = 1;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    TextStyle txtstyle = TextStyle(
      letterSpacing: -0.28,
      fontSize: height * 0.0156,
      fontWeight: FontWeight.normal,
      fontFamily: 'UbuntuREG',
      color: Color(0xFFE7E7E7).withOpacity(0.85),
    );
    List<IconData> Arrowicon = [
      Icons.keyboard_arrow_down,
      Icons.keyboard_arrow_up_outlined
    ];
    return Scaffold(
      body: Container(
        height: height,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification.metrics.pixels < height / 2) {
                if (lock == 1)
                  setState(() {
                    lock = 0;
                    FabOpacity = 1;
                  });
              } else {
                if (lock == 0)
                  setState(() {
                    lock = 1;
                    FabOpacity = 0;
                  });
              }
              return true;
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 220),
              child:
                  isExpanded.length == 0 ||
                          countList.length == 0 ||
                          UserEventList.length == 0 ||
                          mySpec.length == 0
                      ? ListView.builder(
                          key: ValueKey<int>(0),
                          itemBuilder: (context, index) {
                            if (index == 0)
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.065,
                                    bottom: 3,
                                    right: 3.5,
                                    left: 3.5),
                                child: Container(
                                  height: height * 0.18,
                                  width: width,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 221, 221, 221),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 185, 185, 185),
                                    highlightColor: Colors.grey.shade200,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 7, top: 7, right: 7),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black,
                                                  ),
                                                  width: height * 0.045,
                                                  height: height * 0.04,
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
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
                                              padding:
                                                  EdgeInsets.only(bottom: 7),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        color: Colors.black,
                                                        width: width * 0.3,
                                                        height: height * 0.02,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Container(
                                                          color: Colors.black,
                                                          width: width * 0.3,
                                                          height: height * 0.02,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Container(
                                                          color: Colors.black,
                                                          width: width * 0.3,
                                                          height: height * 0.02,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 5),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 3.5),
                              child: Container(
                                height: height * 0.18,
                                width: width,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 221, 221, 221),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 185, 185, 185),
                                  highlightColor: Colors.grey.shade200,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 7, top: 7, right: 7),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black,
                                                ),
                                                width: height * 0.045,
                                                height: height * 0.04,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
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
                                            padding: EdgeInsets.only(bottom: 7),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Container(
                                                        color: Colors.black,
                                                        width: width * 0.3,
                                                        height: height * 0.02,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Container(
                                                        color: Colors.black,
                                                        width: width * 0.3,
                                                        height: height * 0.02,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
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
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            index = index - 1;
                            try {
                              {
                                return index == -1
                                    ? Container(
                                        height: height * 0.065,
                                      )
                                    : ((mySpec.length == 1) &&
                                                (((gender == UserEventList[index]['gender']) && (UserEventList[index]["Spec id"] == mySpec[0]["Specialist ID"])) ||
                                                    ((UserEventList[index]
                                                                ['gender'] ==
                                                            'All Gender') &&
                                                        UserEventList[index]
                                                                ["Spec id"] ==
                                                            mySpec[0][
                                                                "Specialist ID"]))) ||
                                            ((mySpec.length == 2) && ((UserEventList[index]['gender'] == gender) && (UserEventList[index]["Spec id"] == mySpec[1]["Specialist ID"] || UserEventList[index]["Spec id"] == mySpec[0]["Specialist ID"])) ||
                                                ((UserEventList[index]['gender'] ==
                                                        'All Gender') &&
                                                    (UserEventList[index]["Spec id"] == mySpec[1]["Specialist ID"] ||
                                                        UserEventList[index]
                                                                ["Spec id"] ==
                                                            mySpec[0]
                                                                ["Specialist ID"])))
                                        ? InkWell(
                                            onTap: () {
                                              if (!mounted) return;
                                              setState(() {
                                                isExpanded[index].isExpanded =
                                                    !isExpanded[index]
                                                        .isExpanded;
                                                // _isExpanded = !_isExpanded;
                                                // eventlist[index]._isExpanded = _isExpanded;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  3.5, 0, 3.5, 3),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 120),
                                                width: width,
                                                height: isExpanded[index]
                                                            .isExpanded ==
                                                        true
                                                    ? height * 0.23
                                                    : height * 0.18,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 3))
                                                  ],
                                                ),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.0),
                                                      child: ColorFiltered(
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4),
                                                                BlendMode
                                                                    .darken),
                                                        child: Image.asset(
                                                          "${UserEventList[index]["image"]}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      8,
                                                                      6,
                                                                      0,
                                                                      15),
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
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
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                7),
                                                                        child: Text(
                                                                            "${UserEventList[index]["title"]}",
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'UbuntuREG',
                                                                              fontSize: height * 0.031,
                                                                              color: const Color(0xFFE7E7E7),
                                                                            )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                7),
                                                                    child: UserEventList[index]["gender"] !=
                                                                            'All Gender'
                                                                        ? DecoratedIcon(
                                                                            icon:
                                                                                Icon(
                                                                              UserEventList[index]["gender"] == 'Male' ? MyFlutterApp.mars : MyFlutterApp.venus,
                                                                              color: Colors.transparent,
                                                                              size: height * 0.035,
                                                                            ),
                                                                            decoration:
                                                                                IconDecoration(border: IconBorder(width: 1, color: UserEventList[index]["gender"] == 'Male' ? Color.fromARGB(255, 145, 215, 253).withOpacity(0.8) : Color.fromARGB(255, 255, 162, 193).withOpacity(0.8))),
                                                                          )
                                                                        : Container(),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      4,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5),
                                                                width: isExpanded[
                                                                            index]
                                                                        .isExpanded
                                                                    ? width *
                                                                        0.85
                                                                    : width *
                                                                        0.7,
                                                                child:
                                                                    AnimatedCrossFade(
                                                                  crossFadeState: isExpanded[
                                                                              index]
                                                                          .isExpanded
                                                                      ? CrossFadeState
                                                                          .showFirst
                                                                      : CrossFadeState
                                                                          .showSecond,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          120),
                                                                  firstChild: Text(
                                                                      "${UserEventList[index]["desc"]}",
                                                                      maxLines:
                                                                          5,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: txtstyle
                                                                          .copyWith(
                                                                        fontSize:
                                                                            height *
                                                                                0.017,
                                                                      )),
                                                                  secondChild: Text(
                                                                      "${UserEventList[index]["desc"]}",
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: txtstyle
                                                                          .copyWith(
                                                                        fontSize:
                                                                            height *
                                                                                0.017,
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        AnimatedPadding(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  120),
                                                          padding: EdgeInsets.fromLTRB(
                                                              7,
                                                              0,
                                                              0,
                                                              isExpanded[index]
                                                                      .isExpanded
                                                                  ? 20
                                                                  : 4),
                                                          ////////////fffffffffffffffffff
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Row(
                                                                      children: [
                                                                        Icon(
                                                                            MyFlutterApp
                                                                                .note_1,
                                                                            color:
                                                                                const Color(0xFFE7E7E7),
                                                                            size: height * 0.020),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 3),
                                                                          child: Text(
                                                                              "${UserEventList[index]["first date"]}" == "${UserEventList[index]["last date"]}" ? "${UserEventList[index]["first date"]}" : "${UserEventList[index]["first date"]}-${UserEventList[index]["last date"]} ",
                                                                              style: txtstyle),
                                                                        ),
                                                                      ]),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 3),
                                                                    child: Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.access_time,
                                                                              color: const Color(0xFFE7E7E7),
                                                                              size: height * 0.020),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 3),
                                                                            child:
                                                                                Text("${UserEventList[index]["first time"]}" + " - " + "${UserEventList[index]["last time"]}", style: txtstyle),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 2),
                                                                    child:
                                                                        Container(
                                                                      height: height *
                                                                          0.032,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(7)),
                                                                        gradient:
                                                                            LinearGradient(
                                                                                colors: [
                                                                              Color(0xFFD4145A).withOpacity(0.45),
                                                                              Color(0xFFFBB03B).withOpacity(0.45)
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
                                                                                padding: const EdgeInsets.only(left: 3),
                                                                                child: GestureDetector(
                                                                                  onTap: () async {
                                                                                    Future<void> _launchUrl() async {
                                                                                      if (!await launchUrl(Uri.parse(UserEventList[index]["locationLink"]))) {
                                                                                        throw Exception('Could not launch the link');
                                                                                      }
                                                                                    }

                                                                                    _launchUrl();
                                                                                  },
                                                                                  child: Text(maxLines: 1, '${UserEventList[index]["location"]}'.length > 9 ? FilterLocationString('${UserEventList[index]["location"]}') : '${UserEventList[index]["location"]}', style: txtstyle.copyWith(color: Colors.white)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                ], //
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  right: 7,
                                                                ),
                                                                child: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(7)),
                                                                      child:
                                                                          BackdropFilter(
                                                                        filter: ImageFilter.blur(
                                                                            sigmaX:
                                                                                4,
                                                                            sigmaY:
                                                                                4),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              width * 0.14,
                                                                          height:
                                                                              height * 0.032,
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.40),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(5),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${countList[index]}/${UserEventList[index]["limit"]}',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFFDEDEDE),
                                                                          fontSize: height *
                                                                              0.016,
                                                                          fontFamily:
                                                                              'UbuntuREG'),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IgnorePointer(
                                                          ignoring: isExpanded[
                                                                      index]
                                                                  .isExpanded
                                                              ? false
                                                              : true,
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (!mounted)
                                                                return;
                                                              setState(() {
                                                                isExpanded[index]
                                                                        .isjoined =
                                                                    !isExpanded[
                                                                            index]
                                                                        .isjoined;
                                                                !(isExpanded[
                                                                            index]
                                                                        .isjoined)
                                                                    ? deleteItem(
                                                                        '${UserEventList[index].id}')
                                                                    : addItem(
                                                                        '${UserEventList[index].id}',
                                                                        userID);
                                                              });
                                                            },
                                                            child:
                                                                AnimatedOpacity(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          120),
                                                              opacity: isExpanded[
                                                                              index]
                                                                          .isExpanded ==
                                                                      true
                                                                  ? 1
                                                                  : 0,
                                                              child:
                                                                  AnimatedContainer(
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              120),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              gradient:
                                                                                  LinearGradient(
                                                                                colors: isExpanded[index].isjoined ? activated : notActivated,
                                                                                stops: [
                                                                                  0.2,
                                                                                  0.7,
                                                                                  1
                                                                                ],
                                                                                begin: Alignment.topCenter,
                                                                                end: Alignment.bottomCenter,
                                                                              ),
                                                                              boxShadow: const [
                                                                                BoxShadow(blurRadius: 40, spreadRadius: 3)
                                                                              ],
                                                                              borderRadius: BorderRadius.circular(
                                                                                  30)),
                                                                      width: width *
                                                                          0.18,
                                                                      height: height *
                                                                          0.035,
                                                                      child: Center(
                                                                          child: Text(
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w300,
                                                                            shadows: [
                                                                              Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 3))
                                                                            ],
                                                                            color: const Color(0xFFE7E7E7),
                                                                            fontSize: height * 0.016),
                                                                        isExpanded[index].isjoined
                                                                            ? 'Joined'
                                                                            : 'Join',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                      ))),
                                                            ),
                                                          ),
                                                        ),
                                                        AnimatedRotation(
                                                          turns: isExpanded[
                                                                      index]
                                                                  .isExpanded
                                                              ? 0
                                                              : 0.5,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      120),
                                                          child: Icon(
                                                            size: height * 0.03,
                                                            Arrowicon.last,
                                                            color: const Color(
                                                                0xFFE7E7E7),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container();
                              }
                            } catch (e) {
                              Container(
                                child: Text(e.toString()),
                              );
                            }

                            return Container();
                          },
                          itemCount: UserEventList.length + 1,
                        ),
            ),
          ),
        ),
      ),
    );
  }

  String FilterLocationString(String value) {
    if (value.toString().split(",")[0].length > 20) {
      return "${value.toString().substring(0, 15)}...";
    }
    return value.toString().split(",")[0];
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class test1 extends StatefulWidget {
  var height;
  var width;

  test1(this.height, this.width);

  @override
  State<test1> createState() => _test1State();
}

class _test1State extends State<test1> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Center(
        child: Container(
      width: widget.width,
      height: widget.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: height * 0.1,
              width: height * 0.1,
              child: const CircularProgressIndicator(
                strokeWidth: 7,
                backgroundColor: Color.fromARGB(255, 219, 219, 219),
                color: Color.fromARGB(255, 71, 71, 71),
              )),
          Container(
              margin: EdgeInsets.only(top: height * 0.03),
              width: widget.width * 0.8,
              child: Center(
                  child: Text(
                maxLines: 1,
                "Loading..",
                style: TextStyle(fontSize: height * 0.04),
              ))),
        ],
      ),
    ));
  }
}
