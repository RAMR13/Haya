import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/rendering.dart' as render;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Constants.dart';
import 'package:hayaproject/UserPages/WorkoutPage/TrainingSection.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:hayaproject/UserPages/WorkoutPage/ExerciseBody.dart';
import 'package:page_transition/page_transition.dart';

import '../../Loading.dart';

class ExerciseBodyNET extends StatefulWidget {
  late String request;
  List<DocumentSnapshot<Object?>> info;
  List<DocumentSnapshot<Object?>> workoutscustomlistNotEmpty;
  ExerciseBodyNET(this.request, this.info, this.workoutscustomlistNotEmpty);
  @override
  State<ExerciseBodyNET> createState() => _ExerciseBodyState();
}

Widget gauges() {
  return Container(
    child: gauge(30),
    width: 35,
    height: 35,
  );
}

late Exercises custom;
bool isBig = false;
List<CompletedIndex> IsCompleted = [];

class _ExerciseBodyState extends State<ExerciseBodyNET> {
  bool shouldPop = true;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        widget1Opacity = 1;
      });
    });

    upperpadding = 0;
    textOpacity = 0;
    arrowColor = const Color(0xFFFFFFFFF);
    elevation = 0;
    tranc = 0;
    Getdata();
    Getdata1();
    isBig = false;
    Loading();
    custom = Exercises(title: '', duration: 0, workouts: customWk);
    super.initState();
  }

  var db = FirebaseFirestore.instance;
  List<DocumentSnapshot> workoutscustom = [];
  List<DocumentSnapshot> workoutscustominfo = [];

  List<Workouts> customWk = [];
  void Getdata() async {
    List wk = [];
    widget.workoutscustomlistNotEmpty.forEach((element) {
      wk.add(element['name']);
    });
    QuerySnapshot qs =
        await db.collection('workout').where('name', whereIn: wk).get();

    setState(() {
      workoutscustom.addAll(qs.docs);
      workoutscustom.forEach((element) {
        customWk.add(Workouts(
            name: element['name'],
            subText: int.parse(element['subtext']),
            typeChar: 'type',
            image: element['image'],
            imagetype: element['imgtype']));
      });
    });
  }

  void Getdata1() async {
    setState(() {
      //   workoutscustominfo.addAll(qs.docs);
      workoutscustominfo.addAll(widget.info);
    });
  }

  double upperpadding = 0;
  double padding = 15;
  int tranc = 0;
  double elevation = 0;
  Color arrowColor = Colors.white;
  double textOpacity = 0;
  String select = 'Select';
  double widget1Opacity = 0.0;
  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    IsCompleted = List<CompletedIndex>.generate(
        customWk.length, (i) => CompletedIndex(-1, false));
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => MainScreenUser("WHomePage"),
            ),
          );
        return shouldPop;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFF9F9F9),
        ////////////////////Appbar////////////////////////////////
        appBar: AppBar(
          backgroundColor: Color.fromARGB(tranc, 255, 255, 255),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedOpacity(
                opacity: widget1Opacity,
                duration: Duration(milliseconds: 200),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                MainScreenUser("WHomePage"),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: arrowColor,
                        size: size.height * 0.038, //size.width * 0.08,
                      ),
                    )),
              ),
              tranc == 255
                  ? Text(
                      '${'${workoutscustominfo[0]['name']}'}',
                      style: TextStyle(
                          fontSize: size.height * 0.03, //26,
                          fontFamily: 'UbuntuBOLD',
                          color: const Color(0xFF2C2C2C)),
                    )
                  : Container(),
              tranc == 255
                  ? Expanded(
                      child: SizedBox(
                        width: size.width * 0.21, //size.height * 0.1,
                      ),
                    )
                  : Container(),
              tranc == 0
                  ? Container()
                  : SizedBox(width: size.width * 0.088, child: gauges()),
            ],
          ),
          elevation: 0,
        ),
        ////////////////////Appbar////////////////////////////////
        ////////////////////Top Image////////////////////////////////
        body: Stack(alignment: Alignment.topCenter, children: [
          Container(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Image.asset(
                  fit: BoxFit.cover,
                  'asset/Images/customworkoutlist.jpg',
                ),
                AnimatedOpacity(
                  opacity: widget1Opacity,
                  duration: Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          color: const render.Color.fromRGBO(249, 249, 249, 1),
                          child: Material(
                            child: Text(
                              '${workoutscustom.length} WORKOUTS',
                              style: TextStyle(
                                  fontFamily: 'ITC Avant',
                                  fontSize: size.height * 0.024,
                                  color: Colors.black,
                                  overflow: TextOverflow.clip),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            color: const Color(0xFFF9F9F9),
                            child: Material(
                              child: Text(
                                '${workoutscustominfo.length > 0 ? workoutscustominfo[0]['duration'] : 0} MINS',
                                style: TextStyle(
                                    fontFamily: 'ITC Avant',
                                    fontSize: size.height * 0.024, //21,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            height: size.height * 0.45,
            width: size.width,
            //380,
            // height: size.width * 0.95,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 6,
                      color: render.Color.fromARGB(111, 0, 0, 0))
                ]),
          ),

          AnimatedOpacity(
            opacity: widget1Opacity,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isBig == true ? size.width : size.width * 0.92, //380,
                  height: isBig == true
                      ? size.height * 0.957
                      : size.height * 0.69, //600,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: render.Color.fromARGB(183, 235, 235, 235),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10))),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isBig == true ? 0 : 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 12, 0, 20),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        '${workoutscustominfo.length > 0 ? workoutscustominfo[0]['name'] : 0}',
                                        style: TextStyle(
                                            fontSize: size.height * 0.03,
                                            fontFamily: 'UbuntuBOLD'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                    child: SizedBox(
                                        width: size.width * 0.088,
                                        child: gauges()),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: ScrollConfiguration(
                                  behavior: const ScrollBehavior(),
                                  child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    showLeading: false,
                                    showTrailing: false,
                                    color: Colors.transparent,
                                    child: NotificationListener<
                                        UserScrollNotification>(
                                      onNotification: (notification) {
                                        final render.ScrollDirection direction =
                                            notification.direction;
                                        if (direction ==
                                            render.ScrollDirection.reverse) {
                                          setState(() {
                                            upperpadding = 42;
                                            textOpacity = 1;
                                            arrowColor =
                                                const Color(0xFF2C2C2C);
                                            elevation = 3;
                                            tranc = 255;
                                            isBig = true;
                                          });
                                        }
                                        if (direction ==
                                                render
                                                    .ScrollDirection.forward &&
                                            notification.metrics.pixels == 0) {
                                          setState(() {
                                            upperpadding = 0;
                                            textOpacity = 0;
                                            arrowColor =
                                                const Color(0xFFFFFFFFF);
                                            elevation = 0;
                                            tranc = 0;

                                            isBig = false;
                                          });
                                        }
                                        return true;
                                      },
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        itemCount: workoutscustom.length +
                                            1, //variable
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == workoutscustom.length) {
                                            return Container(
                                              height: size.height * 0.09,
                                            );
                                          } else {
                                            return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 6),
                                                child: Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                          boxShadow: [
                                                        BoxShadow(
                                                            color: render.Color
                                                                .fromARGB(64, 0,
                                                                    0, 0),
                                                            blurRadius: 3,
                                                            offset:
                                                                Offset(0, 2))
                                                      ],
                                                          color: render
                                                                  .Color
                                                              .fromARGB(
                                                                  247,
                                                                  250,
                                                                  250,
                                                                  250),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          7))),
                                                  height:
                                                      size.height * 0.112, //95,

                                                  child: Container(
                                                      child: Row(children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          0, 0, 10, 0),
                                                      child: Container(
                                                        width:
                                                            size.width * 0.27,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7),
                                                        child: workoutscustom[
                                                                        index][
                                                                    'imgtype'] ==
                                                                'as'
                                                            ? Image.asset(
                                                                'asset/Images/Gif/${workoutscustom[index]['name']}.gif')
                                                            : Image.network(
                                                                workoutscustom[
                                                                        index]
                                                                    ['image']),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 5, 0, 0),
                                                          child: Container(
                                                            width: size.width *
                                                                0.5,
                                                            child: Text(
                                                                workoutscustom[
                                                                        index]
                                                                    ['name'],
                                                                style: TextStyle(
                                                                    color: const Color(
                                                                        0xFF2C2C2C),
                                                                    fontSize: size
                                                                            .height *
                                                                        0.02 //20

                                                                    )),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 0, 15),
                                                          child: Text(
                                                            workoutscustom[index]
                                                                        [
                                                                        'type'] ==
                                                                    'C'
                                                                ? 'x${workoutscustom[index]['subtext']}'
                                                                : int.parse(workoutscustom[index]
                                                                            [
                                                                            'subtext']) >
                                                                        10
                                                                    ? '00:${workoutscustom[index]['subtext']}'
                                                                    : '0${workoutscustom[index]['subtext']}:00',
                                                            style: TextStyle(
                                                                fontSize: size
                                                                        .height *
                                                                    0.017, //2
                                                                color: const render
                                                                    .Color.fromARGB(
                                                                    255,
                                                                    95,
                                                                    95,
                                                                    95)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ])),
                                                ));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
          //////////////////////////////////NEXT////////////////////////////////
          AnimatedOpacity(
            opacity: widget1Opacity,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: 50,
                margin: const EdgeInsets.fromLTRB(30, 60, 30, 20),
                decoration: const BoxDecoration(
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
                    setState(() {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Training(
                                  'Custom',
                                  Index,
                                  0,
                                  0,
                                  IsCompleted,
                                  widget.request,
                                  widget.info,
                                  widget.workoutscustomlistNotEmpty),
                              type: PageTransitionType.rightToLeftWithFade));
                      select == 'Select' ? select = 'Next' : select = 'Select';
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(350))),
                    margin: const EdgeInsets.all(5),
                    child: ShaderMask(
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          select,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.height * 0.025,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      shaderCallback: (rect) {
                        return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.orange, newRed]).createShader(rect);
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
