import 'dart:async';

import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/signup.dart';
import 'package:page_transition/page_transition.dart';
import 'login.dart';

class IntroHome extends StatefulWidget {
  const IntroHome({super.key});

  @override
  State<IntroHome> createState() => _IntroHomeState();
}

Widget IconPlace(BuildContext context, IconData icon, String text) {
  var size = MediaQuery.of(context).size;
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: size.height * 0.31, //size.height - 600,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color.fromARGB(0, 255, 255, 255),
                Color.fromARGB(45, 255, 255, 255),
                Color.fromARGB(160, 255, 255, 255)
              ])),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                    Color.fromARGB(0, 255, 255, 255),
                    Color.fromARGB(45, 255, 255, 255),
                    Color.fromARGB(160, 255, 255, 255)
                  ])),
              child: Icon(
                icon,
                size: size.height * 0.18, //160,
                color: Color.fromARGB(162, 0, 0, 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xE6FFFFFF), fontSize: size.height * 0.021 // 18
                ),
          ),
        ),
      ]);
}

List<BoxDecoration> x = [x1, x2, x3, x4, x5];
BoxDecoration x1 = BoxDecoration(
    gradient: LinearGradient(
        colors: [
          Color.fromARGB(213, 255, 133, 62),
          Color(0xFFFA6565),
          Color(0xFFF65A5A),
          Color.fromARGB(235, 213, 66, 66),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0004, 0.3, 0.6, 0.9]));
BoxDecoration x2 = BoxDecoration(
    gradient: LinearGradient(colors: [
  Color.fromARGB(255, 253, 156, 52),
  Color.fromARGB(248, 253, 104, 59),
  Color.fromARGB(255, 253, 117, 58),
  Color.fromARGB(236, 253, 162, 65)
], stops: [
  0.0004,
  0.3,
  0.6,
  0.9
], begin: Alignment.topCenter, end: Alignment.bottomCenter));
BoxDecoration x3 = BoxDecoration(
    gradient: LinearGradient(colors: [
  Color(0xFF96C173),
  Color(0xFF2996B8),
], begin: Alignment.topCenter, end: Alignment.bottomCenter));

BoxDecoration x4 = BoxDecoration(
    gradient: LinearGradient(colors: [
  Color(0xFF73B3C1),
  Color(0xFF48BDFF),
  Color.fromARGB(255, 55, 122, 223),
], begin: Alignment.topCenter, end: Alignment.bottomCenter));
BoxDecoration x5 = BoxDecoration(
    gradient: LinearGradient(colors: [
  Color.fromARGB(255, 140, 203, 218),
  Color(0xFF48BDFF),
  Color.fromARGB(255, 59, 51, 219),
], begin: Alignment.topCenter, end: Alignment.bottomCenter));

List<IconData> ico = [
  FontAwesomeIcons.personRunning,
  Icons.person,
  FontAwesomeIcons.solidCalendarDays,
  Icons.restaurant_rounded
];

Paint toPaint() {
  final Paint result = Paint()
    ..color = const Color.fromARGB(197, 0, 0, 0)
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 40);
  assert(() {
    if (debugDisableShadows) result.maskFilter = null;
    return true;
  }());
  return result;
}

class _IntroHomeState extends State<IntroHome> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  CustomBoxShadow shadow = new CustomBoxShadow(
      color: Color(0x1A000000),
      offset: new Offset(0, 2),
      blurRadius: 10,
      blurStyle: BlurStyle.outer);

  //////////////////////
  dynamic q = '';
  double val = 4;

  //late Timer _timer;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final PageController _pageController = PageController();
  bool isEnd = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white));

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: 'arrow',
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Color(0xFF2C2C2C).withOpacity(0),
                  size: size.height * 0.036,
                ),
              ),
              Hero(
                tag: 'haya',
                child: Image.asset(
                  'asset/asset Images Rand/Colored.png',
                  height: size.height * 0.065, //70,
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.transparent,
                size: size.height * 0.036,
              ),
            ],
          ),
        ),
        body: TweenAnimationBuilder(
          curve: Curves.ease,
          duration: const Duration(seconds: 20),
          tween: Tween<double>(begin: 0, end: val),
          builder: (BuildContext context, value, Widget? child) =>
              AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: size.height,
            width: size.width,
            decoration: x[value.toInt()],
            ///////////////////////////////
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.18),
                    child: SizedBox(
                      height: size.height * 0.4, //320,
                      child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          padEnds: false,
                          controller: _pageController,
                          children: [
                            IconPlace(context, ico[0], 'Stay active'),
                            IconPlace(context, ico[1], 'Find an expert'),
                            IconPlace(context, ico[2], 'Join events'),
                            IconPlace(context, ico[3], 'Eat healthy')
                          ]),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: SignUp(),
                                    childCurrent: IntroHome(),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    duration: Duration(milliseconds: 120)));
                          },
                          //////////////////////////////////////////////
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            height: size.height * 0.064,
                            //55,
                            child: Text(
                              'Sign up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xE6FFFFFF), fontSize: 20),
                            ),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x40FFFFFF),
                                      Color(0x26EAEAEA),
                                      Color(0x00D9D9D9)
                                    ]),
                                boxShadow: [shadow],
                                color: Color.fromARGB(255, 76, 76, 76),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                )),
                          ),
                        ),
                        Container(
                          height: size.height * 0.012, //10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Login(),
                                    childCurrent: IntroHome(),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    duration: Duration(milliseconds: 120)));
                          }, //////////////////////////////////////
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            height: size.height * 0.064,
                            //55,
                            child: Text(
                              'Log in',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xE6FFFFFF), fontSize: 20),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0x40FFFFFF),
                                    Color(0x26EAEAEA),
                                    Color(0x00D9D9D9)
                                  ]),
                              boxShadow: [shadow],
                              color: Color.fromARGB(255, 76, 76, 76),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onEnd: () {
              _pageController.animateToPage(value.toInt(),
                  duration: Duration(milliseconds: 400), curve: Curves.linear);
            },
          ),
          key: ValueKey(q),
          onEnd: () {
            setState(() {
              val = val == 3 ? 0 : 3;
            });
          },
        ),
      ),
    );
  }
}

////////////////////////////////////////////////
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
