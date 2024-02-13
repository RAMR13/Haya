import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/SpecialistPage/AddWorkoutSp.dart';
import 'package:hayaproject/chat/ChatPage.dart';
import 'package:page_transition/page_transition.dart';

class CustomWorkout extends StatefulWidget {
  var receiverUserEmail;
  var receiverUserID;
  var name;
  var image;
  var type;
  var senderId;
  var Senderemail;

  CustomWorkout(
      {required this.name,
      required this.image,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.type,
      required this.senderId,
      required this.Senderemail});

  @override
  State<CustomWorkout> createState() => _CustomWorkoutState();
}

class _CustomWorkoutState extends State<CustomWorkout> {
  List<DropdownMenuItem<String>> list = [
    DropdownMenuItem(child: Text('Edit'), value: 'Edit'),
    DropdownMenuItem(child: Text('Delete'), value: 'Delete')
  ];
  int num = 4;
  List<List<DocumentSnapshot<Object?>>> infos = [];
  var db = FirebaseFirestore.instance;
  List<DocumentSnapshot<Object?>> info0 = [];
  List<DocumentSnapshot<Object?>> info1 = [];
  List<DocumentSnapshot<Object?>> info2 = [];
  List<DocumentSnapshot<Object?>> info3 = [];
  List<DocumentSnapshot> Users = [];
  List<String> wkName = ['wk1', 'wk2', 'wk3', 'wk4'];

