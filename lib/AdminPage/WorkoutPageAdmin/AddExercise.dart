import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hayaproject/AdminPage/EventPageAdmin/EventAdminPage.dart';
import 'package:hayaproject/AdminPage/navigatorbarAdmin/NavigationBar.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/WelcomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';

import '../../FlutterAppIcons.dart';
import '../../Loading.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({super.key});

  @override
  State<AddWorkout> createState() => AddWorkoutState();
}

class AddWorkoutState extends State<AddWorkout> {
  CollectionReference qs = FirebaseFirestore.instance.collection("workout");
  List<Workout2> customList = [];
  bool speed2 = false;
  List<DocumentSnapshot> allWorkouts = [];
  bool deleteSelected = false;
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
  }

  TextEditingController searchController = TextEditingController();

  bool ISSearch = false;
  double Speedopacity = 1;
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    String foodname;

    var size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenAdmin(''), type: PageTransitionType.fade));
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
                            PopupMenuButton<String>(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              position: PopupMenuPosition.under,
                              onSelected: (String result) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7))),
                                        width: width * 0.8,
                                        height: height * 0.16,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(14),
                                              child: Container(
                                                  child: Text(
                                                "Are you sure you want to Logout?",
                                                style: TextStyle(
                                                    fontSize: height * 0.024,
                                                    color: Color(0xFF2C2C2C),
                                                    fontFamily: 'UbuntuREG'),
                                              )),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                    child: TextButton(
                                                        style: ButtonStyle(
                                                            overlayColor:
                                                                MaterialStateProperty
                                                                    .all(Color
                                                                        .fromARGB(
                                                                            90,
                                                                            255,
                                                                            119,
                                                                            56))),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF2C2C2C),
                                                                fontFamily:
                                                                    'UbuntuREG',
                                                                fontSize:
                                                                    height *
                                                                        0.018))),
                                                  ),
                                                  TextButton(
                                                      style: ButtonStyle(
                                                          overlayColor:
                                                              MaterialStateProperty
                                                                  .all(Color
                                                                      .fromARGB(
                                                                          90,
                                                                          255,
                                                                          119,
                                                                          56))),
                                                      onPressed: () async {
                                                        await SetBoolean(
                                                            "IsLogin", false);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            PageTransition(
                                                                child:
                                                                    AddExercise(),
                                                                type:
                                                                    PageTransitionType
                                                                        .fade));
                                                      },
                                                      child: Text("Logout",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF2C2C2C),
                                                              fontFamily:
                                                                  'UbuntuREG',
                                                              fontSize: height *
                                                                  0.018)))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },

                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  height: height * 0.04,
                                  value: 'Delete',
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                        color: Color(0xFF2C2C2C),
                                        fontSize: height * 0.017),
                                  ),
                                ),
                              ],
                              child: Icon(
                                MyFlutterApp.profile,
                                color: const Color(0xFF2C2C2C),
                                size: height * 0.032,
                              ), // The icon to display for the menu button (Icon person)
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
                  firstChild: AnimatedCrossFade(
                    duration: Duration(milliseconds: 120),
                    crossFadeState: deleteSelected
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: GestureDetector(
                      onTap: () {
                        if (!mounted) return;
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
                      onTap: () async {
                        if (customList.length != 0)
                          await deleteItem(customList);
                        if (!mounted) return;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.check,
                        size: height * 0.034,
                        color: customList.length == 0
                            ? Colors.grey
                            : Color.fromARGB(255, 44, 173, 72),
                      ),
                    ),
                  ),
                  secondChild: GestureDetector(
                    onTap: () {
                      if (!mounted) return;
                      setState(() {
                        ISSearch = false;
                        if (!mounted) return;
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
        backgroundColor: Color(0xFFFFFFFF),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: height * 0.07),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: Speedopacity,
            child: SpeedDial(
              overlayOpacity: 0,
              overlayColor: Colors.black,
              backgroundColor: const Color(0xFFFFAA5C),
              icon: Icons.edit,
              animatedIcon: AnimatedIcons.menu_close,
              gradient: RadialGradient(
                  tileMode: TileMode.decal,
                  focal: Alignment.topCenter,
                  stops: [
                    0.2,
                    0.75,
                    1
                  ],
                  colors: [
                    const Color(0xFFFFAA5C).withOpacity(0.25),
                    const Color.fromARGB(255, 255, 114, 89).withOpacity(0.5),
                    const Color.fromARGB(255, 255, 60, 0).withOpacity(0.6),
                  ]),
              children: [
                SpeedDialChild(
                    onTap: () {
                      if (!mounted) return;
                      setState(() {
                        Isvisible = !Isvisible;
                        deleteSelected = !deleteSelected;
                        customList = [];

                        Speedopacity = Isvisible ? 0.4 : 1;
                      });
                    },
                    child: const Icon(
                      Icons.remove,
                      color: Colors.black87,
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
                SpeedDialChild(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AddExercise(),
                              type: PageTransitionType.fade));
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.black87,
                    ),
                    backgroundColor: const Color.fromARGB(255, 252, 252, 252)),
              ],
            ),
          ),
        ),
        body: StreamBuilder(
            stream: qs.orderBy('name').snapshots(),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: snapshot.hasData
                      ? Stack(
                          children: [
                            ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == snapshot.data?.docs.length)
                                    return Container(
                                      height: size.height * 0.09,
                                    );
                                  else
                                    foodname = snapshot
                                        .data?.docs[index]['name']
                                        .toLowerCase();
                                  return foodname.contains(search.toLowerCase())
                                      ? GestureDetector(
                                          onTap: () {
                                            Workout2 elements = Workout2(
                                                name: '',
                                                subtext: '',
                                                type: '',
                                                id: '');
                                            if (!mounted) return;
                                            setState(() {
                                              if (customList.any(((element) {
                                                elements = element;
                                                return element.name ==
                                                    snapshot.data?.docs[index]
                                                        ['name'];
                                              })))
                                                customList.remove(elements);
                                              else
                                                customList.add(Workout2(
                                                    name: snapshot.data
                                                        ?.docs[index]['name'],
                                                    subtext: snapshot
                                                            .data?.docs[index]
                                                        ['subtext'],
                                                    type: snapshot.data
                                                        ?.docs[index]['type'],
                                                    id: snapshot
                                                        .data?.docs[index].id));
                                            });
                                          },
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 5, 15, 5),
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color.fromARGB(
                                                              64, 0, 0, 0),
                                                          blurRadius: 3,
                                                          offset: Offset(0, 2))
                                                    ],
                                                    color: Color.fromARGB(
                                                        247, 250, 250, 250),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
                                                height:
                                                    size.height * 0.112, //95,

                                                child: Container(
                                                    child: Row(children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 10, 0),
                                                    child: Container(
                                                        width:
                                                            size.width * 0.27,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7),
                                                        child: "${snapshot.data?.docs[index]['imgtype']}" ==
                                                                "as"
                                                            ? Image.asset(
                                                                '${snapshot.data?.docs[index]['image']}',
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                '${snapshot.data?.docs[index]['image']}',
                                                                fit: BoxFit
                                                                    .cover)),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 5, 0, 0),
                                                        child: Container(
                                                          width: size.width *
                                                              0.45, // size.width * 0.5,
                                                          child: Text(
                                                              "${snapshot.data?.docs[index]['name']}",
                                                              style: TextStyle(
                                                                  color: const Color(
                                                                      0xFF2C2C2C),
                                                                  fontSize: size
                                                                          .height *
                                                                      0.023 //20
                                                                  )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 0, 15),
                                                        child: Text(
                                                          snapshot.data?.docs[
                                                                          index]
                                                                      [
                                                                      'type'] ==
                                                                  'C'
                                                              ? 'x${snapshot.data?.docs[index]['subtext']}'
                                                              : int.parse('${snapshot.data?.docs[index]['subtext']}') >=
                                                                      10
                                                                  ? '00:${snapshot.data?.docs[index]['subtext']}'
                                                                  : '0${snapshot.data?.docs[index]['subtext']}:00',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.017, //2
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  95, 95, 95)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible: Isvisible,
                                                    child: Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 20, 0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child:
                                                              AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        150),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: customList.any(((element) =>
                                                                          element
                                                                              .name ==
                                                                          snapshot.data?.docs[index]
                                                                              [
                                                                              'name']))
                                                                      ? Colors
                                                                          .transparent
                                                                      : const Color(
                                                                          0xFF686868)),
                                                              boxShadow: [],
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: customList.any(((element) =>
                                                                      element
                                                                          .name ==
                                                                      snapshot.data
                                                                              ?.docs[index]
                                                                          [
                                                                          'name']))
                                                                  ? const Color(
                                                                      0xFF53DB81)
                                                                  : Colors
                                                                      .transparent,
                                                            ),
                                                            width: size.width *
                                                                0.062,
                                                            //25,
                                                            height:
                                                                size.height *
                                                                    0.062,
                                                            child: Visibility(
                                                              visible: customList.any(((element) =>
                                                                      element
                                                                          .name ==
                                                                      snapshot
                                                                          .data
                                                                          ?.docs[index]['name'])) ==
                                                                  true,
                                                              child: const Icon(
                                                                Icons
                                                                    .check_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
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
                            ),
                          ],
                        )
                      : snapshot.connectionState == ConnectionState.waiting
                          ? Padding(
                              padding: EdgeInsets.only(top: height * 0.02),
                              child: test1(200.0, 200.0))
                          : snapshot.hasError
                              ? AlertDialog(
                                  title: Text("error"),
                                )
                              : Container());
            }),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  bool Errorimage = false;
  bool Errorname = false;
  bool Errorsubtext = false;
  bool ErrorExercisetypes = false;
  String? Imageurl;
  File? file;
  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }

  bool loading = false;
  pickercamera(ImageSource imageSource) async {
    if (!mounted) return;
    setState(() {});
    final myfile = await ImagePicker().pickImage(source: imageSource);
    {
      if (myfile != null) {
        if (!mounted) return;
        setState(() {});
        file = File(myfile.path);
        String imagename = basename(myfile!.path);
        var refStorage = FirebaseStorage.instance.ref("Workout/$imagename");
        await refStorage.putFile(file!);

        Imageurl = await refStorage.getDownloadURL();
      } else
        print("ddd");
    }
  }

  String selectedtorc = "";
  double timerVal = 0.1;
  double countVal = 0.1;
  TextEditingController ExerciseNameTextEditingController =
      TextEditingController();
  bool IsClickExerciseType = false;
  bool showErrorname = false;
  final List<String> ExerciseTypeItems = [
    'Timer',
    'Count',
  ];
  String selectedValueofExercisetypes = '';
  bool gifClicked = false;

  Widget slide(
      {required double width, required double height, required String txt}) {
    return Row(
      children: [
        Container(
          width: width * 0.16,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                txt == 'Seconds'
                    ? '${((timerVal * 100)).toInt()}' //thissss
                    : '${((countVal * 100) * 0.5).ceil().toInt()}',
                style: TextStyle(
                    fontSize: height * 0.04, color: Color(0xFF2C2C2C)),
              ),
              Text(
                '$txt',
                style: TextStyle(
                    fontSize: height * 0.014,
                    color: Color(0xFF2C2C2C),
                    fontFamily: 'UbuntuREG'),
              ),
            ],
          ),
        ),
        Container(
          width: width * 0.7,
          child: Slider(
            activeColor: Color.fromARGB(255, 255, 104, 17),
            inactiveColor: Color.fromARGB(255, 252, 216, 200),
            min: 0.1,
            max: txt == 'Seconds' ? 0.9 : 1,
            divisions: txt == 'Seconds' ? 8 : 9,
            value: txt == 'Seconds' ? timerVal : countVal,
            onChanged: (val) {
              if (!mounted) return;
              setState(
                () {
                  txt == 'Seconds' ? timerVal = val : countVal = val;
                  selectedtorc = txt == 'Seconds'
                      ? '${((timerVal * 100)).toInt()}'
                      : '${((countVal * 100) * 0.5).ceil().toInt()}';
                },
              );
            },
          ),
        ),
      ],
    );
  }

  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Row(children: [
              Hero(
                tag: 'back',
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: const Color(0xFF2C2C2C),
                    size: height * 0.038, //size.width * 0.08,
                  ),
                ),
              ),
              Container(
                width: width - height * 0.038 * 3,
                child: Center(
                  child: Text(
                    'Add exercise',
                    style: TextStyle(
                      fontSize: height * 0.025,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                ),
              )
            ])),
        body: Container(
          color: Colors.white,
          width: width,
          height: height * 0.9,
          child: Column(
            children: [
              Container(
                width: width * 0.86,
                height: height * 0.85,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: TextField(
                              onChanged: (value) {
                                Errorname = false;

                                if (ExerciseNameTextEditingController
                                        .text.length ==
                                    0) {
                                  Errorname = true;
                                }
                              },
                              style: TextStyle(
                                  color: const Color(0xFF2C2C2C),
                                  fontSize: height * 0.02),
                              cursorHeight: height * 0.024,
                              cursorColor: const Color(0xFF2C2C2C),
                              controller: ExerciseNameTextEditingController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 22, horizontal: 12),
                                  label: Text(
                                    "Exercise title",
                                    style: TextStyle(
                                        color: const Color(0xFF2c2c2c),
                                        fontSize: height * 0.02,
                                        fontFamily: 'UbuntuREG'),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF2c2c2c)),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.3,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            7.0)), // Sets border radius
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            7.0)), // Sets border radius
                                  ),
                                  errorText: showErrorname
                                      ? "enter valid exercise name"
                                      : null),
                            ),
                          ),
                          AnimatedOpacity(
                              duration: Duration(milliseconds: 120),
                              opacity: Errorname ? 1 : 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 1, left: 2),
                                child: Container(
                                  width: width * 0.8,
                                  child: const Text(
                                    "Enter an exercise title",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.01),
                            child: InkWell(
                              onTap: () async {
                                gifClicked = true;
                                await pickercamera(ImageSource.gallery);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(7)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: width * 0.65,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 22, 0, 22),
                                        child: Text(
                                          file == null
                                              ? "Attach GIF"
                                              : "${basename(file!.path)}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'UbuntuREG',
                                            color: const Color(0xFF2c2c2c),
                                            fontSize: height * 0.02,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 12, 0),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: height * 0.032,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                              duration: Duration(milliseconds: 120),
                              opacity:
                                  file == null && gifClicked == true ? 1 : 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 1, left: 2),
                                child: Container(
                                  width: width * 0.8,
                                  child: const Text(
                                    "Upload a GIF",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.01),
                            width: width * 0.52,
                            child: ButtonTheme(
                              child: DropdownButtonFormField2<String>(
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            7)), // Sets border radius
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 22),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                hint: Text(
                                  'Exercise type',
                                  style: TextStyle(
                                      fontSize: height * 0.02,
                                      fontFamily: 'UbuntuREG',
                                      color: const Color(0xFF2c2c2c)),
                                ),
                                style: TextStyle(
                                    fontSize: height * 0.02,
                                    fontFamily: 'UbuntuREG',
                                    color: const Color(0xFF2c2c2c)),
                                items: ExerciseTypeItems.map(
                                    (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                              fontSize: height * 0.02,
                                            ),
                                          ),
                                        )).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Exercise Type.';
                                  }
                                  return null;
                                },
                                onMenuStateChange: (isOpen) {
                                  if (!mounted) return;
                                  setState(() {
                                    isOpen == true
                                        ? IsClickExerciseType = true
                                        : IsClickExerciseType = false;
                                  });
                                },
                                onChanged: (value) {
                                  ErrorExercisetypes = false;

                                  selectedValueofExercisetypes =
                                      value.toString();
                                  if (selectedValueofExercisetypes == '') {
                                    ErrorExercisetypes = true;
                                  }
                                },
                                onSaved: (value) {
                                  selectedValueofExercisetypes =
                                      value.toString();
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: IconStyleData(
                                    icon: IsClickExerciseType == false
                                        ? const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 24)
                                        : const Icon(
                                            Icons.keyboard_arrow_up_outlined,
                                            size: 24,
                                          )),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      const BoxShadow(
                                          inset: true,
                                          color: Colors.black,
                                          blurRadius: 1,
                                          blurStyle: BlurStyle.outer),
                                    ],
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                              duration: Duration(milliseconds: 120),
                              opacity: ErrorExercisetypes ? 1 : 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 1, left: 2),
                                child: Container(
                                  width: width * 0.3,
                                  child: const Text(
                                    "Select a type",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              )),
                          AnimatedOpacity(
                            opacity: selectedValueofExercisetypes == '' ? 0 : 1,
                            duration: Duration(milliseconds: 120),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 5,
                                          offset: Offset(0, 3))
                                    ]),
                                height: height * 0.1,
                                width: width * 0.86,
                                child: selectedValueofExercisetypes == "Timer"
                                    ? slide(
                                        width: width,
                                        height: height,
                                        txt: 'Seconds'
                                        // selectedtorc
                                        )
                                    : slide(
                                        width: width,
                                        height: height,
                                        txt: 'Times'
                                        //  selectedtorc
                                        )),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: height * 0.06,
                          width: width * 0.8,
                          decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
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
                                    inset: true,
                                    offset: Offset(0, 1))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(350))),
                          child: GestureDetector(
                            onTap: () async {
                              if (!mounted) return;
                              setState(() {
                                Errorname = false;
                                ErrorExercisetypes = false;
                                Errorimage = false;
                                Errorsubtext = false;
                              });
                              if (ExerciseNameTextEditingController
                                      .text.length ==
                                  0) {
                                Errorname = true;
                              }
                              if (selectedtorc == "") {
                                Errorsubtext = true;
                              }
                              if (selectedValueofExercisetypes == '') {
                                ErrorExercisetypes = true;
                              }
                              if (file == null) {
                                Errorimage = true;
                                gifClicked = true;
                              }
                              if (Errorsubtext == false &&
                                  Errorname == false &&
                                  Errorimage == false &&
                                  ErrorExercisetypes == false) {
                                DocumentReference workout =
                                    await FirebaseFirestore.instance
                                        .collection("workout")
                                        .add({
                                  "image": Imageurl,
                                  "imgtype": "net",
                                  "name":
                                      ExerciseNameTextEditingController.text,
                                  "subtext": selectedtorc.toString(),
                                  "type":
                                      selectedValueofExercisetypes == "Timer"
                                          ? "T"
                                          : "C",
                                });

                                Navigator.pop(
                                    context,
                                    PageTransition(
                                        child: MainScreenAdmin('wk'),
                                        type: PageTransitionType.fade));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              // ignore: sort_child_properties_last
                              child: ShaderMask(
                                child: const Text(
                                  'Confirm',
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool x = false;
  bool selectedx = false;
  List<TimeTypes> timetype = [
    TimeTypes(
      '00:30',
      false,
    ),
    TimeTypes(
      '00:60 ',
      false,
    ),
    TimeTypes(
      '00:90',
      false,
    ),
  ];
  List<CountType> counttype = [
    CountType(
      '10',
      false,
    ),
    CountType(
      '15',
      false,
    ),
    CountType(
      ' 20',
      false,
    ),
  ];

  int selectedTaskIndex = -1;

// File? _file;
}

class TimeTypes {
  String Time;
  bool isCompleted;

  TimeTypes(
    this.Time,
    this.isCompleted,
  );
}

class CountType {
  String Count;
  bool isCompleted;

  CountType(
    this.Count,
    this.isCompleted,
  );
}

class Workout2 {
  var name;
  var subtext;
  var type;
  var id;

  Workout2(
      {required this.name,
      required this.subtext,
      required this.type,
      required this.id});
}

class wk {
  bool isclick;

  wk({required this.isclick});
}

SetBoolean(String key, bool value) async {
  await Prefs.setBoolean(key, value);
}
