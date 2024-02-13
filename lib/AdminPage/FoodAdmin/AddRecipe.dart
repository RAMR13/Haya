import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../SpecialistPage/MorePage/MorePage.dart';
import '../navigatorbarAdmin/NavigationBar.dart';

class PvAddRecipe extends StatefulWidget {
  const PvAddRecipe({super.key});

  @override
  State<PvAddRecipe> createState() => _PvAddRecipeState();
}

class _PvAddRecipeState extends State<PvAddRecipe> {
  PageController pc = PageController();
  int index = 0;
  bool _isFocused1 = false;
  bool _isFocused = false;

  TextEditingController _textController = TextEditingController();
  TextEditingController _textController3 = TextEditingController();

  TextEditingController _textController2 = TextEditingController();

  List<RecipeTypes> recipeType = [
    RecipeTypes("FoodImages/Breakfast.png", "Breakfast", false),
    RecipeTypes("FoodImages/Lunch.png", "Lunch", false),
    RecipeTypes("FoodImages/Dinner.png", "Dinner", false),
    RecipeTypes("FoodImages/Snacks.png", "Snacks", false),
    RecipeTypes("FoodImages/Dessert.png", "Dessert", false),
    RecipeTypes("FoodImages/Appetizers.png", "Soup & Salad", false)
  ];

  TextEditingController RecipeNameTextEditingController =
      TextEditingController();

  bool IsClickRecipesType = false;
  bool showErrorname = false;
  bool showErrorimage = false;
  bool showErrorbasic = false;
  bool showErrorIngredients = false;
  bool showErrorform = false;
  String? selectedValueofRecipesType;
  String Foodname = "";
  bool nameFood = false;

  bool validatename(String value) {
    if (value.length > 15 || value.length == 0) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    pc = PageController(initialPage: 0);
    super.initState();
  }

