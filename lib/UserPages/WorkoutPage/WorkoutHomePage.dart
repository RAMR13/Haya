import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as material;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/MorePage/screen1.dart';
import 'package:hayaproject/UserPages/WorkoutPage/AssessmentHome.dart';
import 'package:hayaproject/UserPages/WorkoutPage/ExerciseBody.dart';
import 'package:hayaproject/UserPages/WorkoutPage/ExerciseBodyNET.dart' as Net;
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:page_transition/page_transition.dart';

class WHomePage extends StatefulWidget {
  const WHomePage({super.key});

  @override
  State<WHomePage> createState() => _WHomePageState();
}

class _WHomePageState extends State<WHomePage> {
  List<List<DocumentSnapshot<Object?>>> infos = [];
  List<List<DocumentSnapshot<Object?>>> infosnotempty = [];
  var db = FirebaseFirestore.instance;
  List<DocumentSnapshot<Object?>> info0 = [];
  List<DocumentSnapshot<Object?>> info1 = [];
  List<DocumentSnapshot<Object?>> info2 = [];
  List<DocumentSnapshot<Object?>> info3 = [];
  Future<void> Getdata() async {
    try {
      List<QuerySnapshot> querySnapshots = await Future.wait([
        db
            .collection('users')
            .doc(Users[0].id)
            .collection('my specialist')
            .doc('Workout plan')
            .collection('wk1 info')
            .get(),
        db
            .collection('users')
            .doc(Users[0].id)
            .collection('my specialist')
            .doc('Workout plan')
            .collection('wk2 info')
            .get(),
        db
            .collection('users')
            .doc(Users[0].id)
            .collection('my specialist')
            .doc('Workout plan')
            .collection('wk3 info')
            .get(),
        db
            .collection('users')
            .doc(Users[0].id)
            .collection('my specialist')
            .doc('Workout plan')
            .collection('wk4 info')
            .get(),
      ]);

      if (!mounted) return;

      setState(() {
        infos = querySnapshots.map((qs) => qs.docs).toList();

        for (int i = 0; i < infos.length; i++) {
          List<DocumentSnapshot<Object?>> element = infos[i];
          if (element.isNotEmpty) {
            infosnotempty.add(element);
            customNames.add(i == 0
                ? 'wk1'
                : i == 1
                    ? 'wk2'
                    : i == 2
                        ? 'wk3'
                        : 'wk4');
          }
        }
      });
    } catch (e) {
      print("Error in Getdata: $e");
    }
  }

  List<DocumentSnapshot> Users = [];
  var UserId;

