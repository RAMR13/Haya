import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/rendering.dart' as render;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/WorkoutPage/Constants.dart';
import 'package:hayaproject/UserPages/WorkoutPage/TrainingSection.dart';
import 'package:hayaproject/UserPages/WorkoutPage/WorkoutHomePage.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:hayaproject/test.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';

List<Workouts> armBeginnerWorkouts = [
  //9
  Workouts(name: 'Arm raises', subText: 30, typeChar: 'T'),
  Workouts(name: 'Arm circles clockwise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Arm circles counterclockwise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Side arm raise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Triceps dips', subText: 10, typeChar: 'C'),
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Punches', subText: 30, typeChar: 'T'),
  Workouts(name: 'Push ups', subText: 10, typeChar: 'C'),
  Workouts(name: 'Wall push ups', subText: 12, typeChar: 'C'),
];
List<Workouts> armIntermediateWorkouts = [
  //12
  Workouts(name: 'Arm raises', subText: 30, typeChar: 'T'),
  Workouts(name: 'Side arm raise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Triceps dips', subText: 10, typeChar: 'C'),
  Workouts(name: 'Burpees', subText: 10, typeChar: 'C'),
  Workouts(name: 'Floor triceps dips', subText: 12, typeChar: 'C'),
  Workouts(name: 'Arm circles clockwise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Arm circles counterclockwise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Punches', subText: 30, typeChar: 'T'),
  Workouts(name: 'Push ups & rotation', subText: 10, typeChar: 'C'),
  Workouts(name: 'Burpees', subText: 10, typeChar: 'C'),
  Workouts(name: 'Military push ups', subText: 12, typeChar: 'C'),
];
List<Workouts> armAdvancedWorkouts = [
  //16
  Workouts(name: 'Arm raises', subText: 30, typeChar: 'T'),
  Workouts(name: 'Side arm raise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Triceps dips', subText: 12, typeChar: 'C'),
  Workouts(name: 'Burpees', subText: 16, typeChar: 'C'),
  Workouts(name: 'Arm curls crunch left', subText: 14, typeChar: 'C'),
  Workouts(name: 'Arm curls crunch right', subText: 14, typeChar: 'C'),
  Workouts(name: 'Floor triceps dips', subText: 16, typeChar: 'C'),
  Workouts(name: 'Arm circles clockwise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Arm circles counterclockwise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Punches', subText: 30, typeChar: 'T'),
  Workouts(name: 'Push ups & rotation', subText: 12, typeChar: 'C'),
  Workouts(name: 'Burpees', subText: 16, typeChar: 'C'),
  Workouts(name: 'Military push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Arm curls crunch left', subText: 14, typeChar: 'C'),
  Workouts(name: 'Arm curls crunch right', subText: 14, typeChar: 'C'),
];
/////////////////////////////////////////////////////////////////////////

