import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:page_transition/page_transition.dart';

class CustomFood extends StatefulWidget {
  const CustomFood({super.key});

  @override
  State<CustomFood> createState() => _MyEventsState();
}

class _MyEventsState extends State<CustomFood> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF2C2C2C),
                    size: height * 0.036,
                  ),
                ),
                Text(
                  "Food items",
                  style: TextStyle(
                      fontSize: height * 0.028,
                      color: Color(0xFF2C2C2C),
                      fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: height * 0.036,
                    )),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(height * 0.07),
              child: TabBar(
                  indicatorColor: Color.fromARGB(255, 238, 85, 39),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Color.fromARGB(255, 238, 85, 39),
                  unselectedLabelColor: Color.fromARGB(255, 204, 204, 204),
                  tabs: [
                    Tab(
                      text: "Breakfast",
                      icon: Icon(Icons.free_breakfast),
                    ),
                    Tab(
                      text: "Lunch",
                      icon: Icon(Icons.lunch_dining),
                    ),
                    Tab(
                      text: "Dinner",
                      icon: Icon(Icons.kebab_dining_rounded),
                    ),
                  ]),
            ),
            elevation: 2,
          ),
          body: TabBarView(children: [
            CreateEvent('breakfast'),
            CreateEvent('lunch'),
            CreateEvent('dinner')
          ]),
        ));
  }
}

class CreateEvent extends StatefulWidget {
  late String type;
  CreateEvent(this.type);
  @override
  State<CreateEvent> createState() => _CreateEventState(type);
}

class _CreateEventState extends State<CreateEvent> {
  late String type;
  _CreateEventState(this.type);
  late Query<Map<String, dynamic>> qs = FirebaseFirestore.instance
      .collection("foodplan")
      .where('type', isEqualTo: '$type');

  List<food2> customList = [];
  bool speed2 = false;
  // List<DocumentSnapshot> allfood = [];
  late List<food2> allWorkoutsLocal = [];

  getData() async {
    // allfood = [];
    QuerySnapshot qss = await FirebaseFirestore.instance
        .collection("foodplan")
        .where('type', isEqualTo: '$type')
        .get();
    // await FirebaseFirestore.instance.collection("foodplan").get();

    // allfood.addAll(qss.docs);

    // await wklocalget();
    if (mounted) {
      setState(() {
        //  colorr();
      });
    }
  }

  // colorr() {
  //   for (int i = 0; i < allfood.length; i++) {
  //     iscolor.add(wk(isclick: false));
  //   }
  // }

  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    Loading();

