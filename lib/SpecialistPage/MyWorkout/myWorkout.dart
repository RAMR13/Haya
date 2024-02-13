import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hayaproject/AdminPage/WorkoutPageAdmin/AddExercise.dart';
import 'package:hayaproject/SpecialistPage/MorePage/MorePage.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';
import 'package:page_transition/page_transition.dart';
import '../../FlutterAppIcons.dart';
import '../../Loading.dart';

class Myworkout extends StatefulWidget {
  const Myworkout({super.key});

  @override
  State<Myworkout> createState() => _MyworkoutState();
}

class _MyworkoutState extends State<Myworkout> {
  CollectionReference qs = FirebaseFirestore.instance.collection("workout");
  List<Workout2> customList = [];
  bool speed2 = false;
  List<DocumentSnapshot> allWorkouts = [];
  late List<Workout2> allWorkoutsLocal = [];

  getData() async {
    allWorkouts = [];
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("workout").get();

    allWorkouts.addAll(qs.docs);

    await wklocalget();
    if (!mounted) return;
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getData();

    super.initState();
  }

  String search = '';
  bool Isvisible = false;

  deleteItem(List newlist) async {
    for (int i = 0; i < newlist.length; i++) {
      await FirebaseFirestore.instance
          .collection('workout')
          .doc(newlist[i].id)
          .delete();
    }
    customList = [];
    await getData();

    await wklocalget();
  }

  wklocalget() {
    allWorkoutsLocal = [];
    for (int i = 0; i < allWorkouts.length; i++) {
      allWorkoutsLocal.add(Workout2(
          name: allWorkouts[i]['name'],
          subtext: int.parse(allWorkouts[i]['subtext']),
          type: allWorkouts[i]['type'],
          id: allWorkouts[i].id));
    }
  }

  double Speedopacity = 1;
  bool ISSearch = false;
  bool shouldPop = true;
  bool lock = false;
  double opacity = 0;
  @override
  Widget build(BuildContext context) {
    String foodname;

    var size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).size.height;
    Timer(Duration(milliseconds: 0), () {
      opacity = 1;
    });
    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenSpec(""), type: PageTransitionType.fade));
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: AnimatedCrossFade(
                      firstCurve: Curves.easeIn,
                      firstChild: Container(
                        width: size.width * 0.82,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      child: More("Myworkout"),
                                      type: PageTransitionType.fade),
                                );
                              },
                              child: Icon(
                                MyFlutterApp.profile,
                                color: Color(0xFF2C2C2C),
                                size: height * 0.032,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Workouts",
                                style: TextStyle(
                                    fontSize: height * 0.03,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C2C2C)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      secondChild: Container(
                        width: size.width * 0.82,
                        child: TextField(
                          controller: searchController,
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
                          cursorColor: const Color(0xFF2C2C2C),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              hintText: 'Search',
                              hintStyle: TextStyle(fontFamily: 'UbuntuREG'),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 170, 170, 170),
                                    width: 1.2,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 114, 82),
                                    width: 1.4,
                                  ))),
                        ),
                      ),
                      crossFadeState: ISSearch
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 100))),
              Container(
                alignment: Alignment.centerRight,
                child: AnimatedCrossFade(
                  firstCurve: Curves.easeIn,
                  duration: Duration(milliseconds: 100),
                  crossFadeState: ISSearch
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: GestureDetector(
                    onTap: () {
                      setState(() {
                        ISSearch = true;
                      });
                    },
                    child: Icon(
                      MyFlutterApp.search_normal_1,
                      color: Color(0xFF2C2C2C),
                      size: height * 0.03,
                    ),
                  ),
                  secondChild: GestureDetector(
                    onTap: () {
                      setState(() {
                        ISSearch = false;
                        setState(() {
                          search = '';
                          searchController = TextEditingController(text: '');
                        });
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Color(0xFF2C2C2C),
                      size: height * 0.035,
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 3,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFFFFF),
        body: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(milliseconds: 150),
          child: StreamBuilder(
              stream: qs.snapshots(),
              builder: (context, snapshot) {
                if (lock == false) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return test1(20.0, 20.0);
                  }
                  lock = true;
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: snapshot
                        .data?.docs.length, //allWorkouts.length, //variable
                    itemBuilder: (BuildContext context, int index) {
                      if (index == snapshot.data?.docs.length)
                        return Container(
                          margin: EdgeInsets.only(bottom: size.height * 0.05),
                        );
                      else
                        foodname =
                            snapshot.data?.docs[index]['name'].toLowerCase();
                      return foodname.contains(search.toLowerCase())
                          ? GestureDetector(
                              onTap: () {
                                if (!mounted) return;
                                setState(() {
                                  if (customList
                                      .contains(allWorkoutsLocal[index]))
                                    customList.remove(allWorkoutsLocal[index]);
                                  else
                                    customList.add(allWorkoutsLocal[index]);
                                });
                              },
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: index ==
                                                snapshot.data!.docs.length - 1
                                            ? size.height * 0.07
                                            : 0),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color.fromARGB(64, 0, 0, 0),
                                              blurRadius: 3,
                                              offset: Offset(0, 2))
                                        ],
                                        color:
                                            Color.fromARGB(247, 250, 250, 250),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7))),
                                    height: size.height * 0.112,
                                    //95,

                                    child: Container(
                                        child: Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Container(
                                            width: size.width * 0.27,
                                            padding: const EdgeInsets.all(7),
                                            child: "${snapshot.data?.docs[index]['imgtype']}" ==
                                                    "as"
                                                ? Image.asset(
                                                    '${snapshot.data?.docs[index]['image']}',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    '${snapshot.data?.docs[index]['image']}',
                                                    fit: BoxFit.cover)),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 0),
                                            child: Container(
                                              width: size.width *
                                                  0.45, // size.width * 0.5,
                                              child: Text(
                                                  "${snapshot.data?.docs[index]['name']}",
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xFF2C2C2C),
                                                      fontSize: size.height *
                                                          0.023 //20
                                                      )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 15),
                                            child: Text(
                                              snapshot.data?.docs[index]
                                                          ['type'] ==
                                                      'C'
                                                  ? 'x${snapshot.data?.docs[index]['subtext']}'
                                                  : int.parse('${snapshot.data?.docs[index]['subtext']}') >
                                                          10
                                                      ? '00:${snapshot.data?.docs[index]['subtext']}'
                                                      : '0${snapshot.data?.docs[index]['subtext']}:00',
                                              style: TextStyle(
                                                  fontSize:
                                                      size.height * 0.017, //2
                                                  color: const Color.fromARGB(
                                                      255, 95, 95, 95)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: Isvisible,
                                        child: Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 20, 0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 150),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                  width: 1,
                                                )),
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
                  );
                }
                if (snapshot.hasError) {
                  Future.delayed(const Duration(microseconds: 2), () {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("error"),
                        );
                      },
                    );
                  });
                }

                return Container();
              }),
        ),
      ),
    );
  }
}