List<Workouts> absBeginnerWorkouts = [
  Workouts(name: 'Jumping jacks', subText: 20, typeChar: 'T'),
  Workouts(name: 'Heel touch', subText: 20, typeChar: 'C'),
  Workouts(name: 'Plank', subText: 20, typeChar: 'T'),
  Workouts(name: 'Abdominal crunches', subText: 16, typeChar: 'C'),
  Workouts(name: 'Leg raises', subText: 16, typeChar: 'C'),
  Workouts(name: 'Mountain climber', subText: 16, typeChar: 'C'),
  Workouts(name: 'Cobra stretch', subText: 30, typeChar: 'T'),
  Workouts(name: 'Russian twist', subText: 20, typeChar: 'C'),
  Workouts(name: 'Plank', subText: 30, typeChar: 'T'),
];
List<Workouts> absIntermediateWorkouts = [
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Heel touch', subText: 26, typeChar: 'C'),
  Workouts(name: 'Crossover crunches', subText: 20, typeChar: 'C'),
  Workouts(name: 'Abdominal crunches', subText: 16, typeChar: 'C'),
  Workouts(name: 'Plank', subText: 20, typeChar: 'T'),
  Workouts(name: 'Leg raises', subText: 16, typeChar: 'C'),
  Workouts(name: 'Heel touch', subText: 26, typeChar: 'C'),
  Workouts(name: 'Push ups & rotation', subText: 20, typeChar: 'C'),
  Workouts(name: 'Mountain climber', subText: 16, typeChar: 'C'),
  Workouts(name: 'Cobra stretch', subText: 30, typeChar: 'T'),
  Workouts(name: 'Abdominal crunches', subText: 20, typeChar: 'C'),
  Workouts(name: 'Russian twist', subText: 20, typeChar: 'C'),
  Workouts(name: 'Plank', subText: 30, typeChar: 'T'),
];
List<Workouts> absAdvancedWorkouts = [
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Set ups', subText: 20, typeChar: 'C'),
  Workouts(name: 'Side bridges left', subText: 20, typeChar: 'C'),
  Workouts(name: 'Side bridges right', subText: 20, typeChar: 'C'),
  Workouts(name: 'Heel touch', subText: 26, typeChar: 'C'),
  Workouts(name: 'Crossover crunches', subText: 20, typeChar: 'C'),
  Workouts(name: 'Abdominal crunches', subText: 16, typeChar: 'C'),
  Workouts(name: 'Plank', subText: 20, typeChar: 'T'),
  Workouts(name: 'Leg raises', subText: 16, typeChar: 'C'),
  Workouts(name: 'Heel touch', subText: 26, typeChar: 'C'),
  Workouts(name: 'Push ups & rotation', subText: 20, typeChar: 'C'),
  Workouts(name: 'Mountain climber', subText: 16, typeChar: 'C'),
  Workouts(name: 'Cobra stretch', subText: 30, typeChar: 'T'),
  Workouts(name: 'Abdominal crunches', subText: 20, typeChar: 'C'),
  Workouts(name: 'Russian twist', subText: 20, typeChar: 'C'),
  Workouts(name: 'Plank', subText: 20, typeChar: 'T'),
];
///////////////////////////////////////////////////////////

List<Workouts> ChestBeginnerWorkouts = [
  //8
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Incline push ups', subText: 16, typeChar: 'C'),
  Workouts(name: 'Burpees', subText: 10, typeChar: 'C'),
  Workouts(name: 'Knee push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Push ups', subText: 10, typeChar: 'C'),
  Workouts(name: 'Wide arm push ups', subText: 16, typeChar: 'C'),
  Workouts(name: 'Cobra stretch', subText: 20, typeChar: 'T'),
  Workouts(name: 'Box push ups', subText: 12, typeChar: 'C'),
];
List<Workouts> ChestIntermediateWorkouts = [
  //11
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Incline push ups', subText: 16, typeChar: 'C'),
  Workouts(name: 'Knee push ups', subText: 12, typeChar: 'C'), //
  Workouts(name: 'Push ups & rotation', subText: 10, typeChar: 'C'),
  Workouts(name: 'Shoulder stretch', subText: 30, typeChar: 'T'),
  Workouts(name: 'Incline push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Staggered push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Wide arm push ups', subText: 16, typeChar: 'C'),
  Workouts(name: 'Cobra stretch', subText: 20, typeChar: 'T'),
  Workouts(name: 'Box push ups', subText: 12, typeChar: 'C'),
];
List<Workouts> ChestAdvancedWorkouts = [
  //14
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Incline push ups', subText: 16, typeChar: 'C'),
  Workouts(name: 'Knee push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Burpees', subText: 10, typeChar: 'C'),
  Workouts(name: 'Shoulder stretch', subText: 30, typeChar: 'T'),
  Workouts(name: 'Push ups & rotation', subText: 12, typeChar: 'C'),
  Workouts(name: 'Incline push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Staggered push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Wide arm push ups', subText: 16, typeChar: 'C'),
  Workouts(name: 'Burpees', subText: 10, typeChar: 'C'),
  Workouts(name: 'Shoulder stretch', subText: 30, typeChar: 'T'),
  Workouts(name: 'Cobra stretch', subText: 20, typeChar: 'T'),
  Workouts(name: 'Box push ups', subText: 12, typeChar: 'C'),
];
///////////////////////////////////////////////////////////