  getDataMyUser() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: widget.receiverUserID)
        .get();
    Users.addAll(qs.docs);
    if (!mounted) return;
    setState(() {});
    await Getdata();
  }

  Getdata() async {
    QuerySnapshot qs = await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Workout plan')
        .collection('wk1 info')
        .get();
    QuerySnapshot qs1 = await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Workout plan')
        .collection('wk2 info')
        .get();
    QuerySnapshot qs2 = await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Workout plan')
        .collection('wk3 info')
        .get();
    QuerySnapshot qs3 = await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Workout plan')
        .collection('wk4 info')
        .get();
    if (!mounted) return;
    setState(() {
      info0.addAll(qs.docs);
      info1.addAll(qs1.docs);
      info2.addAll(qs2.docs);
      info3.addAll(qs3.docs);
      infos = [info0, info1, info2, info3];
    });
  }

  CollectionReference qs = FirebaseFirestore.instance.collection("workout");

  @override
  void initState() {
    Loading();
    getDataMyUser();
    super.initState();
  }

  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
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
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Hero(
                tag: 'back',
                child: GestureDetector(
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
                    size: size.height * 0.038, //size.width * 0.08,
                  ),
                ),
              ),
            ),
            title: Text('Custom workouts',
                style: TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: size.height * 0.026 //22,
                    ))),
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'asset/Images/customworkout.png',
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xD9FFFFFF),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
                      width: size.width *
                          0.95, //size.width * 0.95, //size.width - 20,
                      height: size.height * 0.87, //size.height - 110,
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: StreamBuilder(
                          stream: qs.snapshots(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              itemCount: 4,
                              itemBuilder: (BuildContext context, int index) {
                                if (index != num) {
                                  return Visibility(
                                    visible: info0.isEmpty && index == 0
                                        ? false
                                        : info1.isEmpty && index == 1
                                            ? false
                                            : info2.isEmpty && index == 2
                                                ? false
                                                : info3.isEmpty && index == 3
                                                    ? false
                                                    : true,
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      height: size.height * 0.14,
                                      //120,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0x40000000),
                                                blurRadius: 5,
                                                offset: Offset(0, 3))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0),
                                                BlendMode.darken),
                                            child: Image.asset(
                                                'asset/Images/customworkoutlist.jpg',
                                                fit: BoxFit.cover),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Container(
                                                  width: size.width * 0.45,
                                                  child: Text(
                                                    '${infos.length > 0 && infos[index].length > 0 ? infos[index][0]['name'] : ''}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'UbuntuREG',
                                                      color: Color(0xFFFAFAFA),
                                                      fontSize:
                                                          size.height * 0.024,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 10, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7)),
                                                        isDense: true,
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        items: list,
                                                        onChanged: (val) async {
                                                          if (val == 'Edit') {
                                                            Navigator.push(
                                                                context,
                                                                PageTransition(
                                                                    child: AddWorkoutSp(
                                                                        collectionName: wkName[
                                                                            index],
                                                                        name: widget
                                                                            .name,
                                                                        image: widget
                                                                            .image,
                                                                        senderId:
                                                                            widget
                                                                                .senderId,
                                                                        Senderemail:
                                                                            widget
                                                                                .Senderemail,
                                                                        type: widget
                                                                            .type,
                                                                        receiverUserEmail:
                                                                            widget
                                                                                .receiverUserEmail,
                                                                        receiverUserID:
                                                                            widget
                                                                                .receiverUserID),
                                                                    type: PageTransitionType
                                                                        .rightToLeftWithFade,
                                                                    childCurrent:
                                                                        CustomWorkout(
                                                                      name: widget
                                                                          .name,
                                                                      image: widget
                                                                          .image,
                                                                      senderId:
                                                                          widget
                                                                              .senderId,
                                                                      Senderemail:
                                                                          widget
                                                                              .Senderemail,
                                                                      type: widget
                                                                          .type,
                                                                      receiverUserEmail:
                                                                          widget
                                                                              .receiverUserEmail,
                                                                      receiverUserID:
                                                                          widget
                                                                              .receiverUserID,
                                                                    )));
                                                          }
                                                          if (val == 'Delete') {
                                                            var collection = await db
                                                                .collection(
                                                                    'users')
                                                                .doc(
                                                                    Users[0].id)
                                                                .collection(
                                                                    'my specialist')
                                                                .doc(
                                                                    'Workout plan')
                                                                .collection(
                                                                    '${wkName[index]} info')
                                                                .get();

                                                            for (var doc
                                                                in collection
                                                                    .docs) {
                                                              await doc
                                                                  .reference
                                                                  .delete();
                                                            }
                                                            if (val ==
                                                                'Delete') {
                                                              var collection1 = await db
                                                                  .collection(
                                                                      'users')
                                                                  .doc(Users[0]
                                                                      .id)
                                                                  .collection(
                                                                      'my specialist')
                                                                  .doc(
                                                                      'Workout plan')
                                                                  .collection(
                                                                      '${wkName[index]}')
                                                                  .get();

                                                              for (var doc
                                                                  in collection1
                                                                      .docs) {
                                                                await doc
                                                                    .reference
                                                                    .delete();
                                                              }
                                                            }
                                                            Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    PageTransition(
                                                                        child:
                                                                            CustomWorkout(
                                                                          name:
                                                                              widget.name,
                                                                          image:
                                                                              widget.image,
                                                                          senderId:
                                                                              widget.senderId,
                                                                          Senderemail:
                                                                              widget.Senderemail,
                                                                          type:
                                                                              widget.type,
                                                                          receiverUserEmail:
                                                                              widget.receiverUserEmail,
                                                                          receiverUserID:
                                                                              widget.receiverUserID,
                                                                        ),
                                                                        type: PageTransitionType
                                                                            .fade));
                                                          }
                                                          if (!mounted) return;

                                                          setState(() {});
                                                        },
                                                        icon: Icon(
                                                          Icons.more_vert,
                                                          color:
                                                              Color(0xFFFAFAFA),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(height: size.height * 0.14);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, size.height * 0.87, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          if (!(info0.isNotEmpty &&
                              info1.isNotEmpty &&
                              info2.isNotEmpty &&
                              info3.isNotEmpty)) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    child: AddWorkoutSp(
                                        collectionName: '',
                                        name: widget.name,
                                        image: widget.image,
                                        senderId: widget.senderId,
                                        Senderemail: widget.Senderemail,
                                        type: widget.type,
                                        receiverUserEmail:
                                            widget.receiverUserEmail,
                                        receiverUserID: widget.receiverUserID),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    childCurrent: CustomWorkout(
                                      name: widget.name,
                                      image: widget.image,
                                      senderId: widget.senderId,
                                      Senderemail: widget.Senderemail,
                                      type: widget.type,
                                      receiverUserEmail:
                                          widget.receiverUserEmail,
                                      receiverUserID: widget.receiverUserID,
                                    )),
                                (Route<dynamic> route) => false);
                          }
                        },
                        child: Container(
                          width: size.width * 1, //65,
                          height: size.height * 0.075, //65,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Color(0x40000000),
                                blurRadius: 7,
                                offset: Offset(-3, 7)),
                            BoxShadow(
                                color: Color(0xFFFFFFFF),
                                blurRadius: 7,
                                offset: Offset(4, -4)),
                          ], color: Color(0xFFF9F9F9), shape: BoxShape.circle),
                          child: Icon(Icons.add_rounded,
                              color: (info0.isNotEmpty &&
                                      info1.isNotEmpty &&
                                      info2.isNotEmpty &&
                                      info3.isNotEmpty)
                                  ? Colors.grey
                                  : Color(0xFF2c2c2c),
                              size: size.height * 0.048 //40,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
