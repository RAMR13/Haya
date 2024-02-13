import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';

class Wait extends StatefulWidget {
  const Wait({super.key});

  @override
  State<Wait> createState() => _WaitState();
}

class _WaitState extends State<Wait> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        //pushReplacement انتبه
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MainScreenSpec(""),
            )));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'Images/Colored.png',
          height: height * .1,
          width: width * .1,
        ),
        leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: Container(
        width: width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'please wait while we evaluate your application',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'Images/wait.jpg',
              height: height * .6,
              width: width,
            ),
          ],
        ),
      ),
    );
  }
}
