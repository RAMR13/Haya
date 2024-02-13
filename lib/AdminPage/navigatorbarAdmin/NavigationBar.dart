import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/AdminPage/EventPageAdmin/EventAdminPage.dart';
import 'package:hayaproject/AdminPage/FoodAdmin/foodAdmin.dart';
import 'package:hayaproject/AdminPage/WorkoutPageAdmin/AddExercise.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:icon_decoration/icon_decoration.dart';
import '../ExpertPageAdmin/ExpertAdminPage.dart';

class MainScreenAdmin extends StatefulWidget {
  String nameofpage;

  MainScreenAdmin(this.nameofpage);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreenAdmin> {
  int selectedIndex = 0;

  void page() {
    if (widget.nameofpage.length > 0) {
      if (widget.nameofpage == "eventpage") {
        _widget = eventpageAdmin();
        selectedIndex = 1;
      } else if (widget.nameofpage == "wk") {
        _widget = AddWorkout();
        selectedIndex = 2;
      } else if (widget.nameofpage == "food") {
        _widget = FoodAdminPage();
        selectedIndex = 3;
      }
    } else if (widget.nameofpage.length == 0) {
      _widget = ExpertAdminPage();
      selectedIndex = 0;
    }
  }

  late Widget _widget;

  @override
  void initState() {
    page();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IconDecoration unsel = IconDecoration();
    IconDecoration sel = IconDecoration(
        border: IconBorder(
      width: 2.0,
      color: Color.fromARGB(255, 253, 110, 27),
    ));

    IconDecoration sel2 = IconDecoration(
        border: IconBorder(
      width: 2,
      color: Colors.black.withOpacity(0.2),
    ));
    Widget fakeShadow(
        {required int selectedIndex,
        required IconData icon,
        required int index}) {
      return Stack(children: [
        Visibility(
          visible: selectedIndex == index ? true : false,
          child: Padding(
            padding: EdgeInsets.only(top: 2),
            child: DecoratedIcon(icon: Icon(icon), decoration: sel2),
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: DecoratedIcon(
                icon: Icon(icon),
                decoration: selectedIndex == index ? sel : unsel),
          ),
        ),
      ]);
    }

    IconDecoration sel3 = IconDecoration(
        border: IconBorder(
      width: 1.5,
      color: Colors.black.withOpacity(0.2),
    ));
    Widget activeIcon({required IconData icon}) {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.5),
            child: DecoratedIcon(
                icon: Icon(
                  icon,
                ),
                decoration: sel3),
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: DecoratedIcon(
                decoration: IconDecoration(
                    border: IconBorder(
                  width: 0.1,
                  color: Color.fromARGB(255, 255, 115, 0),
                )),
                icon: Icon(
                  icon,
                  color: Color.fromARGB(255, 255, 115, 0),
                ),
              ),
            ),
          ),
        ],
      );
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: _widget,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 3,
            width: width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.transparent
                ])),
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Theme(
                data: ThemeData(splashColor: Colors.transparent),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.white.withOpacity(0.85),
                  useLegacyColorScheme: false,
                  iconSize: height * 0.03,
                  unselectedFontSize: height * 0.0125,
                  selectedFontSize: height * 0.012,
                  selectedIconTheme: IconThemeData(
                      size: height * 0.031, color: Colors.transparent),
                  type: BottomNavigationBarType.fixed,
                  onTap: onTap,
                  selectedLabelStyle: TextStyle(
                    color: Color.fromARGB(255, 253, 110, 27),
                  ),
                  unselectedItemColor: Colors.black.withOpacity(0.6),
                  currentIndex: selectedIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: fakeShadow(
                          selectedIndex: selectedIndex,
                          icon: MyFlutterApp.user,
                          index: 0),
                      label: "Expert",
                    ),
                    BottomNavigationBarItem(
                      activeIcon: activeIcon(icon: MyFlutterApp.note_1),
                      icon: fakeShadow(
                          selectedIndex: selectedIndex,
                          icon: MyFlutterApp.note_1__1_,
                          index: 1),
                      label: "Events",
                    ),
                    BottomNavigationBarItem(
                        activeIcon: Stack(
                          children: [
                            /*  Padding(
                              padding: EdgeInsets.only(top: 1.5),
                              child: DecoratedIcon(
                                  icon: Icon(
                                    MyFlutterApp.dumbbell_1,
                                    size: height * 0.035,
                                  ),
                                  decoration: sel2),
                            ),*/
                            ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                child: DecoratedIcon(
                                  decoration: IconDecoration(
                                      border: IconBorder(
                                    width: 1.8,
                                    color: Color.fromARGB(255, 255, 115, 0),
                                  )),
                                  icon: Icon(
                                    MyFlutterApp.dumbbell_1,
                                    size: height * 0.035,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        icon: DecoratedIcon(
                            icon: Icon(
                          MyFlutterApp.dumbbell,
                        )),
                        label: "Workout"),
                    BottomNavigationBarItem(
                        icon: fakeShadow(
                            selectedIndex: selectedIndex,
                            icon: MyFlutterApp.apple_whole_solid_1,
                            index: 3),
                        label: "Nutrition"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTap(int cIndex) {
    selectedIndex = cIndex;
    if (cIndex == 0) {
      _widget = ExpertAdminPage();
    } else if (cIndex == 1) {
      _widget = eventpageAdmin();
    } else if (cIndex == 2) {
      _widget = AddWorkout();
    } else if (cIndex == 3) {
      _widget = FoodAdminPage();
    }
    setState(() {});
  }
}

class CustomShadow extends Shadow {
  final BlurStyle blurStyle;
  const CustomShadow({
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
