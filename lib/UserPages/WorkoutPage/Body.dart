import 'package:flutter/services.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/UserPages/WorkoutPage/AssessmentHome.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Constants.dart';

import 'package:hayaproject/UserPages/WorkoutPage/FrequencyHome.dart';
import 'package:page_transition/page_transition.dart';

class BodyChoice {
  late String choiceText;
  late String genderChar;
  late Widget bodyImg = Image.asset(
    'asset/BodyMap/${genderChar}${choiceText}.png',
    fit: BoxFit.fitHeight,
  );
  late double opacity = 0;
  late Container checkMark = Container();
  BodyChoice({required String text, required genderChar}) {
    choiceText = text;
    this.genderChar = genderChar;
  }

  late BoxDecoration ChoosenDecor = boxDefault;
  Widget bodyParts(
      {required VoidCallback fn, required var size, required var genderChar}) {
    if (choiceText == 'Chest' && genderChar == 'F') {
      return Container();
    }
    return Expanded(
      child: GestureDetector(
        onTap: fn,
        child: AnimatedContainer(
          margin: EdgeInsets.symmetric(
              vertical: genderChar == 'M' ? 10 : 20, horizontal: 30),
          duration: Duration(milliseconds: 50),
          alignment: Alignment.center,
          child: Stack(alignment: Alignment.topRight, children: [
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  choiceText,
                  style: choiceTextStyle.copyWith(
                    fontSize: size.height * 0.024,
                  ), ///////////////////////////
                ),
              ),
            ),
            checkMark,
          ]),
          decoration: ChoosenDecor,
        ),
      ),
    );
  }
}

///////////////////////Class////////////////////////////////
class Body extends StatefulWidget {
  int choiceGoal;
  String genderChar;
  String userID;
  Body(this.genderChar, this.choiceGoal, this.userID);

  @override
  State<Body> createState() => _BodyState();
}

late BodyChoice arm;
late BodyChoice chest;
late BodyChoice abs;
late BodyChoice legs;

void activate(BodyChoice bodyPart) {
  if (bodyPart.ChoosenDecor == boxDefault) {
    bodyPart.checkMark = check;
    bodyPart.opacity = 1;
    bodyPart.ChoosenDecor = boxActive;
  } else if (bodyPart.ChoosenDecor == boxActive) {
    bodyPart.opacity = 0;
    bodyPart.ChoosenDecor = boxDefault;
    bodyPart.checkMark = Container();
  }
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gaugeAnimation;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _gaugeAnimation = Tween(begin: 25.0, end: 50.0)
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
    arm = new BodyChoice(text: 'Arms', genderChar: widget.genderChar);
    chest = widget.genderChar == 'M'
        ? new BodyChoice(text: 'Chest', genderChar: widget.genderChar)
        : arm;
    abs = new BodyChoice(text: 'Abs', genderChar: widget.genderChar);
    legs = new BodyChoice(text: 'Legs', genderChar: widget.genderChar);
  }

  int armChoice = 0;
  int absChoice = 0;
  int chestChoice = 0;
  int legsChoice = 0;
  @override
  Widget build(BuildContext context) {
    if (arm.ChoosenDecor == boxActive) armChoice = 1;
    if (chest.ChoosenDecor == boxActive && genderChar == 'M') chestChoice = 1;
    if (abs.ChoosenDecor == boxActive) absChoice = 1;
    if (legs.ChoosenDecor == boxActive) legsChoice = 1;
    if (arm.ChoosenDecor != boxActive) armChoice = 0;
    if (chest.ChoosenDecor != boxActive) chestChoice = 0;
    if (abs.ChoosenDecor != boxActive) absChoice = 0;
    if (legs.ChoosenDecor != boxActive) legsChoice = 0;

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
            padding: EdgeInsets.fromLTRB(30, 20, 0, 30),
            child: Text(
              'Please select target body areas for training',
              style: TextStyle(
                letterSpacing: -0.2,
                fontFamily: 'UbuntuBOLD',
                fontSize: size.height * 0.032,
              ),
            ),
          ),
          //////////////////////////////////////////
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        arm.bodyParts(
                            fn: () {
                              setState(() {
                                activate(arm);
                              });
                            },
                            size: size,
                            genderChar: widget.genderChar),
                        widget.genderChar == 'M'
                            ? chest.bodyParts(
                                fn: () {
                                  setState(() {
                                    if (widget.genderChar == 'M')
                                      activate(chest);
                                  });
                                },
                                size: size,
                                genderChar: widget.genderChar)
                            : Container(),
                        abs.bodyParts(
                            fn: () {
                              setState(() {
                                activate(abs);
                              });
                            },
                            size: size,
                            genderChar: widget.genderChar),
                        legs.bodyParts(
                            fn: () {
                              setState(() {
                                activate(legs);
                              });
                            },
                            size: size,
                            genderChar: widget.genderChar),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(fit: StackFit.expand, children: [
                    AnimatedOpacity(
                        opacity: arm.opacity,
                        duration: Duration(milliseconds: 120),
                        child: arm.bodyImg),
                    AnimatedOpacity(
                        opacity: chest.opacity,
                        duration: Duration(milliseconds: 120),
                        child: chest.bodyImg),
                    AnimatedOpacity(
                        opacity: abs.opacity,
                        duration: Duration(milliseconds: 120),
                        child: abs.bodyImg),
                    AnimatedOpacity(
                        opacity: legs.opacity,
                        duration: Duration(milliseconds: 120),
                        child: legs.bodyImg),
                    Image.asset(
                      'asset/BodyMap/${widget.genderChar}Body.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ]),
                )
              ],
            ),
          ),
          /////////////////////////NEXT BUTTON//////////////////////////////////////
          Hero(
              tag: 'next',
              child: nextbutton(
                cls: () {
                  if (!(absChoice == 0 &&
                      armChoice == 0 &&
                      chestChoice == 0 &&
                      legsChoice == 0))
                    Navigator.push(
                        context,
                        PageTransition(
                            child: FrequencyHome(
                                widget.choiceGoal,
                                armChoice,
                                chestChoice,
                                absChoice,
                                legsChoice,
                                widget.userID),
                            type: PageTransitionType.rightToLeftWithFade,
                            childCurrent: Body(widget.genderChar,
                                widget.choiceGoal, widget.userID)));
                },
              ))
        ],
      ),
    );
  }
}
