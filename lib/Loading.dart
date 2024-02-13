import 'package:flutter/material.dart';

class test1 extends StatefulWidget {
  var height;
  var width;

  test1(this.height, this.width);

  @override
  State<test1> createState() => _test1State();
}

class _test1State extends State<test1> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: height * 0.042,
            width: height * 0.042,
            color: Colors.transparent,
            child: Container(
                child: CircularProgressIndicator(
              strokeWidth: 4,
              backgroundColor: Color.fromARGB(255, 226, 226, 226),
              color: Color.fromARGB(255, 116, 116, 116),
            )),
          )),
    );
  }
}
