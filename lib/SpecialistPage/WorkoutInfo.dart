import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/SpecialistPage/AddWorkoutSp.dart';
import 'package:hayaproject/SpecialistPage/CustomWorkout.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Constants.dart';
import 'package:page_transition/page_transition.dart';

class WorkoutInfo extends StatefulWidget {
  var receiverUserEmail;
  var receiverUserID;
  var name;
  var image;
  var type;
  var senderId;
  var Senderemail;
  List<String> customWorkout;
  String customName;
  Info information;

  WorkoutInfo(
      {required this.information,
      required this.customWorkout,
      required this.customName,
      required this.name,
      required this.image,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.type,
      required this.senderId,
      required this.Senderemail});

  @override
  State<WorkoutInfo> createState() => _WorkoutInfoState();
}

class _WorkoutInfoState extends State<WorkoutInfo> {
  List<DocumentSnapshot> Users = [];
  int lock = 0;
  getDataMyUser() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: widget.receiverUserID.toString())
        .get();
    Users.addAll(qs.docs);
    if (!mounted) return;
    setState(() {
      print(widget.receiverUserID.toString());
    });
    if (Users.isNotEmpty) await Getdata();
  }

  var db = FirebaseFirestore.instance;
  Color errorColor = Color(0xFFF4222F);
  Color normalColor = Color(0xFFB0B0B0);
  bool isDurationOK = true;
  bool isTitleOK = true;
  int titleLength = 0;
  TextEditingController title = TextEditingController();
  TextEditingController duration = TextEditingController();
  double opacity = 0;

  Widget textField(var size, String title, TextEditingController controllerx,
      double fontSize, String errorText, bool error, TextInputType? keyboard) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: size.height * 0.07, //40,
              child: TextField(
                  keyboardType: keyboard,
                  onChanged: (value) {
                    if (controllerx == duration) {
                      if (int.tryParse(value) == null) {
                        setState(() {
                          isDurationOK = false;
                        });
                      } else {
                        if (int.parse(value) > 300)
                          setState(() {
                            isDurationOK = false;
                          });
                        else
                          setState(() {
                            isDurationOK = true;
                          });
                      }
                    }
                    if (controllerx == this.title) {
                      setState(() {
                        titleLength = value.length;
                        if (value.length > 35)
                          isTitleOK = false;
                        else
                          isTitleOK = true;
                      });
                    }
                  },
                  maxLines: 1,
                  minLines: 1,
                  expands: false,
                  style: TextStyle(
                      fontSize: size.height * 0.021,
                      fontFamily: 'UbuntuREG' //18
                      ),
                  textAlignVertical: TextAlignVertical.center,
                  controller: controllerx,
                  cursorColor: Color(0xFF2C2C2C),
                  decoration: InputDecoration(
                      labelText: title,
                      labelStyle: TextStyle(color: Color(0xFF848484)),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: error
                                ? normalColor
                                : errorColor, //Color(0xFFF4222F)
                            width: 1.5,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 114, 82),
                            width: 1.5,
                          ))))),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedOpacity(
                  duration: Duration(milliseconds: 150),
                  opacity: error ? 0 : 1, //0:1
                  child: Text(
                    '$errorText',
                    style: TextStyle(
                        color: errorColor,
                        fontFamily: 'UbuntuREG',
                        fontSize: fontSize),
                  ),
                ),
                controllerx == this.title
                    ? Text(
                        '$titleLength/35  ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 104, 104, 104),
                            fontFamily: 'UbuntuREG',
                            fontSize: fontSize),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<DocumentSnapshot<Object?>> info0 = [];
  List<DocumentSnapshot<Object?>> info1 = [];
  List<DocumentSnapshot<Object?>> info2 = [];
  List<DocumentSnapshot<Object?>> info3 = [];

  Getdata() async {
    QuerySnapshot qs = await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc("Workout plan")
        .collection('wk1 info')
        .get();
    QuerySnapshot qs1 = await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Workout plan')
        .collection('wk2 info')
        .get();
    QuerySnapshot qs2 = await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Workout plan')
        .collection('wk3 info')
        .get();
    QuerySnapshot qs3 = await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Workout plan')
        .collection('wk4 info')
        .get();
    if (!mounted) return;

    setState(() {
      info0.addAll(qs.docs);
      info1.addAll(qs1.docs);
      info2.addAll(qs2.docs);
      info3.addAll(qs3.docs);
    });
  }

  @override
  void initState() {
    print(widget.receiverUserID.toString() + "djjdjdjdjdjdjdjdj");
    title = TextEditingController(text: widget.information.title);
    duration = TextEditingController(text: widget.information.duration);
    getDataMyUser();
    super.initState();
  }

  Future<void> setData(String collection) async {
    for (int i = 0; i < widget.customWorkout.length; i++) {
      await db
          .collection('users')
          .doc(Users[0].id)
          .collection('my specialist')
          .doc('Workout plan')
          .collection(collection)
          .doc('$i')
          .set({
        'name': '${widget.customWorkout[i]}',
      });
    }
    await db
        .collection('users')
        .doc(Users[0].id)
        .collection('my specialist')
        .doc('Workout plan')
        .collection('$collection info')
        .doc('info')
        .set({'name': title.text, 'duration': duration.text});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              tag: 'back',
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement<void, void>(
                    context,
                    PageTransition(
                        child: AddWorkoutSp(
                            collectionName: widget.customName,
                            name: widget.name,
                            image: widget.image,
                            receiverUserEmail: widget.receiverUserEmail,
                            receiverUserID: widget.receiverUserID,
                            type: widget.type,
                            senderId: widget.senderId,
                            Senderemail: widget.Senderemail),
                        type: PageTransitionType.leftToRightWithFade),
                  );
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF2C2C2C),
                  size: size.height * 0.038,
                ),
              ),
            ),
            Text('Custom workout',
                style: TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: size.height * 0.026,
                    fontFamily: 'UbuntuBOLD')),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.transparent,
              size: size.height * 0.038,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement<void, void>(
            context,
            PageTransition(
                child: AddWorkoutSp(
                    collectionName: widget.customName,
                    name: widget.name,
                    image: widget.image,
                    receiverUserEmail: widget.receiverUserEmail,
                    receiverUserID: widget.receiverUserID,
                    type: widget.type,
                    senderId: widget.senderId,
                    Senderemail: widget.Senderemail),
                type: PageTransitionType.leftToRightWithFade),
          );
          return Future.value(true);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Column(
            children: [
              textField(size, 'Workout title', title, size.height * 0.0152,
                  '  Enter a valid title.', isTitleOK, TextInputType.name),
              textField(
                  size,
                  'Expected duration',
                  duration,
                  size.height * 0.0152,
                  '  Enter a valid duration.',
                  isDurationOK,
                  TextInputType.number),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(
                      context,
                      PageTransition(
                          child: AddWorkoutSp(
                              collectionName: "",
                              name: widget.name,
                              image: widget.image,
                              senderId: widget.senderId,
                              Senderemail: widget.Senderemail,
                              type: widget.type,
                              receiverUserEmail: widget.receiverUserEmail,
                              receiverUserID: widget.receiverUserID),
                          type: PageTransitionType.leftToRightWithFade,
                          childCurrent: WorkoutInfo(
                            type: widget.type,
                            Senderemail: widget.Senderemail,
                            senderId: widget.senderId,
                            image: widget.image,
                            name: widget.name,
                            customName: widget.customName,
                            customWorkout: widget.customWorkout,
                            information: widget.information,
                            receiverUserEmail: widget.receiverUserEmail,
                            receiverUserID: widget.receiverUserID,
                          )));
                  if (!mounted) return;

                  setState(() {});
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    child: Container(
                      height: size.height * 0.07, //40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text(
                              'Edit workout list',
                              style: TextStyle(
                                  color: Color(0xFF848484),
                                  fontSize: size.height * 0.021,
                                  fontFamily: 'UbuntuREG'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Transform.flip(
                                flipX: true,
                                child: Icon(Icons.arrow_back_ios_new_rounded,
                                    color: Color(0xFF848484))),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          border: Border.all(width: 1.5, color: normalColor)),
                    )),
              ),
