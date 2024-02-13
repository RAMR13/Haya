import 'dart:async';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Body.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Constants.dart';
import 'package:page_transition/page_transition.dart';

class Choice {
  late String choiceText;
  late String imageName;
  Choice({required String text, required String img}) {
    choiceText = text;
    imageName = img;
  }
  late Container cont = Container();
  late BoxDecoration selectedBox = boxDefault;
  Widget choice({
    required VoidCallback fn,
    required var size,
  }) {
    return GestureDetector(
      onTap: fn,
      child: AnimatedContainer(
        height: size.height * 0.13,
        duration: Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FittedBox(
                  alignment: Alignment.topLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    choiceText,
                    style: choiceTextStyle.copyWith(
                      fontSize: size.height * 0.024,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Stack(alignment: Alignment.topRight, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image(
                    image: AssetImage('asset/Images/$imageName.png'),
                  ),
                ),
                cont,
              ]),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: selectedBox,
      ),
    );
  }
}

String genderChar = '';

class AssessmentHome extends StatefulWidget {
  String gender;
  String UserId;
  AssessmentHome({required this.gender, required this.UserId});

  @override
  State<AssessmentHome> createState() => _AssesmenHomeState();
}

void active(Choice one, Choice two, Choice three) {
  if (two.selectedBox == boxActive) {
    two.selectedBox = boxDefault;
    two.cont = Container();
  }
  if (three.selectedBox == boxActive) {
    three.selectedBox = boxDefault;
    three.cont = Container();
  }
  if (one.selectedBox == boxDefault) {
    one.selectedBox = boxActive;
    one.cont = check;
  }
}

class _AssesmenHomeState extends State<AssessmentHome>
    with TickerProviderStateMixin {
  String gender = 'Male';
  late AnimationController _controller;
  late Animation<double> _gaugeAnimation;
  late Choice a;
  late Choice b;
  late Choice c;
  String genderChar = 'M';
  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _gaugeAnimation = Tween(begin: 0.0, end: 25.0)
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
    gender = widget.gender;
    genderChar = gender == 'Male' ? 'M' : 'F';
    a = new Choice(text: 'Lose weight', img: 'weight');
    b = new Choice(
        text: gender == 'Male' ? 'Gain muscle' : 'Get stronger',
        img: '${genderChar}muscle');
    c = new Choice(text: 'Keep fit', img: '${genderChar}fit');
  }

  int choice = -1;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (a.selectedBox == boxActive) choice = 1;
    if (b.selectedBox == boxActive) choice = 2;
    if (c.selectedBox == boxActive) choice = 3;
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
            padding: EdgeInsets.fromLTRB(30, 20, 0, 30),
            child: Text(
              'What\'s your goal?',
              style: TextStyle(
                letterSpacing: -0.2,
                fontFamily: 'UbuntuBOLD',
                fontSize: size.height * 0.032,
              ),
            ),
          ),
          //choice('Lose weight', 'weight'),

          a.choice(
              fn: () {
                setState(() {
                  active(a, b, c);
                });
              },
              size: size),
          b.choice(
              fn: () {
                setState(() {
                  active(b, a, c);
                });
              },
              size: size),
          c.choice(
              fn: () {
                setState(
                  () {
                    active(c, a, b);
                  },
                );
              },
              size: size),

          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          ///////////////////////////NEXT BUTTON//////////////////////////////////
          Hero(
              tag: 'next',
              child: nextbutton(cls: () {
                if (choice != -1) {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Body(genderChar, choice, widget.UserId),
                          type: PageTransitionType.rightToLeftWithFade,
                          childCurrent: AssessmentHome(
                            gender: widget.gender,
                            UserId: widget.UserId,
                          )));
                }
              }))
        ],
      ),
    );
  }
}
