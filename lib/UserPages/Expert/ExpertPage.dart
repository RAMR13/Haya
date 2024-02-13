import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/Expert/SearchExpertPage.dart';
import 'package:hayaproject/UserPages/MorePage/screen1.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:hayaproject/chat/ChatPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class Test extends StatefulWidget {
  @override
  createState() {
    return TestState();
  }
}

class TestState extends State<Test> {
  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }

  TextEditingController _textController = TextEditingController();
  String _savedText = '';
  double _rating = 0;
  bool _isFocused = false;

  // List<DocumentSnapshot> specialist = [];
  List<DocumentSnapshot> mySpec = [];

  // getDataspe() async {
  //   QuerySnapshot qs = await FirebaseFirestore.instance
  //       .collection("specialist")
  //       .where("Specialist ID", isEqualTo: widget.specialistId)
  //       .get();
  //   specialist.addAll(qs.docs);

  //   setState(() {});
  // }

  List<DocumentSnapshot> Users = [];
  bool haveSpec = false;
  var UserId;
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

  int lockchat = 0;
  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: UserId)
        // .where("User_id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    Users.addAll(qs.docs);
    await mySpecialist();
    if (!mounted) return;
    setState(() {});
  }

  mySpecialist() async {
    if (Users.length > 0) {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection("users")
          .doc(Users[0].id)
          .collection("my specialist")
          .get();
      print(mySpec.length.toString());

      mySpec.addAll(qs.docs);
      if (!mounted) return;
      setState(() {
        if (mySpec.length > 0) haveSpec = true;
      });
    }
  }

  @override
  void initState() {
    Prefs.getString("Id").then(
      (value) async {
        UserId = await value;
        await getData();
      },
    );
    mySpecialist();
    Loading();
    super.initState();

    // Retrieve the saved text (if any) when the widget is first initialized
    _textController.text = _savedText;
  }

  addReview(
      {required var SpecialistId,
      required var date,
      required var desc,
      required var star_num,
      required var username}) async {
    await FirebaseFirestore.instance
        .collection("specialist")
        .where('Specialist ID', isEqualTo: SpecialistId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection("review").add({
          "date": date.toString(),
          "desc": desc.toString(),
          "stars number": star_num.toString(),
          "user name": username.toString()
        });
      });
    });
  }

  void _showRatingBarModal(BuildContext context, var Specid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: AlertDialog(
              surfaceTintColor: Colors.white,
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    addReview(
                        star_num: _rating.toString().substring(0, 1),
                        date: "${DateTime.now().day}/"
                            "${DateTime.now().month}/"
                            "${DateTime.now().year}",
                        desc: _textController.text,
                        SpecialistId: Specid.toString(),
                        username: Users[0]["FirstName"]);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.white,
                      minimumSize: const Size(0, 25),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                              color: Colors.deepOrangeAccent, width: 2))),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: TextButton(
                      onPressed: () {
                        _savedText = _textController.text;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: Color.fromARGB(255, 121, 120, 120),
                            fontWeight: FontWeight.normal),
                      )),
                ),
              ],
              insetPadding: const EdgeInsets.all(15),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: const Center(
                  child: Text(
                "Add a review",
                style: TextStyle(
                  fontSize: 25,
                ),
              )),
              content: SizedBox(
                width: double.infinity,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(-3, 3),
                                  spreadRadius: 0),
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 5,
                                  offset: Offset(3, -3))
                            ],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        width: 490,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              RatingBar.builder(
                                initialRating: _rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                ),
                                onRatingUpdate: (rating) {
                                  if (!mounted) return;
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                              ),
                              RatingBar(
                                initialRating: _rating,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star_purple500_sharp,
                                      color: Colors.deepOrangeAccent
                                          .withOpacity(0.8)),
                                  half: const Icon(Icons.star_half,
                                      color: Colors.deepOrangeAccent),
                                  empty: const Icon(Icons.star,
                                      color: Colors
                                          .transparent), // Use transparent color for empty stars
                                ),
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                onRatingUpdate: (rating) {
                                  if (!mounted) return;
                                  setState(() {
                                    _rating = rating;
                                  });
                                  // Navigator.pop(context); // Close the dialog after rating
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: TextFormField(
                          controller: _textController,
                          cursorColor: Colors.grey,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.always,
                          keyboardType: TextInputType.multiline,
                          maxLines: _isFocused ? 4 : 1,
                          scrollPhysics: const BouncingScrollPhysics(),
                          textInputAction: TextInputAction.newline,
                          onTap: () {
                            if (!mounted) return;
                            setState(() {
                              _isFocused = !_isFocused;
                            });
                          },
                          onFieldSubmitted: (_) {
                            if (!mounted) return;
                            setState(() {
                              _isFocused = false;
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.deepOrange)),
                              hintText: "Describe your experience (optional)",
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepOrangeAccent)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              hintStyle: const TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        });
      },
    );
  }

  bool showItems = false;
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Widget card(int i) {
      bool istwo = mySpec.length == 2;
      return Container(
        width: istwo ? width * 0.455 : width * 0.92,
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("Images/123.png"), fit: BoxFit.cover),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: CircleAvatar(
                  radius: height * 0.043,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 3,
                            offset: Offset(0, 3))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage("${mySpec[i]['image']}"),
                          fit: BoxFit.cover),
                    ),
                  )),
            ),
            Container(
              height: height * 0.12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "${mySpec[i]['first name']} ${mySpec[i]['last name']}",
                      style: TextStyle(
                        fontFamily: 'UbuntuREG',
                        color: Color(0xFF2C2C2C),
                        fontSize: height * 0.02,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.badge_outlined,
                        size: height * 0.022,
                        color: Color.fromARGB(255, 68, 68, 68),
                      ),
                      Text(
                        " ${mySpec[i]['type'].toString()[0].toUpperCase()}${mySpec[i]['type'].toString().substring(1)}",
                        style: TextStyle(
                            color: Color.fromARGB(255, 68, 68, 68),
                            fontSize: height * 0.018,
                            fontFamily: 'UbuntuREG'),
                      )
                    ],
                  ),
                  Text("Subscribed",
                      style: TextStyle(
                          color: Color.fromARGB(255, 68, 68, 68),
                          fontSize: height * 0.017,
                          fontFamily: 'UbuntuREG')),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        _showRatingBarModal(
                            context, "${mySpec[i]["Specialist ID"]}");
                        setState(() {
                          _isFocused = false;
                          _textController.text = "";
                          _rating = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 176, 170, 172)
                                      .withOpacity(0.1),
                                  blurRadius: 1,
                                  offset: Offset(-2, 2))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.rate_review,
                              color: Color(0xFF5C5F62),
                              size: height * 0.023,
                            ),
                            Text(
                              " Review ",
                              style: TextStyle(
                                  fontFamily: 'UbuntuREG',
                                  fontSize: height * 0.018),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget cardLoading() {
      return Container(
        width: width * 0.455,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 221, 221, 221),
            borderRadius: BorderRadius.circular(7)),
        child: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 185, 185, 185),
          highlightColor: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: CircleAvatar(
                  radius: height * 0.043,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      boxShadow: [],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Container(
                height: height * 0.12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Container(
                          width: width * 0.25,
                          height: height * 0.02,
                          color: Colors.grey,
                        ) //namesss
                        ),
                    Container(
                      width: width * 0.25,
                      height: height * 0.02,
                      color: Colors.grey,
                    ),
                    Container(
                      width: width * 0.25,
                      height: height * 0.02,
                      color: Colors.grey,
                    ), //third
                    Container(
                      height: height * 0.031,
                      width: width * 0.22,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 176, 170, 172)
                                      .withOpacity(0.1),
                                  blurRadius: 1,
                                  offset: Offset(-2, 2))
                            ],
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return WillPopScope(
        onWillPop: () async {
          if (shouldPop)
            Navigator.pushReplacement<void, void>(
                context,
                PageTransition(
                    child: MainScreenUser(""), type: PageTransitionType.fade));
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
                                    child: Screen1("Test"),
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
                            "Experts",
                            style: TextStyle(
                                fontSize: height * 0.03,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2C2C2C)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: SearchPage(),
                                type: PageTransitionType.fade));
                      },
                      child: Icon(
                        MyFlutterApp.search_normal_1,
                        color: const Color(0xFF2C2C2C),
                        size: height * 0.03,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFFFFFFF),
              elevation: 2,
            ),
            body: AnimatedSwitcher(
                duration: Duration(milliseconds: 220),
                child: mySpec.isEmpty
                    ? Center(
                        key: ValueKey<int>(0),
                        child: ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: width * 0.96,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 6,
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              offset: Offset(0, 4))
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 6, 0, 0),
                                          child: Text(
                                            "Subscriptions",
                                            style: TextStyle(
                                                fontFamily: 'UbuntuREG',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.017,
                                                color: const Color(0xFF2C2C2C)),
                                          ),
                                        ),
                                        Container(
                                            height: height * 0.24,
                                            padding: EdgeInsets.all(6),
                                            width: width,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  cardLoading(),
                                                  cardLoading()
                                                ]))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.59,
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    width: width * 0.96,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFf9f9f9),
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3)),
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                6, 6, 0, 6),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Chat",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.017,
                                                    fontFamily: 'UbuntuREG',
                                                    color: const Color(
                                                        0xFF2C2C2C)),
                                              ),
                                            ),
                                          ),
                                          ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    top: i == 0 ? 0 : 7),
                                                child: Container(
                                                  height: height * 0.104,

                                                  //90,
                                                  margin: const EdgeInsets.only(
                                                      left: 8,
                                                      right: 8,
                                                      bottom: 1,
                                                      top: 2),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 221, 221, 221),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.25),
                                                        offset:
                                                            const Offset(-2, 2),
                                                        blurRadius: 4,
                                                      ),
                                                      const BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        offset: Offset(3, -3),
                                                        blurRadius: 2,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        const Color.fromARGB(
                                                            255, 185, 185, 185),
                                                    highlightColor:
                                                        Colors.grey.shade200,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 0),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.08,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.08,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Container(
                                                                color:
                                                                    Colors.grey,
                                                                width:
                                                                    width * 0.4,
                                                                height: height *
                                                                    0.025,
                                                              ),
                                                              Container(
                                                                color:
                                                                    Colors.grey,
                                                                width: width *
                                                                    0.55,
                                                                height: height *
                                                                    0.025,
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
                                            itemCount: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      )
                    : Center(
                        key: ValueKey<int>(1),
                        child: ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: width * 0.96,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 6,
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              offset: Offset(0, 4))
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 6, 0, 0),
                                          child: Text(
                                            "Subscriptions",
                                            style: TextStyle(
                                                fontFamily: 'UbuntuREG',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.017,
                                                color: const Color(0xFF2C2C2C)),
                                          ),
                                        ),
                                        Container(
                                            height: height * 0.24,
                                            padding: EdgeInsets.all(6),
                                            width: width,
                                            child: mySpec.length != 0
                                                ? Row(
                                                    mainAxisAlignment:
                                                        mySpec.length == 1
                                                            ? MainAxisAlignment
                                                                .center
                                                            : MainAxisAlignment
                                                                .spaceBetween,
                                                    children: mySpec.length == 2
                                                        ? [card(0), card(1)]
                                                        : [
                                                            card(0),
                                                          ],
                                                  )
                                                : Container())
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.59,
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    width: width * 0.96,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFf9f9f9),
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3)),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 6, 0, 6),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Chat",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.017,
                                                  fontFamily: 'UbuntuREG',
                                                  color:
                                                      const Color(0xFF2C2C2C)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.93,
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemBuilder: (context, i) {
                                              if (lockchat < mySpec.length) {
                                                getDataMessage(
                                                    mySpec[i]['Specialist ID'],
                                                    UserId,
                                                    i);
                                                lockchat++;
                                              }
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child: ChatPage(
                                                            name: mySpec[i][
                                                                    'first name'] +
                                                                " " +
                                                                mySpec[i][
                                                                    'last name'],
                                                            image: mySpec[i]
                                                                ['image'],
                                                            senderId: UserId,
                                                            Senderemail:
                                                                Users[0]
                                                                    ["email"],
                                                            receiverUserEmail:
                                                                mySpec[i]
                                                                    ['email'],
                                                            receiverUserID: mySpec[
                                                                    i][
                                                                'Specialist ID'],
                                                            type: "specialist",
                                                          ),
                                                          type: PageTransitionType
                                                              .rightToLeftWithFade));

                                                  // ChatPage(
                                                  //     receiverUserEmail: mySpec[i][['email'],
                                                  //     receiverUserID: mySpec[i][['Specialist_id'])
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: i == 0 ? 0 : 7),
                                                  child: Container(
                                                    height: height * 0.104,

                                                    //90,
                                                    margin: EdgeInsets.only(
                                                      bottom: 1,
                                                      top: 2,
                                                    ),
                                                    // left: width * 0.015,
                                                    // right: width * 0.015),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFF9F9F9),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                          offset: const Offset(
                                                              -2, 2),
                                                          blurRadius: 4,
                                                        ),
                                                        const BoxShadow(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          offset: Offset(3, -3),
                                                          blurRadius: 2,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right: 0),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.08,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.08,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child:
                                                                  Image.network(
                                                                "${mySpec[i]['image']}",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    blurRadius:
                                                                        4,
                                                                    offset:
                                                                        const Offset(
                                                                            -2,
                                                                            3))
                                                              ],
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    width * 0.7,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      " ${mySpec[i]['first name']} ${mySpec[i]['last name']}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'UbuntuREG',
                                                                          fontSize: MediaQuery.of(context).size.height *
                                                                              0.023,
                                                                          color:
                                                                              const Color(0xFF2C2C2C)),
                                                                    ),
                                                                    Text(
                                                                      UserId != null &&
                                                                              qss[i].isNotEmpty
                                                                          ? '${qss[i].isNotEmpty ? qss[i][0]['time'] > 12 ? qss[i][0]['time'] - 12 : qss[i][0]['time'] : qss[i][0]['time'] == 12 ? 12 : qss[i][0]['time'] == 0 ? 0 : ''}:${qss[i][0]['timet'] > 10 ? qss[i][0]['timet'] : '0${qss[i][0]['timet']}'}${qss[i][0]['time'] >= 12 ? ' PM' : ' AM'}'
                                                                          : "0:00 pm",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.height *
                                                                                0.016,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.6),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                width:
                                                                    width * 0.7,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width: width *
                                                                          0.52,
                                                                      child:
                                                                          Text(
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        "${qss[i].isNotEmpty ? qss[i][0]['message'] : ''}",
                                                                        style: TextStyle(
                                                                            color: Colors.black.withOpacity(
                                                                                0.6),
                                                                            fontSize: MediaQuery.of(context).size.height *
                                                                                0.017,
                                                                            fontFamily:
                                                                                'UbuntuREG'),
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
                                            itemCount: mySpec.length,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ))));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
