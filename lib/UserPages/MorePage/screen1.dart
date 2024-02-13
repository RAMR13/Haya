// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hayaproject/AdminPage/EventPageAdmin/EventAdminPage.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/Loading.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/MorePage/account.dart';
import 'package:hayaproject/UserPages/MorePage/tips.dart';
import 'package:page_transition/page_transition.dart';
import '../navigatorbarUser/NavigationBar.dart';
import 'settings.dart';

class Screen1 extends StatefulWidget {
  var Page_name;
  Screen1(this.Page_name);
  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  bool _showDropdowns = false;
  bool shouldPop = true;

  List<DocumentSnapshot> Users = [];
  var userId;
  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: userId)
        .get();
    Users.addAll(qs.docs);
    if (!mounted) return;
    setState(() {});
  }

  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    Prefs.getString("Id").then(
      (value) async {
        userId = await value;
        await getData();
      },
    );
    super.initState();
  }

  IsOpen one = IsOpen(false);
  IsOpen two = IsOpen(false);
  IsOpen three = IsOpen(false);
  IsOpen four = IsOpen(false);
  IsOpen five = IsOpen(false);
  void showdropdown() {
    one.isopen = false;
    two.isopen = false;
    three.isopen = false;
    four.isopen = false;
    five.isopen = false;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Widget QA(String q, String A, IsOpen isOpen) {
      return Column(
        children: [
          InkWell(
            onTap: () {
              if (!mounted) return;
              setState(() {
                if (isOpen.isopen == false) {
                  showdropdown();
                  isOpen.isopen = true;
                } else
                  isOpen.isopen = false;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.8,
                    child: Text(
                      q,
                      maxLines: 4,
                      style: TextStyle(
                          fontFamily: 'UbuntuREG',
                          fontSize: height * 0.022,
                          color: Color(0xFF2C2C2C)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen.isopen ? 0.25 : 0,
                    duration: Duration(milliseconds: 120),
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: height * 0.03,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 120),
            child: AnimatedSwitcher(
                switchInCurve: Curves.fastLinearToSlowEaseIn,
                switchOutCurve: Curves.fastEaseInToSlowEaseOut,
                duration: Duration(milliseconds: 0),
                child: isOpen.isopen
                    ? Container(
                        key: ValueKey<int>(A.length),
                        child: Column(
                          children: [
                            const Divider(
                              color: Color.fromARGB(255, 206, 206, 206),
                              thickness: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                A,
                                style: TextStyle(
                                    fontSize: height * 0.02,
                                    color: Color.fromARGB(255, 75, 75, 75),
                                    fontFamily: 'UbuntuREG'),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        key: ValueKey<int>(A.length + 1),
                      )),
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            thickness: 1,
            color: isOpen == five
                ? Color(0xFFF9F9F9)
                : Color.fromARGB(255, 206, 206, 206),
          ),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (shouldPop) if (widget.Page_name == "")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenUser(""), type: PageTransitionType.fade));
        if (widget.Page_name == "WHomePage")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenUser("WHomePage"),
                  type: PageTransitionType.fade));
        if (widget.Page_name == "FoodPage")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenUser("FoodPage"),
                  type: PageTransitionType.fade));
        if (widget.Page_name == "eventpage")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenUser("eventpage"),
                  type: PageTransitionType.fade));
        if (widget.Page_name == "Test")
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenUser("Test"),
                  type: PageTransitionType.fade));
        return shouldPop;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xFFF9F9F9),
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.Page_name == "")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenUser(""),
                              type: PageTransitionType.fade));
                    if (widget.Page_name == "WHomePage")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenUser("WHomePage"),
                              type: PageTransitionType.fade));
                    if (widget.Page_name == "FoodPage")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenUser("FoodPage"),
                              type: PageTransitionType.fade));
                    if (widget.Page_name == "eventpage")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenUser("eventpage"),
                              type: PageTransitionType.fade));
                    if (widget.Page_name == "Test")
                      Navigator.pushReplacement<void, void>(
                          context,
                          PageTransition(
                              child: MainScreenUser("Test"),
                              type: PageTransitionType.fade));
                  },
                  child: Hero(
                    tag: 'arrow',
                    child: Icon(Icons.arrow_back_ios,
                        size: height * 0.035, color: const Color(0xFF2C2C2C)),
                  ),
                ),
                Text('More',
                    style: TextStyle(
                        fontSize: height * 0.03,
                        color: const Color(0xFF2C2C2C))),
              ],
            ),
          ),
          backgroundColor: Color(0xFFF9F9F9),
          body: Users.isEmpty
              ? test1(height, width)
              : ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Container(
                        width: width,
                        margin: EdgeInsets.only(
                            bottom: 0, left: 12, right: 12, top: height * 0.03),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(-2, 3)),
                            const BoxShadow(
                                color: Colors.white,
                                blurRadius: 4,
                                offset: Offset(3, -7)),
                          ],
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child:
                                        Account(widget.Page_name, Users, false),
                                    type: PageTransitionType
                                        .rightToLeftWithFade));
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
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                blurRadius: 3,
                                                offset: const Offset(0, 2))
                                          ]),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.network(
                                          "${Users[0]["images"]}",
                                          fit: BoxFit.cover,
                                        ),
                                        margin: const EdgeInsets.all(3.5),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                blurRadius: 2,
                                                offset: const Offset(0, 2))
                                          ],
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: width * 0.55,
                                      child: Text(
                                          "${Users[0]["FirstName"]} "
                                          "${Users[0]["LastName"]}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF2C2C2C),
                                            fontSize: height * 0.027,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF2C2C2C),
                                size: height * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: width,
                          margin: EdgeInsets.only(
                              bottom: height * 0.02,
                              left: 12,
                              right: 12,
                              top: height * 0.02),
                          decoration: BoxDecoration(
                            color: Color(0xFFF9F9F9),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(-2, 3)),
                              const BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 4,
                                  offset: Offset(3, -7)),
                            ],
                          ),
                          ///////////////////////////////////////////////////////
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: Setting(),
                                          type: PageTransitionType
                                              .rightToLeftWithFade));
                                },
                                child: Container(
                                  height: height * 0.09,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  color: const Color(0xFFF9F9F9),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Row(children: [
                                          ShaderMask(
                                            shaderCallback: (bounds) =>
                                                LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                  const Color.fromARGB(
                                                          255, 255, 99, 26)
                                                      .withOpacity(0.7),
                                                  const Color(0xFFFF3666)
                                                      .withOpacity(0.9)
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
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFF2C2C2C),
                                        size: height * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                height: height * 0.003,
                                child: Divider(
                                  thickness: 1,
                                  color: Color.fromARGB(255, 206, 206, 206),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,

                                  //   MaterialPageRoute(
                                  //     builder: (context) => Tips(),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  height: height * 0.09,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  color: const Color(0xFFF9F9F9),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Row(children: [
                                          ShaderMask(
                                            shaderCallback: (bounds) =>
                                                LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                  const Color.fromARGB(
                                                          255, 255, 99, 26)
                                                      .withOpacity(0.7),
                                                  const Color(0xFFFF3666)
                                                      .withOpacity(0.9)
                                                ],
                                                    stops: [
                                                  0.4,
                                                  1
                                                ]).createShader(bounds),
                                            child: Icon(
                                              Icons.lightbulb_circle,
                                              color: const Color(0xFFFFAA5C),
                                              size: height * 0.045,
                                            ),
                                          ),
                                          Text("  Tips",
                                              style: TextStyle(
                                                color: const Color(0xFF2C2C2C),
                                                fontSize: height * 0.026,
                                              )),
                                        ]),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFF2C2C2C),
                                        size: height * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                height: height * 0.003,
                                child: Divider(
                                  color: Color.fromARGB(255, 206, 206, 206),
                                  thickness: 1,
                                ),
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (!mounted) return;
                                      setState(() {
                                        _showDropdowns = !_showDropdowns;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 50),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFF9F9F9),
                                          boxShadow: _showDropdowns
                                              ? [
                                                  BoxShadow(
                                                      spreadRadius: -3,
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      offset: Offset(0, 5),
                                                      blurRadius: 4)
                                                ]
                                              : [],
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: _showDropdowns
                                                ? Radius.circular(0)
                                                : Radius.circular(7),
                                            bottomRight: _showDropdowns
                                                ? Radius.circular(0)
                                                : Radius.circular(7),
                                          )),
                                      height: height * 0.09,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 7),
                                            child: Row(children: [
                                              ShaderMask(
                                                shaderCallback: (bounds) =>
                                                    LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                      const Color.fromARGB(
                                                              255, 255, 99, 26)
                                                          .withOpacity(0.7),
                                                      const Color(0xFFFF3666)
                                                          .withOpacity(0.9)
                                                    ],
                                                        stops: [
                                                      0.4,
                                                      1
                                                    ]).createShader(bounds),
                                                child: Icon(
                                                  Icons.help,
                                                  color:
                                                      const Color(0xFFFFAA5C),
                                                  size: height * 0.045,
                                                ),
                                              ),
                                              Text("  FAQ",
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF2C2C2C),
                                                    fontSize: height * 0.026,
                                                  )),
                                            ]),
                                          ),
                                          AnimatedRotation(
                                            turns: _showDropdowns ? 0.25 : 0,
                                            duration:
                                                Duration(milliseconds: 120),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Color(0xFF2C2C2C),
                                              size: height * 0.03,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //////////////////////////
                                  AnimatedCrossFade(
                                    crossFadeState: _showDropdowns
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: Duration(milliseconds: 120),
                                    firstChild: Container(
                                      key: ValueKey<int>(-2),
                                    ),
                                    secondChild: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Container(
                                        key: ValueKey<int>(-4),
                                        child: Column(
                                          children: [
                                            QA(
                                                "How do I find a trainer or nutritionist to subscribe to?",
                                                "The app will have a search function where you can browse through a list of certified trainers and nutritionists, and choose the one that best aligns with your goals and preferences.",
                                                one),
                                            QA(
                                                'Can I tailor my training or nutrition plan according to my goals?',
                                                "Yes, after you subscribe to a trainer or nutritionist, they will work with you to create a personalized plan that aligns with your goals, preferences, and fitness level.",
                                                two),
                                            QA(
                                                'Can I track my progress and see my improvement over time?',
                                                "Yes, the app will have a feature that allows you to track your progress and see your improvement over time. This will help you stay motivated and make adjustments to your plan as needed to continue making progress.",
                                                three),
                                            QA(
                                                'What happens if I miss a scheduled event?',
                                                "If you miss a scheduled event, you may not be able to participate in that particular workout or activity. However, you can still access other pre-programmed workouts and continue working towards your goals.",
                                                four),
                                            QA(
                                                'Can I communicate with my specialist through the app?',
                                                "Yes, the app may provide a messaging system that allows you to communicate directly with your trainer or nutritionist.",
                                                five)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ]),
                  ),
                )),
    );
  }
}

class IsOpen {
  bool isopen;
  IsOpen(this.isopen);
}
