import 'dart:ui';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:get/get.dart';
import 'package:hayaproject/AdminPage/EventPageAdmin/EventAdminPage.dart';
import 'package:hayaproject/UserPages/HomePage/HomePageUser.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart' as cupertino;

BoxDecoration pickerStyle = BoxDecoration(
  border: Border.all(
      width: 2,
      color: const Color.fromARGB(255, 244, 92, 54),
      strokeAlign: BorderSide.strokeAlignOutside),
  borderRadius: BorderRadius.all(Radius.circular(7)),
);
List<String> Months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
List thirty = [4, 6, 9, 11];
Future<dynamic> newMethodBD(
    double height, double width, Date date, Context contexts) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
    context: contexts.context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, StateSetter setstate) => Container(
          height: height * 0.45,
          width: width,
          clipBehavior: cupertino.Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height * 0.35,
                width: width,
                child: Stack(children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: width,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  //////////////day
                                  width: width / 3.5,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: cupertino.CupertinoPicker(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    selectionOverlay: Container(
                                        // decoration: pickerStyle,
                                        ),
                                    magnification: 1.5,
                                    squeeze: 0.6,
                                    itemExtent: width * 0.11,
                                    children: List<Widget>.generate(
                                        date.month == DateTime.now().month &&
                                                date.year == DateTime.now().year
                                            ? DateTime.now().day
                                            : date.month == 2 &&
                                                    date.year % 4 == 0
                                                ? 29
                                                : date.month == 2 &&
                                                        date.year % 4 != 0
                                                    ? 28
                                                    : thirty.contains(
                                                            date.month)
                                                        ? 30
                                                        : 31, (index) {
                                      return Center(
                                          child: Text(
                                        (++index).toString(),
                                        style: TextStyle(
                                            color: Color(0xFF2C2C2C),
                                            fontSize: height * 0.023),
                                      ));
                                    }),
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: date.day -
                                                1 // DateTime.now().day - 1
                                            ),
                                    onSelectedItemChanged: (value) {
                                      setstate(() {
                                        date.day = value + 1;
                                      });
                                    },
                                    diameterRatio: 2,
                                  )),
                              Container(
                                  width: width / 2.5,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: cupertino.CupertinoPicker(
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: date.month -
                                                1 // DateTime.now().month - 1
                                            ),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    selectionOverlay: Container(
                                        //  decoration: pickerStyle,
                                        ),
                                    magnification: 1.5,
                                    squeeze: 0.6,
                                    itemExtent: width * 0.11,
                                    children:
                                        List<Widget>.generate(12, (index) {
                                      return Center(
                                          child: Text(
                                        Months[index],
                                        style: TextStyle(
                                            color: Color(0xFF2C2C2C),
                                            fontSize: height * 0.023),
                                      ));
                                    }),
                                    onSelectedItemChanged: (value) {
                                      setstate(() {
                                        date.month = value + 1;
                                      });
                                    },
                                    diameterRatio: 2,
                                  )),
                              Container(
                                  width: width / 3.5,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: cupertino.CupertinoPicker(
                                    scrollController: FixedExtentScrollController(
                                        initialItem: date.year -
                                            1900 //DateTime.now().year - 1900,
                                        ),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    selectionOverlay: Container(
                                        //  decoration: pickerStyle,
                                        ),
                                    magnification: 1.5,
                                    squeeze: 0.6,
                                    itemExtent: width * 0.11,
                                    children: List<Widget>.generate(
                                        DateTime.now().year - 1899, (index) {
                                      return Center(
                                          child: Text(
                                        '${index + 1900}',
                                        style: TextStyle(
                                            color: Color(0xFF2C2C2C),
                                            fontSize: height * 0.023),
                                      ));
                                    }),
                                    onSelectedItemChanged: (value) {
                                      setstate(() {
                                        date.year = value + 1900;
                                      });
                                    },
                                    diameterRatio: 2,
                                  )),
                            ],
                          ),
                          IgnorePointer(
                            ignoring: true,
                            child: Container(
                                width: width,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: cupertino.CupertinoPicker(
                                  backgroundColor: Colors.transparent,
                                  selectionOverlay: Container(
                                    decoration: pickerStyle,
                                  ),
                                  magnification: 1.5,
                                  squeeze: 0.6,
                                  itemExtent: width * 0.11,
                                  children: [],
                                  onSelectedItemChanged: (value) {},
                                  diameterRatio: 2,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //////////////////////////
                  IgnorePointer(
                    ignoring: true,
                    child: Container(
                      height: height * 0.37 - 210,
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
                        height: height * 0.37 - 210,
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
              Container(
                width: width,
                height: height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: -3,
                        blurRadius: 4,
                        offset: Offset(0, -4))
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.white,
                        width: width / 2,
                        height: height * 0.06,
                        child: Center(
                            child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: height * 0.02),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        date.isClicked = true;
                        if (date.isClicked) {
                          if (date.month == 2 &&
                              date.year % 4 == 0 &&
                              date.day > 29) {
                            date.text = '${date.year}-${date.month}-${29}';
                          } else if (date.month == 2 &&
                              date.year % 4 != 0 &&
                              date.day > 28) {
                            date.text = '${date.year}-${date.month}-${28}';
                          } else if (thirty.contains(date.month) &&
                              date.day > 30) {
                            date.text = '${date.year}-${date.month}-${30}';
                          } else if (date.month == DateTime.now().month &&
                              date.month == DateTime.now().month &&
                              date.day > DateTime.now().day) {
                            date.text =
                                '${date.year}-${date.month}-${DateTime.now().day}';
                          } else
                            date.text =
                                '${date.year}-${date.month}-${date.day}';
                        }
                        Navigator.pop(context);
                        (contexts.context as Element).markNeedsBuild();
                      },
                      child: Container(
                        color: Colors.white,
                        width: width / 2,
                        height: height * 0.06,
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(fontSize: height * 0.02),
                        )),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> newMethodWeight(
    double height, double width, UserWeight userweight, Context contexts) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
    context: contexts.context,
    builder: (context) {
      return Container(
        height: height * 0.45,
        width: width,
        clipBehavior: cupertino.Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height * 0.35,
              width: width,
              child: Stack(children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: width,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: cupertino.CupertinoPicker(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  selectionOverlay: Container(
                                      // decoration: pickerStyle,
                                      ),
                                  magnification: 1.5,
                                  squeeze: 0.6,
                                  itemExtent: width * 0.11,
                                  children: List<Widget>.generate(200, (index) {
                                    return Center(
                                        child: Text((++index).toString()));
                                  }),
                                  scrollController: FixedExtentScrollController(
                                      initialItem:
                                          (userweight.userWeight - 1).toInt()),
                                  onSelectedItemChanged: (value) {
                                    userweight.userWeight = value + 1;
                                  },
                                  diameterRatio: 2,
                                )),
                            Container(
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: cupertino.CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                      initialItem:
                                          (userweight.userWeightDec * 10)
                                              .toInt()),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  selectionOverlay: Container(
                                      //  decoration: pickerStyle,
                                      ),
                                  magnification: 1.5,
                                  squeeze: 0.6,
                                  itemExtent: width * 0.11,
                                  children: List<Widget>.generate(10, (index) {
                                    return Center(
                                        child: Text(
                                            '.' + (index).toString() + '0'));
                                  }),
                                  onSelectedItemChanged: (value) {
                                    NumberFormat s = new NumberFormat("#.##");
                                    userweight.userWeightDec =
                                        double.parse(s.format(value * 0.1));
                                  },
                                  diameterRatio: 2,
                                )),
                            Text(
                              'KG',
                              style: TextStyle(
                                  color: Color(0xFF2C2C2C),
                                  fontSize: height * 0.025),
                            ),
                          ],
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: Container(
                              width: width,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: cupertino.CupertinoPicker(
                                backgroundColor: Colors.transparent,
                                selectionOverlay: Container(
                                  decoration: pickerStyle,
                                ),
                                magnification: 1.5,
                                squeeze: 0.6,
                                itemExtent: width * 0.11,
                                children: [],
                                onSelectedItemChanged: (value) {},
                                diameterRatio: 2,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                //////////////////////////
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    height: height * 0.37 - 210,
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
                      height: height * 0.37 - 210,
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
            Container(
              width: width,
              height: height * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: -3,
                      blurRadius: 4,
                      offset: Offset(0, -4))
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.white,
                      width: width / 2,
                      height: height * 0.06,
                      child: Center(
                          child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: height * 0.02),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      userweight.isClicked = true;
                      if (userweight.isClicked) {
                        userweight.text =
                            '${userweight.userWeight + userweight.userWeightDec}';
                      }
                      Navigator.pop(context);
                      (contexts.context as Element).markNeedsBuild();
                    },
                    child: Container(
                      color: Colors.white,
                      width: width / 2,
                      height: height * 0.06,
                      child: Center(
                          child: Text(
                        'Save',
                        style: TextStyle(fontSize: height * 0.02),
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

void newMethodHeight(
    double height, double width, UserHeight userHeight, Context contexts) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
    context: contexts.context,
    builder: (context) {
      return Container(
        height: height * 0.45,
        width: width,
        clipBehavior: cupertino.Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height * 0.35,
              width: width,
              child: Stack(children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: width,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: cupertino.CupertinoPicker(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  selectionOverlay: Container(
                                      // decoration: pickerStyle,
                                      ),
                                  magnification: 1.5,
                                  squeeze: 0.6,
                                  itemExtent: width * 0.11,
                                  children: List<Widget>.generate(201, (index) {
                                    return Center(
                                        child: Text((index += 50).toString()));
                                  }),
                                  scrollController: FixedExtentScrollController(
                                      initialItem:
                                          userHeight.userHeight.toInt() - 50),
                                  onSelectedItemChanged: (value) {
                                    userHeight.userHeight = value + 50;
                                  },
                                  diameterRatio: 2,
                                )),
                            Text(
                              'CM',
                              style: TextStyle(
                                  color: Color(0xFF2C2C2C),
                                  fontSize: height * 0.025),
                            ),
                          ],
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: Container(
                              width: width,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: cupertino.CupertinoPicker(
                                backgroundColor: Colors.transparent,
                                selectionOverlay: Container(
                                  decoration: pickerStyle,
                                ),
                                magnification: 1.5,
                                squeeze: 0.6,
                                itemExtent: width * 0.11,
                                children: [],
                                onSelectedItemChanged: (value) {},
                                diameterRatio: 2,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                //////////////////////////
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    height: height * 0.37 - 210,
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
                      height: height * 0.37 - 210,
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
            Container(
              width: width,
              height: height * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: -3,
                      blurRadius: 4,
                      offset: Offset(0, -4))
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.white,
                      width: width / 2,
                      height: height * 0.06,
                      child: Center(
                          child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: height * 0.02),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      userHeight.isClicked = true;

                      if (userHeight.isClicked) {
                        userHeight.text = '${userHeight.userHeight.toInt()}';
                      }
                      Navigator.pop(context);
                      (contexts.context as Element).markNeedsBuild();
                    },
                    child: Container(
                      color: Colors.white,
                      width: width / 2,
                      height: height * 0.06,
                      child: Center(
                          child: Text(
                        'Save',
                        style: TextStyle(fontSize: height * 0.02),
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

class UserHeight {
  double userHeight;
  bool isClicked;
  String text;
  UserHeight(this.userHeight, this.isClicked, this.text);
}

class UserWeight {
  double userWeight;
  double userWeightDec;
  bool isClicked;
  String text;
  UserWeight(this.userWeight, this.userWeightDec, this.isClicked, this.text);
}

class Date {
  int day;
  int month;
  int year;
  bool isClicked;
  String text;
  Date(this.day, this.month, this.year, this.isClicked, this.text);
}

class Context {
  BuildContext context;
  Context(this.context);
}
