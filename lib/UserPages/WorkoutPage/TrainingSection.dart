import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/WorkoutPage/ExerciseBody.dart';
import 'package:hayaproject/UserPages/WorkoutPage/ExerciseBodyNET.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:meta/meta.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class Training extends StatefulWidget {
  String request;
  String Name;
  int indexDone;
  var Indexoftraining;
  int index;
  var customwk;
  List<DocumentSnapshot<Object?>> info;
  List<DocumentSnapshot<Object?>> workoutscustomlistNotEmpty;
  List<CompletedIndex> IsCompleted;
  Training(this.Name, this.Indexoftraining, this.index, this.indexDone,
      this.IsCompleted,
      [this.request = 's',
      this.info = const [],
      this.workoutscustomlistNotEmpty = const []]);

  @override
  State<Training> createState() => _testState();
}

int prefwk = 1;

class _testState extends State<Training> {
  late Exercises pointer;
  late Exercises pointer2 = Exercises(title: '', duration: 0, workouts: []);
  PageController pc = PageController();
  var index;
  late int _secondsRemaining;
  late Timer _timer;

  /////////////////////
  var db = FirebaseFirestore.instance;
  List<DocumentSnapshot> workoutscustom = [];
  List<Workouts> customWk = [];

  @override
  void initState() {
    super.initState();
    getPrefs();
    startTimer();
    pointer = ReturnPointer();

    _secondsRemaining = pointer.workouts.length > 0
        ? pointer.workouts[widget.index].subText
        : 30;
    pc = PageController(initialPage: 0);
    widget.IsCompleted.forEach((element) {
      if (element.completed == true) completed++;
    });
  }