///////////////////////////////////////////////
List<Workouts> LegBeginnerWorkouts = [
  //9
  Workouts(name: 'Side hop', subText: 30, typeChar: 'T'),
  Workouts(name: 'Squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Backward lunge', subText: 14, typeChar: 'C'),
  Workouts(name: 'Backward lunge', subText: 14, typeChar: 'C'),
  Workouts(name: 'Side-lying leg lift left', subText: 12, typeChar: 'C'),
  Workouts(name: 'Side-lying leg lift right', subText: 12, typeChar: 'C'),
  Workouts(name: 'Calf stretch left', subText: 30, typeChar: 'T'),
  Workouts(name: 'Calf stretch right', subText: 30, typeChar: 'T'),
];
List<Workouts> LegIntermediateWorkouts = [
  //12
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Side hop', subText: 30, typeChar: 'T'),
  Workouts(name: 'Wall set', subText: 30, typeChar: 'T'),
  Workouts(name: 'Backward lunge', subText: 14, typeChar: 'C'),
  Workouts(name: 'Backward lunge', subText: 14, typeChar: 'C'),
  Workouts(name: 'Sumo squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Sumo squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Side-lying leg lift left', subText: 12, typeChar: 'C'),
  Workouts(name: 'Side-lying leg lift right', subText: 12, typeChar: 'C'),
  Workouts(name: 'Calf stretch left', subText: 30, typeChar: 'T'),
  Workouts(name: 'Calf stretch right', subText: 30, typeChar: 'T'),
];
List<Workouts> LegAdvancedWorkouts = [
  //16
  Workouts(name: 'Burpees', subText: 10, typeChar: 'C'),
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Squats', subText: 14, typeChar: 'C'),
  Workouts(name: 'Squats', subText: 14, typeChar: 'C'),
  Workouts(name: 'Squats', subText: 14, typeChar: 'C'),
  Workouts(name: 'Side hop', subText: 30, typeChar: 'T'),
  Workouts(name: 'Wall set', subText: 30, typeChar: 'T'),
  Workouts(name: 'Backward lunge', subText: 16, typeChar: 'C'),
  Workouts(name: 'Backward lunge', subText: 16, typeChar: 'C'),
  Workouts(name: 'Sumo squats', subText: 14, typeChar: 'C'),
  Workouts(name: 'Glute kick back right', subText: 12, typeChar: 'C'),
  Workouts(name: 'Glute kick back left', subText: 12, typeChar: 'C'),
  Workouts(name: 'Sumo squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Sumo squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Side-lying leg lift left', subText: 12, typeChar: 'C'),
  Workouts(name: 'Side-lying leg lift right', subText: 12, typeChar: 'C'),
  Workouts(name: 'Calf stretch left', subText: 30, typeChar: 'T'),
  Workouts(name: 'Calf stretch right', subText: 30, typeChar: 'T'),
];
///////////////////////////////////////////////////////////
List<Workouts> All = [
  Workouts(name: 'Arm raises', subText: 30, typeChar: 'T'),
  Workouts(name: 'Arm circles clockwise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Arm circles counterclockwise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Side arm raise', subText: 30, typeChar: 'T'),
  Workouts(name: 'Triceps dips', subText: 10, typeChar: 'C'),
  Workouts(name: 'Jumping jacks', subText: 30, typeChar: 'T'),
  Workouts(name: 'Punches', subText: 30, typeChar: 'T'),
  Workouts(name: 'Push ups', subText: 10, typeChar: 'C'),
  Workouts(name: 'Wall push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Burpees', subText: 16, typeChar: 'C'),
  Workouts(name: 'Arm curls crunch left', subText: 14, typeChar: 'C'),
  Workouts(name: 'Arm curls crunch right', subText: 14, typeChar: 'C'),
  Workouts(name: 'Floor triceps dips', subText: 16, typeChar: 'C'),
  Workouts(name: 'Push ups & rotation', subText: 12, typeChar: 'C'),
  Workouts(name: 'Military push ups', subText: 12, typeChar: 'C'),
  //DONE
  Workouts(name: 'Heel touch', subText: 20, typeChar: 'C'),
  Workouts(name: 'Plank', subText: 20, typeChar: 'T'),
  Workouts(name: 'Abdominal crunches', subText: 16, typeChar: 'C'),
  Workouts(name: 'Leg raises', subText: 16, typeChar: 'C'),
  Workouts(name: 'Mountain climber', subText: 16, typeChar: 'C'),
  Workouts(name: 'Cobra stretch', subText: 30, typeChar: 'T'),
  Workouts(name: 'Russian twist', subText: 20, typeChar: 'C'),
  Workouts(name: 'Crossover crunches', subText: 20, typeChar: 'C'),
  Workouts(name: 'Set ups', subText: 20, typeChar: 'C'),
  Workouts(name: 'Side bridges left', subText: 20, typeChar: 'C'),
  Workouts(name: 'Side bridges right', subText: 20, typeChar: 'C'),
  //
  Workouts(name: 'Incline push ups', subText: 16, typeChar: 'C'),
  Workouts(name: 'Knee push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Wide arm push ups', subText: 16, typeChar: 'C'),
  Workouts(name: 'Box push ups', subText: 12, typeChar: 'C'),
  Workouts(name: 'Shoulder stretch', subText: 30, typeChar: 'T'),
  Workouts(name: 'Staggered push ups', subText: 12, typeChar: 'C'),
//
  Workouts(name: 'Side hop', subText: 30, typeChar: 'T'),
  Workouts(name: 'Squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Backward lunge', subText: 14, typeChar: 'C'),
  Workouts(name: 'Side-lying leg lift left', subText: 12, typeChar: 'C'),
  Workouts(name: 'Side-lying leg lift right', subText: 12, typeChar: 'C'),
  Workouts(name: 'Calf stretch left', subText: 30, typeChar: 'T'),
  Workouts(name: 'Calf stretch right', subText: 30, typeChar: 'T'),
  Workouts(name: 'Sumo squats', subText: 12, typeChar: 'C'),
  Workouts(name: 'Wall set', subText: 30, typeChar: 'T'),
  Workouts(name: 'Glute kick back right', subText: 12, typeChar: 'C'),
  Workouts(name: 'Glute kick back left', subText: 12, typeChar: 'C'),
];
///////////////////////////////////
Exercises armBeginner = Exercises(
    title: 'Arm beginner', duration: 10, workouts: armBeginnerWorkouts);