  int lock = 0;
  String title = '';
  @override
  Widget build(BuildContext context) {
    setState(() {
      title = file != null ? basename(file!.path) : '';
    });
    if (lock == 0) {
      recipeType[0].isCompleted = true;
      Foodname = recipeType[0].Name;
      lock = 1;
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.pop(
                    context,
                  );
                }
                if (index == 1) {
                  index = 0;
                  pc.animateToPage(index,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic);
                }
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: height * 0.035,
              ),
            ),
            Text(
              "Add recipe",
              style: TextStyle(fontSize: width * 0.05),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.transparent,
                size: height * 0.035,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: height * 0.7,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                index = value;
                if (!mounted) return;
                setState(() {});
              },
              scrollDirection: Axis.horizontal,
              controller: pc,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height * 0.022),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: width * 0.84,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.068,
                                child: TextField(
                                  cursorColor: Color(0xFF2C2C2C),
                                  onChanged: (value) {
                                    if (!mounted) return;
                                    setState(() {
                                      showErrorname = false;
                                    });
                                    if (validatename(
                                        RecipeNameTextEditingController.text)) {
                                      showErrorname = true;
                                    }
                                  },
                                  controller: RecipeNameTextEditingController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    label: Text("Title"),
                                    labelStyle: TextStyle(
                                        color: Color(0xFF2C2C2C),
                                        fontSize: height * 0.019),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 119, 119, 119),
                                          width: 0.9,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 1.0,
                                      ),

                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              7.0)), // Sets border radius
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7))),
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                  duration: Duration(milliseconds: 120),
                                  opacity: showErrorname == false ? 0 : 1,
                                  child: const Text("Title must be provided",
                                      style: TextStyle(color: Colors.red))),
                              Padding(
                                padding: EdgeInsets.only(top: 7),
                                child: InkWell(
                                  onTap: () async {
                                    await pickercamera(ImageSource.gallery);
                                  },
                                  child: Container(
                                    height: height * 0.068,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.9,
                                          color: Color.fromARGB(
                                              255, 119, 119, 119),
                                        ),
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.photo_outlined,
                                                size: height * 0.024,
                                                color: Color(0xFF2C2C2C),
                                              ),
                                              Container(
                                                width: width * 0.65,
                                                child: Text(
                                                  file != null
                                                      ? "${basename(file!.path)}"
                                                      : "Attach image",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: height * 0.019,
                                                      color: Color(0xFF2C2C2C)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: InkWell(
                                              child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: height * 0.02,
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                  duration: Duration(milliseconds: 120),
                                  opacity:
                                      showErrorimage == false || file != null
                                          ? 0
                                          : 1,
                                  child: Text("An image must be added",
                                      style: TextStyle(color: Colors.red))),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            offset: Offset(0, 4),
                                            blurRadius: 8)
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, left: 7),
                                        child: Text(
                                          'Recipe Type',
                                          style: TextStyle(
                                              color: Color(0xFF2C2C2C),
                                              fontSize: height * 0.017,
                                              fontFamily: 'UbuntuREG'),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 7),
                                        child: Container(
                                          height: height * 0.2,
                                          child: ScrollConfiguration(
                                            behavior: MyBehavior(),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: recipeType.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10,
                                                      0,
                                                      index ==
                                                              recipeType
                                                                      .length -
                                                                  1
                                                          ? 10
                                                          : 0,
                                                      7),
                                                  child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 150),
                                                      height: height * 0.15,
                                                      width: width * 0.3,
                                                      decoration: BoxDecoration(
                                                        gradient: recipeType[
                                                                    index]
                                                                .isCompleted
                                                            ? LinearGradient(
                                                                colors: [
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            253,
                                                                            159,
                                                                            17),
                                                                    Colors
                                                                        .orange,
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            247,
                                                                            123,
                                                                            51),
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            245,
                                                                            115,
                                                                            40),
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            241,
                                                                            90,
                                                                            52)
                                                                  ])
                                                            : null,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.25),
                                                              blurRadius: 4,
                                                              offset:
                                                                  Offset(0, 2)),
                                                        ],
                                                        color: recipeType[index]
                                                                .isCompleted
                                                            ? Color.fromARGB(
                                                                255,
                                                                255,
                                                                112,
                                                                112)
                                                            : Color.fromARGB(
                                                                255,
                                                                241,
                                                                241,
                                                                241),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (!mounted) return;
                                                          setState(() {
                                                            switches(index);
                                                            switches2(index);
                                                          });
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(3),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          241,
                                                                          241,
                                                                          241),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(7))),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: <Widget>[
                                                                  Container(
                                                                    height:
                                                                        height *
                                                                            0.11,
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    clipBehavior:
                                                                        Clip.antiAlias,
                                                                    child: Image.asset(
                                                                        recipeType[index]
                                                                            .Images,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                  Text(
                                                                    index ==
                                                                            recipeType.length -
                                                                                1
                                                                        ? 'Appetizers'
                                                                        : recipeType[index]
                                                                            .Name,
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    softWrap:
                                                                        true,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'UbuntuREG',
                                                                      color: Color(
                                                                          0xFF2C2C2C),
                                                                      fontSize:
                                                                          height *
                                                                              0.016,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                );
                                              },
                                            ),
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
                    ],
                  ),
                ),
                //*********************************************************************************
                Padding(
                  padding: EdgeInsets.only(top: height * 0.022),
                  child: Center(
                    child: Container(
                      width: width * 0.84,
                      child: Column(
                        children: [
                          TextField(
                            cursorColor: Color(0xFF2C2C2C),
                            minLines: 1,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            controller: _textController3,
                            textAlign: TextAlign.start,
                            onTap: () {
                              if (!mounted) return;
                              setState(() {});
                            },
                            onChanged: (value) {
                              if (!mounted) return;
                              setState(() {
                                showErrorIngredients = false;
                              });
                              if (validateDescingredients(
                                  _textController3.text)) {
                                showErrorIngredients = true;
                              }
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 119, 119, 119),
                                      width: 0.9,
                                    )),
                                labelStyle: TextStyle(
                                    color: Color(0xFF2C2C2C),
                                    fontSize: height * 0.019),
                                hintMaxLines: 2,
                                hintText: "Ingredients (230 letter at least)",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          7.0)), // Sets border radius
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 119, 119, 119),
                                      width: 0.9,
                                    )),
                                errorText: null),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height * 0.01),
                            child: AnimatedOpacity(
                                duration: Duration(milliseconds: 120),
                                opacity: showErrorIngredients ? 1 : 0,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Must be 230 letter at least",
                                      style: TextStyle(color: Colors.red)),
                                )),
                          ),
                          TextField(
                            cursorColor: Color(0xFF2C2C2C),
                            minLines: 1,
                            maxLines: 8,
                            keyboardType: TextInputType.multiline,
                            controller: _textController2,
                            textAlign: TextAlign.start,
                            onChanged: (value) {
                              if (!mounted) return;
                              setState(() {
                                showErrorform = false;
                              });
                              if (validateDescform(_textController2.text)) {
                                showErrorform = true;
                              }
                            },
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 119, 119, 119),
                                      width: 0.9,
                                    )),
                                hintMaxLines: 2,
                                hintText: "Directions (300 letters at least)",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          7.0)), // Sets border radius
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 119, 119, 119),
                                      width: 0.9,
                                    )),
                                errorText: null),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height * 0.01),
                            child: AnimatedOpacity(
                                duration: Duration(milliseconds: 120),
                                opacity: showErrorform ? 1 : 0,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Must be 300 letter at least",
                                      style: TextStyle(color: Colors.red)),
                                )),
                          ),
                          TextField(
                            cursorColor: Color(0xFF2C2C2C),
                            maxLines: 4,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            controller: _textController,
                            textAlign: TextAlign.start,
                            onTap: () {
                              if (!mounted) return;
                              setState(() {});
                            },
                            onChanged: (value) {
                              if (!mounted) return;
                              setState(() {
                                showErrorbasic = false;
                              });
                              if (validateDescbaseic(_textController.text)) {
                                showErrorbasic = true;
                              }
                            },
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 119, 119, 119),
                                      width: 0.9,
                                    )),
                                hintMaxLines: 2,
                                hintText:
                                    "Nutritional information (180 letter at least)",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          7.0)), // Sets border radius
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                                errorText: null),
                          ),
                          AnimatedOpacity(
                              opacity: showErrorbasic ? 1 : 0,
                              duration: Duration(milliseconds: 120),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Must be 180 letter at least",
                                    style: TextStyle(color: Colors.red)),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.86,
            height: height * 0.08,
            child: Center(
              child: SmoothPageIndicator(
                controller: pc,
                count: 2,
                effect: WormEffect(
                  spacing: 12,
                  activeDotColor: const Color.fromARGB(255, 255, 116, 74),
                  dotColor: Color.fromARGB(255, 204, 204, 204),
                  dotHeight: height * 0.01,
                  dotWidth: height * 0.01,
                ),
              ),
            ),
          ),
          index == 0
              ? Center(
                  child: Container(
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
                        borderRadius: BorderRadius.all(Radius.circular(350))),
                    child: GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        setState(() {
                          showErrorname = false;
                          showErrorimage = false;
                          nameFood = false;
                        });
                        if (validatename(
                            RecipeNameTextEditingController.text)) {
                          showErrorname = true;
                        }

                        if (file == null) {
                          showErrorimage = true;
                        }

                        if (Foodname != "" &&
                            showErrorname == false &&
                            showErrorimage == false) {
                          if (!mounted) return;
                          setState(() {
                            index = 1;
                            pc.animateToPage(index,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOutCubic);
                          });
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
                )
              : Center(
                  child: Container(
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
                        borderRadius: BorderRadius.all(Radius.circular(350))),
                    child: GestureDetector(
                      onTap: () async {
                        if (!mounted) return;
                        setState(() {
                          showErrorIngredients = false;

                          showErrorbasic = false;
                          showErrorform = false;
                        });
                        if (validateDescingredients(_textController3.text)) {
                          showErrorIngredients = true;
                        }
                        if (validateDescbaseic(_textController.text)) {
                          showErrorbasic = true;
                        }
                        if (validateDescform(_textController2.text)) {
                          showErrorform = true;
                        }
                        if (showErrorbasic == false &&
                            showErrorform == false &&
                            showErrorIngredients == false) {
                          if (!mounted) return;
                          setState(() {});
                          try {
                            DocumentReference Food = await FirebaseFirestore
                                .instance
                                .collection("Food")
                                .add({
                              "ingredients": _textController3.text,
                              "Benefit": _textController.text,
                              "Desc": _textController2.text,
                              "ImageUrl": Imageurl,
                              "Type": Foodname.toString(),
                              "name": RecipeNameTextEditingController.text
                            });
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: MainScreenAdmin('food'),
                                    type: PageTransitionType.fade));
                          } catch (e) {}
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
    );
  }

  void switches(int i) {
    recipeType[0].isCompleted = i == 0 ? true : false;
    recipeType[1].isCompleted = i == 1 ? true : false;
    recipeType[2].isCompleted = i == 2 ? true : false;
    recipeType[3].isCompleted = i == 3 ? true : false;
    recipeType[4].isCompleted = i == 4 ? true : false;
    recipeType[5].isCompleted = i == 5 ? true : false;
  }

  void switches2(int i) {
    if (recipeType[i].isCompleted == true) {
      Foodname = recipeType[i].Name;
    }
  }

  String? Imageurl;
  File? file;

  pickercamera(ImageSource imageSource) async {
    if (!mounted) return;
    setState(() {});
    final myfile = await ImagePicker().pickImage(source: imageSource);
    {
      if (!mounted) return;
      setState(() {});
      if (myfile != null) {
        file = File(myfile.path);

        String imagename = basename(myfile!.path);

        var refStorage = FirebaseStorage.instance.ref("FoodImages/$imagename");
        await refStorage.putFile(file!);
        Imageurl = await refStorage.getDownloadURL();
      } else
        print("ddd");
    }
  }

  bool validateDescbaseic(String value) {
    if (value.length < 180 || value.length > 280) {
      return true;
    }

    return false;
  }

  bool validateDescingredients(String value) {
    if (value.length < 230 || value.length > 300) {
      return true;
    }

    return false;
  }

  bool validateDescform(String value) {
    if (value.length < 300 || value.length > 500) {
      return true;
    }

    return false;
  }

  bool isloading = true;

  Future Loading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isloading = false;
    });
  }
}

// class Page1AddRecipe extends StatefulWidget {
//   const Page1AddRecipe({super.key});
//
//   @override
//   State<Page1AddRecipe> createState() => _Page1AddRecipeState();
// }

class RecipeTypes {
  var Images;
  var Name;
  bool isCompleted;

  RecipeTypes(this.Images, this.Name, this.isCompleted);
}

class TimeTypes {
  String Time;
  bool isCompleted;

  TimeTypes(
    this.Time,
    this.isCompleted,
  );
}