  void startTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel(); // Stop the timer when it reaches 0 seconds.
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed.
    super.dispose();
  }

  getPrefs() async {
    prefwk = 1;
    prefwk = await Prefs.getPrefInt('workout index', 1);
    if (!mounted) return;
    setState(() {
      if (prefwk == 1) pointer2 = armBeginner;
      if (prefwk == 2) pointer2 = ChestBeginner;
      if (prefwk == 3) pointer2 = AbsBeginner;
      if (prefwk == 4) pointer2 = LegBeginner;
      if (prefwk == 5) pointer2 = armIntermediate;
      if (prefwk == 6) pointer2 = ChestIntermediate;
      if (prefwk == 7) pointer2 = AbsIntermediate;
      if (prefwk == 8) pointer2 = LegIntermediate;
      if (prefwk == 9) pointer2 = armAdvanced;
      if (prefwk == 10) pointer2 = ChestAdvanced;
      if (prefwk == 11) pointer2 = AbsAdvanced;
      if (prefwk == 12) pointer2 = LegAdvanced;
    });
  }

  // Exercises custom = Exercises(
  //     title: 'Arm beginner', duration: 10, workouts: armBeginnerWorkouts1);
  Exercises ReturnPointer() {
    setState(() {});
    if (widget.Name == "Custom") {
      return custom;
    }
    if (widget.Name == "Beginner") {
      if (widget.Indexoftraining == 0)
        return armBeginner;
      else if (widget.Indexoftraining == 1)
        return ChestBeginner;
      else if (widget.Indexoftraining == 2)
        return AbsBeginner;
      else if (widget.Indexoftraining == 3) return LegBeginner;
    } else if (widget.Name == "Intermediate") {
      if (widget.Indexoftraining == 0)
        return armIntermediate;
      else if (widget.Indexoftraining == 1)
        return ChestIntermediate;
      else if (widget.Indexoftraining == 2)
        return AbsIntermediate;
      else if (widget.Indexoftraining == 3) return LegIntermediate;
    } else if (widget.Name == "advance") {
      if (widget.Indexoftraining == 0)
        return armAdvanced;
      else if (widget.Indexoftraining == 1)
        return ChestAdvanced;
      else if (widget.Indexoftraining == 2)
        return AbsAdvanced;
      else if (widget.Indexoftraining == 3) return LegAdvanced;
    }
    return AbsAdvanced;
  }

  int completed = 0;

  @override
  Widget build(BuildContext context) {
    index = widget.index;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                width: width * 0.8,
                height: height * 0.16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(14),
                      child: Container(
                          child: Material(
                        color: Colors.white,
                        child: Text(
                          "Are you sure you want to finish the workout?",
                          style: TextStyle(
                              fontSize: height * 0.024,
                              color: Color(0xFF2C2C2C),
                              fontFamily: 'UbuntuREG'),
                        ),
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: TextButton(
                                style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Color.fromARGB(90, 255, 119, 56))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel",
                                    style: TextStyle(
                                        color: Color(0xFF2C2C2C),
                                        fontFamily: 'UbuntuREG',
                                        fontSize: height * 0.018))),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Color.fromARGB(90, 255, 119, 56))),
                              onPressed: () async {
                                /////////////////herrrrreeeeee
                                if (pointer2 == pointer) {
                                  await Prefs.savePrefInt(
                                      'workout done', completed);
                                }
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  PageTransition(
                                      child: widget.Name == 'Custom'
                                          ? ExerciseBodyNET(
                                              widget.request,
                                              widget.info,
                                              widget
                                                  .workoutscustomlistNotEmpty) ////hereee
                                          : ExerciseBody(widget.Name,
                                              widget.Indexoftraining),
                                      type: PageTransitionType
                                          .leftToRightWithFade),
                                );
                              },
                              child: Text("Confirm",
                                  style: TextStyle(
                                      color: Color(0xFF2C2C2C),
                                      fontFamily: 'UbuntuREG',
                                      fontSize: height * 0.018)))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        return Future.value(false);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Hero(
        //     tag: 'back',
        //     child: Icon(
        //       Icons.arrow_back_ios_rounded,
        //       size: height * 0.04,
        //     ),
        //   ),
        //   onPressed: () {
        // Navigator.pushReplacement<void, void>(
        //   context,
        //   PageTransition(
        //       child: widget.Name == 'Custom'
        //           ? ExerciseBodyNET(widget.request)
        //           : ExerciseBody(widget.Name, widget.Indexoftraining),
        //       type: PageTransitionType.leftToRightWithFade),
        // );
        //   },
        // ),
        //   surfaceTintColor: Colors.white,
        //   title: Container(
        //       padding: EdgeInsets.only(right: 20),
        //       alignment: Alignment.center,
        //       child: Text(
        //         "",
        //         style: TextStyle(
        //             fontWeight: FontWeight.bold, fontSize: width * 0.05),
        //       )),
        //   elevation: 0,
        // ),
        body: Container(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: width,
                    height: height * 0.51,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: pointer.workouts.length > 0
                          ? pointer.workouts[index].imagetype == 'net'
                              ? Image.network(pointer.workouts[index].image)
                              : Image.asset(
                                  'asset/Images/Gif/${pointer.workouts[index].name}.gif',
                                  fit: BoxFit.cover)
                          : Container(),
                    ),
                  ),
                  IconButton(
                    icon: Hero(
                      tag: 'back',
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: height * 0.036,
                      ),
                    ),
                    onPressed: () {
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
                                        child: Material(
                                      color: Colors.white,
                                      child: Text(
                                        "Are you sure you want to finish the workout?",
                                        style: TextStyle(
                                            fontSize: height * 0.024,
                                            color: Color(0xFF2C2C2C),
                                            fontFamily: 'UbuntuREG'),
                                      ),
                                    )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: TextButton(
                                              style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(90,
                                                              255, 119, 56))),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: Color(0xFF2C2C2C),
                                                      fontFamily: 'UbuntuREG',
                                                      fontSize:
                                                          height * 0.018))),
                                        ),
                                        TextButton(
                                            style: ButtonStyle(
                                                overlayColor:
                                                    MaterialStateProperty.all(
                                                        Color.fromARGB(
                                                            90, 255, 119, 56))),
                                            onPressed: () async {
                                              /////////////////herrrrreeeeee
                                              if (pointer2 == pointer) {
                                                await Prefs.savePrefInt(
                                                    'workout done', completed);
                                              }
                                              Navigator.pushReplacement<void,
                                                  void>(
                                                context,
                                                PageTransition(
                                                    child: widget.Name ==
                                                            'Custom'
                                                        ? ExerciseBodyNET(
                                                            widget.request,
                                                            widget.info,
                                                            widget
                                                                .workoutscustomlistNotEmpty)

                                                        ///herrree
                                                        : ExerciseBody(
                                                            widget.Name,
                                                            widget
                                                                .Indexoftraining),
                                                    type: PageTransitionType
                                                        .leftToRightWithFade),
                                              );
                                            },
                                            child: Text("Confirm",
                                                style: TextStyle(
                                                    color: Color(0xFF2C2C2C),
                                                    fontFamily: 'UbuntuREG',
                                                    fontSize: height * 0.018)))
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
                  ),
                ],
              ),
              Hero(
                tag: 'big',
                child: Container(
                  height: height * 0.45,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurStyle: BlurStyle.outer,
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Stack(
                    children: [
                      Container(
                          color: Colors.red,
                          width: width,
                          child: Image.asset(
                            'asset/Images/exBack.png',
                            fit: BoxFit.cover,
                          )),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.84),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: width * 0.94,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      pointer.workouts.length > 0
                                          ? "${pointer.workouts[index].name}"
                                          : '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: height * 0.034,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF2C2C2C)),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (index > 0) {
                                                widget.IsCompleted[index] =
                                                    CompletedIndex(
                                                        index, false);
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        childCurrent: Training(
                                                            widget.Name,
                                                            widget
                                                                .Indexoftraining,
                                                            index,
                                                            widget.indexDone,
                                                            widget.IsCompleted,
                                                            widget.request,
                                                            widget.info,
                                                            widget
                                                                .workoutscustomlistNotEmpty),
                                                        child: Training(
                                                            widget.Name,
                                                            widget
                                                                .Indexoftraining,
                                                            --index,
                                                            widget.indexDone > 0
                                                                ? widget.indexDone -
                                                                    1
                                                                : widget
                                                                    .indexDone,
                                                            widget.IsCompleted,
                                                            widget.request,
                                                            widget.info,
                                                            widget
                                                                .workoutscustomlistNotEmpty),
                                                        type: PageTransitionType
                                                            .fade));
                                              }
                                            },
                                            child: Transform.flip(
                                              flipX: true,
                                              child: ShaderMask(
                                                blendMode: BlendMode.srcIn,
                                                shaderCallback: (bounds) =>
                                                    LinearGradient(
                                                            colors:
                                                                index > 0
                                                                    ? [
                                                                        Colors
                                                                            .orange,
                                                                        Colors
                                                                            .deepOrangeAccent,
                                                                        Colors
                                                                            .deepOrange
                                                                      ]
                                                                    : [
                                                                        Colors
                                                                            .grey
                                                                            .shade400,
                                                                        Colors
                                                                            .grey
                                                                            .shade500,
                                                                        Colors
                                                                            .grey
                                                                            .shade600
                                                                      ],
                                                            stops: [.2, .5, 1],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter)
                                                        .createShader(bounds),
                                                child: Icon(
                                                  //Icons.skip_previous,
                                                  FontAwesomeIcons.play,
                                                  size: height * 0.036,
                                                  color: index > 0
                                                      ? Colors.deepOrange
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Container(
                                            width: width * 0.18,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                "Previous",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: height * 0.018,
                                                    color: Color(0xFF2C2C2C)),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    // pointer.workouts.length > 0
                                    //     ? pointer.workouts[index].typeChar == 'C'

                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                blurRadius: 4,
                                                offset: Offset(0, 4))
                                          ],
                                          shape: BoxShape.circle),
                                      child: CircularPercentIndicator(
                                        radius: width * 0.16,
                                        lineWidth: 8.0,
                                        animation:
                                            pointer.workouts[index].typeChar ==
                                                    'C'
                                                ? false
                                                : true,
                                        animationDuration:
                                            pointer.workouts[index].subText *
                                                1000,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor:
                                            pointer.workouts[index].typeChar ==
                                                    'C'
                                                ? Colors.white
                                                : Colors.deepOrangeAccent,
                                        backgroundColor: Colors.white,
                                        percent: 1.0,
                                        center: Container(
                                          alignment: Alignment.center,
                                          width: width * 0.28,
                                          height: width * 0.28,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: pointer.workouts[index]
                                                          .typeChar ==
                                                      'C'
                                                  ? []
                                                  : [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                          blurRadius: 4,
                                                          offset: Offset(0, 4))
                                                    ],
                                              shape: BoxShape.circle),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              pointer.workouts[index]
                                                          .typeChar ==
                                                      'C'
                                                  ? 'x${pointer.workouts[index].subText}'
                                                  : _secondsRemaining < 10
                                                      ? '00:0$_secondsRemaining'
                                                      : '00:$_secondsRemaining',
                                              style: TextStyle(
                                                  fontSize: height * 0.033,
                                                  color: Color(0xFF2C2C2C)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: GestureDetector(
                                              onTap: () {
                                                if (index !=
                                                    pointer.workouts.length -
                                                        1) {
                                                  widget.IsCompleted[index] =
                                                      CompletedIndex(
                                                          index, false);
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          childCurrent: Training(
                                                              widget.Name,
                                                              widget
                                                                  .Indexoftraining,
                                                              index,
                                                              widget.indexDone,
                                                              widget
                                                                  .IsCompleted,
                                                              widget.request,
                                                              widget.info,
                                                              widget
                                                                  .workoutscustomlistNotEmpty),
                                                          child: Training(
                                                              widget.Name,
                                                              widget
                                                                  .Indexoftraining,
                                                              ++index,
                                                              widget.indexDone,
                                                              widget
                                                                  .IsCompleted,
                                                              widget.request,
                                                              widget.info,
                                                              widget
                                                                  .workoutscustomlistNotEmpty),
                                                          type: PageTransitionType
                                                              .rightToLeftJoined));
                                                }
                                              },
                                              child: ShaderMask(
                                                blendMode: BlendMode.srcIn,
                                                shaderCallback: (bounds) =>
                                                    LinearGradient(
                                                            colors: index ==
                                                                    pointer.workouts
                                                                            .length -
                                                                        1
                                                                ? [
                                                                    Colors.grey
                                                                        .shade400,
                                                                    Colors.grey
                                                                        .shade500,
                                                                    Colors.grey
                                                                        .shade600
                                                                  ]
                                                                : [
                                                                    Colors
                                                                        .orange,
                                                                    Colors
                                                                        .deepOrangeAccent,
                                                                    Colors
                                                                        .deepOrange
                                                                  ],
                                                            stops: [.2, .5, 1],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter)
                                                        .createShader(bounds),
                                                child: Icon(
                                                  FontAwesomeIcons.play,
                                                  size: height * 0.036,
                                                  color: index ==
                                                          pointer.workouts
                                                                  .length -
                                                              1
                                                      ? Colors.grey
                                                      : Colors.deepOrange,
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Container(
                                            width: width * 0.18,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                "Skip",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: height * 0.018,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Container()
                              ],
                            ),
                          ),
                        ),
                      ),
                      /////////////////////DONE/////////////////
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Container(
                          width: width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Container(
                                  width: width * 0.7,
                                  height: height * 0.059,
                                  margin: const EdgeInsets.only(
                                      top: 60, bottom: 20),
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(350),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (index !=
                                          pointer.workouts.length - 1) {
                                        widget.IsCompleted[index] =
                                            CompletedIndex(index, true);
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                childCurrent: Training(
                                                    widget.Name,
                                                    widget.Indexoftraining,
                                                    index,
                                                    widget.indexDone + 1,
                                                    widget.IsCompleted,
                                                    widget.request,
                                                    widget.info,
                                                    widget
                                                        .workoutscustomlistNotEmpty),
                                                child: Training(
                                                    widget.Name,
                                                    widget.Indexoftraining,
                                                    ++index,
                                                    widget.indexDone + 1,
                                                    widget.IsCompleted,
                                                    widget.request,
                                                    widget.info,
                                                    widget
                                                        .workoutscustomlistNotEmpty),
                                                type: PageTransitionType
                                                    .rightToLeftJoined));
                                      } else if (index ==
                                          pointer.workouts.length - 1) {
                                        if (pointer2 == pointer) {
                                          await Prefs.savePrefInt(
                                              'workout done', completed + 1);
                                        }
                                        Navigator.pushReplacement<void, void>(
                                            context,
                                            PageTransition(
                                                child: widget.Name == 'Custom'
                                                    ? ExerciseBodyNET(
                                                        widget.request,
                                                        widget.info,
                                                        widget
                                                            .workoutscustomlistNotEmpty) ////hereee
                                                    : ExerciseBody(widget.Name,
                                                        widget.Indexoftraining),
                                                type: PageTransitionType
                                                    .leftToRightWithFade));
                                        if (!mounted) return;
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(350))),
                                      margin: const EdgeInsets.all(5),
                                      child: ShaderMask(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            index == pointer.workouts.length - 1
                                                ? 'Confirm'
                                                : 'Done',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: height * 0.025,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        shaderCallback: (rect) {
                                          return LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.orange,
                                                Colors.red
                                              ]).createShader(rect);
                                        },
                                      ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<listviews> Beginner = [
    listviews("Beginner", 0),
    listviews("Beginner", 1),
    listviews("Beginner", 2),
    listviews("Beginner", 3),
  ];
  List<listviews> Custom = [
    listviews("Custom", 0),
    listviews("Custom", 1),
    listviews("Custom", 2),
    listviews("Custom", 3),
  ];
}

class listviews {
  String name;
  var inddexofTraining;
  listviews(this.name, this.inddexofTraining);
}
