import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Body.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Constants.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:page_transition/page_transition.dart';

////////////////

////////////////
class WeeklyGoal extends StatefulWidget {
  int activeChoice;
  int choiceGoal;
  int absChoice;
  int armChoice;
  int chestChoice;
  int legChoice;
  String userID;
  WeeklyGoal(this.activeChoice, this.choiceGoal, this.absChoice, this.armChoice,
      this.chestChoice, this.legChoice, this.userID);
  @override
  State<WeeklyGoal> createState() => _AssesmenHomeState();
}

class _AssesmenHomeState extends State<WeeklyGoal>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gaugeAnimation;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _gaugeAnimation = Tween(begin: 75.0, end: 100.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.dispose();
      }
      ;
    });
  }

  int pickerSelectedVal = 1;
  @override
  Widget build(BuildContext context) {
    print(widget.userID);
    var size = MediaQuery.of(context).size;
    double pickerSize = size.width * 0.095;
    fontsizepicker = pickerSize;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        title: Hero(
          tag: 'appbar',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF2C2C2C),
                    size: size.height * 0.036,
                  )),
              AnimatedContainer(
                duration: Duration(seconds: 2),
                width: size.height * 0.038,
                child: gauge(_gaugeAnimation.value),
              )
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 0, 10),
            child: Text(
              'Set your weekly goal',
              style: TextStyle(
                letterSpacing: -0.2,
                fontFamily: 'UbuntuBOLD',
                fontSize: size.height * 0.032,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 65, 30),
            child: Text(
              'We recommend training for at least 3 days a week to achieve optimal results.',
              style: subTextStyle.copyWith(
                fontSize: size.height * 0.018,
              ),
            ),
          ),

          Expanded(
            child: Stack(children: [
              ////////////////////////
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: cupertino.CupertinoPicker(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      selectionOverlay: Container(
                        decoration: pickerStyle,
                      ),
                      magnification: 1.5,
                      squeeze: 0.6,
                      itemExtent: size.width * 0.11,
                      children: week,
                      onSelectedItemChanged: (value) {
                        pickerSelectedVal = value + 1;
                      },
                      diameterRatio: 2,
                    )),
              ),
              //////////////////////////
              IgnorePointer(
                ignoring: true,
                child: Container(
                  height: size.height * 0.5 - 210,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                        0.4,
                        0.9
                      ],
                          colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(0, 255, 255, 255)
                      ])),
                ),
              ),
              ////////////////////////////
              Align(
                alignment: Alignment.bottomCenter,
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    height: size.height * 0.5 - 210,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                          0.4,
                          0.9
                        ],
                            colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(0, 255, 255, 255)
                        ])),
                  ),
                ),
              ),
              ///////////////////////////
            ]),
          ),

          ///////////////////////////NEXT BUTTON//////////////////////////////////
          Hero(
              tag: 'next',
              child: nextbutton(
                text: 'Confirm',
                cls: () async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.userID)
                      .collection('assessment')
                      .doc("1")
                      .set({
                    "goal choice": widget.choiceGoal,
                    "active choice": widget.activeChoice,
                    "week goal": pickerSelectedVal,
                    "arm": widget.armChoice,
                    "abs": widget.absChoice,
                    "chest": widget.chestChoice,
                    "leg": widget.legChoice,
                  });
                  Navigator.pushReplacement<void, void>(
                      context,
                      PageTransition(
                          child: MainScreenUser("WHomePage"),
                          type: PageTransitionType.leftToRightWithFade));

                  //     .doc("${widget.userID}")
                  //     .collection("assessment")
                  //     .add({
                  // "goal choice": widget.choiceGoal,
                  // "active choice": widget.activeChoice,
                  // "week goal": pickerSelectedVal,
                  // "arm": widget.armChoice,
                  // "abs": widget.absChoice,
                  // "chest": widget.chestChoice,
                  // "leg": widget.legChoice,
                  // });
                },
              ))
        ],
      ),
    );
  }
}
