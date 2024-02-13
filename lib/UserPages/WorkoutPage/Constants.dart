import 'package:flutter/services.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

Color newRed = Color(0xFFFF2214);
Color shad = Color.fromARGB(71, 0, 0, 0);
/////////////////////////////////////////
BoxDecoration boxDefault = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Color(0xFFF9F9F9),
    boxShadow: [
      BoxShadow(
          color: Color.fromARGB(71, 0, 0, 0),
          blurRadius: 8,
          spreadRadius: 0,
          offset: Offset(0, 4)),
      BoxShadow(
          color: Color(0xFFFFFFFF),
          blurRadius: 2,
          spreadRadius: 1,
          offset: Offset(0, -4)),
    ]);
//////////////////////////////////////////
BoxDecoration boxActive = BoxDecoration(
    border: Border.all(
        width: 2,
        color: const Color.fromARGB(255, 244, 92, 54),
        strokeAlign: BorderSide.strokeAlignInside),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Color(0xFFF9F9F9),
    boxShadow: [
      BoxShadow(
          color: Color.fromARGB(71, 0, 0, 0),
          blurRadius: 8,
          spreadRadius: 0,
          offset: Offset(0, 4)),
      BoxShadow(
          color: Color(0xFFFFFFFF),
          blurRadius: 2,
          spreadRadius: 1,
          offset: Offset(0, -4)),
    ]);
/////////////////////////

List<Widget> week = [
  Center(child: Text('1', style: choiceTextStylePicker)),
  Center(child: Text('2', style: choiceTextStylePicker)),
  Center(child: Text('3', style: choiceTextStylePicker)),
  Center(child: Text('4', style: choiceTextStylePicker)),
  Center(child: Text('5', style: choiceTextStylePicker)),
  Center(child: Text('6', style: choiceTextStylePicker)),
  Center(child: Text('7', style: choiceTextStylePicker)),
];

BoxDecoration pickerStyle = BoxDecoration(
  border: Border.all(
      width: 2,
      color: const Color.fromARGB(255, 244, 92, 54),
      strokeAlign: BorderSide.strokeAlignOutside),
  borderRadius: BorderRadius.all(Radius.circular(7)),
);

Container check = Container(
  margin: EdgeInsets.all(8),
  child: Icon(
    Icons.check,
    color: Colors.white,
    size: 18,
  ),
  decoration:
      BoxDecoration(shape: BoxShape.circle, color: Colors.orange, boxShadow: [
    BoxShadow(
        color: newRed,
        blurRadius: 5,
        spreadRadius: 1.5,
        offset: Offset(0, -2),
        inset: true),
    BoxShadow(
      color: shad,
      blurRadius: 3,
      spreadRadius: 1,
      offset: Offset(1, 2),
    )
  ]),
);

TextStyle choiceTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.normal);
TextStyle subTextStyle =
    TextStyle(fontSize: 16, fontFamily: 'UbuntuREG', color: Color(0xFF434343));
////////////////////////////////////////////////
double fontsizepicker = 0.0;
TextStyle choiceTextStylePicker = TextStyle(
    fontSize: fontsizepicker,
    fontWeight: FontWeight.normal,
    fontFamily: 'UbuntuMED',
    color: Color(0xFF2C2C2C));
///////////GAUGE////////////////////////////////
Widget gauge(double val) {
  return SfRadialGauge(
    axes: [
      RadialAxis(
        startAngle: 270,
        endAngle: 270,
        axisLineStyle: AxisLineStyle(thickness: 3.5),
        showTicks: false,
        showLabels: false,
        minimum: 0,
        maximum: 100,
        pointers: <GaugePointer>[
          RangePointer(
            width: 3.5,
            value: val,
            gradient: SweepGradient(
                colors: [const Color.fromARGB(255, 255, 170, 43), newRed]),
          )
        ],
      ),
    ],
  );
}

///////////////////////////////Next Button///////////////////////
Widget nextButton({String text = 'Next', var cls}) {
  return Container(
    alignment: Alignment.center,
    child: ShaderMask(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, newRed]).createShader(rect);
      },
    ),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(350))),
    margin: EdgeInsets.all(5),
  );
}

///////////////

Widget nextbutton({String text = 'Next', required VoidCallback cls}) {
  return Container(
    height: 50,
    margin: EdgeInsets.fromLTRB(30, 60, 30, 20),
    decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 173, 50),
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
        borderRadius: BorderRadius.all(Radius.circular(350))),
    child: GestureDetector(
      onTap: cls,
      child: Container(
        alignment: Alignment.center,
        child: ShaderMask(
          child: Material(
            color: Colors.transparent,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
          shaderCallback: (rect) {
            return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange, newRed]).createShader(rect);
          },
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(350))),
        margin: EdgeInsets.all(5),
      ),
    ),
  );
}