    super.initState();
  }

  String search = '';
  bool Isvisible = false;
  deleteItem(List newlist) async {
    for (int i = 0; i < newlist.length; i++) {
      await FirebaseFirestore.instance
          .collection('foodplan')
          .doc(newlist[i].id)
          .delete();
    }
    customList = [];
    await getData();

    // await wklocalget();
  }

  // wklocalget() {
  //   allWorkoutsLocal = [];
  //   for (int i = 0; i < allfood.length; i++) {
  //     allWorkoutsLocal.add(food2(
  //         name: allfood[i]['name'],
  //         cal: allfood[i]['cal'],
  //         type: allfood[i]['type'],
  //         id: allfood[i].id));
  //   }
  // }

  double Speedopacity = 1;
  @override
  Widget build(BuildContext context) {
    String workoutName;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: Speedopacity,
        child: SpeedDial(
          overlayOpacity: 0,
          overlayColor: Colors.black,
          backgroundColor: Color(0xFFFFAA5C),
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
                Color(0xFFFFAA5C).withOpacity(0.25),
                Color.fromARGB(255, 255, 114, 89).withOpacity(0.5),
                Color.fromARGB(255, 255, 60, 0).withOpacity(0.6),
              ]),
          children: [
            SpeedDialChild(
                onTap: () {
                  if (!mounted) return;
                  setState(() {
                    Isvisible = !Isvisible;
                    customList = [];
                    // iscolor.forEach((element) {
                    //   element.isclick = false;
                    //   Speedopacity = Isvisible ? 0.4 : 1;
                    // });
                  });
                },
                child: Icon(
                  Icons.remove,
                  color: Colors.black87,
                ),
                backgroundColor: Color.fromARGB(255, 255, 255, 255)),
            SpeedDialChild(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: AddFood(),
                          type: PageTransitionType.rightToLeftWithFade));
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black87,
                ),
                backgroundColor: Color.fromARGB(255, 252, 252, 252)),
          ],
        ),
      ),
      body: isloading == true
          ? test1(height, width)
          : Stack(
              children: [
                StreamBuilder(
                    stream: qs.snapshots(),
                    builder: (context, snapshot) {
                      /*  if (i == 0) {
                      wklocalget();
                      i++;
                    }*/

                      print(customList.isEmpty
                          ? 'sssssssss'
                          : customList.map((e) => e.name));

                      if (snapshot.hasData) {
                        return Stack(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.all(0),
                              itemCount: snapshot.data?.docs.length,
                              //snapshot.data?.docs.length, //allWorkouts.length, //variable
                              itemBuilder: (BuildContext context, int index) {
                                if (index == snapshot.data?.docs.length)
                                  return Container(
                                    height: height * 0.09,
                                  );
                                else
                                  workoutName = snapshot
                                      .data!.docs[index]['name']
                                      .toString()
                                      .toLowerCase(); //allWorkoutsLocal[index]
                                //      .name
                                //    .toLowerCase();
                                return workoutName
                                        .contains(search.toLowerCase())
                                    ? GestureDetector(
                                        onTap: () {
                                          if (!mounted) return;
                                          setState(() {
                                            // iscolor[index].isclick =
                                            //     !iscolor[index].isclick!;
                                            food2 elements = food2(
                                                name: '',
                                                cal: '',
                                                type: '',
                                                id: '');

                                            if (customList.any(((element) {
                                              elements = element;
                                              return element.name ==
                                                  snapshot.data?.docs[index]
                                                      ['name'];
                                            })))
                                              customList.remove(elements);
                                            else
                                              customList.add(food2(
                                                  cal: snapshot
                                                      .data!.docs[index]['cal'],
                                                  name: snapshot.data!
                                                      .docs[index]['name'],
                                                  type: snapshot.data!
                                                      .docs[index]['type'],
                                                  id: snapshot
                                                      .data!.docs[index].id));
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, index == 0 ? 10 : 5, 15, 5),
                                            child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
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
                                                          Radius.circular(7))),
                                              height: height * 0.112, //95,

                                              child: Container(
                                                  child: Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                                  child: Container(
                                                    width: width * 0.02,
                                                    padding: EdgeInsets.all(7),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 5, 0, 0),
                                                      child: Container(
                                                        width: width *
                                                            0.7, // size.width * 0.5,
                                                        child: Text(
                                                            "${snapshot.data!.docs[index]['name']}",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF2C2C2C),
                                                                fontSize: height *
                                                                    0.023 //20
                                                                )),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 15),
                                                      child: Text(
                                                        ' ${snapshot.data!.docs[index]['cal']} cal',
                                                        style: TextStyle(
                                                            fontSize: height *
                                                                0.017, //2
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    95,
                                                                    95,
                                                                    95)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: Isvisible,
                                                  child: Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 20, 0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child:
                                                            AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  150),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: customList.any(((element) =>
                                                                            element.name ==
                                                                            snapshot.data?.docs[index][
                                                                                'name'])) ==
                                                                        true
                                                                    ? Colors
                                                                        .transparent
                                                                    : Color(
                                                                        0xFF686868)),
                                                            boxShadow: [],
                                                            shape:
                                                                BoxShape.circle,
                                                            color: customList.any(((element) =>
                                                                    element
                                                                        .name ==
                                                                    snapshot.data
                                                                            ?.docs[index]
                                                                        [
                                                                        'name']))
                                                                ? Color(
                                                                    0xFF53DB81)
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                          width: width * 0.062,
                                                          //25,
                                                          height:
                                                              height * 0.062,
                                                          child: Visibility(
                                                            visible: customList
                                                                .any(((element) =>
                                                                    element
                                                                        .name ==
                                                                    snapshot.data
                                                                            ?.docs[index]
                                                                        [
                                                                        'name'])),
                                                            // iscolor[
                                                            //             index]
                                                            //         .isclick ==
                                                            //     true,
                                                            child: Icon(
                                                              Icons
                                                                  .check_rounded,
                                                              color:
                                                                  Colors.white,
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
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        Future.delayed(Duration(microseconds: 2), () {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("error"),
                              );
                            },
                          );
                        });
                      }

                      return Container();
                    }),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 150),
                  opacity: Isvisible ? 1 : 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(500)),
                        elevation: 4,
                        child: GestureDetector(
                          onTap: () async {
                            if (customList.length != 0)
                              await deleteItem(customList);

                            if (!mounted) return;
                            setState(() {});
                          },
                          child: Container(
                            child: Center(
                              child: Icon(
                                Icons.delete,
                                size: height * 0.035,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class food {
  late String name;
  late String type;
  late String cal;
  late String id;
  food({required String cal, required String name, required String type}) {
    this.name = name;
    this.type = type;
    this.cal = cal;
    this.id = id;
  }
}

class food2 {
  late String name;
  late String type;
  late String cal;
  late String id;
  food2(
      {required String cal,
      required String name,
      required String type,
      required String id}) {
    this.name = name;
    this.type = type;
    this.cal = cal;
    this.id = id;
  }
}

class wk {
  bool isclick;
  wk({required this.isclick});
}

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

///////////////////////////////////////////////////////////
class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddFood> {
  bool Errorname = false;
  bool ErrorCalories = false;
  bool ErrorFoodtypes = false;
  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isloading = false;
    });
  }

  TextEditingController FoodNameTextEditingController = TextEditingController();
  TextEditingController CaloriesTextEditingController = TextEditingController();
  bool IsClickFoodType = false;

  bool showErrorcal = false;
  final List<String> FoodTypeItems = ['Breakfast', 'Lunch', 'Dinner'];
  String selectedValueofFoodtypes = '';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  Icons.arrow_back_ios,
                  color: Color(0xFF2C2C2C),
                  size: height * 0.036, //size.width * 0.08,
                ),
              ),
            ),
            Container(
              width: width - height * 0.038 * 3,
              child: Center(
                child: Text(
                  'Add a food item',
                  style: TextStyle(
                    fontSize: height * 0.025,
                    color: Color(0xFF2C2C2C),
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
              height: height * 0.03,
            ),
            Container(
              width: width * 0.86,
              height: height * 0.85,
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: TextField(
                          onChanged: (value) {
                            Errorname = false;
                            setState(() {});
                            if (FoodNameTextEditingController.text.length ==
                                    0 ||
                                FoodNameTextEditingController.text.length >=
                                    20) {
                              Errorname = true;
                            }
                          },
                          style: TextStyle(
                              color: Color(0xFF2C2C2C),
                              fontSize: height * 0.02),
                          cursorHeight: height * 0.024,
                          cursorColor: Color(0xFF2C2C2C),
                          controller: FoodNameTextEditingController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 22, horizontal: 12),
                            label: Text(
                              "Food name",
                              style: TextStyle(
                                  color: Color(0xFF2c2c2c),
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
                                  Radius.circular(7.0)), // Sets border radius
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(7.0)), // Sets border radius
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: Errorname,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 3, top: 2),
                                child: Container(
                                  width: width * 0.8,
                                  child: Text(
                                    FoodNameTextEditingController.text.length ==
                                            0
                                        ? "Name can't be empty"
                                        : FoodNameTextEditingController
                                                    .text.length >=
                                                20
                                            ? 'Food name must be less than 20 characters'
                                            : '',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 216, 56, 44)),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                ErrorCalories = false;
                              });

                              if (CaloriesTextEditingController.text.length >
                                  4) {
                                ErrorCalories = true;
                              }
                              if (CaloriesTextEditingController.text.isEmpty) {
                                ErrorCalories = true;
                              }
                              if (int.tryParse(
                                      CaloriesTextEditingController.text) ==
                                  null) {
                                ErrorCalories = true;
                              }
                            },
                            style: TextStyle(
                                color: Color(0xFF2C2C2C),
                                fontSize: height * 0.02),
                            cursorHeight: height * 0.024,
                            cursorColor: Color(0xFF2C2C2C),
                            controller: CaloriesTextEditingController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 22, horizontal: 12),
                              label: Text(
                                "Calories",
                                style: TextStyle(
                                    color: Color(0xFF2c2c2c),
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
                                    Radius.circular(7.0)), // Sets border radius
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(7.0)), // Sets border radius
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: ErrorCalories,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 3, top: 2),
                                child: Container(
                                  width: width * 0.8,
                                  child: Text(
                                    int.tryParse(CaloriesTextEditingController
                                                .text) ==
                                            null
                                        ? 'Calories must be a number'
                                        : CaloriesTextEditingController
                                                    .text.length >
                                                4
                                            ? 'Calories must be 4 digits maximum'
                                            : CaloriesTextEditingController
                                                        .text.length ==
                                                    0
                                                ? "Calories can't be empty"
                                                : '',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 216, 56, 44)),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: height * 0.02),
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
                                  'Food type',
                                  style: TextStyle(
                                      fontSize: height * 0.02,
                                      fontFamily: 'UbuntuREG',
                                      color: Color(0xFF2c2c2c)),
                                ),
                                style: TextStyle(
                                    fontSize: height * 0.02,
                                    fontFamily: 'UbuntuREG',
                                    color: Color(0xFF2c2c2c)),
                                items: FoodTypeItems.map(
                                    (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                              fontSize: height * 0.02,
                                            ),
                                          ),
                                        )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    ErrorFoodtypes = false;
                                  });

                                  selectedValueofFoodtypes = value.toString();
                                  if (selectedValueofFoodtypes == '') {
                                    ErrorFoodtypes = true;
                                  }
                                },
                                onSaved: (value) {
                                  selectedValueofFoodtypes = value.toString();
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: IconStyleData(
                                    icon: IsClickFoodType == false
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
                                      BoxShadow(
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
                        ],
                      ),
                      Visibility(
                          visible: ErrorFoodtypes,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 3, top: 2),
                                child: Container(
                                  width: width * 0.8,
                                  child: const Text(
                                    "Choose a type",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 216, 56, 44)),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Container(
                      height: height * 0.06,
                      width: width * 0.86,
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
                          borderRadius: BorderRadius.all(Radius.circular(350))),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            Errorname = false;
                            ErrorFoodtypes = false;
                            ErrorCalories = false;
                          });
                          if (FoodNameTextEditingController.text.length == 0) {
                            Errorname = true;
                          }

                          if (CaloriesTextEditingController.text.length > 4) {
                            ErrorCalories = true;
                          }
                          if (CaloriesTextEditingController.text.isEmpty) {
                            ErrorCalories = true;
                          }
                          if (int.tryParse(
                                  CaloriesTextEditingController.text) ==
                              null) {
                            ErrorCalories = true;
                          }
                          //   if (selectedValueofExercisetypes == '') {
                          //  ErrorExercisetypes = true;
                          // }
                          if (FoodNameTextEditingController.text.length == 0 ||
                              FoodNameTextEditingController.text.length >= 20) {
                            Errorname = true;
                          }
                          if (selectedValueofFoodtypes == '') {
                            ErrorFoodtypes = true;
                          }
                          if (ErrorCalories == false &&
                              Errorname == false &&
                              ErrorFoodtypes == false) {
                            DocumentReference Food = await FirebaseFirestore
                                .instance
                                .collection("foodplan")
                                .add({
                              "name": FoodNameTextEditingController.text,
                              "cal": CaloriesTextEditingController.text,
                              "type": selectedValueofFoodtypes.toLowerCase(),
                            });

                            Navigator.pop(
                              context,
                            );
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool x = false;
  bool selectedx = false;
}