Exercises armIntermediate = Exercises(
    title: 'Arm intermediate', duration: 16, workouts: armIntermediateWorkouts);
Exercises armAdvanced = Exercises(
    title: 'Arm advanced', duration: 22, workouts: armAdvancedWorkouts);
//////Done///////
Exercises AbsBeginner = Exercises(
    title: 'Abs beginner', duration: 12, workouts: absBeginnerWorkouts);
Exercises AbsIntermediate = Exercises(
    title: 'Abs intermediate', duration: 17, workouts: absIntermediateWorkouts);
Exercises AbsAdvanced = Exercises(
    title: 'Abs advanced', duration: 21, workouts: absAdvancedWorkouts);
//////Done//////
Exercises ChestBeginner = Exercises(
    title: 'Chest beginner', duration: 10, workouts: ChestBeginnerWorkouts);
Exercises ChestIntermediate = Exercises(
    title: 'Chest intermediate',
    duration: 14,
    workouts: ChestIntermediateWorkouts);
Exercises ChestAdvanced = Exercises(
    title: 'Chest advanced', duration: 18, workouts: ChestAdvancedWorkouts);
////////////
Exercises LegBeginner = Exercises(
    title: 'Leg beginner', duration: 14, workouts: LegBeginnerWorkouts);
Exercises LegIntermediate = Exercises(
    title: 'Leg intermediate', duration: 19, workouts: LegIntermediateWorkouts);
Exercises LegAdvanced = Exercises(
    title: 'Leg advanced', duration: 26, workouts: LegAdvancedWorkouts);
///////////
Exercises AllExercises = Exercises(title: 'All', duration: 14, workouts: All);
Exercises customBeginner = Exercises(
    title: 'Custom beginner', duration: 10, workouts: armBeginnerWorkouts);

class Exercises {
  late String title;
  late int duration;
  late List<Workouts> workouts;
  Exercises(
      {required String title,
      required int duration,
      required List<Workouts> workouts}) {
    this.workouts = workouts;
    this.duration = duration;
    this.title = title;
  }
}

