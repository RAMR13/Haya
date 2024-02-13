import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Constants.dart';
import 'package:hayaproject/UserPages/WorkoutPage/WeeklyGoal.dart';
import 'package:page_transition/page_transition.dart';

class Frequency {
  late String choiceText;
  late String imageName;
  late String subText;

  Frequency({
    required String text,
    required String subStr,
    required String img,
  }) {
    subText = subStr;
    choiceText = text;
    imageName = img;
  }

  late Container cont = Container();
  late BoxDecoration selectedBox = boxDefault;
  Widget frequency({required VoidCallback fn, required var size}) {
    return GestureDetector(
      onTap: fn,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: AnimatedContainer(
          height: size.height * 0.12,
          duration: Duration(milliseconds: 100),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text(
                        choiceText,
                        style: choiceTextStyle.copyWith(
                          fontSize: size.height * 0.023,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 6, 0, 0),
                      child: Text(
                        subText,
                        style: subTextStyle.copyWith(
                          fontSize: size.height * 0.018,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Stack(alignment: Alignment.topRight, children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 10, 20),
                    child: Image(
                      image: AssetImage('asset/Images/$imageName.png'),
                    ),
                  ),
                  cont,
                ]),
              ),
            ],
          ),
          decoration: selectedBox,
        ),
      ),
    );
  }
}

////////////////
class FrequencyHome extends StatefulWidget {
  int choiceGoal;
  int armChoice;
  int absChoice;
  int chestChoice;
  int legChoice;
  String userID;
  FrequencyHome(this.choiceGoal, this.armChoice, this.absChoice,
      this.chestChoice, this.legChoice, this.userID);

  @override
  State<FrequencyHome> createState() => _AssesmenHomeState();
}

Frequency a = new Frequency(
    text: 'Lightly active',
    subStr: 'Light exercise\n1-3 Days/Week',
    img: 'Vector 1');
Frequency b = new Frequency(
    text: 'Moderately active',
    subStr: 'Moderate exercise\n3-5 Days/Week',
    img: 'Vector 2');
Frequency c = new Frequency(
    text: 'Very active',
    subStr: 'Heavy exercise\n6-7 Days/Week',
    img: 'Vector 3');
void active(Frequency one, Frequency two, Frequency three) {
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

class _AssesmenHomeState extends State<FrequencyHome>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gaugeAnimation;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _gaugeAnimation = Tween(begin: 50.0, end: 75.0)
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

  int activeChoice = -1;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (a.selectedBox == boxActive) activeChoice = 1;
    if (b.selectedBox == boxActive) activeChoice = 2;
    if (c.selectedBox == boxActive) activeChoice = 3;
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
              'How active are you?',
              style: TextStyle(
                letterSpacing: -0.2,
                fontFamily: 'UbuntuBOLD',
                //fontSize: 28,
                fontSize: size.height * 0.032,
              ),
            ),
          ),

          a.frequency(
              fn: () {
                setState(() {
                  active(a, b, c);
                });
              },
              size: size),
          b.frequency(
              fn: () {
                setState(() {
                  active(b, a, c);
                });
              },
              size: size),
          c.frequency(
              fn: () {
                setState(() {
                  active(c, a, b);
                });
              },
              size: size),

          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          ///////////////////////////NEXT BUTTON//////////////////////////////////
          Hero(
              tag: 'next',
              child: nextbutton(
                cls: () {
                  if (activeChoice != -1)
                    Navigator.push(
                        context,
                        PageTransition(
                            child: WeeklyGoal(
                                activeChoice,
                                widget.choiceGoal,
                                widget.absChoice,
                                widget.armChoice,
                                widget.chestChoice,
                                widget.legChoice,
                                widget.userID),
                            type: PageTransitionType.rightToLeftWithFade,
                            childCurrent: FrequencyHome(
                                widget.choiceGoal,
                                widget.armChoice,
                                widget.absChoice,
                                widget.chestChoice,
                                widget.legChoice,
                                widget.userID)));
                },
              ))
        ],
      ),
    );
  }
}
