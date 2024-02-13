import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/Chat/ChatBubble.dart';
import 'package:hayaproject/Chat/Chat_Service.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SpecialistPage/CustomWorkout.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';
import 'package:hayaproject/UserPages/Expert/ProfileFSTU.dart';
import 'package:hayaproject/UserPages/MorePage/account.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:page_transition/page_transition.dart';

import '../SharedPrefrences.dart';
import '../SpecialistPage/AddFoodSp.dart';

class ChatPage extends StatefulWidget {
  var receiverUserEmail;
  var receiverUserID;
  var type;
  var senderId;
  var Senderemail;
  var image;
  var name;

  ChatPage(
      {required this.name,
      required this.image,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.type,
      required this.senderId,
      required this.Senderemail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late int selectedhour = DateTime.timestamp().hour;
  late int selectedminute = DateTime.timestamp().minute;

  TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  Timer? _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 40), () {
      // do something with query
    });
  }

  void sendMessage() async {
    //only sends a message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserID,
          _messageController.text, widget.senderId, widget.Senderemail);
      // clear the text Controller after sending the message
      _messageController.clear();
    }
  }

  List<DocumentSnapshot> MyUserdata = [];
  List<DocumentSnapshot> MySpecdata = [];

  List<DocumentSnapshot> review = [];
  List<DocumentSnapshot> specialist = [];
  List<DocumentSnapshot> User = [];

  List<Future<List<QueryDocumentSnapshot<Object?>>>> queryFutures = [];
  List<List<QueryDocumentSnapshot<Object?>>> reviewList = [];

  getData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("specialist")
        .where("Specialist ID", isEqualTo: widget.receiverUserID)
        .get();
    specialist.addAll(await qs.docs);
    getDataReview();
    setState(() {});
  }

  getData2() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("users")
        .where("User_id", isEqualTo: widget.receiverUserID)
        .get();
    User.addAll(await qs.docs);
    setState(() {});
  }

  getDataReview() async {
    Future<List<QueryDocumentSnapshot<Object?>>> queryFuture = FirebaseFirestore
        .instance
        .collection("specialist")
        .doc(specialist[0].id)
        .collection("review")
        .get()
        .then((QuerySnapshot qs2) => qs2.docs);
    queryFutures.add(queryFuture);

    reviewList = await Future.wait(queryFutures);
    setState(() {});
  }

  var Type;
  var MyID;
  bool isUser = true;

  @override
  void initState() {
    super.initState();
    isUser = widget.type == 'specialist' ? true : false;
    Prefs.getString("Id").then((value) {
      setState(() {
        MyID = value;
      });
      Prefs.getString("Type").then(
        (value) async {
          Type = await value;
        },
      );
      if (widget.type == "specialist") {
        getData();
      } else if (widget.type == "user") {
        getData2();
      }
    });
  }

  Widget option(double height, double width, Color color, Color shadow,
      IconData icon, String title, Widget page) {
    //CustomWorkout() to view workouts
//AddWorkoutSp('') to add workout
//FoodPlan() to add food
    return GestureDetector(
      onTap: () {
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     PageTransition(
        //         child: page,
        //         type: PageTransitionType.bottomToTop,
        //         childCurrent: ChatPage(
        //           receiverUserEmail: widget.receiverUserEmail,
        //           receiverUserID: widget.receiverUserID,
        //         )),
        //     (Route<dynamic> route) => false)
        Navigator.push(
          context,
          PageTransition(
              child: page,
              type: PageTransitionType.bottomToTop,
              childCurrent: ChatPage(
                name: widget.name,
                image: widget.image,
                Senderemail: widget.Senderemail,
                senderId: widget.senderId,
                receiverUserEmail: widget.receiverUserEmail,
                receiverUserID: widget.receiverUserID,
                type: widget.type,
              )),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width * 0.35,
            height: height * 0.16,
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                boxShadow: [
                  BoxShadow(
                      color: shadow.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4))
                ]),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size:
                    color == Colors.greenAccent ? height * 0.14 : height * 0.12,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: width * 0.3,
              height: height * 0.04,
              child: Text(
                title,
                style: TextStyle(
                    color: const Color(0xFF5B5B5B),
                    fontFamily: 'UbuntuREG',
                    overflow: TextOverflow.visible,
                    fontSize: height * 0.017),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  String specialistType = '';
  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    specialistType = isUser == true ? "" : Type.toString();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.type == "user") {
                  Navigator.pushReplacement<void, void>(
                    context,
                    PageTransition(
                        child: MainScreenSpec(""),
                        type: PageTransitionType.leftToRightWithFade),
                  );
                } else
                  Navigator.pushReplacement<void, void>(
                    context,
                    PageTransition(
                        child: MainScreenUser("Test"),
                        type: PageTransitionType.leftToRightWithFade),
                  );
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: height * 0.032,
                color: Color.fromARGB(255, 61, 61, 61),
              ),
            ),
            Container(
              width: height * 0.045,
              height: height * 0.045,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage('${widget.image}'),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 7),
              child: Container(
                width: width * 0.6,
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    if (widget.type == "specialist") {
                      Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(milliseconds: 120),
                            reverseDuration: Duration(milliseconds: 120),
                            child: ProfileSpec(reviewList[0], specialist[0]),
                            type: PageTransitionType.rightToLeftWithFade),
                      );
                    } else if (widget.type == "user") {
                      Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(milliseconds: 120),
                            reverseDuration: Duration(milliseconds: 120),
                            child: Account("chat page", User, false),
                            type: PageTransitionType.rightToLeftWithFade),
                      );
                    }
                  },
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'UbuntuREG',
                        color: Color.fromARGB(255, 61, 61, 61),
                        fontSize: height * 0.022),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (widget.type == "user") {
            Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenSpec(""),
                  type: PageTransitionType.leftToRightWithFade),
            );
          } else
            Navigator.pushReplacement<void, void>(
              context,
              PageTransition(
                  child: MainScreenUser("Test"),
                  type: PageTransitionType.leftToRightWithFade),
            );
          return Future.value(true);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  opacity = 0;
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'Images/zz.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  opacity = 0;
                });
              },
              child: Column(
                children: [
                  Expanded(child: _buildmessagelist(height)),
                  _buildmessageinput(specialistType),
                ],
              ),
            ),
            IgnorePointer(
              ignoring: opacity == 0 ? true : false,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 120),
                opacity: opacity,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height * 0.08),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                option(
                                  height,
                                  width,
                                  const Color.fromARGB(255, 252, 148, 122),
                                  const Color.fromARGB(255, 156, 52, 25),
                                  Icons.edit,
                                  specialistType == 'trainer'
                                      ? 'View custom workouts'
                                      : 'Add new nutritional plan',
                                  specialistType == "trainer"
                                      ? CustomWorkout(
                                          name: widget.name,
                                          image: widget.image,
                                          senderId: widget.senderId,
                                          Senderemail: widget.Senderemail,
                                          type: widget.type,
                                          receiverUserEmail:
                                              widget.receiverUserEmail,
                                          receiverUserID: widget.receiverUserID,
                                        )
                                      : FoodPlan(
                                          name: widget.name,
                                          image: widget.image,
                                          senderId: widget.senderId,
                                          Senderemail: widget.Senderemail,
                                          type: widget.type,
                                          receiverUserEmail:
                                              widget.receiverUserEmail,
                                          receiverUserID: widget.receiverUserID,
                                        ),
                                ),
                              ]),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.white.withOpacity(0.75),
                          ),
                          width: width * 0.94,
                          height: height * 0.25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool keyboardOn = false;
  bool lock = false;
  bool shouldPop = true;
  CollectionReference qs = FirebaseFirestore.instance.collection("sowkd;lsd;l");

  // build message list
  Widget _buildmessagelist(var height) {
    //   var height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.topCenter,
      child: StreamBuilder(
          stream: MyID == null
              ? qs.snapshots()
              : _chatService.getmessage(widget.receiverUserID.toString(), MyID),
          // .getmessage(
          // widget.receiverUserID, _firebaseAuth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Text("");
            }
            if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            }
            if (lock == false) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              lock = true;
            }
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  children: snapshot.data!.docs
                      .map((document) => _buildmessageitem(document))
                      .toList(),
                  reverse: true,
                ),
              ),
            );
          }),
    );
  }

  // build message item
  Widget _buildmessageitem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    int hour = data['time'];
    int min = data['timet'];
    int finalTime = 0;
    String finalMin = '';
    if (hour > 12) {
      finalTime = hour - 12;
      finalMin = "$min PM";
    }
    if (hour < 12) {
      finalTime = hour;
      finalMin = "$min AM";
    }
    if (hour == 0) {
      finalTime = 12;
      finalMin = "$min AM";
    }
    if (hour == 12) {
      finalTime = 12;
      finalMin = "$min PM";
    }
    var color = (data['senderId'] == MyID)
        //_firebaseAuth.currentUser!.uid)
        ? const Color.fromARGB(255, 240, 115, 98)
        : const Color.fromARGB(255, 255, 255, 255);
    var textColor = (data['senderId'] == MyID)
        //_firebaseAuth.currentUser!.uid)
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color(0xFF2C2C2C);
    var alignment = (data['senderId'] == MyID)
        //_firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == MyID)
              // _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == MyID)
              // _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            //Text(data['FirstName']),
            // const SizedBox(
            //   height: 5,
            // ),

            ChatBubble(
              color: color,
              message: data['message'],
              hour: finalTime.toString(),
              minute: min < 10 && min > 0 ? "0$finalMin" : finalMin,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();

  bool isntEmpty = false;

  // build message input
  Widget _buildmessageinput(String specialistType) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            height: height * 0.06,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(300)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ]),
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              focusNode: _focusNode,
              onTapOutside: (PointerDownEvent) {
                setState(() {
                  keyboardOn = false;
                });
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onTap: () {
                _focusNode.requestFocus(); // Show the keyboard

                setState(() {
                  keyboardOn = true;
                });

                opacity = 0;
              },
              cursorColor: const Color.fromARGB(255, 255, 137, 82),
              keyboardType: TextInputType.multiline,
              obscureText: false,
              expands: true,
              minLines: null,
              maxLines: null,
              controller: _messageController,
              onChanged: (value) {
                _onSearchChanged(value);
                if (value != "") {
                  setState(() {
                    isntEmpty = true;
                  });
                } else
                  setState(() {
                    isntEmpty = false;
                  });
              },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(left: 15.0, bottom: 8.0, top: 8.0),
                  suffixIconColor: Colors.grey,
                  suffixIcon: Container(
                    width: width * 0.19,
                    child: specialistType == ""
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width * 0.14,
                                height: height * 0.1,
                                color: Colors.transparent,
                                alignment: Alignment.centerRight,
                                child: AnimatedCrossFade(
                                  crossFadeState: isntEmpty == false
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  duration: const Duration(milliseconds: 120),
                                  firstChild: Opacity(
                                    opacity: 0,
                                    child: Icon(
                                      FontAwesomeIcons.paperclip,
                                      size: height * 0.028,
                                    ),
                                  ),
                                  secondChild: GestureDetector(
                                      onTap: () {
                                        sendMessage();
                                        setState(() {
                                          isntEmpty = false;
                                        });
                                      },
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (Rect bounds) =>
                                            RadialGradient(colors: [
                                          const Color(0xFFFF9A3D),
                                          const Color.fromARGB(
                                                  255, 255, 128, 69)
                                              .withOpacity(0.7),
                                          const Color.fromARGB(255, 255, 84, 61)
                                              .withOpacity(0.7),
                                          const Color(0xFFFF2525)
                                              .withOpacity(0.7),
                                        ], stops: [
                                          .1,
                                          .2,
                                          .6,
                                          1
                                        ]).createShader(bounds),
                                        child: Icon(
                                          Icons.send_rounded,
                                          size: height * 0.035,
                                          color: const Color(0xFFFF9A3D),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {},
                                  child: Visibility(
                                    visible: false,
                                    child: Icon(
                                      FontAwesomeIcons.paperclip,
                                      size: height * 0.026,
                                    ),
                                  )),
                              Container(
                                width: width * 0.13,
                                height: height * 0.1,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: AnimatedCrossFade(
                                  crossFadeState: isntEmpty == false
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  duration: const Duration(milliseconds: 120),
                                  firstChild: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        opacity = opacity == 0 ? 1 : 0;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: specialistType == "trainer"
                                              ? 1
                                              : 4),
                                      child: Icon(
                                        specialistType == "trainer"
                                            ? MyFlutterApp.dumbbell
                                            : MyFlutterApp.apple_whole_solid_1,
                                        size: height * 0.032,
                                      ),
                                    ),
                                  ),
                                  secondChild: GestureDetector(
                                      onTap: () {
                                        sendMessage();
                                        setState(() {
                                          isntEmpty = false;
                                        });
                                      },
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (Rect bounds) =>
                                            RadialGradient(colors: [
                                          const Color(0xFFFF9A3D),
                                          const Color.fromARGB(
                                                  255, 255, 128, 69)
                                              .withOpacity(0.7),
                                          const Color.fromARGB(255, 255, 84, 61)
                                              .withOpacity(0.7),
                                          const Color(0xFFFF2525)
                                              .withOpacity(0.7),
                                        ], stops: [
                                          .1,
                                          .2,
                                          .6,
                                          1
                                        ]).createShader(bounds),
                                        child: Icon(
                                          Icons.send_rounded,
                                          size: height * 0.035,
                                          color: const Color(0xFFFF9A3D),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                  ),
                  hintText: 'Message',
                  hintStyle: TextStyle(
                      fontSize: height * 0.02, fontFamily: 'UbuntuREG'),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(300)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(300)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(300))),
            ),
          ),
        ),
      ],
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
