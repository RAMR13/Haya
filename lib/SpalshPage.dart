import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/AdminPage/navigatorbarAdmin/NavigationBar.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/WelcomePage.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  double opacity = 0;
  var Type;
  bool? isLogin;
  void initState() {
    Prefs.getBoolean("IsLogin").then(
      (value) {
        isLogin = value;
      },
    );
    Prefs.getString("Type").then(
      (value) {
        Type = value;
      },
    );

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1;
      });
    });

    Timer(Duration(milliseconds: 2000), () {
      if (isLogin == true) {
        setState(() {});
        if (Type == "trainer" || Type == "nutritionist") {
          widgetPage = MainScreenSpec("");
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: MainScreenSpec(""), type: PageTransitionType.fade));
        }
        if (Type == "User") {
          widgetPage = MainScreenUser("");
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: MainScreenUser(""), type: PageTransitionType.fade));
        }
        if (Type == "Admin") {
          widgetPage = MainScreenAdmin('');
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: MainScreenAdmin(''), type: PageTransitionType.fade));
        }
      } else {
        Navigator.pushReplacement(context,
            PageTransition(child: IntroHome(), type: PageTransitionType.fade));
        widgetPage = IntroHome();
      }
    });

    // print(isLogin.toString());

    super.initState();
  }

  Widget? widgetPage;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFFF9F9F9),
        body: Container(
          width: width,
          height: height,
          child: Center(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 620),
              opacity: opacity,
              child: Transform.rotate(
                angle: math.pi * 1.5,
                child: Container(
                  width: height * 0.33,
                  height: height * 0.33,
                  decoration: BoxDecoration(
                      gradient: SweepGradient(
                        tileMode: TileMode.repeated,
                        colors: [
                          Colors.orangeAccent,
                          Colors.orange,
                          Colors.deepOrangeAccent,
                          Colors.deepOrange,
                          Colors.deepOrangeAccent,
                          Colors.orange,
                          Colors.orangeAccent,
                        ],
                      ),
                      shape: BoxShape.circle),
                  child: Transform.rotate(
                    angle: math.pi * 1.5 * 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Colors.deepOrange.withOpacity(0.7)
                        CircularProgressIndicator(
                          color: Color(0xFFF9F9F9),
                          strokeWidth: height * 0.04,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: height * 0.31,
                              height: height * 0.31,
                              decoration: BoxDecoration(
                                  color: Color(0xFFF9F9F9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(4, 16),
                                      blurRadius: 8,
                                      inset: true,
                                    ),
                                    BoxShadow(
                                      inset: true,
                                      color: Colors.black.withOpacity(0.45),
                                      offset: const Offset(-2, -14),
                                      blurRadius: 12,
                                    ),
                                  ]),
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 1020),
                                opacity: opacity,
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(bottom: height * 0.025),
                                    child: Image.asset(
                                      "Images/haya 5.png",
                                      fit: BoxFit.cover,
                                      height: height * 0.18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
