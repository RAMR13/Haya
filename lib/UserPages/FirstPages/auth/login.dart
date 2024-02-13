import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as og;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/AdminPage/navigatorbarAdmin/NavigationBar.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/WelcomePage.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var SpecType = "";
  var UserId = "";
  var SpecId = "";
  var AdminId = "";
  List<DocumentSnapshot> specialists = [];
  List<DocumentSnapshot> Users = [];
  bool showErrorEmail = false;
  bool showErrorPassword = false;
  List<UserVerefication> CustomUser = [];
  List<Verefication> CustomSpecialist = [];
  late UserCredential userCredential;
  UserVerefication? foundUser;

  getDataUser() async {
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("users").get();
    Users.addAll(qs.docs);
    for (int i = 0; i < Users.length; i++) {
      CustomUser.add(UserVerefication(
          Type: "User",
          Id: Users[i]['User_id'],
          Email: Users[i]['email'],
          Password: Users[i]['password'],
          weight: Users[i]['weight'],
          gender: Users[i]['gender'],
          height: Users[i]['height']));
    }
    setState(() {});
  }

  getDataSpecialist() async {
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("specialist").get();

    specialists.addAll(qs.docs);
    for (int i = 0; i < specialists.length; i++) {
      CustomSpecialist.add(Verefication(
        Id: specialists[i]['Specialist ID'],
        Type: specialists[i]['type'],
        Email: specialists[i]['email'],
        Password: specialists[i]['password'],
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    getDataSpecialist();
    getDataUser();
    super.initState();
  }

  var o = Colors.orange;
  bool passwordvisibile = true;
  late var size = MediaQuery.of(context).size;
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  double opacity = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Timer(Duration(milliseconds: 0), () {
      if (!mounted) return;
      opacity = 1;
    });
    return WillPopScope(
      onWillPop: () async {
        if (true)
          Navigator.pushReplacement<void, void>(
            context,
            PageTransition(
                child: IntroHome(),
                childCurrent: Login(),
                type: PageTransitionType.leftToRightWithFade),
          );

        return true;
      },
      child: Scaffold(
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
                    Navigator.pushReplacement<void, void>(
                      context,
                      PageTransition(
                          child: IntroHome(),
                          childCurrent: Login(),
                          type: PageTransitionType.leftToRightWithFade),
                    );
                  },
                  child: Hero(
                    tag: 'arrow',
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
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
          decoration: const og.BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("Images/Login.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: size.height * 0.05),
                  child: Text(
                    'Log in to your Account',
                    style: TextStyle(
                      color: Color(0xFF2C2C2C),
                      fontFamily: 'UbuntuMED',
                      fontSize: height * 0.032,
                    ),
                  ),
                ),
                TextField(
                  cursorColor: Color(0xFF2C2C2C),
                  onChanged: (value) {
                    setState(() {
                      showErrorEmail = false;
                    });
                  },
                  controller: Email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text("Email"),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 94, 94, 94),
                        fontSize: height * 0.019),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 119, 119, 119),
                          width: 0.9,
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1.0,
                      ),

                      borderRadius: BorderRadius.all(
                          Radius.circular(7.0)), // Sets border radius
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: size.height * 0.01),
                //   child: TextField(
                //     onChanged: (value) {
                //       setState(() {
                //         showErrorEmail = false;
                //       });
                //       if (!isEmail(Email.text)) {
                //         showErrorEmail = true;
                //       }
                //     },
                //     controller: Email,
                //     keyboardType: TextInputType.emailAddress,
                //     autocorrect: true,
                //     maxLines: 1,
                //     decoration: InputDecoration(
                //         hintText: 'Email',
                //         focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: o, width: 2),
                //             borderRadius: BorderRadius.circular(7)),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(7))),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 2, top: 2),
                  child: Align(
                    //////////error email
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: size.width * 0.8,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 120),
                        child: Text("Enter your email",
                            style: TextStyle(
                                color: Colors.red, fontSize: height * 0.016)),
                        opacity: showErrorEmail ? 1 : 0,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: TextField(
                    cursorColor: Color(0xFF2C2C2C),
                    onChanged: (value) {
                      setState(() {
                        showErrorPassword = false;
                      });
                    },
                    controller: Password,
                    obscureText: passwordvisibile,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordvisibile = !passwordvisibile;
                          });
                        },
                        icon: Icon(passwordvisibile
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        color: Colors.grey,
                      ),
                      label: Text("Password"),
                      labelStyle: TextStyle(
                          color: Color.fromARGB(255, 94, 94, 94),
                          fontSize: height * 0.019),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 119, 119, 119),
                            width: 0.9,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepOrangeAccent,
                          width: 1.0,
                        ),

                        borderRadius: BorderRadius.all(
                            Radius.circular(7.0)), // Sets border radius
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 2, top: 2),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.4,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 120),
                            child: Text("Enter your password",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: height * 0.016)),
                            opacity: showErrorPassword ? 1 : 0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Container(
                            alignment: Alignment.topRight,
                            width: size.width * 0.4,
                            child: InkWell(
                              onTap: () async {
                                if (isEmail(Email.text)) {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: Email.text);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.bottomSlide,
                                    desc:
                                        'A password reset email has been sent. Please check your email.',
                                  ).show();
                                } else
                                  showErrorEmail = true;
                                setState(() {});
                              },
                              child: Text("Forgot password?",
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: height * 0.016)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(30, 60, 30, 20),
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
                        onTap: () async {
                          setState(() {
                            showErrorEmail = false;
                            showErrorPassword = false;
                          });

                          if (!isEmail(Email.text)) {
                            showErrorEmail = true;
                          }
                          if (!validateStrongPassword(Password.text)) {
                            showErrorPassword = true;
                          }
                          if (showErrorPassword == false &&
                              showErrorEmail == false) {
                            if (CustomUser.any((element) {
                              return element.Email == Email.text.toString() &&
                                  element.Password == Password.text.toString();
                            })) {
                              try {
                                await SetString("Type", "User");
                                await SetBoolean("IsLogin", true);
                                for (UserVerefication element in CustomUser) {
                                  if (element.Email == Email.text &&
                                      element.Password == Password.text) {
                                    foundUser = element;
                                    break; // Exit the loop once the user is found
                                  }
                                }
                                if (foundUser != null) {
                                  // Perform asynchronous operations for the found user
                                  await updateUserPreferences(foundUser!);
                                }
                                // CustomUser.forEach((element) async {
                                //   if (element.Email == Email.text &&
                                //       element.Password == Password.text) {
                                //     UserId = element.Id;

                                //     await SetString("Id", UserId.toString());
                                //     await SetString("weight", element.weight);
                                //     await SetString("gender", element.gender);
                                //     await SetString("height", element.height);
                                //     await Prefs.savePrefInt(
                                //         "workout index", -1);
                                //     await Prefs.savePrefInt("workout done", -1);
                                //   }
                                // });
                              } catch (e) {}

                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: MainScreenUser(""),
                                      type: PageTransitionType
                                          .rightToLeftWithFade));
                            } else if (CustomSpecialist.any((element) =>
                                element.Email == Email.text &&
                                element.Password == Password.text)) {
                              CustomSpecialist.forEach((element) async {
                                if (element.Email == Email.text &&
                                    element.Password == Password.text) {
                                  SpecType = element.Type;
                                  SpecId = element.Id;
                                  await SetString("Id", SpecId.toString());
                                }
                              });

                              try {
                                await SetBoolean("IsLogin", true);
                                await SetString("Type", SpecType.toString());
                              } catch (e) {}

                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: MainScreenSpec(""),
                                      type: PageTransitionType
                                          .rightToLeftWithFade));
                            } else if (Email.text.length >= 10 &&
                                Email.text.toString().substring(0, 9) ==
                                    "hayastaff") {
                              try {
                                await SetString("Type", "Admin");
                                await SetString("Id", "");
                                await SetBoolean("IsLogin", true);
                              } catch (e) {}

                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: MainScreenAdmin(''),
                                      type: PageTransitionType
                                          .rightToLeftWithFade));
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'There is wrong in Email OR Password',
                              ).show();
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // ignore: sort_child_properties_last
                          child: ShaderMask(
                            child: const Text(
                              'Next',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(350))),
                          margin: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);

    if (em.isEmpty)
      return false;
    else
      return regExp.hasMatch(em);
  }

  SetString(String key, String value) async {
    await Prefs.setString(key, value);
  }

  SetBoolean(String key, bool value) async {
    await Prefs.setBoolean(key, value);
  }

  bool validateStrongPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty)
      return false;
    else
      return regExp.hasMatch(value);
  }

  Future<void> updateUserPreferences(UserVerefication element) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Use a single SharedPreferences instance for multiple writes
    await prefs.setString("Id", element.Id);
    await prefs.setString("weight", element.weight);
    await prefs.setString("gender", element.gender);
    await prefs.setString("height", element.height);

    // Use Prefs instance if it's already available
    await prefs.setInt("workout index", -1);
    await prefs.setInt("workout done", -1);
  }
}

class Verefication {
  var Id;
  var Email;
  var Password;
  var Type;

  Verefication(
      {required this.Id,
      required this.Email,
      required this.Password,
      required this.Type});
}

class UserVerefication {
  var Id;
  var Email;
  var Password;
  var Type;
  var weight;
  var height;
  var gender;
  UserVerefication(
      {required this.Id,
      required this.Email,
      required this.Password,
      required this.Type,
      required this.weight,
      required this.height,
      required this.gender});
}
