import 'dart:async';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:page_transition/page_transition.dart';
import '../../../SpecialistPage/firstPage/CreateAccount.dart';
import '../signup/create_account.dart';
import 'package:flutter/material.dart' as og;

class Choices {
  late BuildContext context;
  late var size = MediaQuery.of(context).size;
  late double width = size.width * 0.45;
  late double height = size.height * 0.4;
  late double fontSize = size.width * 0.075;
  bool isActivated = false;
  double padding = 70;

  double opacit = 0;
  Color c = Colors.transparent;
  late String title;
  late String recName;
  late String charName;
  late String backgroundName;
  late int shadowOP = 0;

  Choices({
    required String rec,
    required String char,
    required String background,
    required String text,
  }) {
    recName = rec;
    charName = char;
    backgroundName = background;
    title = text;
  }

  Widget choice({required VoidCallback fn}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
            onTap: fn,
            child: AnimatedContainer(
                clipBehavior: Clip.antiAlias,
                duration: const Duration(milliseconds: 120),
                height: height,
                width: width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(shadowOP, 0, 0, 0),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    )),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 120),
                  tween: Tween(begin: opacit, end: opacit),
                  builder: (_, opacit, __) => ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Color.fromARGB(opacit.toInt(), 157, 157, 157),
                      BlendMode.color,
                    ),
                    child: Stack(fit: StackFit.expand, children: [
                      Image.asset(
                        'Images/$recName.png',
                        fit: BoxFit.cover,
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 120),
                        padding: EdgeInsets.fromLTRB(0, padding, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(
                            'Images/$backgroundName.png',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 120),
                          tween: Tween<double>(begin: fontSize, end: fontSize),
                          builder: (_, fontSize, __) => Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 110, 0, 0),
                        child: Image.asset(
                          'Images/$charName.png',
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ]),
                  ),
                ))));
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late var size = MediaQuery.of(context).size;

  void Activate(Choices choice, bool on) {
    if (on == true) {
      choice.width += 8;
      choice.height += 13;
      choice.padding -= 50;
      choice.fontSize += 4;
      choice.isActivated = true;
    }
    if (on == false) {
      choice.width -= 8;
      choice.height -= 13;
      choice.padding += 50;
      choice.fontSize -= 4;
      choice.isActivated = false;
    }
  }

  Choices choice1 = new Choices(
    rec: 'recOrange',
    char: 'woman',
    background: 'clouds',
    text: 'User',
  );
  Choices choice2 = new Choices(
    rec: 'recBlue',
    char: 'man',
    background: 'degree',
    text: 'Specialist',
  );
  double opacity = 0;
  @override
  Widget build(BuildContext context) {
    choice1.context = context;
    choice2.context = context;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Timer(Duration(milliseconds: 0), () {
      if (!mounted) return;
      opacity = 1;
      setState(() {});
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Hero(
                  tag: 'arrow',
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 120),
                    opacity: opacity,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xFF2C2C2C),
                      size: height * 0.036,
                    ),
                  ),
                )),
            Hero(
              tag: 'haya',
              child: Image.asset(
                "Images/Colored.png",
                height: size.height * 0.056,
              ),
            ),
            Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.transparent,
              size: height * 0.036,
            )
          ],
        ),
      ),
      body: Container(
        width: width,
        height: height,
        decoration: og.BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('Images/Login.png'))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.03),
                child: Container(
                  width: width,
                  alignment: Alignment.center,
                  child: Text(
                    'Choose account type',
                    style: TextStyle(
                        fontSize: height * 0.033, color: Color(0xFF2C2C2C)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    choice1.choice(
                      fn: () {
                        setState(() {
                          if (choice1.isActivated == false) {
                            Activate(choice1, true);
                            choice1.opacit = 0;
                            choice1.shadowOP = 75;
                            choice2.shadowOP = 0;

                            choice2.opacit = 255;
                            if (choice2.isActivated) {
                              Activate(choice2, false);
                              choice2.shadowOP = 0;
                            }
                          }
                        });
                      },
                    ),
                    choice2.choice(
                      fn: () {
                        setState(() {
                          if (choice2.isActivated == false) {
                            Activate(choice2, true);
                            choice1.shadowOP = 0;
                            choice2.shadowOP = 75;
                            choice2.opacit = 0;
                            choice1.opacit = 255;
                            if (choice1.isActivated) {
                              Activate(choice1, false);
                              choice1.shadowOP = 0;
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Hero(
                tag: 'next',
                child: Container(
                  height: height * 0.06,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 173, 50),
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
                    onTap: () {
                      if (choice1.isActivated == true) {
                        Navigator.push(
                          context,
                          PageTransition(
                              child: CreateAccount(),
                              type: PageTransitionType.rightToLeftWithFade),
                        );
                      } else if (choice2.isActivated == true) {
                        Navigator.push(
                          context,
                          PageTransition(
                              child: SpeCreateaccount(),
                              type: PageTransitionType.rightToLeftWithFade),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      // ignore: sort_child_properties_last
                      child: ShaderMask(
                        child: Material(
                          color: Colors.transparent,
                          child: const Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        shaderCallback: (rect) {
                          return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.orange, Colors.red])
                              .createShader(rect);
                        },
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(350))),
                      margin: const EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
