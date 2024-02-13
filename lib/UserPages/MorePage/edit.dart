//medical info
// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:io';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/MorePage/account.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect/multiselect.dart';

//medical info
// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

class EditInfo extends StatefulWidget {
  var Page_name;
  var Users;
  bool isEdit;

  EditInfo(this.Page_name, this.Users, this.isEdit);

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  List<QueryDocumentSnapshot> data = [];
  var UserId;

  getdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("User_id", isEqualTo: UserId)
        // .where("User_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    // isloading = false;
    setState(() {
      print(UserId.toString());
      print(data.length);
    });
  }

  @override
  void initState() {
    Prefs.getString("Id").then(
      (value) async {
        UserId = await value;
        await getdata();
      },
    );

    super.initState();
  }

  bool isloading = false;
  bool showErrorFile = false;

  var o = Colors.orange;
  TextEditingController _Fname = TextEditingController();
  TextEditingController _Lname = TextEditingController();

  final _form = GlobalKey<FormState>();

  _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
  }

  nameValidata(String value) {
    if (value.isEmpty || value.length > 15) {
      return true;
    }
    return false;
  }

  bool LnameValidate = false;
  bool FnameValidate = false;
  pickercamera(ImageSource imageSource) async {
    final myfile = await ImagePicker().pickImage(source: imageSource);
    if (myfile != null) {
      file = File(myfile.path);
      if (!mounted) return;
      setState(() {});
      String imagename = basename(myfile!.path);
      var refStorage = FirebaseStorage.instance.ref("UserImage/$imagename");
      await refStorage.putFile(file!);
      Imageurl = await refStorage.getDownloadURL();
      if (!mounted) return;
      setState(() {});
    } else if (!mounted) return;
    setState(() {});
  }

  bool shouldPop = true;
  File? file;
  String? Imageurl;
  bool ImageError = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'Images/Colored.png',
          height: height * .1,
          width: width * .1,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: height * 0.036,
            )),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("Images/Login.png"),
                    fit: BoxFit.cover,
                    opacity: .05,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: height * 0.05),
                          // decoration: BoxDecoration(
                          //   color: const Color(0xFFF9F9F9),
                          //   borderRadius: BorderRadius.circular(7),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.black.withOpacity(0.8),
                          //       offset: const Offset(0, 2),
                          //       blurRadius: 4,
                          //     ),
                          //   ],
                          // ),

                          width: width * 0.9,
                          child: Text(
                            'Edit your information ',
                            style: TextStyle(fontSize: height * 0.025),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              file;
                            });
                            pickercamera(ImageSource.gallery);
                          },
                          child: Center(
                            child: Container(
                              width: height * 0.14,
                              height: height * 0.14,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              padding: EdgeInsets.all(10),
                              child: Stack(
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    width: height * 0.12,
                                    height: height * 0.12,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              blurRadius: 4,
                                              offset: Offset(0, 3))
                                        ],
                                        shape: BoxShape.circle),
                                    child: file != null
                                        ? Imageurl == null
                                            ? Container(
                                                width: height * 0.04,
                                                height: height * 0.04,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.deepOrange,
                                                    strokeWidth: 2.5,
                                                  ),
                                                ),
                                              )
                                            : Image.file(
                                                file!,
                                                fit: BoxFit.cover,
                                              )
                                        : Icon(
                                            Icons
                                                .camera_alt, ////////////////////////////////////////////////////////
                                            size: height * 0.05,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                  ),
                                  file != null
                                      ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            width: height * 0.035,
                                            height: height * 0.035,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2.5))
                                                ]),
                                            child: Icon(
                                              Icons.edit,
                                              size: height * 0.021,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Text(
                              'Edit profile photo',
                              style: TextStyle(
                                fontSize: height * 0.019,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: 120),
                              opacity: showErrorFile && file == null ? 1 : 0,
                              child: Center(
                                child: Text(
                                  "Please upload a profile photo",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.86,
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                top: height * 0.03,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _Fname,
                                onChanged: (value) {
                                  setState(() {
                                    FnameValidate = false;
                                  });

                                  if (nameValidata(_Fname.text)) {
                                    FnameValidate = true;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: 'First Name',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: o, width: 2),
                                        borderRadius: BorderRadius.circular(5)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Visibility(
                                child: const Text("First name Error",
                                    style: TextStyle(color: Colors.red)),
                                visible: FnameValidate,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.86,
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                top: height * 0.02,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _Lname,
                                onChanged: (value) {
                                  setState(() {
                                    LnameValidate = false;
                                  });
                                  if (nameValidata(_Lname.text)) {
                                    LnameValidate = true;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: o, width: 2),
                                        borderRadius: BorderRadius.circular(5)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Visibility(
                                child: const Text("Last name Error",
                                    style: TextStyle(color: Colors.red)),
                                visible: LnameValidate,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.2),
                          decoration:
                              const BoxDecoration(shape: BoxShape.rectangle),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(350))),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  FnameValidate = false;
                                  LnameValidate = false;
                                  ImageError = false;
                                  showErrorFile = false;
                                });

                                if (nameValidata(_Fname.text)) {
                                  FnameValidate = true;
                                }
                                if (nameValidata(_Lname.text)) {
                                  LnameValidate = true;
                                }
                                if (file == null) {
                                  showErrorFile = true;

                                  ImageError = true;
                                }
                                print(data[0].id.toString());
                                if (_form.currentState!.validate() &&
                                    Imageurl != null &&
                                    LnameValidate == false &&
                                    ImageError == false &&
                                    FnameValidate == false) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.rightSlide,
                                    title: 'warning',
                                    btnOk: TextButton(
                                        child: const Text('yes'),
                                        onPressed: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(data[0].id)
                                                .update({
                                              "images": Imageurl.toString(),
                                              'FirstName': _Fname.text,
                                              'LastName': _Lname.text
                                            });

                                            Navigator.pushReplacement<void,
                                                    void>(
                                                context,
                                                PageTransition(
                                                    child: Account(
                                                        widget.Page_name,
                                                        data,
                                                        true),
                                                    type: PageTransitionType
                                                        .leftToRightWithFade));

                                            setState(() {});
                                          } catch (e) {}
                                        }),
                                    btnCancel: TextButton(
                                      child: const Text('cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                    ),
                                    desc:
                                        'are you sure you want to update your information',
                                  ).show();
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                // ignore: sort_child_properties_last
                                child: ShaderMask(
                                  child: const Text(
                                    'Update',
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
                ),
              ),
            ),
    );
  }
}

