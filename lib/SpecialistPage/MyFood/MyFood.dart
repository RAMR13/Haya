import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/Loading.dart';
import 'package:hayaproject/SpecialistPage/MorePage/MorePage.dart';
import 'package:page_transition/page_transition.dart';

import '../navigatorbarSpec/NavigatorbarSpec.dart';

class CustomFood extends StatefulWidget {
  const CustomFood({super.key});

  @override
  State<CustomFood> createState() => _MyEventsState();
}

class _MyEventsState extends State<CustomFood> {
  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return DefaultTabController(
        length: 3,
        child: WillPopScope(
          onWillPop: () async {
            if (shouldPop)
              Navigator.pushReplacement<void, void>(
                  context,
                  PageTransition(
                      child: MainScreenSpec(""),
                      type: PageTransitionType.fade));
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
                                  child: More("CustomFood"),
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
                            "Nutrition",
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(height * 0.07),
                child: TabBar(
                    indicatorColor: Color.fromARGB(255, 238, 85, 39),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Color.fromARGB(255, 238, 85, 39),
                    unselectedLabelColor: Color.fromARGB(255, 204, 204, 204),
                    tabs: [
                      Tab(
                        text: "Breakfast",
                        icon: Icon(Icons.free_breakfast),
                      ),
                      Tab(
                        text: "Lunch",
                        icon: Icon(Icons.lunch_dining),
                      ),
                      Tab(
                        text: "Dinner",
                        icon: Icon(Icons.kebab_dining_rounded),
                      ),
                    ]),
              ),
            ),
            body: TabBarView(children: [
              MyFoodPage('breakfast'),
              MyFoodPage('lunch'),
              MyFoodPage('dinner')
            ]),
          ),
        ));
  }
}

class MyFoodPage extends StatefulWidget {
  late String type;
  MyFoodPage(this.type);
  @override
  State<MyFoodPage> createState() => _CreateEventState(type);
}

class _CreateEventState extends State<MyFoodPage> {
  late String type;
  _CreateEventState(this.type);
  late Query<Map<String, dynamic>> qs = FirebaseFirestore.instance
      .collection("foodplan")
      .where('type', isEqualTo: '$type');

  List<food2> customList = [];
  bool speed2 = false;
  List<DocumentSnapshot> allfood = [];
  late List<food2> allWorkoutsLocal = [];

  getData() async {
    allfood = [];
    QuerySnapshot qss = await FirebaseFirestore.instance
        .collection("foodplan")
        .where('type', isEqualTo: '$type')
        .get();
    // await FirebaseFirestore.instance.collection("foodplan").get();

    allfood.addAll(qss.docs);

    await wklocalget();
  }

  bool isloading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  String search = '';
  bool Isvisible = false;
  bool lock = false;
  wklocalget() {
    allWorkoutsLocal = [];
    for (int i = 0; i < allfood.length; i++) {
      allWorkoutsLocal.add(food2(
          name: allfood[i]['name'],
          cal: allfood[i]['cal'],
          type: allfood[i]['type'],
          id: allfood[i].id));
    }
    if (!mounted) return;
    setState(() {});
  }

  double opacity = 0;
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 0), () {
      opacity = 1;
    });
    String workoutName;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      body: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 150),
        child: StreamBuilder(
            stream: qs.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              }
              if (lock == false) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return test1(20.0, 20.0);
                }
                lock = true;
              }
              /*  if (i == 0) {
                    wklocalget();
                    i++;
                  }*/

              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: allWorkoutsLocal
                      .length, //snapshot.data?.docs.length, //allWorkouts.length, //variable
                  itemBuilder: (BuildContext context, int index) {
                    if (index == snapshot.data?.docs.length)
                      return Container(
                        height: height * 0.09,
                      );
                    else
                      workoutName = allWorkoutsLocal[index].name.toLowerCase();
                    return workoutName.contains(search.toLowerCase())
                        ? GestureDetector(
                            onTap: () {
                              if (!mounted) return;
                              setState(() {
                                if (customList
                                    .contains(allWorkoutsLocal[index]))
                                  customList.remove(allWorkoutsLocal[index]);
                                else
                                  customList.add(allWorkoutsLocal[index]);
                              });
                            },
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    15, index == 0 ? 10 : 5, 15, 5),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: index ==
                                              snapshot.data!.docs.length - 1
                                          ? height * 0.07
                                          : 0),

                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(64, 0, 0, 0),
                                            blurRadius: 3,
                                            offset: Offset(0, 2))
                                      ],
                                      color: Color.fromARGB(247, 250, 250, 250),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  height: height * 0.112, //95,

                                  child: Container(
                                      child: Row(children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Container(
                                        width: width * 0.02,
                                        padding: EdgeInsets.all(7),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Container(
                                            width: width *
                                                0.7, // size.width * 0.5,
                                            child: Text(
                                                "${allWorkoutsLocal[index].name}",
                                                style: TextStyle(
                                                    color: Color(0xFF2C2C2C),
                                                    fontSize:
                                                        height * 0.023 //20
                                                    )),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 15),
                                          child: Text(
                                            ' ${allWorkoutsLocal[index].cal} cal',
                                            style: TextStyle(
                                                fontSize: height * 0.017, //2
                                                color: Color.fromARGB(
                                                    255, 95, 95, 95)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])),
                                )),
                          )
                        : Container();
                  },
                );
              }
              if (snapshot.hasError) {
                Future.delayed(Duration(microseconds: 2), () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
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

class food2 {
  late String name;
  late String type;
  late String cal;
  late String id;
  food2(
      {required String cal,
      required String name,
      required String type,
      required String id}) {
    this.name = name;
    this.type = type;
    this.cal = cal;
    this.id = id;
  }
}