class Workouts {
  late String name;
  late int subText;
  late String typeChar; //T or C
  late String image;
  late String imagetype;
  Workouts(
      {required String name,
      required int subText,
      required String typeChar,
      String image = '',
      String imagetype = ''}) {
    this.name = name;
    this.subText = subText;
    this.typeChar = typeChar;
    this.image = image;
    this.imagetype = imagetype;
  } //T(timer) or C (Count)
}

class ExerciseBody extends StatefulWidget {
  String Name;
  var Indexoftraining;

  ExerciseBody(this.Name, this.Indexoftraining);

  @override
  State<ExerciseBody> createState() => _ExerciseBodyState();
}

////////////

Widget gauges() {
  return Container(
    child: gauge(30),
    width: 35,
    height: 35,
  );
}

bool isBig = false;

class _ExerciseBodyState extends State<ExerciseBody> {
  Exercises ReturnPointer() {
    setState(() {});
    if (widget.Name == "Beginner") {
      if (widget.Indexoftraining == 0)
        return armBeginner;
      else if (widget.Indexoftraining == 1)
        return ChestBeginner;
      else if (widget.Indexoftraining == 2)
        return AbsBeginner;
      else if (widget.Indexoftraining == 3) return LegBeginner;
    } else if (widget.Name == "Intermediate") {
      if (widget.Indexoftraining == 0)
        return armIntermediate;
      else if (widget.Indexoftraining == 1)
        return ChestIntermediate;
      else if (widget.Indexoftraining == 2)
        return AbsIntermediate;
      else if (widget.Indexoftraining == 3) return LegIntermediate;
    } else if (widget.Name == "advance") {
      if (widget.Indexoftraining == 0)
        return armAdvanced;
      else if (widget.Indexoftraining == 1)
        return ChestAdvanced;
      else if (widget.Indexoftraining == 2)
        return AbsAdvanced;
      else if (widget.Indexoftraining == 3) return LegAdvanced;
    }

    return AbsAdvanced;
  }

