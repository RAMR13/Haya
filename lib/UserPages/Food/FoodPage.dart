import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/MorePage/screen1.dart';
import 'package:hayaproject/test.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as material;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import '../../Loading.dart';
import '../navigatorbarUser/NavigationBar.dart';
import 'dart:ui';

import 'dart:ui';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
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

class _FoodPageState extends State<FoodPage>
    with SingleTickerProviderStateMixin {
  List<DocumentSnapshot> Users = [];
  List<DocumentSnapshot> UsersFood = [];

  var UserId;
  getData1() async {
    Prefs.getString("Id").then(
      (value) {
        UserId = value;
      },
    );
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: "$UserId")
        .get();
    Users.addAll(qs.docs);
    if (!mounted) return;
    getData();
  }

  @override
  void initState() {
    Prefs.getString("Id").then(
      (value) async {
        UserId = await value;
        await getData1();
      },
    );
    super.initState();
  }

  getData() async {
    print(UserId);

    print(Users[0].id);

    QuerySnapshot qs1 = await FirebaseFirestore.instance
        .collection("users")
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Food plan')
        .collection('data')
        .get();
    UsersFood.addAll(qs1.docs);
    if (!mounted) return;
    setState(() {});
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Fetch data based on "Type" field
  Future<QuerySnapshot> fetchData(String type) {
    return _firestore.collection('Food').where('Type', isEqualTo: type).get();
  }

  bool isSubscribed = true;

  var Imagesurl = "https://firsthayaproject.appspot.com/foodimages/eggs.jpg";
  String Type = "Breakfast";
  List<ButtonData> buttonsList = [
    ButtonData([RecipeTypes("FoodImages/4773355.png", "Nutritionist", false)]),
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

  void switches(int i) {
    buttonsList[0].buttonTitle[0].isCompleted = i == 0 ? true : false;
    buttonsList[1].buttonTitle[0].isCompleted = i == 1 ? true : false;
    buttonsList[2].buttonTitle[0].isCompleted = i == 2 ? true : false;
    buttonsList[3].buttonTitle[0].isCompleted = i == 3 ? true : false;
    buttonsList[4].buttonTitle[0].isCompleted = i == 4 ? true : false;
    buttonsList[5].buttonTitle[0].isCompleted = i == 5 ? true : false;
    buttonsList[6].buttonTitle[0].isCompleted = i == 6 ? true : false;
  }

  String convertNewLine(String content) {
    print("Converting");
    return content.replaceAll(r'\n', '\n• ');
  }

  String convertNewLineDesc(String content) {
    print("Converting");
    return content.replaceAll(r'.  ', '.\n');
  }

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
                                child: Screen1("FoodPage"),
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
                      itemCount: UsersFood.isEmpty
                          ? buttonsList.length - 1
                          : buttonsList.length,
                      itemBuilder: (context, index) {
                        index = UsersFood.isEmpty ? index + 1 : index = index;
                        return index == buttonsList.length
                            ? GestureDetector(
                                onTap: () {
                                  switches(6);
                                },
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 206, 113, 107),
                                  width: 100,
                                  height: 20,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.fromLTRB(
                                    10,
                                    0,
                                    index == buttonsList.length - 1 ? 10 : 0,
                                    7),
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
                                            color:
                                                Colors.black.withOpacity(0.25),
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
                                          Type = buttonsList[index]
                                              .buttonTitle[0]
                                              .Name;
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
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
                                                  child: index == 0
                                                      ? Icon(
                                                          MyFlutterApp
                                                              .apple_whole_solid_1,
                                                          size: height * 0.08,
                                                          color: Color.fromARGB(
                                                              255, 59, 59, 59),
                                                        )
                                                      : Image.asset(
                                                          buttonsList[index]
                                                              .buttonTitle[0]
                                                              .Images,
                                                          fit: BoxFit.cover),
                                                ),
                                                Text(
                                                  index ==
                                                          buttonsList.length - 1
                                                      ? 'Appetizers'
                                                      : buttonsList[index]
                                                          .buttonTitle[0]
                                                          .Name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                              child:
                                  buttonsList[0].buttonTitle[0].isCompleted ==
                                          true
                                      ? Container(
                                          width: width,
                                          child: FoodPlanUser(),
                                        )
                                      : ListView.builder(
                                          itemCount: snapshot.data?.docs.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8),
                                              child: Container(
                                                decoration:
                                                    BoxDecoration(boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2))
                                                ]),
                                                height: height * 0.3,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7)),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet<
                                                          dynamic>(
                                                        isScrollControlled:
                                                            true,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            14))),
                                                        context: context,
                                                        builder:
                                                            (BuildContext bc) {
                                                          return StatefulBuilder(
                                                              builder:
                                                                  (BuildContext
                                                                          context,
                                                                      setState) {
                                                            Widget NewEx(
                                                                VoidCallback fn,
                                                                bool ex,
                                                                String txt,
                                                                Widget
                                                                    content) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  setState(fn);
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                                  child: Column(
                                                                    children: [
                                                                      AnimatedContainer(
                                                                        duration:
                                                                            const Duration(milliseconds: 120),
                                                                        width:
                                                                            width,
                                                                        height: height *
                                                                            0.08,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                                boxShadow: [
                                                                              BoxShadow(color: const Color(0xFFFEF4EF).withOpacity(0.45), inset: true, spreadRadius: 200),
                                                                              CustomBoxShadow(blurStyle: BlurStyle.outer, color: Colors.black.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 0))
                                                                            ]),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Text(
                                                                                '$txt',
                                                                                style: TextStyle(fontFamily: 'UbuntuREG', fontSize: height * 0.025),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 10),
                                                                              child: AnimatedRotation(
                                                                                turns: ex ? 0.75 : 1 / 2,
                                                                                duration: const Duration(milliseconds: 120),
                                                                                child: Icon(
                                                                                  Icons.arrow_back_ios_new_rounded,
                                                                                  size: height * 0.026,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      AnimatedSize(
                                                                        duration:
                                                                            const Duration(milliseconds: 120),
                                                                        child:
                                                                            AnimatedSwitcher(
                                                                          reverseDuration:
                                                                              const Duration(milliseconds: 0),
                                                                          switchInCurve:
                                                                              Curves.fastLinearToSlowEaseIn,
                                                                          switchOutCurve:
                                                                              Curves.fastEaseInToSlowEaseOut,
                                                                          duration:
                                                                              const Duration(milliseconds: 150),
                                                                          child: ex
                                                                              ? rec = Align(
                                                                                  alignment: Alignment.topLeft,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                    child: Container(key: const ValueKey<int>(0), child: content),
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
                                                                              : rec = Container(
                                                                                  key: const ValueKey<int>(1),
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
                                                                      top: Radius
                                                                          .circular(
                                                                              14)),
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              child:
                                                                  ScrollConfiguration(
                                                                behavior:
                                                                    const ScrollBehavior(),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Stack(
                                                                    children: [
                                                                      Positioned
                                                                          .fill(
                                                                        child: Image.asset(
                                                                            'asset/asset Images Rand/FoodBack.png'),
                                                                      ),
                                                                      BackdropFilter(
                                                                        filter: ImageFilter.blur(
                                                                            sigmaX:
                                                                                80,
                                                                            sigmaY:
                                                                                80),
                                                                        child:
                                                                            Container(
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.6),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.stretch,
                                                                            children: [
                                                                              /////////////////////IMG
                                                                              Container(
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: const BoxDecoration(
                                                                                  borderRadius: BorderRadius.vertical(
                                                                                    top: Radius.circular(14),
                                                                                  ),
                                                                                ),
                                                                                height: height * 0.28,
                                                                                child: Stack(
                                                                                  fit: StackFit.passthrough,
                                                                                  children: [
                                                                                    Image.network(
                                                                                      "${snapshot.data?.docs[index]['ImageUrl']}", ///////////////////////////comeback
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                    Container(
                                                                                      /////shadow
                                                                                      decoration: BoxDecoration(boxShadow: [
                                                                                        BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 15, inset: true, offset: const Offset(0, -80))
                                                                                      ]),
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.bottomLeft,
                                                                                      child: Container(
                                                                                        width: width * 0.9,
                                                                                        margin: const EdgeInsets.all(7),
                                                                                        child: Text(
                                                                                          snapshot.data?.docs[index]['name'],
                                                                                          style: TextStyle(shadows: [
                                                                                            Shadow(blurRadius: 12, offset: const Offset(0, 4), color: Colors.black.withOpacity(0.45))
                                                                                          ], fontSize: height * 0.035, color: Colors.white, fontFamily: 'UbuntuREG'),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              //////////////////////IMG
                                                                              NewEx(() {
                                                                                isEx1 == false
                                                                                    ? {
                                                                                        isEx1 = true,
                                                                                        isEx2 = false,
                                                                                        isEx3 = false
                                                                                      }
                                                                                    : isEx1 = false;
                                                                              },
                                                                                  isEx1,
                                                                                  'Ingredients',
                                                                                  Text('• ${convertNewLine(snapshot.data?.docs[index]['ingredients'])}',
                                                                                      style: TextStyle(
                                                                                        color: const Color(0xFF1E1E1E).withOpacity(0.85),
                                                                                        fontSize: height * 0.017,
                                                                                        fontFamily: 'UbuntuREG',
                                                                                      ))),
                                                                              NewEx(() {
                                                                                isEx2 == false
                                                                                    ? {
                                                                                        isEx1 = false,
                                                                                        isEx3 = false,
                                                                                        isEx2 = true
                                                                                      }
                                                                                    : isEx2 = false;
                                                                              },
                                                                                  isEx2,
                                                                                  'Directions',
                                                                                  Text(
                                                                                    '${convertNewLineDesc(snapshot.data?.docs[index]['Desc'])}',
                                                                                    style: TextStyle(
                                                                                      color: const Color(0xFF1E1E1E).withOpacity(0.85),
                                                                                      fontSize: height * 0.017,
                                                                                      fontFamily: 'UbuntuREG',
                                                                                    ),
                                                                                  )),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(bottom: 5),
                                                                                child: NewEx(
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
                                                                                    snapshot.data?.docs[index]['Benefit'],
                                                                                    style: TextStyle(color: const Color(0xFF1E1E1E).withOpacity(0.85), fontSize: height * 0.017, fontFamily: 'UbuntuREG'),
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
                                                        snapshot.data!.docs
                                                                .isEmpty
                                                            ? test1(
                                                                height, width)
                                                            : Container(
                                                                color: Colors
                                                                    .white,
                                                                height: height *
                                                                    0.3,
                                                                width: width *
                                                                    0.96,
                                                                child: Image
                                                                    .network(
                                                                  "${snapshot.data?.docs[index]['ImageUrl']}",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                            height:
                                                                height * 0.12,
                                                            decoration:
                                                                BoxDecoration(
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                      blurRadius:
                                                                          15,
                                                                      inset:
                                                                          true,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              -80))
                                                                ]),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 12,
                                                                    left: 10),
                                                            child: Text(
                                                              '${snapshot.data?.docs[index]['name']}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  shadows: [
                                                                    Shadow(
                                                                        blurRadius:
                                                                            12,
                                                                        offset: const Offset(
                                                                            0,
                                                                            4),
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.45))
                                                                  ],
                                                                  fontSize:
                                                                      height *
                                                                          0.035,
                                                                  fontFamily:
                                                                      'UbuntuREG'),
                                                            ),
                                                          ),
                                                        )
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

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;
  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);
  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

////////////////////////////////////////////////////////////////////////////////
class FoodPlanUser extends StatefulWidget {
  const FoodPlanUser({super.key});

  @override
  State<FoodPlanUser> createState() => _FoodPlanState();
}

class _FoodPlanState extends State<FoodPlanUser> {
  bool isloading = true;
  List allfood = [];
  List<DocumentSnapshot> Users = [];
  var UserId;

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

  getData1() async {
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

  String days = '';
  String water = '';
  String notes = '';
  List data = [];

  getData() async {
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
    allfood.addAll(qs.docs);
  }

  bool hide = true;
  List allbreakfast = [];
  List alllunch = [];
  List alldinner = [];

  @override
  void initState() {
    Loading();
    Prefs.getString("Id").then(
      (value) async {
        UserId = await value;
        getData1();
      },
    );
    super.initState();
  }

  exp expandedOne = exp(false);
  exp expandedTwo = exp(false);
  exp expandedThree = exp(false);

  Slide valueWater = Slide(0);
  Slide valueDay = Slide(0);
  List<food> customList = [];

  int j3 = 0;
  int j1 = 0;
  int j2 = 0;
  final dataKey = new GlobalKey();
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    Widget kk(exp expanded, String Title, List<food> allLocal, List all) {
      return Center(
          child: Padding(
        padding: EdgeInsets.only(top: Title == 'Breakfast' ? 0 : 10),
        child: GestureDetector(
          onTap: () {
            if (!mounted) return;
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
                                    itemCount: allLocal.length, //variable
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (!mounted) return;
                                          setState(() {
                                            if (customList
                                                .contains(allLocal[index]))
                                              customList
                                                  .remove(allLocal[index]);
                                            else
                                              customList.add(allLocal[index]);
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
                                              height: size.height * 0.095, //95,

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
                            Icons.arrow_back_ios,
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

    Widget slide(Slide val, int div) {
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
              Container(
                  child: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    div == 7 ? '$days' : '$water',
                    style: TextStyle(
                        fontSize: height * 0.07, color: Color(0xFF2C2C2C)),
                  ),
                  Text(
                    div == 7 ? 'Days' : 'Cups/day',
                    style: TextStyle(
                        fontFamily: 'UbuntuREG', fontSize: height * 0.016),
                  )
                ],
              ))),
            ],
          ),
        ),
      );
    }

    return isloading == true
        ? test1(size.height, size.width)
        : Stack(
            children: [
              Column(
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
                          children: [
                            slide(valueWater, 15),
                            slide(valueDay, 7)
                          ])),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 10),
                    child: Container(
                      width: width * 0.97,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: TextField(
                          controller: TextEditingController(text: notes),
                          readOnly: true,
                          minLines: 1,
                          maxLines: 5,
                          key: dataKey,
                          onTap: () {
                            Scrollable.ensureVisible(dataKey.currentContext!);
                          },
                          onChanged: (value) {},
                          style: TextStyle(
                              color: Color(0xFF2C2C2C),
                              fontFamily: 'UbuntuREG',
                              fontSize: height * 0.02),
                          cursorHeight: height * 0.024,
                          cursorColor: Color(0xFF2C2C2C),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            label: Text(
                              "Notes",
                              style: TextStyle(
                                  color: Color(0xFF2C2C2C),
                                  fontSize: height * 0.02,
                                  fontFamily: 'UbuntuREG'),
                            ),
                            labelStyle:
                                const TextStyle(color: Color(0xFF2C2C2C)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
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
                  ),
                ],
              ),
            ],
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
