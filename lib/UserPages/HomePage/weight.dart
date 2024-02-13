import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:hayaproject/AdminPage/EventPageAdmin/EventAdminPage.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:page_transition/page_transition.dart';

class UserWeight extends StatefulWidget {
  var UserId;
  var weight;

  UserWeight(this.UserId, this.weight);

  @override
  State<UserWeight> createState() => UserWeightState();
}

class UserWeightState extends State<UserWeight> {
  List<DocumentSnapshot> User = [];

  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: widget.UserId)
        .get();
    User.addAll(qs.docs);
    if (!mounted) return;
    setState(() {});
  }

  void initState() {
    finalweight = widget.weight;
    getData();
  }

  List<FlSpot> points = [
    FlSpot(0, 64),
    FlSpot(1, 65),
    FlSpot(2, 63),
    FlSpot(3, 68),
    FlSpot(4, 65),
    FlSpot(5, 65),
    FlSpot(6, 64),
    FlSpot(7, 65),
    FlSpot(8, 63),
    FlSpot(9, 68),
    FlSpot(10, 65),
    FlSpot(11, 65),
    FlSpot(12, 64),
    FlSpot(13, 65),
    FlSpot(14, 63),
    FlSpot(15, 68),
    FlSpot(16, 65),
    FlSpot(17, 65),
  ];
  double finalweight = 50.0; ////sign up
  @override
  Widget build(BuildContext context) {
    BoxDecoration pickerStyle = BoxDecoration(
      border: Border.all(
          width: 2,
          color: const Color.fromARGB(255, 244, 92, 54),
          strokeAlign: BorderSide.strokeAlignOutside),
      borderRadius: BorderRadius.all(Radius.circular(7)),
    );

    double userHeight = 176;
    double weight = 55;
    double weightdec = 0;

    double bmi = finalweight / (userHeight * userHeight) * 10000;

    double ideal = (22.07 * (userHeight * userHeight) / 10000);
    double slider = 0;

    if (bmi < 18.5) slider = bmi * (0.01351351351351351351351351351351);
    double min = 18.5 * (userHeight * userHeight) * 0.00001;
    if (bmi >= 18.5 && bmi < 25) {
      slider = bmi * (0.03846153846153846153846153846154) - 0.46;
    }
    if (bmi >= 25 && bmi < 30) {
      slider = bmi * (0.05) - 0.744;
    }
    if (bmi >= 30 && bmi < 40) {
      slider = bmi * (0.025);
    }
    if (bmi >= 40) {
      slider = 1;
    }
    //0.013
    //21.7==0.249999 optimal (middle of balanced)
    //25==0.5 (middle) 25*0.2
    //57.3

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: MainScreenUser(""),
                        type: PageTransitionType.fade));
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF2C2C2C),
                size: height * 0.036,
              ),
            ),
            Center(
              child: Text(
                "Weight",
                style: TextStyle(
                    fontFamily: 'UbuntuREG',
                    fontSize: height * 0.028,
                    color: Color(0xFF2C2C2C)),
              ),
            ),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.transparent,
              size: height * 0.036,
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(0, 249, 249, 249),
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.push(
              context,
              PageTransition(
                  child: MainScreenUser(""), type: PageTransitionType.fade));
          return Future.value(true);
        },
        child: Container(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    width: width * 0.96,
                    height: height * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: Offset(0, 3))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: height * 0.28,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '$finalweight',
                                        style: TextStyle(
                                            color: Color(0xFF2C2C2C),
                                            fontSize: height * 0.055,
                                            fontFamily: 'UbuntuREG'),
                                      ),
                                      Text(
                                        'kg',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 80, 80, 80),
                                            fontSize: height * 0.02,
                                            fontFamily: 'UbuntuREG'),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'BMI ${NumberFormat("##.#").format(bmi)} ${slider >= 0.0 && slider < 0.25 ? 'Underweight' : slider >= 0.25 && slider < 0.5 ? 'Balanced' : slider >= 0.5 && slider < 0.75 ? 'Overweight' : slider >= 0.75 && slider < 1 ? 'Obese' : ''}',
                                    style: TextStyle(
                                        letterSpacing: -0.5,
                                        color: Color.fromARGB(255, 80, 80, 80),
                                        fontSize: height * 0.02,
                                        fontFamily: 'UbuntuREG'),
                                  ),
                                ],
                              ),
                              Container(
                                child: ScrollConfiguration(
                                  behavior: MyBehavior(),
                                  child: SingleChildScrollView(
                                    reverse: true,
                                    clipBehavior: Clip.none,
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      width: points.length <= 9
                                          ? width * 0.96
                                          : points.length * width * 0.1,
                                      height: height * 0.08,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: LineChart(LineChartData(
                                          lineTouchData: LineTouchData(
                                              getTouchedSpotIndicator:
                                                  (barData, indicators) {
                                                return indicators
                                                    .map((int index) {
                                                  /// Indicator Line
                                                  var lineColor = barData
                                                          .gradient
                                                          ?.colors
                                                          .first ??
                                                      barData.color;

                                                  const lineStrokeWidth = 0.0;
                                                  final flLine = FlLine(
                                                      color: lineColor!,
                                                      strokeWidth:
                                                          lineStrokeWidth);
                                                  var dotSize = 8.0; ///////
                                                  if (barData.dotData.show) {
                                                    dotSize = 4.0 * 1.8;
                                                  }

                                                  final dotData = FlDotData(
                                                    getDotPainter: (spot,
                                                            percent,
                                                            bar,
                                                            index) =>
                                                        _defaultGetDotPainter(
                                                            spot,
                                                            percent,
                                                            bar,
                                                            index,
                                                            size: dotSize),
                                                  );

                                                  return TouchedSpotIndicatorData(
                                                      flLine, dotData);
                                                }).toList();
                                              },
                                              touchTooltipData:
                                                  LineTouchTooltipData(
                                                      fitInsideHorizontally:
                                                          true,
                                                      tooltipRoundedRadius: 9,
                                                      tooltipPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 8),
                                                      getTooltipItems:
                                                          (touchedSpots) {
                                                        return touchedSpots.map(
                                                          (LineBarSpot
                                                              touchedSpot) {
                                                            const textStyle =
                                                                TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      77,
                                                                      77,
                                                                      77),
                                                            );
                                                            return LineTooltipItem(
                                                              points[touchedSpot
                                                                          .spotIndex]
                                                                      .y
                                                                      .toStringAsFixed(
                                                                          1) +
                                                                  ' kg' +
                                                                  '\n${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                                              textStyle,
                                                            );
                                                          },
                                                        ).toList();
                                                      },
                                                      tooltipBgColor:
                                                          Color.fromARGB(255,
                                                                  255, 242, 234)
                                                              .withOpacity(
                                                                  0.8))),
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                            getDrawingHorizontalLine: (value) {
                                              return FlLine(
                                                  color: Colors.grey.shade600,
                                                  strokeWidth: 1,
                                                  dashArray: [5]);
                                            },
                                          ),
                                          borderData: FlBorderData(show: false),
                                          titlesData: FlTitlesData(show: false),
                                          lineBarsData: [
                                            LineChartBarData(
                                                spots: points,
                                                isCurved: true,
                                                gradient:
                                                    LinearGradient(colors: [
                                                  Color(0xFFFABF2F),
                                                  Color(0xFFF57A37),
                                                  Color(0xFFED3342),
                                                ]),
                                                color: Colors.orange,
                                                barWidth: 4,
                                                dotData: FlDotData(
                                                  getDotPainter:
                                                      (p0, p1, p2, p3) {
                                                    return FlDotCirclePainter(
                                                        radius: 6.5,
                                                        strokeWidth: 0,
                                                        color: p2.gradient !=
                                                                    null &&
                                                                p2.gradient
                                                                    is LinearGradient
                                                            ? lerpGradient(
                                                                p2.gradient!
                                                                    .colors,
                                                                p2.gradient!
                                                                    .getSafeColorStops(),
                                                                p1 / 100,
                                                              )
                                                            : p2
                                                                    .gradient
                                                                    ?.colors
                                                                    .first ??
                                                                p2.color ??
                                                                Colors
                                                                    .blueGrey);
                                                  },
                                                )),
                                          ],
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            DateFormat('dd MMM yyyy').format(DateTime.now()),
                            style: TextStyle(
                                letterSpacing: -0.5,
                                color: Color.fromARGB(255, 80, 80, 80),
                                fontSize: height * 0.018,
                                fontFamily: 'UbuntuREG'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      width: width * 0.96,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: Offset(0, 3))
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, left: 7),
                            child: Row(
                              children: [
                                Text(
                                  'Ideal weight: ',
                                  style: TextStyle(fontSize: height * 0.017),
                                ),
                                Text(
                                  '${NumberFormat("##.#").format(ideal)}kg',
                                  style: TextStyle(
                                      fontSize: height * 0.017,
                                      fontFamily: 'UbuntuREG'),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: height * 0.078,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: height * 0.03,
                                    width: width * 0.934,
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: width * 0.934 / 4,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF6AAFFF),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                0xFF5890D2),
                                                            blurRadius: 2,
                                                            inset: true,
                                                            offset:
                                                                Offset(0, -2))
                                                      ]),
                                                ),
                                                Container(
                                                  width: width * 0.934 / 4,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF26DF47),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                0xFF61C282),
                                                            blurRadius: 2,
                                                            inset: true,
                                                            offset:
                                                                Offset(0, -2))
                                                      ]),
                                                ),
                                                Container(
                                                  width: width * 0.934 / 4,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFFFE076),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                0xFFDDC163),
                                                            blurRadius: 2,
                                                            inset: true,
                                                            offset:
                                                                Offset(0, -2))
                                                      ]),
                                                ),
                                                Container(
                                                  width: width * 0.934 / 4,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFFF7D7D),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                    0xFF8B3434)
                                                                .withOpacity(
                                                                    0.5),
                                                            blurRadius: 2,
                                                            inset: true,
                                                            offset:
                                                                Offset(0, -2))
                                                      ]),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                            ),
                                            height: height * 0.011,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: (width * 0.934 -
                                                      height * 0.018) *
                                                  slider),
                                          child: Container(
                                            width: height * 0.018,
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: slider >= 0 &&
                                                          slider < 0.25
                                                      ? Color(0xFF5890D2)
                                                      : slider >= 0.25 &&
                                                              slider < 0.5
                                                          ? Color(0xFF26DF47)
                                                          : slider >= 0.5 &&
                                                                  slider < 0.75
                                                              ? Color(
                                                                  0xFFFFE076)
                                                              : Color(
                                                                  0xFFFF7D7D),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Center(
                                            child: Text(
                                          'Underweight',
                                          style: TextStyle(
                                              color:
                                                  slider >= 0.0 && slider < 0.25
                                                      ? Color(0xFF5890D2)
                                                      : Color(0xFF666666),
                                              fontSize: height * 0.016),
                                        )),
                                        height: height * 0.02,
                                        width: width * 0.934 / 4,
                                      ),
                                      Container(
                                        child: Center(
                                            child: Text(
                                          'Balanced',
                                          style: TextStyle(
                                              color:
                                                  slider >= 0.25 && slider < 0.5
                                                      ? Color(0xFF60C381)
                                                      : Color(0xFF666666),
                                              fontSize: height * 0.016),
                                        )),
                                        height: height * 0.02,
                                        width: width * 0.934 / 4,
                                      ),
                                      Container(
                                        child: Center(
                                            child: Text(
                                          'Overweight',
                                          style: TextStyle(
                                              color:
                                                  slider >= 0.5 && slider < 0.75
                                                      ? Color(0xFFDDC163)
                                                      : Color(0xFF666666),
                                              fontSize: height * 0.016),
                                        )),
                                        height: height * 0.02,
                                        width: width * 0.934 / 4,
                                      ),
                                      Container(
                                        child: Center(
                                            child: Text(
                                          'Obese',
                                          style: TextStyle(
                                              color:
                                                  slider >= 0.75 && slider < 1
                                                      ? Color(0xFFFF7D7D)
                                                      : Color(0xFF666666),
                                              fontSize: height * 0.016),
                                        )),
                                        height: height * 0.02,
                                        width: width * 0.934 / 4,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(14))),
                          context: context,
                          builder: (context) {
                            return Container(
                              height: height * 0.45,
                              width: width,
                              clipBehavior: cupertino.Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      width: width * 0.4,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: cupertino
                                                          .CupertinoPicker(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                255, 255, 255),
                                                        selectionOverlay: Container(
                                                            // decoration: pickerStyle,
                                                            ),
                                                        magnification: 1.5,
                                                        squeeze: 0.6,
                                                        itemExtent:
                                                            width * 0.11,
                                                        children: List<
                                                                Widget>.generate(
                                                            200, (index) {
                                                          return Center(
                                                              child: Text((++index)
                                                                  .toString()));
                                                        }),
                                                        scrollController:
                                                            FixedExtentScrollController(
                                                                initialItem:
                                                                    54),
                                                        onSelectedItemChanged:
                                                            (value) {
                                                          weight = value + 1;
                                                        },
                                                        diameterRatio: 2,
                                                      )),
                                                  Container(
                                                      width: width * 0.4,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: cupertino
                                                          .CupertinoPicker(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                255, 255, 255),
                                                        selectionOverlay: Container(
                                                            //  decoration: pickerStyle,
                                                            ),
                                                        magnification: 1.5,
                                                        squeeze: 0.6,
                                                        itemExtent:
                                                            width * 0.11,
                                                        children: List<
                                                                Widget>.generate(
                                                            10, (index) {
                                                          return Center(
                                                              child: Text('.' +
                                                                  (index)
                                                                      .toString() +
                                                                  '0'));
                                                        }),
                                                        onSelectedItemChanged:
                                                            (value) {
                                                          NumberFormat s =
                                                              new NumberFormat(
                                                                  "#.##");
                                                          weightdec = double
                                                              .parse(s.format(
                                                                  value * 0.1));
                                                        },
                                                        diameterRatio: 2,
                                                      )),
                                                  Text(
                                                    'KG',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF2C2C2C),
                                                        fontSize:
                                                            height * 0.025),
                                                  ),
                                                ],
                                              ),
                                              IgnorePointer(
                                                ignoring: true,
                                                child: Container(
                                                    width: width,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: cupertino
                                                        .CupertinoPicker(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      selectionOverlay:
                                                          Container(
                                                        decoration: pickerStyle,
                                                      ),
                                                      magnification: 1.5,
                                                      squeeze: 0.6,
                                                      itemExtent: width * 0.11,
                                                      children: [],
                                                      onSelectedItemChanged:
                                                          (value) {},
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
                                                Color.fromARGB(
                                                    255, 255, 255, 255),
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
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    stops: [
                                                  0.4,
                                                  0.9
                                                ],
                                                    colors: [
                                                  Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  Color.fromARGB(
                                                      0, 255, 255, 255)
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
                                            color:
                                                Colors.black.withOpacity(0.25),
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
                                              style: TextStyle(
                                                  fontSize: height * 0.02),
                                            )),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            points.add(FlSpot(points.length + 0,
                                                (weight + weightdec)));
                                            finalweight = weight + weightdec;
                                            setState(() {});
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(User[0].id)
                                                .update({
                                              "weight": finalweight.toString(),
                                            });
                                            await Prefs.setString("weight",
                                                finalweight.toString());
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            width: width / 2,
                                            height: height * 0.06,
                                            child: Center(
                                                child: Text(
                                              'Save',
                                              style: TextStyle(
                                                  fontSize: height * 0.02),
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
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFF9F9F9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: Offset(-4, 3)),
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 4,
                                  offset: Offset(3, -5))
                            ]),
                        width: height * 0.065,
                        height: height * 0.065,
                        child: Center(
                          child: Icon(
                            Icons.edit_note,
                            size: height * 0.04,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Add weight',
                        style: TextStyle(
                            letterSpacing: -0.5,
                            color: Color.fromARGB(255, 80, 80, 80),
                            fontSize: height * 0.016,
                            fontFamily: 'UbuntuREG'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  final length = colors.length;
  if (stops.length != length) {
    /// provided gradientColorStops is invalid and we calculate it here
    stops = List.generate(length, (i) => (i + 1) / length);
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];

    final leftColor = colors[s];
    final rightColor = colors[s + 1];

    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}

/// Extensions on [Gradient]
extension GradientExtension on Gradient {
  /// Returns colorStops
  ///
  /// if [stops] provided, returns it directly,
  /// Otherwise we calculate it using colors list
  List<double> getSafeColorStops() {
    var resultStops = <double>[];
    if (stops == null || stops!.length != colors.length) {
      if (colors.length > 1) {
        /// provided colorStops is invalid and we calculate it here
        colors.asMap().forEach((index, color) {
          final percent = 1.0 / (colors.length - 1);
          resultStops.add(percent * index);
        });
      } else {
        throw ArgumentError('"colors" must have length > 1.');
      }
    } else {
      resultStops = stops!;
    }
    return resultStops;
  }
}

Color _defaultGetDotColor(FlSpot _, double xPercentage, LineChartBarData bar) {
  if (bar.gradient != null && bar.gradient is LinearGradient) {
    return lerpGradient(
      bar.gradient!.colors,
      bar.gradient!.getSafeColorStops(),
      xPercentage / 100,
    );
  }
  return bar.gradient?.colors.first ?? bar.color ?? Colors.blueGrey;
}

FlDotPainter _defaultGetDotPainter(
  FlSpot spot,
  double xPercentage,
  LineChartBarData bar,
  int index, {
  double? size,
}) {
  return FlDotCirclePainter(
    radius: size,
    color: _defaultGetDotColor(spot, xPercentage, bar),
    strokeColor: _defaultGetDotStrokeColor(spot, xPercentage, bar),
  );
}

Color _defaultGetDotStrokeColor(
  FlSpot spot,
  double xPercentage,
  LineChartBarData bar,
) {
  Color color;
  if (bar.gradient != null && bar.gradient is LinearGradient) {
    color = lerpGradient(
      bar.gradient!.colors,
      bar.gradient!.getSafeColorStops(),
      xPercentage / 100,
    );
  } else {
    color = bar.gradient?.colors.first ?? bar.color ?? Colors.blueGrey;
  }
  return color;
}
