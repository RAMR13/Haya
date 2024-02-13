import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/Chat/ChatPage.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';
import 'package:page_transition/page_transition.dart';

class FoodPlan extends StatefulWidget {
  var receiverUserEmail;
  var receiverUserID;
  var name;
  var image;
  var type;
  var senderId;
  var Senderemail;

  FoodPlan(
      {required this.name,
      required this.image,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.type,
      required this.senderId,
      required this.Senderemail});

  @override
  State<FoodPlan> createState() => _FoodPlanState();
}

class _FoodPlanState extends State<FoodPlan> {
  bool isloading = true;
  List allfood = [];
  List<DocumentSnapshot> Users = [];

  List<food> allbreakfastlocal = [];
  List<food> alllunchlocal = [];
  List<food> alldinnerlocal = [];

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }

  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("foodplan")
        .orderBy('name')
        .get();
    allfood.addAll(qs.docs);
  }

  getDataMyUser() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: widget.receiverUserID)
        .get();
    Users.addAll(qs.docs);
    if (!mounted) return;
    setState(() {});
    await getData2();
  }

  ///////////////////////////////////////
  String days = '';
  String water = '';
  String notes = '';
  List data = [];
  List allfood2 = [];
  TextEditingController Notes = TextEditingController();

  getData2() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Food plan')
        .collection('food')
        .get();
    QuerySnapshot qs1 = await FirebaseFirestore.instance
        .collection("users")
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Food plan')
        .collection('data')
        .get();
    data.addAll(qs1.docs);
    days = data[0]['days'];
    water = data[0]['water'];
    notes = data[0]['notes'];
    allfood2.addAll(qs.docs);
    for (int i = 0; i < allfood2.length; i++) {
      customList.add(food(
          name: allfood2[i]['name'],
          cal: allfood2[i]['cal'],
          type: allfood2[i]['type']));
    }
    if (!mounted) return;
    setState(() {
      Notes = TextEditingController(text: data[0]['notes']);
    });
    valueWater = Slide(double.parse(water) / 15);
    valueDay = Slide(double.parse(days) / 7);
  }

  ///////////////////////////////////////
  bool hide = true;
  List allbreakfast = [];
  List alllunch = [];
  List alldinner = [];

  @override
  void initState() {
    Loading();
    getData();
    getDataMyUser();
    super.initState();
  }

  exp expandedOne = exp(false);
  exp expandedTwo = exp(false);
  exp expandedThree = exp(false);

  List<food> customList = [];

  int j3 = 0;
  int j1 = 0;
  int j2 = 0;
  int j4 = 0;
  List<food> breakfastCustom = [];
  List<food> lunchCustom = [];
  List<food> dinnerCustom = [];
  Slide valueWater = Slide(0);
  Slide valueDay = Slide(0);

  bool hasAllLists(List<food> custom) {
    bool hasbreakfast = false;
    bool haslunch = false;
    bool hasdinner = false;
    custom.forEach((element) {
      if (allbreakfastlocal.contains(element)) {
        hasbreakfast = true;
      }
      if (alldinnerlocal.contains(element)) {
        hasdinner = true;
      }
      if (alllunchlocal.contains(element)) {
        haslunch = true;
      }
    });
    if (hasbreakfast &&
        hasdinner &&
        haslunch &&
        (valueWater.slide * 15).toInt() != 0 &&
        (valueDay.slide * 15).toInt() != 0 &&
        Notes.text.isNotEmpty) return true;
    return false;
  }

  final dataKey = new GlobalKey();
  bool ischanged = false;

  @override
  Widget build(BuildContext context) {
    allfood.forEach((element) {
      if (element['type'] == 'breakfast') allbreakfast.add(element);
      if (element['type'] == 'lunch') alllunch.add(element);
      if (element['type'] == 'dinner') alldinner.add(element);
    });

    if (j1 == 0) {
      for (int i = 0; i < alllunch.length; i++) {
        alllunchlocal.add(food(
            name: alllunch[i]['name'],
            cal: alllunch[i]['cal'],
            type: alllunch[i]['type']));
        j1 = 1;
      }
    }
    if (j2 == 0) {
      for (int i = 0; i < alldinner.length; i++) {
        alldinnerlocal.add(food(
            name: alldinner[i]['name'],
            cal: alldinner[i]['cal'],
            type: alldinner[i]['type']));
        j2 = 1;
      }
    }
    if (j3 == 0) {
      for (int i = 0; i < allbreakfast.length; i++) {
        allbreakfastlocal.add(food(
            name: allbreakfast[i]['name'],
            cal: allbreakfast[i]['cal'],
            type: allbreakfast[i]['type']));
        j3 = 1;
      }
    }
    // if (j4 == 0) {
    //   for (int i = 0; i < allfood2.length; i++) {
    //     customList.add(food(
    //         name: allfood2[i]['name'],
    //         cal: allfood2[i]['cal'],
    //         type: allfood2[i]['type']));
    //     j4 = 1;
    //   }
    // }

    var db = FirebaseFirestore.instance;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    Widget kk(exp expanded, String Title, List<food> allLocal, List all) {
      return Center(
          child: Padding(
        padding: EdgeInsets.only(top: 8),
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (Title == 'Breakfast') {
                expandedOne.isexp = !expandedOne.isexp;
                expandedTwo.isexp = false;
                expandedThree.isexp = false;
              }
              if (Title == 'Lunch') {
                expandedTwo.isexp = !expandedTwo.isexp;
                expandedOne.isexp = false;
                expandedThree.isexp = false;
              }
              if (Title == 'Dinner') {
                expandedThree.isexp = !expandedThree.isexp;
                expandedTwo.isexp = false;
                expandedOne.isexp = false;
              }
            });
          },
          child: AnimatedContainer(
            clipBehavior: Clip.antiAlias,
            duration: Duration(milliseconds: 170),
            width: width * 0.97,
            height: expanded.isexp == true ? height * 0.45 : height * 0.115,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 170),
                  width: width,
                  height:
                      expanded.isexp == true ? height * 0.45 : height * 0.115,
                  child: Image.asset(
                    'Images/Left.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: IgnorePointer(
                    ignoring: expanded.isexp ? false : true,
                    child: GestureDetector(
                      onTap: () {},
                      child: AnimatedContainer(
                        color: Colors.transparent,
                        duration: Duration(milliseconds: 170),
                        height: expanded.isexp
                            ? size.height * 0.38
                            : size.height * 0.07,
                        width: size.width * 0.97,
                        child: IgnorePointer(
                          ignoring: expanded.isexp ? false : true,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 150),
                            opacity: expanded.isexp ? 1 : 0,
                            child: Stack(
                              children: [
                                ScrollConfiguration(
                                  behavior: MyBehavior(),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(0),
                                    itemCount: allLocal.length,
                                    //variable
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (customList.any((element) =>
                                                element.name ==
                                                allLocal[index].name)) {
                                              customList.removeWhere(
                                                  (element) =>
                                                      allLocal[index].name ==
                                                      element.name);
                                            } else {
                                              customList.add(allLocal[index]);
                                            }
                                            customList.forEach((element) {
                                              print(element.name);
                                            });
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15,
                                                index == 0 ? 13 : 5,
                                                15,
                                                index == allLocal.length - 1
                                                    ? 13
                                                    : 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Color.fromARGB(
                                                            64, 0, 0, 0),
                                                        blurRadius: 3,
                                                        offset: Offset(0, 2))
                                                  ],
                                                  color: Color.fromARGB(
                                                      247, 250, 250, 250),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              height: size.height * 0.095,
                                              //95,

                                              child: Container(
                                                  child: Row(children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 5, 0, 0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 7),
                                                        child: Container(
                                                          width: width * 0.6,
                                                          child: Text(
                                                              all[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF2C2C2C),
                                                                  fontSize: size
                                                                          .height *
                                                                      0.023 //20
                                                                  )),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              7, 0, 0, 7),
                                                      child: Text(
                                                          '${all[index]['cal']} cal'),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 20, 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 150),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: customList.any((element) =>
                                                                      element
                                                                          .name ==
                                                                      allLocal[
                                                                              index]
                                                                          .name)
                                                                  ? Colors
                                                                      .transparent
                                                                  : Color(
                                                                      0xFF686868)),
                                                          boxShadow: [],
                                                          shape:
                                                              BoxShape.circle,
                                                          color: customList.any(
                                                                  (element) =>
                                                                      element
                                                                          .name ==
                                                                      allLocal[
                                                                              index]
                                                                          .name)
                                                              ? Color(
                                                                  0xFF53DB81)
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        width:
                                                            size.width * 0.062,
                                                        //25,
                                                        height:
                                                            size.height * 0.062,
                                                        child: Visibility(
                                                          visible: customList
                                                              .any((element) =>
                                                                  element
                                                                      .name ==
                                                                  allLocal[
                                                                          index]
                                                                      .name),
                                                          child: Icon(
                                                            Icons.check_rounded,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ])),
                                            )),
                                      );
                                    },
                                  ),
                                ),
                                IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    height: height * 0.03,
                                    width: width * 0.97,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                          Color.fromARGB(255, 0, 0, 0)
                                              .withOpacity(0.15),
                                          const Color.fromARGB(0, 255, 255, 255)
                                        ],
                                            stops: [
                                          0.01,
                                          0.6
                                        ],
                                            begin:
                                                AlignmentDirectional.topCenter,
                                            end: Alignment.bottomCenter)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Container(
                                      height: height * 0.03,
                                      width: width * 0.97,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                            Color.fromARGB(255, 0, 0, 0)
                                                .withOpacity(0.15),
                                            const Color.fromARGB(
                                                0, 255, 255, 255)
                                          ],
                                              stops: [
                                            0.01,
                                            0.6
                                          ],
                                              begin: AlignmentDirectional
                                                  .bottomCenter,
                                              end: Alignment.topCenter)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 1),
                    opacity: expanded.isexp ? 0 : 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4, left: 5, bottom: 10),
                        child: Text('${Title}',
                            style: TextStyle(
                                fontSize: height * 0.03,
                                color: Color(0xFF2C2C2C),
                                fontFamily: 'UbuntuREG')),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 180),
                    opacity: expanded.isexp ? 1 : 0,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4, left: 5, bottom: 10),
                        child: Text('$Title',
                            style: TextStyle(
                                fontSize: height * 0.016,
                                color: Color(0xFF2C2C2C),
                                fontFamily: 'UbuntuREG')),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: expanded.isexp ? 0 : 4),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedRotation(
                          duration: Duration(milliseconds: 140),
                          turns: expanded.isexp ? 1.25 : 0.75,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF2C2C2C),
                            size: height * 0.022,
                          ))),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
                borderRadius: BorderRadius.all(Radius.circular(7))),
          ),
        ),
      ));
    }

    Widget slide(
      Slide val,
      int div,
    ) {
      return Padding(
        padding: EdgeInsetsDirectional.only(top: 0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(7)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2))
              ]),
          height: height * 0.24,
          width: width * 0.97 / 2.04,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 4, left: 5),
                  child: Text(
                    div == 7 ? 'Number of days' : 'Hydration',
                    style: TextStyle(
                        fontSize: height * 0.016,
                        color: Color(0xFF2C2C2C),
                        fontFamily: 'UbuntuREG'),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: width * 0.3,
                      height: height * 0.15,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(val.slide * div).toInt()}',
                            style: TextStyle(
                                fontSize: height * 0.07,
                                color: Color(0xFF2C2C2C)),
                          ),
                          Text(
                            div == 7 ? 'Days' : 'Cups/day',
                            style: TextStyle(
                                fontFamily: 'UbuntuREG',
                                fontSize: height * 0.016),
                          )
                        ],
                      ))),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                        activeColor: Color.fromARGB(255, 255, 104, 17),
                        inactiveColor: Color.fromARGB(255, 252, 216, 200),
                        divisions: div,
                        value: val.slide,
                        onChanged: (value) {
                          setState(() {
                            val.slide = value;
                          });
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
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
                      child: ChatPage(
                          name: widget.name,
                          image: widget.image,
                          receiverUserEmail: widget.receiverUserEmail,
                          receiverUserID: widget.receiverUserID,
                          type: widget.type,
                          senderId: widget.senderId,
                          Senderemail: widget.Senderemail),
                      type: PageTransitionType.leftToRightWithFade),
                );
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF2C2C2C),
                size: height * 0.032,
              ),
            ),
            Text(
              "Custom diet",
              style: TextStyle(
                  fontSize: height * 0.028,
                  color: Color(0xFF2C2C2C),
                  fontWeight: FontWeight.w300),
            ),
            GestureDetector(
              onTap: () async {
                if (hasAllLists(customList)) {
                  await db
                      .collection('users')
                      .doc(Users[0].id)
                      .collection('my specialist')
                      .doc('Food plan')
                      .collection('data')
                      .doc('0')
                      .set({
                    'water': '${(valueWater.slide * 15).toInt()}',
                    'days': '${(valueDay.slide * 7).toInt()}',
                    'notes': Notes.text
                  });
                  for (int i = 0; i < customList.length; i++) {
                    await db
                        .collection('users')
                        .doc(Users[0].id)
                        .collection('my specialist')
                        .doc('Food plan')
                        .collection('food')
                        .doc('$i')
                        .set({
                      'name': customList[i].name,
                      'type': customList[i].type,
                      'cal': customList[i].cal,
                    });
                  }
                  Navigator.pushReplacement<void, void>(
                    context,
                    PageTransition(
                        child: ChatPage(
                            name: widget.name,
                            image: widget.image,
                            receiverUserEmail: widget.receiverUserEmail,
                            receiverUserID: widget.receiverUserID,
                            type: widget.type,
                            senderId: widget.senderId,
                            Senderemail: widget.Senderemail),
                        type: PageTransitionType.leftToRightWithFade),
                  );
                }
              },
              child: Icon(
                color: hasAllLists(customList)
                    ? Color.fromARGB(255, 56, 175, 96)
                    : Colors.grey,
                Icons.done,
                size: size.height * 0.038,
              ),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement<void, void>(
            context,
            PageTransition(
                child: ChatPage(
                    name: widget.name,
                    image: widget.image,
                    receiverUserEmail: widget.receiverUserEmail,
                    receiverUserID: widget.receiverUserID,
                    type: widget.type,
                    senderId: widget.senderId,
                    Senderemail: widget.Senderemail),
                type: PageTransitionType.leftToRightWithFade),
          );
          return Future.value(true);
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              kk(expandedOne, 'Breakfast', allbreakfastlocal, allbreakfast),
              kk(expandedTwo, 'Lunch', alllunchlocal, alllunch),
              kk(expandedThree, 'Dinner', alldinnerlocal, alldinner),
              Container(
                  height: height * 0.26,
                  width: width * 0.97,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [slide(valueWater, 15), slide(valueDay, 7)])),
              Padding(
                padding: EdgeInsets.only(top: 4, bottom: 10),
                child: Container(
                  width: width * 0.97,
                  child: TextField(
                    controller: Notes,
                    key: dataKey,
                    onTap: () {
                      Scrollable.ensureVisible(dataKey.currentContext!);
                    },
                    onChanged: (value) {},
                    style: TextStyle(
                        color: Color(0xFF2C2C2C), fontSize: height * 0.02),
                    cursorHeight: height * 0.024,
                    cursorColor: Color(0xFF2C2C2C),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 22, horizontal: 12),
                      label: Text(
                        "Notes",
                        style: TextStyle(
                            color: Color(0xFF2c2c2c),
                            fontSize: height * 0.02,
                            fontFamily: 'UbuntuREG'),
                      ),
                      labelStyle: const TextStyle(color: Color(0xFF2c2c2c)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepOrangeAccent,
                          width: 1.3,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(7.0)), // Sets border radius
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(7.0)), // Sets border radius
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class exp {
  bool isexp;

  exp(this.isexp) {}
}

class Slide {
  double slide;

  Slide(this.slide) {}
}

class food {
  late String name;
  late String type;
  late String cal;

  food({required String cal, required String name, required String type}) {
    this.name = name;
    this.type = type;
    this.cal = cal;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