  getData1() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: UserId)
        .get();

    Users.addAll(qs.docs);

    if (!mounted) return;
    setState(() {});
    Getdata();
    Getdata1();
  }

  List<DocumentSnapshot> workoutscustom = [];
  List<DocumentSnapshot> workoutscustom1 = [];
  List<DocumentSnapshot> workoutscustom2 = [];
  List<DocumentSnapshot> workoutscustom3 = [];
  List<List<DocumentSnapshot>> workoutscustomlist = [];
  List<List<DocumentSnapshot>> workoutscustomlistNotEmpty = [];
  List<String> customNames = [];
  Future<void> Getdata1() async {
    try {
      List<QuerySnapshot> querySnapshots = await Future.wait([
        db
            .collection('users')
            .doc(Users[0].id)
            .collection('my specialist')
            .doc('Workout plan')
            .collection('wk1')
            .get(),
        db
            .collection('users')
            .doc(Users[0].id)
            .collection('my specialist')
            .doc('Workout plan')
            .collection('wk2')
            .get(),
        db
            .collection('users')
            .doc(Users[0].id)
            .collection('my specialist')
            .doc('Workout plan')
            .collection('wk3')
            .get(),
        db
            .collection('users')
            .doc(Users[0].id)
            .collection('my specialist')
            .doc('Workout plan')
            .collection('wk4')
            .get(),
      ]);

      if (!mounted) return;

      List<List<DocumentSnapshot<Object?>>> customLists = [];

      for (int i = 0; i < querySnapshots.length; i++) {
        List<String> wk = [];
        querySnapshots[i].docs.forEach((element) {
          wk.add(element['name']);
        });

        QuerySnapshot workoutQuery = wk.isNotEmpty
            ? await db.collection('workout').where('name', whereIn: wk).get()
            : await db
                .collection('workout')
                .where('name', whereIn: ['-1']).get();

        customLists.add(workoutQuery.docs);
      }

      setState(() {
        workoutscustomlist = customLists;

        workoutscustomlist.forEach((element) {
          if (element.length > 0) {
            workoutscustomlistNotEmpty.add(element);
          }
        });
      });
    } catch (e) {
      print("Error in Getdata1: $e");
    }
  }

  String gender = 'male';

  @override
  void initState() {
    Prefs.getString("Id").then(
      (value) async {
        UserId = await value;
        await getData1();
      },
    );

    Prefs.getString("gender").then(
      (value) async {
        gender = await value;
      },
    );
    super.initState();
  }

  List<Exercises> beginner = [
    armBeginner,
    ChestBeginner,
    AbsBeginner,
    LegBeginner
  ];
  List<Exercises> intermediate = [
    armIntermediate,
    ChestIntermediate,
    AbsIntermediate,
    LegIntermediate
  ];
  List<Exercises> advanced = [
    armAdvanced,
    ChestAdvanced,
    AbsAdvanced,
    LegAdvanced
  ];

  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextStyle whiteSpace = TextStyle(
        letterSpacing: -0.2, fontFamily: 'ITC Avant', fontSize: height * 0.018);
    Widget listtt({
      required String title,
      required List<listviews> list,
      required List<Exercises> exercises,
    }) {
      return Padding(
        padding: EdgeInsets.fromLTRB(5,
            title == 'Custom workouts' || (title == 'Beginner') ? 8 : 5, 5, 5),
        child: Container(
          width: width,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4))
              ],
              borderRadius: BorderRadius.circular(7)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(7, 4, 0, 0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "$title",
                    style: TextStyle(
                        color: Color(0xFF2C2C2C), fontSize: height * 0.0162),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Container(
                  height: height * 0.23,
                  width: width,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.fromLTRB(7, 5, index == 3 ? 7 : 0, 5),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseBody(
                                      list[index].name,
                                      list[index].inddexofTraining),
                                ),
                              );
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 3,
                                        color: Colors.black.withOpacity(0.4),
                                        offset: Offset(0, 2))
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              height: height * 0.22,
                              width: height * 0.24,
                              child: Hero(
                                tag: '${exercises[index].title} f',
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      list[index].photo,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 10),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Material(
                                                  child: Text(
                                                    exercises[index]
                                                        .title
                                                        .toUpperCase(),
                                                    style: whiteSpace,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 3.5),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Material(
                                                        child: Text(
                                                          '${exercises[index].duration} MIN',
                                                          style: whiteSpace,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 3.5),
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Material(
                                                          child: Text(
                                                            '${exercises[index].workouts.length} WORKOUTS',
                                                            style: whiteSpace,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
                            ),
                          ),
                        );
                      },
                      itemCount: list.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget custom1(List<String> custom) {
      return Padding(
        padding: EdgeInsets.fromLTRB(5, 8, 5, 5),
        child: Container(
          width: width,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4))
              ],
              borderRadius: BorderRadius.circular(7)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(7, 4, 0, 0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Custom workouts",
                    style: TextStyle(
                        color: Color(0xFF2C2C2C), fontSize: height * 0.0162),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Container(
                  height: height * 0.23,
                  width: width,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.fromLTRB(7, 5, index == 3 ? 7 : 0, 5),
                          child: InkWell(
                            onTap: () {
                              if (customNames.length > 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Net.ExerciseBodyNET(
                                      '${customNames[index]}',
                                      infosnotempty[index],
                                      workoutscustomlistNotEmpty[index],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 3,
                                        color: Colors.black.withOpacity(0.3),
                                        offset: Offset(0, 2))
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              height: height * 0.22,
                              width: height * 0.24,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'asset/Images/customworkoutlist.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Material(
                                                child: Text(
                                                  infosnotempty[index][0]
                                                          ['name']
                                                      .toUpperCase(),
                                                  style: whiteSpace,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 3.5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Material(
                                                      child: Text(
                                                        '${ //exercises[index].duration
                                                        infosnotempty[index][0]['duration']} MIN',
                                                        style: whiteSpace,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 3.5),
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Material(
                                                        child: Text(
                                                          '${workoutscustomlistNotEmpty.length > 0 ? workoutscustomlistNotEmpty[index].length : 0} WORKOUTS',
                                                          style: whiteSpace,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                          ),
                        );
                      },
                      itemCount: workoutscustomlistNotEmpty.length,
                    ),
                  ),
                ),
              ),
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
          backgroundColor: Color(0xFFF9F9F9),
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
                                  child: Screen1("WHomePage"),
                                  type: PageTransitionType.fade));
                        },
                        child: Users.isNotEmpty
                            ? Container(
                                height: height * 0.034,
                                width: height * 0.034,
                                decoration: material.BoxDecoration(
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
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Workout",
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
                  height: height * 0.04,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: width * 0.35,
                      height: height * 0.055,
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
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: AssessmentHome(
                                      gender: gender, UserId: Users[0].id),
                                  type: PageTransitionType.fade));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // ignore: sort_child_properties_last
                          child: ShaderMask(
                            child: Text(
                              'Take Assessment',
                              style: TextStyle(
                                fontSize: height * 0.016,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(350))),
                          margin: const EdgeInsets.all(2.7),
                        ),
                      ),
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
            child: ListView(children: [
              Column(children: [
                infosnotempty.isEmpty
                    ? Container()
                    : custom1(['wk1', 'wk2', 'wk3', 'wk4']),
                listtt(
                  title: 'Beginner',
                  list: Beginner,
                  exercises: beginner,
                ),
                listtt(
                  title: 'Intermediate',
                  list: Intermediate,
                  exercises: intermediate,
                ),
                listtt(
                  title: 'Advanced',
                  list: advance,
                  exercises: advanced,
                ),
              ]),
            ]),
          )),
    );
  }

  List<listviews> Beginner = [
    listviews("asset/Images/Workout cover/Arm beginner.png", "Beginner", 0),
    listviews("asset/Images/Workout cover/Chest beginner.png", "Beginner", 1),
    listviews("asset/Images/Workout cover/Abs beginner.png", "Beginner", 2),
    listviews("asset/Images/Workout cover/Leg beginner.png", "Beginner", 3),
  ];
  List<listviews> Intermediate = [
    listviews(
        "asset/Images/Workout cover/Arm intermediate.png", "Intermediate", 0),
    listviews(
        "asset/Images/Workout cover/Chest intermediate.png", "Intermediate", 1),
    listviews(
        "asset/Images/Workout cover/Abs intermediate.png", "Intermediate", 2),
    listviews(
        "asset/Images/Workout cover/Leg intermediate.png", "Intermediate", 3),
  ];
  List<listviews> advance = [
    listviews("asset/Images/Workout cover/Arm advanced.png", "advance", 0),
    listviews("asset/Images/Workout cover/Chest advanced.png", "advance", 1),
    listviews("asset/Images/Workout cover/Abs intermediate.png", "advance", 2),
    listviews("asset/Images/Workout cover/Leg advanced.png", "advance", 3),
  ];
}

class listviews {
  var photo;
  String name;
  var inddexofTraining;
  listviews(this.photo, this.name, this.inddexofTraining);
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