///////////////////////////////////////////////////////////////////////////
              Expanded(child: Container()),

              Hero(
                tag: 'next',
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
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
                      onTap: () async {
                        if (title.text == '')
                          setState(() {
                            isTitleOK = false;
                          });
                        if (duration.text == '')
                          setState(() {
                            isDurationOK = false;
                          });
                        if (isDurationOK && isTitleOK && lock == 0) {
                          lock++;
                          if (await widget.customName == '') {
                            if (await info0.isEmpty)
                              await setData('wk1');
                            else if (info0.isNotEmpty && info1.isEmpty)
                              await setData('wk2');
                            else if (info0.isNotEmpty &&
                                await info1.isNotEmpty &&
                                await info2.isEmpty)
                              await setData('wk3');
                            else if (info0.isNotEmpty &&
                                info1.isNotEmpty &&
                                info2.isNotEmpty &&
                                info3.isEmpty)
                              await setData('wk4');
                            else
                              print(
                                  'enough SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS');
                          }
                          if (widget.customName != '') {
                            await setData(widget.customName);
                          }
                          if (!mounted) return;
                          setState(() {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    child: CustomWorkout(
                                      name: widget.name,
                                      image: widget.image,
                                      senderId: widget.senderId,
                                      Senderemail: widget.Senderemail,
                                      type: widget.type,
                                      receiverUserEmail:
                                          widget.receiverUserEmail,
                                      receiverUserID: widget.receiverUserID,
                                    ),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    childCurrent: WorkoutInfo(
                                      type: widget.type,
                                      Senderemail: widget.Senderemail,
                                      senderId: widget.senderId,
                                      image: widget.image,
                                      name: widget.name,
                                      customName: widget.customName,
                                      customWorkout: widget.customWorkout,
                                      information: widget.information,
                                      receiverUserEmail:
                                          widget.receiverUserEmail,
                                      receiverUserID: widget.receiverUserID,
                                    )),
                                (Route<dynamic> route) => false);
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: ShaderMask(
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.customName == '' ? 'Create' : 'Update',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          shaderCallback: (rect) {
                            return LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.orange, newRed])
                                .createShader(rect);
                          },
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(350))),
                        margin: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Info {
  String title;
  String duration;

  Info(this.title, this.duration);
}
