import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as material;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart'; //delete
import 'package:hayaproject/UserPages/HomePage/weight.dart';
import 'package:hayaproject/UserPages/MorePage/screen1.dart';
import 'package:hayaproject/UserPages/WorkoutPage/ExerciseBody.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => UserHomeState();
}

int prefwk = 0;
Exercises pointer =
    armIntermediate; //Exercises(title: '', duration: 0, workouts: []);
double userWeight = 0;
double userHeight = 0;
String stringHeight = '';
String stringWeight = '';
int doneWk = 0;
List<DocumentSnapshot<Map<String, dynamic>>> UserEvent = [];

class UserHomeState extends State<UserHome> with TickerProviderStateMixin {
  //Exercises pointer = armIntermediate;

  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }

  late AnimationController controller;
  late Animation<double> animate;
  var userID;
  List<DocumentSnapshot> UserEventList = [];
  List<String> Myjoined = [];

  List<DocumentSnapshot> user = [];
  List<tablee> table = [];
  @override
  void initState() {
    super.initState();
    initializeData();
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    controller.addListener(() {
      getPrefs();
    });
    animate = Tween(begin: 0.0, end: 75.0).animate(controller);
  }

  Future<void> initializeData() async {
    try {
      await Prefs.getString("Id").then((value) async {
        userID = await value;
        // Now that userID is available, proceed with fetching data
        await getData();
        await getPrefs();
      });
    } catch (e) {
      print("Error in initializeData: $e");
    }
  }

  Future<void> getData() async {
    try {
      final userQuery = FirebaseFirestore.instance
          .collectionGroup("users")
          .where('User_id', isEqualTo: userID)
          .get();

      final userEventQuery = FirebaseFirestore.instance
          .collection("Events")
          .doc("E4AoboJAGVZzQtD8VuLB")
          .collection("UserEvent")
          .get();

      final results = await Future.wait([userQuery, userEventQuery]);

      final QuerySnapshot qs0 = results[0];
      final QuerySnapshot qs = results[1];

      user.addAll(qs0.docs);
      UserEventList.addAll(qs.docs);

      final subscriptionQueries = await Future.wait(UserEventList.map(
          (eventDoc) => FirebaseFirestore.instance
              .collection("Events")
              .doc('E4AoboJAGVZzQtD8VuLB')
              .collection("UserEvent")
              .doc(eventDoc.id)
              .collection('subscribtion')
              .where('user id', isEqualTo: userID)
              .get()));

      for (int i = 0; i < subscriptionQueries.length; i++) {
        if (subscriptionQueries[i].docs.isNotEmpty) {
          Myjoined.add(UserEventList[i].id.toString());
        } else {
          print("fery good");
          // Do something if there's no subscription
        }
      }
      if (Myjoined.isNotEmpty) await getdata2();
    } catch (e) {
      print("Error in getData: $e");
    }
  }

  Future<void> getdata2() async {
    try {
      // Clear the list before adding new elements
      UserEvent.clear();

      // Batch queries for multiple documents
      QuerySnapshot<Map<String, dynamic>> batch = await FirebaseFirestore
          .instance
          .collection("Events")
          .doc("E4AoboJAGVZzQtD8VuLB")
          .collection("UserEvent")
          .where(FieldPath.documentId, whereIn: Myjoined)
          .get();

      // Add the fetched data to UserEvent list
      UserEvent.addAll(
          batch.docs.cast<DocumentSnapshot<Map<String, dynamic>>>());

      // Update the table based on UserEvent
      if (UserEvent.isEmpty) {
        table = [tablee('', '', '', '', '')];
      } else {
        table = UserEvent.map((element) => tablee(
              element['title'],
              element['first date'].toString().substring(0),
              '',
              element['first time'],
              element['limit'],
            )).toList();
      }
    } catch (e) {
      print("Error in getdata2: $e");
    }
  }

  Future<void> getPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      doneWk = prefs.getInt("workout done")!;
      prefwk = int.parse(prefs.getInt("workout index").toString()!);
      stringHeight = prefs.getString("height")!;
      stringWeight = prefs.getString("weight")!;
      await prefs.reload();
      userHeight = double.parse(stringHeight);
      userWeight = double.parse(stringWeight);

      if (!mounted) return;
      setState(() {
        if (prefwk == 1) pointer = armBeginner;
        if (prefwk == 2) pointer = ChestBeginner;
        if (prefwk == 3) pointer = AbsBeginner;
        if (prefwk == 4) pointer = LegBeginner;
        if (prefwk == 5) pointer = armIntermediate;
        if (prefwk == 6) pointer = ChestIntermediate;
        if (prefwk == 7) pointer = AbsIntermediate;
        if (prefwk == 8) pointer = LegIntermediate;
        if (prefwk == 9) pointer = armAdvanced;
        if (prefwk == 10) pointer = ChestAdvanced;
        if (prefwk == 11) pointer = AbsAdvanced;
        if (prefwk == 12) pointer = LegAdvanced;
      });
    } catch (e) {
      print("Error in getPrefs: $e");
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isWk = prefwk == -1 ? false : true;
  int lock = 0;

  @override
  Widget build(BuildContext context) {
    // getPrefs();

    List completedDEMO = [0];
    completedDEMO = prefwk == -1 ? [] : List<int>.generate(doneWk, (i) => i);
    var size = MediaQuery.of(context).size;
    RichText newDir = RichText(
        text: TextSpan(
            style: TextStyle(
                color: const Color(0xFF1E1E1E).withOpacity(0.85),
                fontSize: size.height * 0.017,
                fontFamily: 'UbuntuREG'),
            children: const [
          TextSpan(text: 'Step 1\n', style: TextStyle(fontFamily: 'UbuntuMED')),
          TextSpan(
              text:
                  'Heat 2 teaspoons oil in a large skillet on medium-high. Season salmon with ½ teaspoon each salt and pepper, add to skillet, flesh side down, reduce heat to medium, and cook until golden brown and just opaque throughout, 5 to 6 minutes per side.\n\n'),
          TextSpan(text: 'Step 2\n', style: TextStyle(fontFamily: 'UbuntuMED')),
          TextSpan(
              text:
                  'Heat remaining 2 tablespoons oil in a large cast-iron skillet on medium-high. Add green beans and cook until browned, 2½ minutes. Turn with tongs and cook until browned and just barely tender, about 3 minutes more.\n\n'),
          TextSpan(text: 'Step 3\n', style: TextStyle(fontFamily: 'UbuntuMED')),
          TextSpan(
              text:
                  'Remove from heat and toss with ¼ teaspoon salt, then garlic, chile, and capers. Return to medium heat and cook, tossing until garlic is golden brown, 1 to 2 minutes. Serve with salmon and lemon wedges if desired.')
        ]));
    food tandoori = food(
        cal: '440',
        name: 'Tandoori Chicken',
        ingredients:
            '• Lemon wedges, for serving\n• 4 cloves garlic, smashed and thinly sliced\n• 1 1/4 lb. skinless salmon fillet, cut into 4 portions\n• 2 tbsp. capers, drained, patted dry\n• 1 small red chile, thinly sliced\n• 1 lb. green beans, trimmed\n• Kosher salt and pepper',
        directions: newDir,
        nutrition:
            '283 calories, 14.5 g fat (2.5 g saturated), 31 g protein, 540 mg sodium, 9 g carb, 3 g fiber',
        pic: 'asset/Images Food/1.png');
    food california = food(
        cal: '280',
        name: 'California Roll Salad',
        ingredients:
            '• Lemon wedges, for serving\n• 4 cloves garlic, smashed and thinly sliced\n• 1 1/4 lb. skinless salmon fillet, cut into 4 portions\n• 2 tbsp. capers, drained, patted dry\n• 1 small red chile, thinly sliced\n• 1 lb. green beans, trimmed\n• Kosher salt and pepper',
        directions: newDir,
        nutrition:
            '284 calories, 14.5 g fat (2.5 g saturated), 31 g protein, 540 mg sodium, 9 g carb, 3 g fiber',
        pic: 'asset/Images Food/2.png');
    food shakshuka = food(
        cal: '235',
        name: 'Shakshuka',
        ingredients:
            '• Lemon wedges, for serving\n• 4 cloves garlic, smashed and thinly sliced\n• 1 1/4 lb. skinless salmon fillet, cut into 4 portions\n• 2 tbsp. capers, drained, patted dry\n• 1 small red chile, thinly sliced\n• 1 lb. green beans, trimmed\n• Kosher salt and pepper',
        directions: newDir,
        nutrition:
            '285 calories, 14.5 g fat (2.5 g saturated), 31 g protein, 540 mg sodium, 9 g carb, 3 g fiber',
        pic: 'asset/Images Food/3.png');
    food salmon = food(
        cal: '285',
        name: 'Salmon With Charred green Beans',
        ingredients:
            '• Lemon wedges, for serving\n• 4 cloves garlic, smashed and thinly sliced\n• 1 1/4 lb. skinless salmon fillet, cut into 4 portions\n• 2 tbsp. capers, drained, patted dry\n• 1 small red chile, thinly sliced\n• 1 lb. green beans, trimmed\n• Kosher salt and pepper',
        directions: newDir,
        nutrition:
            '286 calories, 14.5 g fat (2.5 g saturated), 31 g protein, 540 mg sodium, 9 g carb, 3 g fiber',
        pic: 'asset/Images Food/4.png');
    List<food> foods = [tandoori, california, shakshuka, salmon];
    double weight = userWeight;
    double height = userHeight;
    double bmi = weight /
        (height * height) *
        10000; // <18.5 Underweight, 18.5-24.9 Balanced, 25-29.9 Overweight, >30 Obese
    List joinedEvents = [];
    double hei = size.height * 0.08;
    double cirw = size.height / size.width < 1.6
        ? size.height * 0.15
        : size.width * 0.315; //128;

    Widget circ(
        {required Color color,
        required IconData icon,
        required String main,
        required String sub}) {
      return Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedIcon(
                  icon: Icon(
                    icon,
                    size: size.height * 0.036, //30,
                    color:
                        icon == Icons.bolt_rounded ? Colors.transparent : color,
                  ),
                  decoration: IconDecoration(
                      border: icon == Icons.bolt_rounded
                          ? IconBorder(width: 1.8, color: color)
                          : const IconBorder(
                              width: 0, color: Colors.transparent)),
                ),
                (sub == "Workout" || sub == "Kcal") && prefwk == -1
                    ? Container()
                    : Text(main,
                        style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: size.height * 0.019,
                            fontFamily: 'UbuntuREG')),
                (sub == "Workout" || sub == "Kcal") && prefwk == -1
                    ? Container(
                        width: size.width * 0.2,
                        child: Text('No workout plan selected yet',
                            maxLines: 4,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: const Color(0xFF1E1E1E),
                                fontSize: size.height * 0.014, //14,
                                fontFamily: 'UbuntuREG')),
                      )
                    : Container(),
                (sub == "Workout" || sub == "Kcal") && prefwk == -1
                    ? Container()
                    : Text(sub,
                        style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: size.height * 0.015, //14,
                            fontFamily: 'UbuntuREG')),
              ],
            ),
          ),

          height: size.height / 0.2,
          width: size.height / size.width < 1.6
              ? size.height / 8.2
              : size.width / 3.9, //108,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      );
    }

    const Color textcolor = Color(0xFF2C2C2C);
    Color inactiveWk = const Color(0xFFFF6A49).withOpacity(0.25);
    Color activeWk = const Color(0xFFFF6A49).withOpacity(1);
    Color bmiLow = const Color(0xFF65ACFF);
    Color bmiNorm = const Color(0xFF21DE43);
    Color bmiHigh = const Color(0xFFFFE074);
    Color bmiObese = const Color(0xFFFF7D7D);

    String bmiText = bmi <= 24.9 && bmi >= 18.5
        ? 'Balanced'
        : bmi <= 29.9 && bmi >= 25.0
            ? 'Overweight'
            : bmi >= 30
                ? 'Obese'
                : bmi < 18.5
                    ? 'Underweight'
                    : '';
    List chartSect = [
      (color: bmiNorm.withOpacity(bmi <= 24.9 && bmi >= 18.5 ? 1 : 0.25)),
      (color: bmiHigh.withOpacity(bmi <= 29.9 && bmi >= 25.0 ? 1 : 0.25)),
      (color: bmiObese.withOpacity(bmi >= 30 ? 1 : 0.25)),
      (color: bmiLow.withOpacity(bmi < 18.5 ? 1 : 0.25))
    ];
    List<PieChartSectionData> _firstChartSections() {
      List<(Workouts, bool)> active = [];
      for (int i = 0; i < pointer.workouts.length; i++) {
        completedDEMO.contains(i)
            ? active.add((pointer.workouts[i], true))
            : active.add((pointer.workouts[i], false));
      }
      final List<PieChartSectionData> list = [];
      for (var sector in active) {
        final data = PieChartSectionData(
          color: sector.$2 == true ? activeWk : inactiveWk,
        );
        list.add(data);
      }
      return list;
    }

    List<PieChartSectionData> _chartSections(List chartSect) {
      final List<PieChartSectionData> list = [];
      for (var sector in chartSect) {
        final data = PieChartSectionData(
          color: sector.color,
        );
        list.add(data);
      }
      return list;
    }

    Widget circ2(double tr, bool t, List<PieChartSectionData> list) {
      return Center(
        child: Opacity(
          opacity: tr,
          child: Container(
            child: t == true
                ? PieChart(PieChartData(
                    startDegreeOffset: -90,
                    borderData: FlBorderData(show: false),
                    sections: _chartSections(list)))
                : Container(),
            height: cirw,
            width: cirw, //108,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    inset: true,
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 6)
              ],
              shape: BoxShape.circle,
              color: const Color(0xFFF9F9F9),
            ),
          ),
        ),
      );
    }

    Widget circE() {
      return Container(
        height: cirw,
        width: cirw,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0), shape: BoxShape.circle),
      );
    }

    bool isEx1 = false;
    bool isEx2 = false;
    bool isEx3 = false;
    Widget rec;

    double SubtractH = doneWk == -1
        ? 0
        : size.height * (doneWk / pointer.workouts.length * 0.18);

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Screen1(""),
                                type: PageTransitionType.fade));
                      },
                      child: user.isNotEmpty
                          ? Container(
                              height: size.height * 0.034,
                              width: size.height * 0.034,
                              decoration: material.BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(user[0]['images']),
                                    fit: BoxFit.cover),
                              ),
                            )
                          : Icon(
                              MyFlutterApp.profile,
                              color: Color(0xFF2C2C2C),
                              size: size.height * 0.032,
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Home",
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   PageTransition(child: child, type: PageTransitionType.fade)

                    //   MaterialPageRoute<void>(
                    //     builder: (BuildContext context) => MainScreenSpec(""),
                    //   ),
                    // );
                  },
                  child: Icon(
                    FontAwesomeIcons.bell,
                    color: Color(0xFF2C2C2C),
                    size: size.height * 0.03,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 3,
        ),
        backgroundColor: const Color(0xFFF9F9F9),
        body: Center(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      width: size.width / 1.03,
                      height: size.height / 5.3,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                circ2(0, true, []),
                                circ2(1, false, []),
                                circ2(0, true, [])
                              ]),
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(animate.value, 0, 0, 5),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: SubtractH,
                                child: Image.asset(
                                    'asset/asset Images Rand/Subtract back.png',
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(0, 0, animate.value, 5),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: SubtractH,
                                child: Image.asset(
                                    'asset/asset Images Rand/Subtract front.png',
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          //////////////////toooop////////////////////////
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                circ2(1, true, _firstChartSections()),
                                circ2(0, false, []),
                                circ2(1, true, _chartSections(chartSect))
                              ]),
                          ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Color.fromARGB(255, 255, 255, 255),
                                BlendMode.srcOut),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    backgroundBlendMode: BlendMode.dstOut,
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [circE(), circE(), circE()],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              circ(
                                  main:
                                      '${completedDEMO.length}/${pointer.workouts.length}',
                                  sub: 'Workout',
                                  icon: MyFlutterApp.dumbbell,
                                  color:
                                      const Color.fromARGB(255, 255, 103, 103)),
                              circ(
                                  main:
                                      '${((520 / pointer.workouts.length * completedDEMO.length)).toInt()}',
                                  sub: 'Kcal',
                                  icon: Icons.bolt_rounded,
                                  color:
                                      const Color.fromARGB(255, 244, 111, 54)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: UserWeight(userID, userWeight),
                                          type: PageTransitionType.fade));
                                },
                                child: circ(
                                  main: '$userWeight' + 'KG',
                                  sub: '$bmiText',
                                  icon: MyFlutterApp.vector_1,
                                  color: bmi <= 24.9 && bmi >= 18.5
                                      ? const Color.fromARGB(255, 21, 184, 122)
                                      : bmi <= 29.9 && bmi >= 25.0
                                          ? const Color.fromARGB(
                                              255, 245, 191, 44)
                                          : bmi >= 30
                                              ? bmiObese
                                              : bmi < 18.5
                                                  ? bmiLow
                                                  : const Color.fromARGB(
                                                      255,
                                                      21,
                                                      184,
                                                      122), //Color.fromARGB(255, 21, 184, 122)
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.29,
                      width: size.width / 1.03,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: size.width * 0.02),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Today's recommended recipes",
                              style: TextStyle(
                                  color: textcolor,
                                  fontFamily: 'UbuntuREG',
                                  fontSize: size.height * 0.017),
                            ),
                          ),
                          Container(
                            height: size.height * 0.25,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: index == 0
                                      ? const EdgeInsets.fromLTRB(5, 0, 0, 0)
                                      : index == 3
                                          ? const EdgeInsets.fromLTRB(
                                              5, 0, 5, 0)
                                          : const EdgeInsets.fromLTRB(
                                              5, 0, 0, 0),
                                  child: Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet<dynamic>(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(14))),
                                          context: context,
                                          builder: (BuildContext bc) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    setState) {
                                              Widget NewEx(
                                                  VoidCallback fn,
                                                  bool ex,
                                                  String txt,
                                                  Widget content) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(fn);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Column(
                                                      children: [
                                                        AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      120),
                                                          width: size.width,
                                                          height: hei,
                                                          decoration:
                                                              BoxDecoration(
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                    color: const Color(
                                                                            0xFFFEF4EF)
                                                                        .withOpacity(
                                                                            0.45),
                                                                    inset: true,
                                                                    spreadRadius:
                                                                        200),
                                                                CustomBoxShadow(
                                                                    blurStyle:
                                                                        BlurStyle
                                                                            .outer,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.25),
                                                                    blurRadius:
                                                                        6,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            0))
                                                              ]),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  '$txt',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'UbuntuREG',
                                                                      fontSize:
                                                                          size.height *
                                                                              0.025),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10),
                                                                child:
                                                                    AnimatedRotation(
                                                                  turns: ex
                                                                      ? 0.75
                                                                      : 1 / 2,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          120),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_back_ios_new_rounded,
                                                                    size: size
                                                                            .height *
                                                                        0.026,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        AnimatedSize(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      120),
                                                          child:
                                                              AnimatedSwitcher(
                                                            reverseDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            switchInCurve: Curves
                                                                .fastLinearToSlowEaseIn,
                                                            switchOutCurve: Curves
                                                                .fastEaseInToSlowEaseOut,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        150),
                                                            child: ex
                                                                ? rec = Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              5),
                                                                      child: Container(
                                                                          key: const ValueKey<int>(
                                                                              0),
                                                                          child:
                                                                              content),
                                                                      /*  Text(
                                                                          '$content',
                                                                          style: TextStyle(
                                                                              color: Color(0xFF1E1E1E).withOpacity(
                                                                                  0.85),
                                                                              fontSize: size.height *
                                                                                  0.019,
                                                                              fontFamily:
                                                                                  'UbuntuREG'),
                                                                        ),*/
                                                                    ),
                                                                  )
                                                                : rec =
                                                                    Container(
                                                                    key: const ValueKey<
                                                                        int>(1),
                                                                  ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }

                                              return ClipRRect(
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(14)),
                                                clipBehavior: Clip.antiAlias,
                                                child: ScrollConfiguration(
                                                  behavior:
                                                      const ScrollBehavior(),
                                                  child: SingleChildScrollView(
                                                    child: Stack(
                                                      children: [
                                                        Positioned.fill(
                                                          child: Image.asset(
                                                              'asset/asset Images Rand/FoodBack.png'),
                                                        ),
                                                        BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 80,
                                                                  sigmaY: 80),
                                                          child: Container(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.6),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                /////////////////////IMG
                                                                Container(
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              14),
                                                                    ),
                                                                  ),
                                                                  height:
                                                                      size.height *
                                                                          0.28,
                                                                  child: Stack(
                                                                    fit: StackFit
                                                                        .passthrough,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        foods[index]
                                                                            .pic,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      Container(
                                                                        /////shadow
                                                                        decoration:
                                                                            BoxDecoration(boxShadow: [
                                                                          BoxShadow(
                                                                              color: Colors.black.withOpacity(0.45),
                                                                              blurRadius: 15,
                                                                              inset: true,
                                                                              offset: const Offset(0, -80))
                                                                        ]),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.bottomLeft,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              size.width * 0.9,
                                                                          margin: const EdgeInsets
                                                                              .all(
                                                                              7),
                                                                          child:
                                                                              Text(
                                                                            foods[index].name,
                                                                            style:
                                                                                TextStyle(shadows: [
                                                                              Shadow(blurRadius: 12, offset: const Offset(0, 4), color: Colors.black.withOpacity(0.45))
                                                                            ], fontSize: size.height * 0.035, color: Colors.white, fontFamily: 'UbuntuREG'),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                //////////////////////IMG
                                                                NewEx(() {
                                                                  isEx1 == false
                                                                      ? {
                                                                          isEx1 =
                                                                              true,
                                                                          isEx2 =
                                                                              false,
                                                                          isEx3 =
                                                                              false
                                                                        }
                                                                      : isEx1 =
                                                                          false;
                                                                },
                                                                    isEx1,
                                                                    'Ingredients',
                                                                    Text(
                                                                        foods[index]
                                                                            .ingredients,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFF1E1E1E).withOpacity(0.85),
                                                                          fontSize:
                                                                              size.height * 0.017,
                                                                          fontFamily:
                                                                              'UbuntuREG',
                                                                        ))),
                                                                NewEx(() {
                                                                  isEx2 == false
                                                                      ? {
                                                                          isEx1 =
                                                                              false,
                                                                          isEx3 =
                                                                              false,
                                                                          isEx2 =
                                                                              true
                                                                        }
                                                                      : isEx2 =
                                                                          false;
                                                                },
                                                                    isEx2,
                                                                    'Directions',
                                                                    foods[index]
                                                                        .directions),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                  child: NewEx(
                                                                    () {
                                                                      isEx3 ==
                                                                              false
                                                                          ? {
                                                                              isEx1 = false,
                                                                              isEx2 = false,
                                                                              isEx3 = true
                                                                            }
                                                                          : isEx3 =
                                                                              false;
                                                                    },
                                                                    isEx3,
                                                                    'Nutritional information',
                                                                    Text(
                                                                      foods[index]
                                                                          .nutrition,
                                                                      style: TextStyle(
                                                                          color: const Color(0xFF1E1E1E).withOpacity(
                                                                              0.85),
                                                                          fontSize: size.height *
                                                                              0.017,
                                                                          fontFamily:
                                                                              'UbuntuREG'),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              foods[index].pic,
                                              fit: BoxFit.cover,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4, 8, 0, 0),
                                              child: Container(
                                                width: size.height * 0.23,
                                                ////////////////////////////////////
                                                child: Text(
                                                  foods[index].name,
                                                  style: TextStyle(
                                                    shadows: [
                                                      Shadow(
                                                          blurRadius: 12,
                                                          offset: const Offset(
                                                              0, 4),
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.45))
                                                    ],
                                                    letterSpacing: -0.3,
                                                    color: Colors.white,
                                                    fontFamily: 'UbuntuREG',
                                                    fontSize:
                                                        size.height * 0.022,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 0, 0, 4),
                                                child: Row(
                                                  children: [
                                                    DecoratedIcon(
                                                      icon: Icon(
                                                        Icons.bolt_rounded,
                                                        shadows: [
                                                          Shadow(
                                                              blurRadius: 12,
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.45))
                                                        ],
                                                        color:
                                                            Colors.transparent,
                                                        size:
                                                            size.height * 0.025,
                                                      ),
                                                      decoration:
                                                          const IconDecoration(
                                                              border: IconBorder(
                                                                  width: 1.4,
                                                                  color: Colors
                                                                      .white)),
                                                    ),
                                                    Text(
                                                      '${foods[index].cal} Cal/Serv',
                                                      style: TextStyle(
                                                        shadows: [
                                                          Shadow(
                                                              blurRadius: 12,
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.45))
                                                        ],
                                                        letterSpacing: -0.3,
                                                        color: Colors.white,
                                                        fontFamily: 'UbuntuREG',
                                                        fontSize:
                                                            size.height * 0.02,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.21,
                      width: size.width / 1.03,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: size.width * 0.02),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Workout report",
                              style: TextStyle(
                                  color: textcolor,
                                  fontFamily: 'UbuntuREG',
                                  fontSize: size.height * 0.016),
                            ),
                          ),
                          Container(
                            height: size.height * 0.17,
                            width: size.width * 0.94,
                            child: prefwk == -1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Container(
                                          width: size.width * 0.09,
                                          height: size.height * 0.05,
                                          child: Image.asset(
                                            'asset/Images/weightOutline.png',
                                            color: Color(0xFF5B5B5B),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Container(
                                          width: size.width * 0.85,
                                          child: Text(
                                            'You have not selected any workout plan yet',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'UbuntuREG',
                                                fontSize: size.height * 0.016,
                                                color: Color(0xFF5B5B5B)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 12),
                                        child: Container(
                                          height: size.height * 0.034,
                                          width: size.width * 0.25,
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 173, 50),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(0xFFFF2214),
                                                    blurRadius: 12,
                                                    inset: true,
                                                    offset: Offset(0, -7)),
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                        71, 0, 0, 0),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 1))
                                              ],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(350))),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(350))),
                                            margin: const EdgeInsets.all(2.5),
                                            child: ShaderMask(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child: MainScreenUser(
                                                              "WHomePage"),
                                                          type:
                                                              PageTransitionType
                                                                  .fade),
                                                    );
                                                  }, /////////Do it
                                                  child: Text(
                                                    'Select',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.016,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              shaderCallback: (rect) {
                                                return const LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.orange,
                                                      Colors.red
                                                    ]).createShader(rect);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                          "asset/Images/Workout cover/${pointer.title}.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: DecoratedIcon(
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            shadows: [
                                              Shadow(
                                                  offset: const Offset(0, 2),
                                                  color: const Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      .withOpacity(0.3),
                                                  blurRadius: 12)
                                            ],
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            size: size.height * 0.05,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                color: const Color(0xFFF9F9F9),
                                                child: Text(
                                                  '${pointer.title.toUpperCase()}',
                                                  style: TextStyle(
                                                      fontFamily: 'ITC Avant',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: size.height *
                                                          0.022, //21,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 3, 0, 0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    color:
                                                        const Color(0xFFF9F9F9),
                                                    child: Text(
                                                      '${completedDEMO.length}/${pointer.workouts.length} Workouts',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'ITC Avant',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              size.height *
                                                                  0.022, //21,
                                                          color: Colors.black),
                                                    ),
                                                  )),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 3, 0, 0),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  color: const Color.fromRGBO(
                                                      249, 249, 249, 1),
                                                  child: Text(
                                                    '632 Calories',
                                                    style: TextStyle(
                                                        fontFamily: 'ITC Avant',
                                                        fontSize:
                                                            size.height * 0.022,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        overflow:
                                                            TextOverflow.clip),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(0, 2),
                                    blurRadius: 6,
                                  )
                                ]),
                            height: size.height * 0.21,
                            width: size.width / 1.03,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: size.width * 0.02),
                                    child: Text(
                                      "Joined events",
                                      style: TextStyle(
                                          color: textcolor,
                                          fontFamily: 'UbuntuREG',
                                          fontSize: size.height * 0.016),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.17,
                                  width: size.width * 0.96,
                                  child: table.length == 0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Container(
                                                width: size.width * 0.09,
                                                height: size.height * 0.05,
                                                child: Image.asset(
                                                  'asset/Images/event.png',
                                                  color: Color(0xFF5B5B5B),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Container(
                                                width: size.width * 0.85,
                                                child: Text(
                                                  'You have not joined any events yet',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'UbuntuREG',
                                                      fontSize:
                                                          size.height * 0.016,
                                                      color: Color(0xFF5B5B5B)),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 12),
                                              child: Container(
                                                height: size.height * 0.034,
                                                width: size.width * 0.25,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 255, 173, 50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              Color(0xFFFF2214),
                                                          blurRadius: 12,
                                                          inset: true,
                                                          offset:
                                                              Offset(0, -7)),
                                                      BoxShadow(
                                                          color: Color.fromARGB(
                                                              71, 0, 0, 0),
                                                          blurRadius: 4,
                                                          offset: Offset(0, 1))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                350))),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          350))),
                                                  margin:
                                                      const EdgeInsets.all(2.5),
                                                  child: ShaderMask(
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                child: MainScreenUser(
                                                                    "eventpage"),
                                                                type:
                                                                    PageTransitionType
                                                                        .fade),
                                                          );
                                                        }, /////////Do it
                                                        child: Text(
                                                          'Join',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.016,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    shaderCallback: (rect) {
                                                      return const LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.orange,
                                                            Colors.red
                                                          ]).createShader(rect);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 6),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          inset: true,
                                                          blurRadius: 7,
                                                          spreadRadius: -2,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.45))
                                                    ],
                                                    border: index == 0
                                                        ? Border.all(
                                                            width: 1,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                255, 92, 47))
                                                        : const Border(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4),
                                                          child: Text(
                                                            table[index].name,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'UbuntuREG',
                                                                color: const Color(
                                                                    0xFF1E1E1E),
                                                                fontSize:
                                                                    size.height *
                                                                        0.016),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                table[index]
                                                                    .month,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'UbuntuREG',
                                                                    color: const Color(
                                                                        0xFF1E1E1E),
                                                                    fontSize: size
                                                                            .height *
                                                                        0.016),
                                                              ),
                                                              Text(
                                                                table[index]
                                                                    .day,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'UbuntuREG',
                                                                    color: const Color(
                                                                        0xFF1E1E1E),
                                                                    fontSize: size
                                                                            .height *
                                                                        0.016),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            table[index].hours,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'UbuntuREG',
                                                                color: const Color(
                                                                    0xFF1E1E1E),
                                                                fontSize:
                                                                    size.height *
                                                                        0.016),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 4),
                                                          child: Text(
                                                            "limit: " +
                                                                table[index]
                                                                    .date
                                                                    .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'UbuntuREG',
                                                                color: const Color(
                                                                    0xFF1E1E1E),
                                                                fontSize:
                                                                    size.height *
                                                                        0.016),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: table.length,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class tablee {
  var name;
  var month;
  var day;
  var hours;
  var date;

  tablee(this.name, this.month, this.day, this.hours, this.date);
}

class listviews {
  var photo;

  listviews(this.photo);
}

class food {
  late String cal;
  late String name;
  late RichText directions;
  late String ingredients;
  late String nutrition;
  late String pic;

  food(
      {required String name,
      required String ingredients,
      required RichText directions,
      required String nutrition,
      required String pic,
      required String cal}) {
    this.cal = cal;
    this.name = name;
    this.ingredients = ingredients;
    this.directions = directions;
    this.nutrition = nutrition;
    this.pic = pic;
  }
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