  bool showNotif = false;
  bool shouldPop = true;
  List<CompletedIndex> IsCompleted = [];
  late Exercises pointer;
  int prefInt = -1;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        widget1Opacity = 1;
      });
    });
    pointer = ReturnPointer();
    upperpadding = 0;
    textOpacity = 0;
    arrowColor = const Color(0xFFFFFFFFF);
    elevation = 0;
    tranc = 0;

    isBig = false;
    IsCompleted = List<CompletedIndex>.generate(
        pointer.workouts.length, (i) => CompletedIndex(-1, false));
    super.initState();
  }

  double upperpadding = 0;
  double padding = 15;
  int tranc = 0;
  double elevation = 0;
  Color arrowColor = Colors.white;
  double textOpacity = 0;
  double widget1Opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => MainScreenUser("WHomePage"),
            ),
          );
        return shouldPop;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFF9F9F9),
        ////////////////////Appbar////////////////////////////////
        appBar: AppBar(
          backgroundColor: Color.fromARGB(tranc, 255, 255, 255),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedOpacity(
                opacity: widget1Opacity,
                duration: Duration(milliseconds: 200),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                MainScreenUser("WHomePage"),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: arrowColor,
                        size: size.height * 0.038, //size.width * 0.08,
                      ),
                    )),
              ),
              tranc == 255
                  ? Text(
                      '${pointer.title}',
                      style: TextStyle(
                          fontSize: size.height * 0.03, //26,
                          fontFamily: 'UbuntuBOLD',
                          color: const Color(0xFF2C2C2C)),
                    )
                  : Container(),
              tranc == 255
                  ? Expanded(
                      child: SizedBox(
                        width: size.width * 0.21, //size.height * 0.1,
                      ),
                    )
                  : Container(),
              tranc == 0
                  ? AnimatedOpacity(
                      opacity: widget1Opacity,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: Text(
                            'Browse other workouts',
                            style: TextStyle(
                                color: const Color(0xFF2C2C2C),
                                fontSize: size.height * 0.017 //16
                                ),
                            textAlign: TextAlign.center,
                          )),
                    )
                  : SizedBox(width: size.width * 0.088, child: gauges()),
            ],
          ),
          elevation: elevation,
        ),
        ////////////////////Appbar////////////////////////////////
        ////////////////////Top Image////////////////////////////////
        body: Stack(alignment: Alignment.topCenter, children: [
          Container(
            clipBehavior: Clip.antiAlias,
            child: Hero(
              tag: '${pointer.title} f',
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Image.asset(
                    fit: BoxFit.cover,
                    'asset/Images/Workout cover/${pointer.title}.png',
                  ),
                  AnimatedOpacity(
                    opacity: widget1Opacity,
                    duration: Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            color:
                                const render.Color.fromRGBO(249, 249, 249, 1),
                            child: Material(
                              child: Text(
                                '${pointer.workouts.length} WORKOUTS',
                                style: TextStyle(
                                    fontFamily: 'ITC Avant',
                                    fontSize: size.height * 0.024,
                                    color: Colors.black,
                                    overflow: TextOverflow.clip),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                color: const Color(0xFFF9F9F9),
                                child: Material(
                                  child: Text(
                                    '${pointer.duration} MINS',
                                    style: TextStyle(
                                        fontFamily: 'ITC Avant',
                                        fontSize: size.height * 0.024, //21,
                                        color: Colors.black),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            height: size.height * 0.45,
            width: size.width,
            //380,
            // height: size.width * 0.95,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 6,
                      color: render.Color.fromARGB(111, 0, 0, 0))
                ]),
          ),

          AnimatedOpacity(
            opacity: widget1Opacity,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isBig == true ? size.width : size.width * 0.92, //380,
                  height: isBig == true
                      ? size.height * 0.957
                      : size.height * 0.69, //600,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: render.Color.fromARGB(183, 235, 235, 235),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10))),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isBig == true ? 0 : 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 12, 0, 20),
                                    child: Hero(
                                      tag: '${pointer.title}first',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          '${pointer.title}',
                                          style: TextStyle(
                                              fontSize: size.height * 0.03,
                                              fontFamily: 'UbuntuBOLD'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                    child: SizedBox(
                                        width: size.width * 0.088,
                                        child: gauges()),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: ScrollConfiguration(
                                  behavior: const ScrollBehavior(),
                                  child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    showLeading: false,
                                    showTrailing: false,
                                    color: Colors.transparent,
                                    child: NotificationListener<
                                        UserScrollNotification>(
                                      onNotification: (notification) {
                                        final render.ScrollDirection direction =
                                            notification.direction;
                                        if (direction ==
                                            render.ScrollDirection.reverse) {
                                          setState(() {
                                            upperpadding = 42;
                                            textOpacity = 1;
                                            arrowColor =
                                                const Color(0xFF2C2C2C);
                                            elevation = 3;
                                            tranc = 255;
                                            isBig = true;
                                          });
                                        }
                                        if (direction ==
                                                render
                                                    .ScrollDirection.forward &&
                                            notification.metrics.pixels == 0) {
                                          setState(() {
                                            upperpadding = 0;
                                            textOpacity = 0;
                                            arrowColor =
                                                const Color(0xFFFFFFFFF);
                                            elevation = 0;
                                            tranc = 0;

                                            isBig = false;
                                          });
                                        }
                                        return true;
                                      },
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        itemCount: pointer.workouts.length +
                                            1, //variable
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index ==
                                              pointer.workouts.length) {
                                            return Container(
                                              height: size.height * 0.09,
                                            );
                                          } else {
                                            return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 6),
                                                child: Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                          boxShadow: [
                                                        BoxShadow(
                                                            color: render.Color
                                                                .fromARGB(64, 0,
                                                                    0, 0),
                                                            blurRadius: 3,
                                                            offset:
                                                                Offset(0, 2))
                                                      ],
                                                          color: render
                                                                  .Color
                                                              .fromARGB(
                                                                  247,
                                                                  250,
                                                                  250,
                                                                  250),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          7))),
                                                  height:
                                                      size.height * 0.112, //95,

                                                  child: Container(
                                                      child: Row(children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          0, 0, 10, 0),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7),
                                                        child: Image.asset(
                                                            'asset/Images/Gif/${pointer.workouts[index].name}.gif'),
                                                      ),
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
                                                                0.5,
                                                            child: Text(
                                                                pointer
                                                                    .workouts[
                                                                        index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    color: const Color(
                                                                        0xFF2C2C2C),
                                                                    fontSize: size
                                                                            .height *
                                                                        0.02 //20

                                                                    )),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 0, 15),
                                                          child: Text(
                                                            pointer
                                                                        .workouts[
                                                                            index]
                                                                        .typeChar ==
                                                                    'C'
                                                                ? 'x${pointer.workouts[index].subText}'
                                                                : pointer.workouts[index]
                                                                            .subText
                                                                            .toInt() >
                                                                        10
                                                                    ? '00:${pointer.workouts[index].subText}'
                                                                    : '0${pointer.workouts[index].subText}:00',
                                                            style: TextStyle(
                                                                fontSize: size
                                                                        .height *
                                                                    0.017, //2
                                                                color: const render
                                                                    .Color.fromARGB(
                                                                    255,
                                                                    95,
                                                                    95,
                                                                    95)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ])),
                                                ));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: size.height * 0.095,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: showNotif ? 1 : 0,
                duration: Duration(milliseconds: 120),
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: size.height * 0.035,
                          color: Colors.white,
                        ),
                        Text(
                          'Workout pinned to home successfully',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.018),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 250, 84, 72),
                          Colors.orange
                        ]),
                        borderRadius: BorderRadius.all(Radius.circular(200))),
                    width: size.width * 0.85,
                    height: size.height * 0.05,
                  ),
                ),
              ),
            ),
          ),
          //////////////////////////////////NEXT////////////////////////////////
          AnimatedOpacity(
            opacity: widget1Opacity,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                width: size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Container(
                        width: size.width * 0.7,
                        height: size.height * 0.059,
                        margin: const EdgeInsets.only(top: 60, bottom: 20),
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(350),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (!mounted) return;
                            setState(() {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Training(
                                        widget.Name,
                                        widget.Indexoftraining,
                                        0,
                                        0,
                                        IsCompleted!,
                                      ),
                                      type: PageTransitionType
                                          .rightToLeftWithFade));
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(350))),
                            margin: const EdgeInsets.all(5),
                            child: ShaderMask(
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Start',
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
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: GestureDetector(
                        onTap: () async {
                          if (pointer.title == 'Arm beginner') prefInt = 1;
                          if (pointer.title == 'Chest beginner') prefInt = 2;
                          if (pointer.title == 'Abs beginner') prefInt = 3;
                          if (pointer.title == 'Leg beginner') prefInt = 4;
                          if (pointer.title == 'Arm intermediate') prefInt = 5;
                          if (pointer.title == 'Chest intermediate')
                            prefInt = 6;
                          if (pointer.title == 'Abs intermediate') prefInt = 7;
                          if (pointer.title == 'Leg intermediate') prefInt = 8;
                          if (pointer.title == 'Arm advanced') prefInt = 9;
                          if (pointer.title == 'Chest advanced') prefInt = 10;
                          if (pointer.title == 'Abs advanced') prefInt = 11;
                          if (pointer.title == 'Leg advanced') prefInt = 12;
                          await Prefs.savePrefInt('workout index', prefInt);
                          await Prefs.savePrefInt('workout done', 0);
                          if (!mounted) return;
                          setState(() {
                            showNotif = true;
                          });
                          Timer timer = Timer(Duration(seconds: 3), () {
                            if (!mounted) return;
                            setState(() {
                              showNotif = false;
                            });
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 60, bottom: 20),
                          width: size.height * 0.059,
                          height: size.height * 0.059,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFFFF5F6D),
                                Color(0xFFFFC371)
                              ]),
                              color: Color.fromARGB(255, 255, 253, 253),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: Offset(0, 6))
                              ]),
                          child: Transform.rotate(
                            angle: 0.5,
                            child: Icon(
                              Icons.push_pin,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: Offset(2, 3.5))
                              ],
                              size: size.height * 0.03,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class CompletedIndex {
  int index;
  bool completed;
  CompletedIndex(this.index, this.completed);
}
