import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/AdminPage/navigatorbarAdmin/NavigationBar.dart'; //delete
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/SpecialistPage/AddFoodSp.dart';
import 'package:hayaproject/SpecialistPage/MorePage/MorePage.dart';
import 'package:hayaproject/UserPages/MorePage/account.dart';
import 'package:hayaproject/chat/ChatPage.dart';
import 'package:meta/meta.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class RequestPage extends StatefulWidget {
  var specialistId;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  bool messageSeen = false;

  List<DocumentSnapshot> usersPend = [];
  List<DocumentSnapshot> specialist = [];
  List<DocumentSnapshot> usersAccept = [];
  List<DocumentSnapshot> mySpec = [];
  List<DocumentSnapshot> mySpecT = [];
  var SpecId;
  List<bool> d = [];

  bool xss = false;

  List<DocumentSnapshot> AllSpecialist = [];
  List<int> countList = [];
  List<Future<int>> queryFutures = [];
  List<Future<void>> futures = [];

  List<int> isJoined = [];

  getData2(var DocId) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("specialist")
        .where('type', isEqualTo: specialist[0]["type"])
        .get();
    AllSpecialist.addAll(qs.docs);

    for (int i = 0; i < AllSpecialist.length; i++) {
      if (AllSpecialist[i].id != specialist[0].id) {
        Future<void> future = FirebaseFirestore.instance
            .collection("specialist")
            .doc(AllSpecialist[i].id)
            .collection('my user')
            .where('User_id', isEqualTo: DocId)
            .get()
            .then((QuerySnapshot qs) {
          qs.docs.forEach((element) {
            element.reference.delete();
          });
        });
        futures.add(future);
      }
    }

    await Future.wait(futures);
  }

  var Spectype;
  int x = 0;
  int lockChat = 0;
  Future<bool> UserSpecialist(String docid) async {
    await Prefs.getString("Type").then(
      (value) {
        Spectype = value;
      },
    );
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .doc(docid)
        .collection("my specialist")
        .where("type", isEqualTo: Spectype)
        .get();

    mySpec.addAll(qs.docs);

    if (mySpec.length > 0) return true;
    return false;
  }

  Future<List<DocumentSnapshot>> getDataUser(String id) async {
    List<DocumentSnapshot> userDocuments = [];

    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where('User_id', isEqualTo: id)
        .get();

    userDocuments.addAll(qs.docs);

    return userDocuments;
  }

  List<List<DocumentSnapshot>> qss = List.filled(30, []);

  Future<void> getDataMessage(String id, String userId, int i) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc('$id' + '_' + '$userId')
        .collection('message')
        .orderBy('timestamp', descending: true)
        .get();

    qss[i] = qs.docs;
    if (!mounted) return;
    setState(() {});
  }

  getData() async {
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

    if (!mounted) return;
    setState(() {});
  }

  Query<Map<String, dynamic>> fetchData(String type) {
    return FirebaseFirestore.instance
        .collection("specialist")
        .doc(specialist[0].id)
        .collection("my user")
        .where("accept", isEqualTo: type);
  }

  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    Loading();
    getData();
    super.initState();
  }

  bool lock = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
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
                                child: More(""), type: PageTransitionType.fade),
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
                          "Clients",
                          style: TextStyle(
                              fontSize: height * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      FontAwesomeIcons.bell,
                      color: Color(0xFF2C2C2C),
                      size: height * 0.03,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFFFFFFFF),
            elevation: 3,
          ),
          body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFf9f9f9),
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(7, 7, 0, 0),
                                  child: Text(
                                    "Subscription requests",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              .018,
                                    ),
                                  ),
                                ),
                                AnimatedCrossFade(
                                  duration: Duration(milliseconds: 220),
                                  crossFadeState: specialist.length == 0
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.24,
                                    width: width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 3,
                                      itemBuilder: (context, i) => Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 7, 0, 5),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .38,
                                          margin: EdgeInsets.only(
                                              right: 5,
                                              left: i == 0 ? 5 : 3,
                                              bottom: 1,
                                              top: 3),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 214, 214, 214),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey.shade400,
                                            highlightColor:
                                                Colors.grey.shade200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // Added this line
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: width * 0.2,
                                                  height: height * 0.02,
                                                  color: Colors.grey,
                                                ),
                                                Container(
                                                  color: Colors.grey,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  secondChild: StreamBuilder(
                                      stream: specialist.length == 0
                                          ? null
                                          : fetchData("pend").snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error ${snapshot.error}');
                                        }
                                        if (lock == false) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          }
                                          lock = true;
                                        }

                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.24,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot
                                                        .data?.docs.length ==
                                                    null
                                                ? 0
                                                : snapshot.data?.docs.length,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 7, 0, 5),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .38,
                                                  margin: EdgeInsets.only(
                                                      right: 5,
                                                      left: i == 0 ? 5 : 3,
                                                      bottom: 1,
                                                      top: 3),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF9F9F9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.35),
                                                        offset: Offset(0, 2),
                                                        blurRadius: 5,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.white
                                                            .withOpacity(0.75),
                                                        offset: Offset(1, -2),
                                                        blurRadius: 1,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        // Added this line
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.09,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.09,
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    blurRadius:
                                                                        4,
                                                                    offset:
                                                                        Offset(
                                                                            -2,
                                                                            3))
                                                              ],
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              120),
                                                                      reverseDuration: Duration(
                                                                          milliseconds:
                                                                              120),
                                                                      child: Account(
                                                                          "chat page",
                                                                          await getDataUser(snapshot.data!.docs[i]
                                                                              [
                                                                              'User_id']),
                                                                          false),
                                                                      type: PageTransitionType
                                                                          .rightToLeftWithFade),
                                                                );
                                                              },
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: Image
                                                                      .network(
                                                                    "${snapshot.data!.docs[i]["image"]}",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                            ),
                                                          ),

                                                          Text(
                                                            "${snapshot.data?.docs[i]['FirstName']}",
                                                            style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .022,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),

                                                          // Conditional rendering of the button text
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.04,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.25,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                  side: BorderSide(
                                                                      color: Color(
                                                                          0xffe75d03)),
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                onPrimary: Color(
                                                                    0xffe75d03),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                // await FirebaseFirestore
                                                                //     .instance
                                                                //     .collection(
                                                                //     "users")
                                                                //     .doc(
                                                                //   "${snapshot.data?.docs[i]["UserDocId"]}",
                                                                // ).update({
                                                                //   "ISsubsT":"",
                                                                // });
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "users")
                                                                    .doc(
                                                                      "${snapshot.data?.docs[i]["UserDocId"]}",
                                                                    )
                                                                    .collection(
                                                                        "my specialist")
                                                                    .add(
                                                                  {
                                                                    "image":
                                                                        "${specialist[0]['image']}",
                                                                    "first name":
                                                                        "${specialist[0]['first name']}",
                                                                    "last name":
                                                                        "${specialist[0]['last name']}",
                                                                    "email":
                                                                        "${specialist[0]['email']}",
                                                                    "Specialist ID":
                                                                        "${specialist[0]['Specialist ID']}",
                                                                    "type":
                                                                        "${specialist[0]['type']}",
                                                                  },
                                                                );
                                                                //////////////////////////////////////////

                                                                //////////////////////////////////////////
                                                                //   setState(() {

                                                                //  isAccept[i].isAccepted=!isAccept[i].isAccepted;
                                                                //   });

                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "specialist")
                                                                    .doc(specialist[
                                                                            0]
                                                                        .id)
                                                                    .collection(
                                                                        "my user")
                                                                    .doc(snapshot
                                                                        .data
                                                                        ?.docs[
                                                                            i]
                                                                        .id)
                                                                    .update(
                                                                  {
                                                                    "accept":
                                                                        "accept"
                                                                  },
                                                                );

                                                                getData2(snapshot
                                                                        .data!
                                                                        .docs[i]
                                                                    [
                                                                    "User_id"]);
                                                              },
                                                              child: Text(
                                                                " ACCEPT",
                                                                // isAccept[i].isAccepted
                                                                //   ? "Accepted"
                                                                //   : "Accept",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xfff65d05),
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.014,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 1,
                                                                  right: 2),
                                                          child: InkWell(
                                                            onTap: () {
                                                              deleteItem(
                                                                "${snapshot.data?.docs[i]["User_id"]}",
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              size: height *
                                                                  0.033,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                )
                              ],
                            )),

                        /////////////////////////////////////////////// chat
                        Container(
                          width: MediaQuery.of(context).size.width * 0.97,
                          decoration: BoxDecoration(
                            color: Color(0xFFf9f9f9),
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 7, top: 5, bottom: 0),
                                    child: Text(
                                      "Chat",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                .018,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.97,
                                  child: AnimatedCrossFade(
                                    duration: Duration(milliseconds: 220),
                                    crossFadeState: specialist.length == 0
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    firstChild: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: 7, right: 7),
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 2,
                                                  right: 2,
                                                  bottom: 6,
                                                  top: 2),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 214, 214, 214),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey.shade400,
                                                highlightColor:
                                                    Colors.grey.shade200,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .125,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.92,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              3,
                                                                          left:
                                                                              3),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.09,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.09,
                                                                  child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(100),
                                                                      child: Container(
                                                                        color: Colors
                                                                            .grey,
                                                                      )),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    color: Colors
                                                                        .grey,
                                                                    height:
                                                                        height *
                                                                            0.025,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6,
                                                                  ),
                                                                  Container(
                                                                    color: Colors
                                                                        .grey,
                                                                    height:
                                                                        height *
                                                                            0.025,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.5,
                                                                  ),
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
                                          );
                                        },
                                        itemCount: 5),
                                    secondChild: StreamBuilder(
                                        stream: specialist.length == 0
                                            ? null
                                            : fetchData("accept").snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error ${snapshot.error}');
                                          }
                                          if (lock == false) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Container(
                                                height: height,
                                                width: width / 2,
                                                color: Colors.transparent,
                                              );
                                            }
                                            lock = true;
                                          }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(
                                                top: 4,
                                                bottom: snapshot.data?.docs
                                                            .length ==
                                                        0
                                                    ? height * 0.08
                                                    : height * 0.02),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              if (lockChat <
                                                  snapshot.data!.docs.length) {
                                                getDataMessage(
                                                    SpecId,
                                                    snapshot.data?.docs[i]
                                                        ['User_id'],
                                                    i);
                                                lockChat++;
                                              }
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeftWithFade,
                                                        child: ChatPage(
                                                            name: snapshot.data?.docs[i]['FirstName'] +
                                                                " " +
                                                                snapshot.data?.docs[i][
                                                                    'LastName'],
                                                            image: snapshot.data
                                                                    ?.docs[i]
                                                                ['image'],
                                                            senderId: SpecId,
                                                            Senderemail:
                                                                specialist[0]
                                                                    ["email"],
                                                            receiverUserEmail:
                                                                snapshot.data?.docs[i]
                                                                    ['email'],
                                                            receiverUserID:
                                                                snapshot.data
                                                                        ?.docs[i]
                                                                    ['User_id'],
                                                            type: "user"),
                                                        childCurrent:
                                                            RequestPage(),
                                                      ));
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 7, right: 7),
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 2,
                                                        right: 2,
                                                        bottom: 0,
                                                        top: i ==
                                                                snapshot
                                                                    .data
                                                                    ?.docs
                                                                    .length
                                                            ? 0
                                                            : 7),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF9F9F9),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                          offset: Offset(0, 2),
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .125,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.92,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              3,
                                                                          left:
                                                                              3),
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.09,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.09,
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(100),
                                                                          child: Image.network(
                                                                            "${snapshot.data!.docs[i]["image"]}",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              color: Colors.black.withOpacity(0.25),
                                                                              blurRadius: 4,
                                                                              offset: Offset(-2, 3))
                                                                        ],
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.5,
                                                                        child:
                                                                            Text(
                                                                          "${snapshot.data?.docs[i]['FirstName']}",
                                                                          style: TextStyle(
                                                                              fontSize: MediaQuery.of(context).size.height * 0.023,
                                                                              fontFamily: 'UbuntuREG'),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.45,
                                                                        child:
                                                                            Text(
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          //note   //add message in chat
                                                                          "${qss[i].isNotEmpty ? qss[i][0]['message'] : ''}",

                                                                          style: TextStyle(
                                                                              color: Colors.black.withOpacity(0.6),
                                                                              fontSize: MediaQuery.of(context).size.height * 0.017,
                                                                              fontFamily: 'UbuntuREG'),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            7),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    //add time in chat
                                                                    Text(
                                                                      SpecId != null &&
                                                                              qss[i].isNotEmpty
                                                                          ? '${qss[i].isNotEmpty ? qss[i][0]['time'] > 12 ? qss[i][0]['time'] - 12 : qss[i][0]['time'] : qss[i][0]['time'] == 12 ? 12 : qss[i][0]['time'] == 0 ? 0 : ''}:${qss[i][0]['timet'] > 10 ? qss[i][0]['timet'] : '0${qss[i][0]['timet']}'}${qss[i][0]['time'] >= 12 ? ' PM' : ' AM'}'
                                                                          : "0:00 pm",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.height *
                                                                                0.015,
                                                                      ),
                                                                    ),

                                                                    Opacity(
                                                                      opacity:
                                                                          0,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        size: MediaQuery.of(context).size.height *
                                                                            0.024,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: snapshot
                                                        .data?.docs.length ==
                                                    null
                                                ? 0
                                                : snapshot.data?.docs.length,
                                          );
                                        }),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  deleteItem(var id) async {
    //////////////////////////////ارجع
    await FirebaseFirestore.instance
        .collection("specialist")
        .doc(specialist[0].id)
        .collection("my user")
        .where('User_id', isEqualTo: id)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }
}

class ChatRoom {
  var chatroomId;
  var lastmessage;
  var lastmessageTimeStamp;
  ChatRoom(
      {required this.chatroomId,
      required this.lastmessage,
      required this.lastmessageTimeStamp});
}

class Accepted {
  bool isAccepted;
  Accepted(this.isAccepted);
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
