import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/SpecialistPage/CustomWorkout.dart';
import 'package:hayaproject/SpecialistPage/WorkoutInfo.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Constants.dart';
import 'package:hayaproject/UserPages/WorkoutPage/ExerciseBody.dart';
import 'package:page_transition/page_transition.dart';

class AddWorkoutSp extends StatefulWidget {
  String collectionName;
  var receiverUserEmail;
  var receiverUserID;
  var name;
  var image;
  var type;
  var senderId;
  var Senderemail;

  AddWorkoutSp(
      {required this.collectionName,
      required this.name,
      required this.image,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.type,
      required this.senderId,
      required this.Senderemail});

  @override
  State<AddWorkoutSp> createState() => AddWorkoutState();
}

class AddWorkoutState extends State<AddWorkoutSp> {
  Color active1 = Color.fromARGB(255, 255, 173, 50);
  Color active2 = newRed;
  List<String> customList = [];
  String search = '';
  List allWorkouts = [];
  List<Workouts> allWorkoutsLocal = [];
  List<DocumentSnapshot<Object?>> info0 = [];
  var db = FirebaseFirestore.instance;
  List<DocumentSnapshot> Users = [];

  GetdataNames() async {
    if (widget.collectionName != '') {
      QuerySnapshot qs = await db
          .collection('users')
          .doc(Users[0].id)
          .collection('my specialist')
          .doc('Workout plan')
          .collection('${widget.collectionName}')
          .get();
      if (!mounted) return;

      setState(() {
        info0.addAll(qs.docs);
      });
      for (int i = 0; i < info0.length; i++) {
        customList.add(info0[i]['name']);
      }
    }
  }

  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("workout")
        .orderBy('name')
        .get();

    allWorkouts.addAll(qs.docs);
    if (!mounted) return;

