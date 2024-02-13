import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hayaproject/AdminPage/FoodAdmin/FoodPlan.dart';
import 'package:hayaproject/AdminPage/navigatorbarAdmin/NavigationBar.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/Loading.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/WelcomePage.dart'
    as intro;
import 'package:hayaproject/UserPages/WorkoutPage/ExerciseBodyNET.dart';
import 'package:page_transition/page_transition.dart';
import '../../SpecialistPage/MorePage/MorePage.dart';
import 'AddRecipe.dart';

class FoodAdminPage extends StatefulWidget {
  const FoodAdminPage({super.key});

  @override
  State<FoodAdminPage> createState() => _FoodPageState();
}

class RecipeTypes {
  var Images;
  var Name;
  bool isCompleted;

  RecipeTypes(this.Images, this.Name, this.isCompleted);
}

class ButtonData {
  List<RecipeTypes> buttonTitle;

  ButtonData(this.buttonTitle);
}

class _FoodPageState extends State<FoodAdminPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Loading();
    super.initState();
  }

  deleteItem(var id) async {
    await FirebaseFirestore.instance.collection("Food").doc("$id").delete();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Fetch data based on "Type" field
  Future<QuerySnapshot> fetchData(String type) {
    return _firestore.collection('Food').where('Type', isEqualTo: type).get();
  }

  String Type = "Breakfast";
  List<ButtonData> buttonsList = [
    ButtonData([RecipeTypes("FoodImages/Breakfast.png", "Breakfast", true)]),
    ButtonData([RecipeTypes("FoodImages/Lunch.png", "Lunch", false)]),
    ButtonData([RecipeTypes("FoodImages/Dinner.png", "Dinner", false)]),
    ButtonData([RecipeTypes("FoodImages/Snacks.png", "Snacks", false)]),
    ButtonData([RecipeTypes("FoodImages/Dessert.png", "Dessert", false)]),
    ButtonData(
        [RecipeTypes("FoodImages/Appetizers.png", "Soup & Salad", false)]),

    // Add more buttons and lists as needed
  ];
  bool shouldPop = true;
  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }

  bool Isvisible = true;
  void switches(int i) {
    buttonsList[0].buttonTitle[0].isCompleted = i == 0 ? true : false;
    buttonsList[1].buttonTitle[0].isCompleted = i == 1 ? true : false;
    buttonsList[2].buttonTitle[0].isCompleted = i == 2 ? true : false;
    buttonsList[3].buttonTitle[0].isCompleted = i == 3 ? true : false;
    buttonsList[4].buttonTitle[0].isCompleted = i == 4 ? true : false;
    buttonsList[5].buttonTitle[0].isCompleted = i == 5 ? true : false;
  }

  String convertNewLine(String content) {
    print("Converting");
    return content.replaceAll(r'\n', '\n• ');
  }

  String convertNewLineDesc(String content) {
    print("Converting");
    return content.replaceAll(r'.  ', '.\n');
  }

  double Speedopacity = 1;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool isEx1 = false;
    bool isEx2 = false;
    bool isEx3 = false;
    Widget rec;
    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenAdmin(''), type: PageTransitionType.fade));
        return shouldPop;
      },
      child: Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: height * 0.07),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: Speedopacity,
            child: SpeedDial(
              overlayOpacity: 0,
              overlayColor: Colors.black,
              backgroundColor: Color(0xFFFFAA5C),
              icon: Icons.edit,
              animatedIcon: AnimatedIcons.menu_close,
              gradient: RadialGradient(
                  tileMode: TileMode.decal,
                  focal: Alignment.topCenter,
                  stops: [
                    0.2,
                    0.75,
                    1
                  ],
                  colors: [
                    Color(0xFFFFAA5C).withOpacity(0.25),
                    Color.fromARGB(255, 255, 114, 89).withOpacity(0.5),
                    Color.fromARGB(255, 255, 60, 0).withOpacity(0.6),
                  ]),
              children: [
                SpeedDialChild(
                    label: 'Food item',
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: CustomFood(),
                              type: PageTransitionType.fade));
                    },
                    child: Icon(
                      Icons.add_box_outlined,
                      color: Colors.black87,
                    ),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                SpeedDialChild(
                    label: 'Recipe',
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: PvAddRecipe(),
                              type: PageTransitionType.fade));
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.black87,
                    ),
                    backgroundColor: Color.fromARGB(255, 252, 252, 252)),
              ],
            ),
          ),
        ),
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
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      position: PopupMenuPosition.under,
                      onSelected: (String result) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
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
                                            padding: EdgeInsets.only(right: 8),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(Color.fromARGB(
                                                                90,
                                                                255,
                                                                119,
                                                                56))),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF2C2C2C),
                                                        fontFamily: 'UbuntuREG',
                                                        fontSize:
                                                            height * 0.018))),
                                          ),
                                          TextButton(
                                              style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(90,
                                                              255, 119, 56))),
                                              onPressed: () async {
                                                await SetBoolean(
                                                    "IsLogin", false);
                                                Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                        child:
                                                            intro.IntroHome(),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                              child: Text("Logout",
                                                  style: TextStyle(
                                                      color: Color(0xFF2C2C2C),
                                                      fontFamily: 'UbuntuREG',
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
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 7),
                child: Container(
                  height: height * 0.156,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: buttonsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(10, 0,
                              index == buttonsList.length - 1 ? 10 : 0, 7),
                          child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              height: height * 0.15,
                              width: width * 0.27,
                              decoration: BoxDecoration(
                                gradient: buttonsList[index]
                                        .buttonTitle[0]
                                        .isCompleted
                                    ? LinearGradient(colors: [
                                        Color.fromARGB(255, 253, 159, 17),
                                        Colors.orange,
                                        Color.fromARGB(255, 247, 123, 51),
                                        Color.fromARGB(255, 245, 115, 40),
                                        Color.fromARGB(255, 241, 90, 52)
                                      ])
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 4,
                                      offset: Offset(0, 2)),
                                ],
                                color: buttonsList[index]
                                        .buttonTitle[0]
                                        .isCompleted
                                    ? Color.fromARGB(255, 255, 112, 112)
                                    : Color.fromARGB(255, 241, 241, 241),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (!mounted) return;
                                  setState(() {
                                    isloading = true;
                                    Loading();
                                    Type =
                                        buttonsList[index].buttonTitle[0].Name;
                                  });
                                  if (!mounted) return;
                                  setState(() {
                                    switches(index);
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 241, 241, 241),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7))),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            height: height * 0.11,
                                            decoration: BoxDecoration(),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.asset(
                                                buttonsList[index]
                                                    .buttonTitle[0]
                                                    .Images,
                                                fit: BoxFit.cover),
                                          ),
                                          Text(
                                            index == buttonsList.length - 1
                                                ? 'Appetizers'
                                                : buttonsList[index]
                                                    .buttonTitle[0]
                                                    .Name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontFamily: 'UbuntuREG',
                                              color: Color(0xFF2C2C2C),
                                              fontSize: height * 0.016,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7),
                child: FutureBuilder(
                    future: fetchData(Type),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            width: width * 0.96,
                            child: ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            blurRadius: 4,
                                            offset: Offset(0, 2))
                                      ]),
                                      height: height * 0.3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet<dynamic>(
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      14))),
                                              context: context,
                                              builder: (BuildContext bc) {
                                                return StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        setState) {
                                                  Widget NewEx(
                                                      VoidCallback fn,
                                                      bool ex,
                                                      String txt,
                                                      Widget content) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(fn);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: Column(
                                                          children: [
                                                            AnimatedContainer(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          120),
                                                              width: width,
                                                              height:
                                                                  height * 0.08,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      boxShadow: [
                                                                    BoxShadow(
                                                                        color: const Color(0xFFFEF4EF).withOpacity(
                                                                            0.45),
                                                                        inset:
                                                                            true,
                                                                        spreadRadius:
                                                                            200),
                                                                    CustomBoxShadow(
                                                                        blurStyle:
                                                                            BlurStyle
                                                                                .outer,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.25),
                                                                        blurRadius:
                                                                            6,
                                                                        offset: const Offset(
                                                                            0,
                                                                            0))
                                                                  ]),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    child: Text(
                                                                      '$txt',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'UbuntuREG',
                                                                          fontSize:
                                                                              height * 0.025),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10),
                                                                    child:
                                                                        AnimatedRotation(
                                                                      turns: ex
                                                                          ? 0.75
                                                                          : 1 /
                                                                              2,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              120),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_back_ios_new_rounded,
                                                                        size: height *
                                                                            0.026,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            AnimatedSize(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          120),
                                                              child:
                                                                  AnimatedSwitcher(
                                                                reverseDuration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            0),
                                                                switchInCurve:
                                                                    Curves
                                                                        .fastLinearToSlowEaseIn,
                                                                switchOutCurve:
                                                                    Curves
                                                                        .fastEaseInToSlowEaseOut,
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            150),
                                                                child: ex
                                                                    ? rec =
                                                                        Align(
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10,
                                                                              vertical: 5),
                                                                          child: Container(
                                                                              key: const ValueKey<int>(0),
                                                                              child: content),
                                                                          /*  Text(
                                                                            '$content',
                                                                            style: TextStyle(
                                                                                color: Color(0xFF1E1E1E).withOpacity(
                                                                                    0.85),
                                                                                fontSize: size.height *
                                                                                    0.019,
                                                                                fontFamily:
                                                                                    'UbuntuREG'),
                                                                          ),*/
                                                                        ),
                                                                      )
                                                                    : rec =
                                                                        Container(
                                                                        key: const ValueKey<
                                                                            int>(1),
                                                                      ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  return ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    14)),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: ScrollConfiguration(
                                                      behavior:
                                                          const ScrollBehavior(),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Stack(
                                                          children: [
                                                            Positioned.fill(
                                                              child: Image.asset(
                                                                  'asset/asset Images Rand/FoodBack.png'),
                                                            ),
                                                            BackdropFilter(
                                                              filter: ImageFilter
                                                                  .blur(
                                                                      sigmaX:
                                                                          80,
                                                                      sigmaY:
                                                                          80),
                                                              child: Container(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: [
                                                                    /////////////////////IMG
                                                                    Container(
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              14),
                                                                        ),
                                                                      ),
                                                                      height:
                                                                          height *
                                                                              0.28,
                                                                      child:
                                                                          Stack(
                                                                        fit: StackFit
                                                                            .passthrough,
                                                                        children: [
                                                                          Image
                                                                              .network(
                                                                            "${snapshot.data?.docs[index]['ImageUrl']}", ///////////////////////////comeback
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                          Container(
                                                                            /////shadow
                                                                            decoration:
                                                                                BoxDecoration(boxShadow: [
                                                                              BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 15, inset: true, offset: const Offset(0, -80))
                                                                            ]),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomLeft,
                                                                            child:
                                                                                Container(
                                                                              width: width * 0.9,
                                                                              margin: const EdgeInsets.all(7),
                                                                              child: Text(
                                                                                snapshot.data?.docs[index]['name'],
                                                                                style: TextStyle(shadows: [
                                                                                  Shadow(blurRadius: 12, offset: const Offset(0, 4), color: Colors.black.withOpacity(0.45))
                                                                                ], fontSize: height * 0.035, color: Colors.white, fontFamily: 'UbuntuREG'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    //////////////////////IMG
                                                                    NewEx(() {
                                                                      isEx1 ==
                                                                              false
                                                                          ? {
                                                                              isEx1 = true,
                                                                              isEx2 = false,
                                                                              isEx3 = false
                                                                            }
                                                                          : isEx1 =
                                                                              false;
                                                                    },
                                                                        isEx1,
                                                                        'Ingredients',
                                                                        Text(
                                                                            '• ${convertNewLine(snapshot.data?.docs[index]['ingredients'])}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: const Color(0xFF1E1E1E).withOpacity(0.85),
                                                                              fontSize: height * 0.017,
                                                                              fontFamily: 'UbuntuREG',
                                                                            ))),
                                                                    NewEx(() {
                                                                      isEx2 ==
                                                                              false
                                                                          ? {
                                                                              isEx1 = false,
                                                                              isEx3 = false,
                                                                              isEx2 = true
                                                                            }
                                                                          : isEx2 =
                                                                              false;
                                                                    },
                                                                        isEx2,
                                                                        'Directions',
                                                                        Text(
                                                                          '${convertNewLineDesc(snapshot.data?.docs[index]['Desc'])}',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                const Color(0xFF1E1E1E).withOpacity(0.85),
                                                                            fontSize:
                                                                                height * 0.017,
                                                                            fontFamily:
                                                                                'UbuntuREG',
                                                                          ),
                                                                        )),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          NewEx(
                                                                        () {
                                                                          isEx3 == false
                                                                              ? {
                                                                                  isEx1 = false,
                                                                                  isEx2 = false,
                                                                                  isEx3 = true
                                                                                }
                                                                              : isEx3 = false;
                                                                        },
                                                                        isEx3,
                                                                        'Nutritional information',
                                                                        Text(
                                                                          snapshot
                                                                              .data
                                                                              ?.docs[index]['Benefit'],
                                                                          style: TextStyle(
                                                                              color: const Color(0xFF1E1E1E).withOpacity(0.85),
                                                                              fontSize: height * 0.017,
                                                                              fontFamily: 'UbuntuREG'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                color: Colors.white,
                                                height: height * 0.3,
                                                width: width * 0.96,
                                                child: Image.network(
                                                  "${snapshot.data?.docs[index]['ImageUrl']}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  height: height * 0.12,
                                                  decoration:
                                                      BoxDecoration(boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 15,
                                                        inset: true,
                                                        offset: const Offset(
                                                            0, -80))
                                                  ]),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 12, left: 10),
                                                  child: Container(
                                                    width: width * 0.8,
                                                    child: Text(
                                                      '${snapshot.data?.docs[index]['name']}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          shadows: [
                                                            Shadow(
                                                                blurRadius: 12,
                                                                offset:
                                                                    const Offset(
                                                                        0, 4),
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.45))
                                                          ],
                                                          fontSize:
                                                              height * 0.035,
                                                          fontFamily:
                                                              'UbuntuREG'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: PopupMenuButton<String>(
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  7))),
                                                  position:
                                                      PopupMenuPosition.under,
                                                  onSelected: (String result) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Center(
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7))),
                                                            width: width * 0.8,
                                                            height:
                                                                height * 0.18,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              14),
                                                                  child: Text(
                                                                    "Are you sure you want to delete this recipe?",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            height *
                                                                                0.024,
                                                                        color: Color(
                                                                            0xFF2C2C2C),
                                                                        fontFamily:
                                                                            'UbuntuREG'),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              12),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 8),
                                                                        child: TextButton(
                                                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Color.fromARGB(90, 255, 119, 56))),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text("Cancel", style: TextStyle(color: Color(0xFF2C2C2C), fontFamily: 'UbuntuREG', fontSize: height * 0.018))),
                                                                      ),
                                                                      TextButton(
                                                                          style: ButtonStyle(
                                                                              overlayColor: MaterialStateProperty.all(Color.fromARGB(90, 255, 119,
                                                                                  56))),
                                                                          onPressed:
                                                                              () {
                                                                            deleteItem(snapshot.data?.docs[index].id);
                                                                            snapshot.data?.docs.removeAt(index);
                                                                            setState(() {});
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Text(
                                                                              "Delete",
                                                                              style: TextStyle(color: Color(0xFF2C2C2C), fontFamily: 'UbuntuREG', fontSize: height * 0.018)))
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
                                                      <PopupMenuEntry<String>>[
                                                    PopupMenuItem<String>(
                                                      height: height * 0.04,
                                                      value: 'Delete',
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF2C2C2C),
                                                            fontSize:
                                                                height * 0.017),
                                                      ),
                                                    ),
                                                  ],
                                                  icon: Icon(
                                                    Icons.more_vert_outlined,
                                                    color: Colors.white,
                                                    size: height * 0.035,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 2))
                                                    ],
                                                  ), // The icon to display for the menu button (Icon person)
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ));
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
            ]),
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

SetBoolean(String key, bool value) async {
  await Prefs.setBoolean(key, value);
}