class MedicalInfoEdit extends StatefulWidget {
  var Page_name;
  var Users;

  MedicalInfoEdit(this.Page_name, this.Users);

  @override
  State<MedicalInfoEdit> createState() => _MedicalInfoEditState();
}

class _MedicalInfoEditState extends State<MedicalInfoEdit> {
  var fileBytes;
  String? fileName;
  int? filesize;
  String downloadlink = "";
  bool x = false;
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

  List<QueryDocumentSnapshot> data = [];
  var UserId;

  getdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("User_id", isEqualTo: UserId)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    Prefs.getString("Id").then(
      (value) async {
        UserId = await value;
        await getdata();
      },
    );

    super.initState();
  }

  bool isloading = false;

  var o = Colors.orange;
  List<String> selectedInjuries = [];
  List<String> Injuries = [
    'None ',
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
    'None',
    'Blood pressure Medications',
    'Cholesterol-lowering Medication',
    'Insulin',
    'PainKillers'
  ];
  List<String> ChronicDisease = [
    'None ',
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
    'None ',
    'Food Allergies',
    'Medication Allergies',
    'Environmental Allergies',
  ];
  List<String> selectedAllergies = [];
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (shouldPop)
          Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: Account(widget.Page_name, widget.Users, false),
                  type: PageTransitionType.leftToRightWithFade));

        return shouldPop;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            'Images/Colored.png',
            height: height * 0.058,
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: height * 0.036,
              )),
        ),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("Images/Login.png"),
                    fit: BoxFit.cover,
                    opacity: .05,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Medical information',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: height * 0.03,
                                color: Color(0xFF2C2C2C)),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: height * 0.01, bottom: height * 0.04),
                            child: Text(
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              "This info helps your specialist craft a personalized plan, considering your health and medical conditions. Ensuring a safe, effective coaching experience tailored to your needs.",
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
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: o),
                                    borderRadius: BorderRadius.circular(5))),
                            hint: const Text('Medication'),
                            selectedValues: selectedMedication,
                            onChanged: (value) {
                              setState(() {
                                selectedMedication = value;
                              });
                              print('you have selected $selectedMedication');
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //Injuries
                          DropDownMultiSelect(
                            options: Injuries,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: o),
                                    borderRadius: BorderRadius.circular(5))),
                            hint: const Text('Injuries'),
                            selectedValues: selectedInjuries,
                            onChanged: (value) {
                              setState(() {
                                selectedInjuries = value;
                              });
                              print('you have selected $selectedInjuries');
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //Chronic Disease
                          DropDownMultiSelect(
                            options: ChronicDisease,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: o),
                                    borderRadius: BorderRadius.circular(5))),
                            hint: const Text('Chronic Disease'),
                            selectedValues: selectedChronicDisease,
                            onChanged: (value) {
                              setState(() {
                                selectedChronicDisease = value;
                              });
                              print(
                                  'you have selected $selectedChronicDisease ');
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //Allergies
                          DropDownMultiSelect(
                            options: Allergies,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: o),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            hint: const Text('Allergies'),
                            selectedValues: selectedAllergies,
                            onChanged: (value) {
                              setState(() {
                                selectedAllergies = value;
                              });
                              print('you have selected $selectedAllergies ');
                            },
                          ),

                          SizedBox(
                            height: height * .01,
                          ),
                          InkWell(
                            onTap: () {
                              pickfile1();
                              setState(() {
                                x = true;
                              });
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
                                              ? Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Container(
                                                    width: height * 0.03,
                                                    height: height * 0.03,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            Colors.deepOrange,
                                                        strokeWidth: 2.5,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: width * 0.75,
                                                  child: Text(
                                                    "  $fileName",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontFamily: 'UbuntuREG',
                                                        color: Color.fromARGB(
                                                            255, 94, 94, 94),
                                                        fontSize:
                                                            height * 0.019),
                                                  ),
                                                )
                                          : Text(
                                              '  Upload diagnosis',
                                              style: TextStyle(
                                                  fontFamily: 'UbuntuREG',
                                                  color: Color.fromARGB(
                                                      255, 94, 94, 94),
                                                  fontSize: height * 0.019),
                                            ),
                                    ],
                                  ),
                                  icon: Icon(
                                    Icons.abc,
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
                      Container(
                        decoration:
                            const BoxDecoration(shape: BoxShape.rectangle),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(350))),
                          child: GestureDetector(
                            onTap: () async {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'warning',
                                btnOk: TextButton(
                                  child: const Text('yes'),
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(data[0].id)
                                          .update({
                                        "diagnosis": downloadlink == ""
                                            ? data[0]["diagnosis"]
                                            : downloadlink.toString(),
                                        "medications":
                                            selectedMedication.toString(),
                                        "injuries": selectedInjuries.toString(),
                                        "chronicdisease":
                                            selectedChronicDisease.toString(),
                                        "allergies":
                                            selectedAllergies.toString(),
                                      });

                                      Navigator.pushReplacement<void, void>(
                                          context,
                                          PageTransition(
                                              child: Account(
                                                  widget.Page_name, data, true),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));

                                      setState(() {});
                                    } catch (e) {}
                                  },
                                ),
                                btnCancel: TextButton(
                                  child: const Text('cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                                desc:
                                    'are you sure you want to update your Medical information',
                              ).show();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              // ignore: sort_child_properties_last
                              child: ShaderMask(
                                child: const Text(
                                  'Update',
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
              ),
      ),
    );
  }
}