    setState(() {
      for (int i = 0; i < allWorkouts.length; i++) {
        allWorkoutsLocal.add(Workouts(
            name: allWorkouts[i]['name'],
            subText: int.parse(allWorkouts[i]['subtext']),
            typeChar: allWorkouts[i]['type']));
      }
    });
  }

  getDataMyUser() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: widget.receiverUserID)
        .get();
    Users.addAll(qs.docs);
    if (!mounted) return;
    setState(() {});
    await GetdataNames();
    await getInfo(); //killme
    await getData(); //new
  }

  List<DocumentSnapshot<Object?>> information = [];
  Info customInfo = Info('', '');

  getInfo() async {
    //for next page
    if (widget.collectionName != '') {
      QuerySnapshot qs = await db
          .collection('users')
          .doc(await Users[0].id)
          .collection('my specialist')
          .doc('Workout plan')
          .collection('${widget.collectionName} info')
          .get();
      if (!mounted) return;

      setState(() {
        information.addAll(qs.docs);
      });
      customInfo = Info(information[0]['name'], information[0]['duration']);
    }
  }

  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (!mounted) return;

    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    print(widget.receiverUserID.toString() +
        "dddddddddddddddddddddddddddddddddddddddss");
    if (widget.collectionName != '') getDataMyUser();
    if (widget.collectionName == '') {
      getInfo(); //killme
      getData();
    }
    Loading();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String workoutName;

    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Hero(
              tag: 'back',
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement<void, void>(
                    context,
                    PageTransition(
                        child: CustomWorkout(
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
                  size: size.height * 0.038, //size.width * 0.08,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Container(
                  height: size.height * 0.048, //40,
                  child: TextField(
                    onChanged: (value) {
                      if (!mounted) return;

                      setState(() {
                        search = value;
                      });
                    },
                    maxLines: 1,
                    style: TextStyle(fontSize: size.height * 0.02 //18
                        ),
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Color(0xFF2C2C2C),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        hintText: 'Search',
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 170, 170, 170),
                              width: 1.5,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 114, 82),
                              width: 1.5,
                            ))),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size.height * 0.038,
            )
          ],
        ),
        elevation: 2.2,
        backgroundColor: Color(0xFFF9F9F9),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement<void, void>(
            context,
            PageTransition(
                child: CustomWorkout(
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
        child: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: allWorkoutsLocal.length + 1, //variable
              itemBuilder: (BuildContext context, int index) {
                if (index == allWorkoutsLocal.length)
                  return Container(
                    height: size.height * 0.09,
                  );
                else
                  workoutName = allWorkoutsLocal[index].name.toLowerCase();
                return workoutName.contains(search.toLowerCase())
                    ? GestureDetector(
                        onTap: () {
                          if (!mounted) return;

                          setState(() {
                            if (customList
                                .contains(allWorkoutsLocal[index].name))
                              customList.remove(allWorkoutsLocal[index].name);
                            else
                              customList.add(allWorkoutsLocal[index].name);
                          });
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromARGB(64, 0, 0, 0),
                                        blurRadius: 3,
                                        offset: Offset(0, 2))
                                  ],
                                  color: Color.fromARGB(247, 250, 250, 250),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              height: size.height * 0.112, //95,

                              child: Container(
                                  child: Row(children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Container(
                                    width: size.width * 0.27,
                                    padding: EdgeInsets.all(7),
                                    child: allWorkouts[index]['imgtype'] == 'as'
                                        ? Image.asset(
                                            '${allWorkouts[index]['image']}')
                                        : Image.network(
                                            '${allWorkouts[index]['image']}'),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Container(
                                        width: size.width *
                                            0.45, // size.width * 0.5,
                                        child: Text(
                                            '${allWorkouts[index]['name']}',
                                            style: TextStyle(
                                                color: Color(0xFF2C2C2C),
                                                fontSize:
                                                    size.height * 0.023 //20
                                                )),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: Text(
                                        allWorkouts[index]['type'] == 'C'
                                            ? 'x${allWorkouts[index]['subtext']}'
                                            : int.parse(allWorkouts[index]
                                                        ['subtext']) >
                                                    10
                                                ? '00:${allWorkouts[index]['subtext']}'
                                                : '0${allWorkouts[index]['subtext']}:00',
                                        style: TextStyle(
                                            fontSize: size.height * 0.017, //2
                                            color: Color.fromARGB(
                                                255, 95, 95, 95)),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 150),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: customList.contains(
                                                      allWorkoutsLocal[index]
                                                          .name)
                                                  ? Colors.transparent
                                                  : Color(0xFF686868)),
                                          boxShadow: [],
                                          shape: BoxShape.circle,
                                          color: customList.contains(
                                                  allWorkoutsLocal[index].name)
                                              ? Color(0xFF53DB81)
                                              : Colors.transparent,
                                        ),
                                        width: size.width * 0.062,
                                        //25,
                                        height: size.height * 0.062,
                                        child: Visibility(
                                          visible: customList.contains(
                                              allWorkoutsLocal[index].name),
                                          child: Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ])),
                            )),
                      )
                    : Container();
              },
            ),
            Hero(
              tag: 'next',
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 60, 30, 20),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    height: 50,
                    decoration: BoxDecoration(
                        color: customList.isEmpty
                            ? const Color.fromARGB(255, 197, 197, 197)
                            : const Color.fromARGB(255, 255, 173, 50),
                        boxShadow: [
                          BoxShadow(
                              color: customList.isEmpty
                                  ? const Color.fromARGB(255, 104, 104, 104)
                                  : newRed,
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
                        if (customList.length != 0) {
                          if (!mounted) return;

                          setState(() {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: WorkoutInfo(
                                      information: customInfo,
                                      customWorkout: customList,
                                      customName: widget.collectionName,
                                      name: widget.name,
                                      image: widget.image,
                                      receiverUserEmail:
                                          widget.receiverUserEmail,
                                      receiverUserID: widget.receiverUserID,
                                      type: widget.type,
                                      senderId: widget.senderId,
                                      Senderemail: widget.Senderemail,
                                    ),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    childCurrent: AddWorkoutSp(
                                        collectionName: "",
                                        name: widget.name,
                                        image: widget.image,
                                        senderId: widget.senderId,
                                        Senderemail: widget.Senderemail,
                                        type: widget.type,
                                        receiverUserEmail:
                                            widget.receiverUserEmail,
                                        receiverUserID:
                                            widget.receiverUserID)));
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: ShaderMask(
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              'Continue',
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
                                colors: [
                                  customList.isEmpty
                                      ? Colors.grey
                                      : const Color.fromARGB(255, 255, 173, 50),
                                  customList.isEmpty ? Colors.grey : newRed
                                ]).createShader(rect);
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
