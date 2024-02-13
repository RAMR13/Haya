// ignore_for_file: sort_child_properties_last
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hayaproject/AdminPage/EventPageAdmin/EventAdminPage.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/WelcomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class ExpertAdminPage extends StatefulWidget {
  final String docid = '';
  ExpertAdminPage({super.key});

  @override
  State<ExpertAdminPage> createState() => _testState();
}

class _testState extends State<ExpertAdminPage> {
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("specialist")
        .where('status', isEqualTo: false)
        .get();
    data.addAll(qs.docs);
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<String> list = <String>['Logout'];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextStyle infoStyle = TextStyle(
        fontFamily: 'UbuntuREG',
        fontSize: height * 0.018,
        color: Color(0xFF2C2C2C));
    Widget loading() {
      return ListView.builder(
          key: Key('4'),
          itemCount: 4,
          itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 214, 214, 214),
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.28),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 4)),
                        BoxShadow(
                            color: Colors.white,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(2, -2)),
                      ]),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 7, top: 7, right: 4),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                width: height * 0.09,
                                height: height * 0.09,
                                child: Container(
                                  color: Colors.grey,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 2,
                                        offset: Offset(0, 3))
                                  ],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Container(
                              width: width * .4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          width: width * 0.39,
                                          child: Text('',
                                              style: TextStyle(
                                                  fontSize: height * 0.022,
                                                  color: Color(0xFF2C2C2C))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.work_outline,
                                            size: height * 0.025,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 6),
                                          child: Container(
                                            color: Colors.grey,
                                            width: width * 0.32,
                                            child: Text(
                                              '',
                                              style: infoStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.work_outline,
                                            size: height * 0.025,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 6),
                                          child: Container(
                                            color: Colors.grey,
                                            width: width * 0.32,
                                            child: Text(
                                              '',
                                              style: infoStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 7),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.work_outline,
                                            size: height * 0.025,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 6),
                                          child: Container(
                                              color: Colors.grey,
                                              width: width * 0.32,
                                              child: Text(
                                                '',
                                                style: infoStyle,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: height * 0.05, right: 5),
                              child: Container(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                ),
                                width: width * 0.22,
                                height: height * 0.05,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(300)),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: height * 0.08,
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
    }

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
                    PopupMenuButton<String>(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      position: PopupMenuPosition.under,
                      onSelected: (String result) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
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
                                      padding: EdgeInsets.only(right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(Color.fromARGB(
                                                                90,
                                                                255,
                                                                119,
                                                                56))),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF2C2C2C),
                                                        fontFamily: 'UbuntuREG',
                                                        fontSize:
                                                            height * 0.018))),
                                          ),
                                          TextButton(
                                              style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(90,
                                                              255, 119, 56))),
                                              onPressed: () async {
                                                await SetBoolean(
                                                    "IsLogin", false);
                                                Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                        child: IntroHome(),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                              child: Text("Logout",
                                                  style: TextStyle(
                                                      color: Color(0xFF2C2C2C),
                                                      fontFamily: 'UbuntuREG',
                                                      fontSize:
                                                          height * 0.018)))
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
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Experts",
                        style: TextStyle(
                            fontSize: height * 0.03,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C2C2C)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFFFFFFF),
          elevation: 1.5,
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 220),
            child: data.length == 0
                ? loading()
                : ListView.builder(
                    key: Key('s'),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.28),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: Offset(0, 4)),
                                BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(2, -2)),
                              ]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 7, top: 7, right: 0),
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      width: height * 0.08,
                                      height: height * 0.08,
                                      child: Image.network(
                                        "${data[index]['image']}",
                                        fit: BoxFit.cover,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 2,
                                              offset: Offset(0, 3))
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * .44, //49 ارجع
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${data[index]['first name']}',
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: height * 0.022,
                                                      color:
                                                          Color(0xFF2C2C2C))),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                size: height * 0.025,
                                                color: Color(0xFF2C2C2C),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6),
                                                child: Container(
                                                  width: width * 0.35,
                                                  child: Text(
                                                    '${data[index]['type']}',
                                                    style: infoStyle,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.school_outlined,
                                                size: height * 0.025,
                                                color: Color(0xFF2C2C2C),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6),
                                                child: Container(
                                                  width: width * 0.35,
                                                  child: Text(
                                                    '${data[index]['University']}',
                                                    style: infoStyle,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 7),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.work_outline,
                                                size: height * 0.025,
                                                color: Color(0xFF2C2C2C),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6),
                                                child: Container(
                                                    width: width * 0.35,
                                                    child: Text(
                                                      '${data[index]['occupation']}',
                                                      style: infoStyle,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, right: 5),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {});
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('specialist')
                                                      .doc(data[index].id)
                                                      .delete();
                                                  setState(() {
                                                    data.removeAt(index);
                                                  });
                                                } catch (e) {}
                                              },
                                              child: Icon(
                                                Icons.cancel_outlined,
                                                size: height * 0.03,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.01,
                                            top: height * 0.03),
                                        child: Container(
                                          child: InkWell(
                                            onTap: () async {
                                              setState(() {});
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('specialist')
                                                    .doc(data[index].id)
                                                    .update({'status': true});
                                                setState(() {
                                                  data.removeAt(index);
                                                });
                                              } catch (e) {}
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: height * 0.025,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const Text("Accept")
                                              ],
                                            ),
                                          ),
                                          width: width * 0.22,
                                          height: height * 0.05,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFF9F9F9),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    spreadRadius: 1,
                                                    blurRadius: 4,
                                                    offset: Offset(-2, 3)),
                                                BoxShadow(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    spreadRadius: 1.5,
                                                    blurRadius: 2,
                                                    offset: Offset(1.5, -3))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(300)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: height * 0.08,
                                margin: const EdgeInsets.fromLTRB(5, 0, 5, 7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.28),
                                          blurRadius: 4,
                                          offset: Offset(0, 3))
                                    ]),
                                child: InkWell(
                                  onTap: () async {
                                    final url = "${data[index]["PdfFile"]}";
                                    final file = await PDFApi.loadNetwork(url);
                                    openPDF(context, file);
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Image.asset(
                                            "Images/pdfimages.png",
                                            fit: BoxFit.cover,
                                            scale: height * 0.012,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${data[index]['fileName']}"),
                                                Text(
                                                    "${NumberFormat('##.#').format((data[index]['filesize'] / 1024))} KB",
                                                    style: TextStyle(
                                                        fontSize:
                                                            height * 0.016,
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontFamily:
                                                            'UbuntuREG')),
                                                // Text("${data[index]['FileName']}"),
                                                // Text("${data[index]['filesize']} Kb",
                                                //     style: const TextStyle(
                                                //         color: Colors.grey)),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   height: height*.01 ,
                              //   width: width,
                              //   child: SfPdfViewer.network(data[index]['FileName']),
                              // )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  void openPDF(BuildContext context, File file) =>
      Navigator.of(context).push(PageTransition(
          child: PDFViewerPage(
            file: file,
          ),
          type: PageTransitionType.fade));
}

class PDFApi {
  static Future<File> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    return _storeFile(path, bytes);
  }

  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    return _storeFile(url, bytes);
  }

  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return null;
    return File(result.paths.first!);
  }

  // static Future<File?> loadFirebase(String url) async {
  //   try {
  //     final refPDF = FirebaseStorage.instance.ref("FilesPdf/").child(url);
  //     final bytes = await refPDF.getData();
  //
  //     return _storeFile(url, bytes!);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({
    required this.file,
  });

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final text = '${indexPage + 1} of $pages';
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: height * 0.04,
            )),
        backgroundColor: Colors.white,
        title: Text(name),
        actions: pages >= 2
            ? [
                Center(child: Text(text)),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: height * 0.04),
                  onPressed: () {
                    final page = indexPage == 0 ? pages : indexPage - 1;
                    controller.setPage(page);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: height * 0.04),
                    onPressed: () {
                      final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                      controller.setPage(page);
                    },
                  ),
                ),
              ]
            : null,
      ),
      body: PDFView(
        filePath: widget.file.path,
        // autoSpacing: false,
        // swipeHorizontal: true,
        // pageSnap: false,
        // pageFling: false,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage!),
      ),
    );
  }
}

SetBoolean(String key, bool value) async {
  await Prefs.setBoolean(key, value);
}
