import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hayaproject/FlutterAppIcons.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/WelcomePage.dart';
import 'package:page_transition/page_transition.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Widget option(String title, String subText, IconData icon) {
      return Container(
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.all(10),
        height: height * .10,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            height: height * .1,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        child: Icon(
                          icon,
                          color: Color(0xFF707070),
                          size: height * 0.05,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: width * 0.72,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.9,
                              child: Text(
                                maxLines: 2,
                                title,
                                style: TextStyle(
                                  fontSize: height * 0.018,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: width * 0.7,
                              child: Text(subText,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'UbuntuREG',
                                      fontSize: height * 0.017,
                                      color:
                                          const Color.fromARGB(255, 66, 66, 66)
                                              .withOpacity(.8))),
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
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        elevation: 3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Hero(
                  tag: 'arrow',
                  child: Icon(Icons.arrow_back_ios,
                      size: height * 0.035, color: const Color(0xFF2C2C2C)),
                )),
            Text('Settings',
                style: TextStyle(
                    fontSize: height * 0.03, color: const Color(0xFF2C2C2C))),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                option('Your Account', 'See information about your account.',
                    Icons.account_circle_outlined),
                option(
                    'Privacy and safety',
                    'Manage what information you see and share.',
                    Icons.privacy_tip_outlined),
                option('Security and account access',
                    'Manage your accounts security.', Icons.lock_outline),
                option(
                    'Notifications',
                    'Select the notifications you get about your activities and recommendations.',
                    Icons.notifications_outlined),
                option(
                    'Accessibility',
                    'Manage how content is displayed to you',
                    Icons.accessibility_new_outlined),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: const BoxDecoration(shape: BoxShape.rectangle),
                child: Container(
                  height: height * 0.06,
                  margin: const EdgeInsets.fromLTRB(15, 30, 15, 10),
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
                      await SetBoolean("IsLogin", false);
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: IntroHome(),
                              type: PageTransitionType.fade));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      // ignore: sort_child_properties_last
                      child: ShaderMask(
                        child: Text(
                          'Logout',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: height * 0.024,
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
                          borderRadius: BorderRadius.all(Radius.circular(350))),
                      margin: const EdgeInsets.all(5),
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

  SetBoolean(String key, bool value) async {
    await Prefs.setBoolean(key, value);
  }
}
