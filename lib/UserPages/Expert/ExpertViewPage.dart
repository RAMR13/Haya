import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hayaproject/UserPages/Expert/SearchExpertPage.dart';
import 'package:hayaproject/UserPages/Expert/ProfileFSTU.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User1 {
  String name;
  String subtitle;
  String imageUrl; // New field for the user's image URL
  String userprice;

  User1(this.name, this.subtitle, this.imageUrl, this.userprice);
}

class TrainerPage extends StatefulWidget {
  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  // Sample user data
  List<DocumentSnapshot> review = [];
  List<DocumentSnapshot> specialist = [];
  List<Future<List<QueryDocumentSnapshot<Object?>>>> queryFutures = [];
  List<List<QueryDocumentSnapshot<Object?>>> reviewList = [];
  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("specialist")
        .where("type", isEqualTo: "trainer")
        .where("status", isEqualTo: true)
        .get();
    specialist.addAll(qs.docs);
    getDataReview();
    setState(() {});
  }

  getDataReview() async {
    for (int i = 0; i < specialist.length; i++) {
      Future<List<QueryDocumentSnapshot<Object?>>> queryFuture =
          FirebaseFirestore.instance
              .collection("specialist")
              .doc(specialist[i].id)
              .collection("review")
              .get()
              .then((QuerySnapshot qs2) => qs2.docs);
      queryFutures.add(queryFuture);
    }
    reviewList = await Future.wait(queryFutures);

    setState(() {});
  }

  double reviewAvg(List<QueryDocumentSnapshot<Object?>> docs) {
    double sum = 0;
    for (int i = 0; i < docs.length; i++) {
      sum += double.parse(docs[i]['stars number']);
    }
    return sum / docs.length;
  }

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  String search = '';
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 2,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Hero(
                tag: 'ios',
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: height * 0.036,
                  ),
                ),
              ),
              Container(
                width: width * 0.82,
                child: Material(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() {
                        search = value;
                      });
                    },
                    maxLines: 1,
                    style: TextStyle(fontSize: height * 0.02 //18
                        ),
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: const Color(0xFF2C2C2C),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        hintText: 'Search',
                        hintStyle: TextStyle(fontFamily: 'UbuntuREG'),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 170, 170, 170),
                              width: 1.2,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 114, 82),
                              width: 1.4,
                            ))),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: Center(
            child: Container(
              width: width * 0.96,
              child: ListView.builder(
                  itemCount: specialist.length,
                  itemBuilder: (context, i) {
                    String fullName =
                        '${specialist[i]['first name']} ${specialist[i]['last name']}';
                    return (fullName.toLowerCase()).contains(search)
                        ? Container(
                            height: height * 0.13,
                            width: width,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(-2, 2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 120),
                                      reverseDuration:
                                          Duration(milliseconds: 120),
                                      child: ProfileSpec(
                                          reviewList[i], specialist[i]),
                                      childCurrent: NutritionistPage(),
                                      type:
                                          PageTransitionType.rightToLeftJoined),
                                );
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "${specialist[i]["price"]} JOD/month",
                                      style: TextStyle(
                                          fontSize: height * 0.018,
                                          fontFamily: 'UbuntuREG',
                                          color: Color(0xFF2C2C2C)),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: height * 0.105,
                                        width: height * 0.105,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  blurRadius: 3,
                                                  offset: Offset(0, 2))
                                            ]),
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.network(
                                            "${specialist[i]["image"]}",
                                            fit: BoxFit.cover,
                                          ),
                                          margin: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2))
                                            ],
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.04),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Container(
                                              width: width * 0.55,
                                              child: Text(
                                                "${specialist[i]["first name"]}" +
                                                    " " +
                                                    "${specialist[i]["last name"]}",
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: height * 0.023,
                                                    fontFamily: 'UbuntuREG'),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                ShaderMask(
                                                  shaderCallback: (bounds) {
                                                    return LinearGradient(
                                                        colors: [
                                                          Colors.orangeAccent,
                                                          Colors.orange,
                                                          Colors
                                                              .deepOrangeAccent,
                                                          Colors.deepOrange,
                                                        ],
                                                        stops: [
                                                          0.3,
                                                          0.4,
                                                          0.7,
                                                          1.0
                                                        ]).createShader(bounds);
                                                  },
                                                  child: Icon(
                                                    Icons.star_outlined,
                                                    size: height * 0.03,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                ShaderMask(
                                                  shaderCallback: (bounds) {
                                                    return LinearGradient(
                                                        colors: [
                                                          Colors.orangeAccent,
                                                          Colors.orange,
                                                          Colors
                                                              .deepOrangeAccent,
                                                          Colors.deepOrange,
                                                        ],
                                                        stops: [
                                                          0.3,
                                                          0.4,
                                                          0.7,
                                                          1.0
                                                        ]).createShader(bounds);
                                                  },
                                                  child: Text(
                                                      reviewList.length == 0
                                                          ? ''
                                                          : reviewList[i]
                                                                      .length ==
                                                                  0
                                                              ? "0 "
                                                              : "${NumberFormat("#.##").format(reviewAvg(reviewList[i]))} ",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'UbuntuREG',
                                                          color: const Color(
                                                              0xffe8a512),
                                                          fontSize:
                                                              height * 0.021)),
                                                ),
                                                Text(
                                                    reviewList.length == 0
                                                        ? ''
                                                        : "(${reviewList[i].length})",
                                                    style: TextStyle(
                                                        fontFamily: 'UbuntuREG',
                                                        color: Color.fromARGB(
                                                            255, 129, 129, 129),
                                                        fontSize:
                                                            height * 0.017)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                        : Container();
                  }),
            ),
          ),
        ));
  }
}

