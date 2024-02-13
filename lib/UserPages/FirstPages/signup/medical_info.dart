import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as og;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/login.dart';
import 'package:multiselect/multiselect.dart';
import 'package:page_transition/page_transition.dart';

class MedicalInfo extends StatefulWidget {
  var email;
  var ImageUrl;
  var password;
  var firstName;
  var lastName;
  var height;
  var weight;
  var date;
  var gender;
  var medications;
  var injuries;
  var chronicdisease;
  var allergies;

  MedicalInfo(
      {super.key,
      required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.height,
      required this.weight,
      required this.date,
      required this.gender,
      required this.ImageUrl});

  @override
  State<MedicalInfo> createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo> {
  var fileBytes;
  String? fileName;
  int? filesize;
  String downloadlink = "";
  FilePickerResult? resultCheck;
  pickfile1() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      resultCheck = result;
      fileBytes = result.files.first.path;
      fileName = result.files.first.name;
      filesize = result.files.first.size;
      if (!mounted) return;
      setState(() {});
      final reference = FirebaseStorage.instance.ref('uploads/$fileName');

      final UploadTask = reference.putFile(File(fileBytes!));
      await UploadTask.whenComplete(() {});
      downloadlink = await reference.getDownloadURL();
      if (!mounted) return;
      setState(() {});
    }
  }

  var email;
  var ImageUrl;
  var password;
  var firstName;
  var lastName;
  var height1;
  var weight;
  var date;
  var gender;
  var medications;
  var injuries;
  var chronicdisease;
  var allergies;
  bool Isclick = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ImageUrl = widget.ImageUrl;
    email = widget.email;
    password = widget.password;
    firstName = widget.firstName;
    lastName = widget.lastName;
    height1 = widget.height;
    weight = widget.weight;
    date = widget.date;
    gender = widget.gender;
    medications = widget.medications;
    injuries = widget.injuries;
    chronicdisease = widget.chronicdisease;
    allergies = widget.allergies;
  }

  bool showerrorFile = false;

  var o = Colors.deepOrange;
  List<String> selectedInjuries = [];
  List<String> Injuries = [
    'Asthma Inhalers',
    'Back pain',
    'Burns',
    'Concussions',
    'Cuts and Lacerations',
    'Dislocation',
    'Torn ligaments',
    'Torn tendons',
    'Whiplsh',
  ];
  List<String> selectedMedication = [];
  List<String> Medication = [
    'Ankle Injuries',
    'Blood pressure Medications',
    'Cholesterol-lowering Medication',
    'Insulin',
    'PainKillers'
  ];

  List<String> ChronicDisease = [
    'Arthritis',
    'Asthma',
    'Cancer',
    'Cardiovasculer disease',
    'Chronic respiratory disease',
    'Chronic Kidney disease',
    'Chronic pain',
    'Diabetes',
    'High blood pressure',
    'Osteoporosis'
  ];
  List<String> selectedChronicDisease = [];
  List<String> Allergies = [
    'Food Allergies',
    'Medication Allergies',
    'Environmental Allergies',
  ];
  List<String> selectedAllergies = [];
  bool _isContainerVisible = false;

  void _toggleContainerVisibility() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  int lock = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Color(0xFF2C2C2C),
                    size: height * 0.036,
                  ),
                )),
            Hero(
              tag: 'haya',
              child: Image.asset(
                "Images/Colored.png",
                height: height * 0.056,
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
        decoration: og.BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("Images/Login.png"),
            opacity: 0.6,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              width: double.maxFinite,
              child: Column(
                children: [
                  Text(
                    'Medical information\n(Optional)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: height * 0.03, color: Color(0xFF2C2C2C)),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.01, bottom: height * 0.04),
                    child: Text(
                      "This info helps your specialist craft a personalized plan, considering your health and medical conditions. Ensuring a safe, effective coaching experience tailored to your needs.",
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: height * 0.0165,
                          color: Color(0xFF434343),
                          fontFamily: 'UbuntuREG'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //Medication
                  DropDownMultiSelect(
                    options: Medication,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: o),
                            borderRadius: BorderRadius.circular(7)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: o),
                            borderRadius: BorderRadius.circular(7))),
                    hint: Text('Medication',
                        style: TextStyle(
                            fontFamily: 'UbuntuREG',
                            color: Color.fromARGB(255, 94, 94, 94),
                            fontSize: height * 0.019)),
                    selectedValues: selectedMedication,
                    onChanged: (value) {
                      setState(() {
                        selectedMedication = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Injuries
                  DropDownMultiSelect(
                    options: Injuries,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: o),
                            borderRadius: BorderRadius.circular(7)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: o),
                            borderRadius: BorderRadius.circular(7))),
                    hint: Text('Injuries',
                        style: TextStyle(
                            fontFamily: 'UbuntuREG',
                            color: Color.fromARGB(255, 94, 94, 94),
                            fontSize: height * 0.019)),
                    selectedValues: selectedInjuries,
                    onChanged: (value) {
                      setState(() {
                        selectedInjuries = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Chronic Disease
                  DropDownMultiSelect(
                    options: ChronicDisease,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: o),
                            borderRadius: BorderRadius.circular(7)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: o),
                            borderRadius: BorderRadius.circular(7))),
                    hint: Text('Chronic Disease',
                        style: TextStyle(
                            fontFamily: 'UbuntuREG',
                            color: Color.fromARGB(255, 94, 94, 94),
                            fontSize: height * 0.019)),
                    selectedValues: selectedChronicDisease,
                    onChanged: (value) {
                      setState(() {
                        selectedChronicDisease = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Allergies
                  DropDownMultiSelect(
                    options: Allergies,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: o),
                          borderRadius: BorderRadius.circular(7)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: o),
                          borderRadius: BorderRadius.circular(7)),
                    ),
                    hint: Text('Allergies',
                        style: TextStyle(
                            fontFamily: 'UbuntuREG',
                            color: Color.fromARGB(255, 94, 94, 94),
                            fontSize: height * 0.019)),
                    selectedValues: selectedAllergies,
                    onChanged: (value) {
                      setState(() {
                        selectedAllergies = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      pickfile1();
                    },
                    child: Stack(
                      children: [
                        DropDownMultiSelect(
                          options: [],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: o),
                                borderRadius: BorderRadius.circular(7)),
                          ),
                          hint: Row(
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Color.fromARGB(255, 94, 94, 94),
                              ),
                              resultCheck != null
                                  ? downloadlink == ""
                                      ? Container(
                                          width: width * 0.7,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Container(
                                                width: height * 0.03,
                                                height: height * 0.03,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.deepOrange,
                                                    strokeWidth: 2.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: width * 0.7,
                                          child: Text(
                                            "  $fileName",
                                            style: TextStyle(
                                              fontFamily: 'UbuntuREG',
                                              color: Color.fromARGB(
                                                  255, 94, 94, 94),
                                              fontSize: height * 0.019,
                                            ),
                                          ),
                                        )
                                  : Container(
                                      width: width * 0.7,
                                      child: Text(
                                        '  Upload diagnosis',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'UbuntuREG',
                                            color:
                                                Color.fromARGB(255, 94, 94, 94),
                                            fontSize: height * 0.019),
                                      ),
                                    ),
                            ],
                          ),
                          icon: Icon(
                            Icons.abc,
                            size: 0,
                            color: Colors.transparent,
                          ),
                          selectedValues: [],
                          onChanged: (value) {},
                        ),
                      ],
                    ),
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
                  onTap: () async {
                    if (lock == 0) {
                      if (Isclick == false) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc:
                                  'The account already exists for that email.',
                            ).show();
                          }
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          Isclick = true;
                        });
                        await FirebaseFirestore.instance
                            .collection("users")
                            .add({
                          "User_id": FirebaseAuth.instance.currentUser!.uid,
                          "FirstName": firstName.toString(),
                          "LastName": lastName.toString(),
                          "email": email.toString(),
                          "password": password.toString(),
                          "height": height1.toString(),
                          "weight": weight.toString(),
                          "date": date.toString(),
                          "gender": gender.toString(),
                          "diagnosis": downloadlink.toString(),
                          "images": ImageUrl.toString(),
                          "medications": selectedMedication.toString(),
                          "injuries": selectedInjuries.toString(),
                          "chronicdisease": selectedChronicDisease.toString(),
                          "allergies": selectedAllergies.toString(),
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: Login(), type: PageTransitionType.fade));
                      }
                      lock++;
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
          ],
        ),
      ),
    );
  }
}