class NutritionistPage extends StatefulWidget {
  @override
  State<NutritionistPage> createState() => _NutritionistPageState();
}

class _NutritionistPageState extends State<NutritionistPage> {
  List<DocumentSnapshot> specialist = [];
  List<DocumentSnapshot> review = [];
  List<Future<List<QueryDocumentSnapshot<Object?>>>> queryFutures = [];
  List<List<QueryDocumentSnapshot<Object?>>> reviewList = [];

  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("specialist")
        .where("type", isEqualTo: "nutritionist")
        .where("status", isEqualTo: true)
        .get();
    specialist.addAll(qs.docs);
    getDataReview();
    setState(() {});
  }

  getDataReview() async {
    for (int i = 0; i < specialist.length; i++) {
      Future<List<QueryDocumentSnapshot<Object?>>> queryFuture =
          FirebaseFirestore.instance
              .collection("specialist")
              .doc(specialist[i].id)
              .collection("review")
              .get()
              .then((QuerySnapshot qs2) => qs2.docs);
      queryFutures.add(queryFuture);
    }
    reviewList = await Future.wait(queryFutures);

    setState(() {});
  }

  double reviewAvg(List<QueryDocumentSnapshot<Object?>> docs) {
    double sum = 0;
    for (int i = 0; i < docs.length; i++) {
      sum += double.parse(docs[i]['stars number']);
    }
    return sum / docs.length;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Hero(
              tag: 'ios',
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: height * 0.036,
                ),
              ),
            ),
            Container(
              width: width * 0.82,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  if (!mounted) return;
                  setState(() {
                    search = value;
                  });
                },
                maxLines: 1,
                style: TextStyle(fontSize: height * 0.02 //18
                    ),
                textAlignVertical: TextAlignVertical.center,
                cursorColor: const Color(0xFF2C2C2C),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    hintText: 'Search',
                    hintStyle: TextStyle(fontFamily: 'UbuntuREG'),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 170, 170, 170),
                          width: 1.2,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 114, 82),
                          width: 1.4,
                        ))),
              ),
            ),
          ],
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: Center(
          child: Container(
            width: width * 0.96,
            child: ListView.builder(
                itemCount: specialist.length,
                itemBuilder: (context, i) {
                  String fullName =
                      '${specialist[i]['first name']} ${specialist[i]['last name']}';
                  return (fullName.toLowerCase()).contains(search)
                      ? Container(
                          height: height * 0.13,
                          width: width,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(-2, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 120),
                                      reverseDuration:
                                          Duration(milliseconds: 120),
                                      child: ProfileSpec(
                                          reviewList[i], specialist[i]),
                                      childCurrent: NutritionistPage(),
                                      type: PageTransitionType
                                          .rightToLeftJoined));
                            },
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "${specialist[i]["price"]} JOD/month",
                                    style: TextStyle(
                                        fontSize: height * 0.018,
                                        fontFamily: 'UbuntuREG',
                                        color: Color(0xFF2C2C2C)),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: height * 0.105,
                                      width: height * 0.105,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                blurRadius: 3,
                                                offset: Offset(0, 2))
                                          ]),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.network(
                                          "${specialist[i]["image"]}",
                                          fit: BoxFit.cover,
                                        ),
                                        margin: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                blurRadius: 2,
                                                offset: Offset(0, 2))
                                          ],
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.04),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Container(
                                            width: width * 0.55,
                                            child: Text(
                                              "${specialist[i]["first name"]}" +
                                                  " " +
                                                  "${specialist[i]["last name"]}",
                                              style: TextStyle(
                                                  fontSize: height * 0.023,
                                                  fontFamily: 'UbuntuREG'),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              ShaderMask(
                                                shaderCallback: (bounds) {
                                                  return LinearGradient(
                                                      colors: [
                                                        Colors.orangeAccent,
                                                        Colors.orange,
                                                        Colors.deepOrangeAccent,
                                                        Colors.deepOrange,
                                                      ],
                                                      stops: [
                                                        0.3,
                                                        0.4,
                                                        0.7,
                                                        1.0
                                                      ]).createShader(bounds);
                                                },
                                                child: Icon(
                                                  Icons.star_outlined,
                                                  size: height * 0.03,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              ShaderMask(
                                                shaderCallback: (bounds) {
                                                  return LinearGradient(
                                                      colors: [
                                                        Colors.orangeAccent,
                                                        Colors.orange,
                                                        Colors.deepOrangeAccent,
                                                        Colors.deepOrange,
                                                      ],
                                                      stops: [
                                                        0.3,
                                                        0.4,
                                                        0.7,
                                                        1.0
                                                      ]).createShader(bounds);
                                                },
                                                child: Text(
                                                    reviewList.length == 0
                                                        ? ''
                                                        : reviewList[i]
                                                                    .length ==
                                                                0
                                                            ? "0 "
                                                            : "${NumberFormat("#.##").format(reviewAvg(reviewList[i]))} ",
                                                    style: TextStyle(
                                                        fontFamily: 'UbuntuREG',
                                                        color: const Color(
                                                            0xffe8a512),
                                                        fontSize:
                                                            height * 0.021)),
                                              ),
                                              Text(
                                                  reviewList.length == 0
                                                      ? ''
                                                      : "(${reviewList[i].length})",
                                                  style: TextStyle(
                                                      fontFamily: 'UbuntuREG',
                                                      color: Color.fromARGB(
                                                          255, 129, 129, 129),
                                                      fontSize:
                                                          height * 0.017)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                      : Container();
                }),
          ),
        ),
      ),
    );
  }
}
