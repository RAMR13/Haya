import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hayaproject/SharedPrefrences.dart';
import 'package:hayaproject/SpalshPage.dart';
import 'package:hayaproject/SpecialistPage/navigatorbarSpec/NavigatorbarSpec.dart';
import 'package:hayaproject/UserPages/FirstPages/auth/WelcomePage.dart';
import 'package:hayaproject/UserPages/navigatorbarUser/NavigationBar.dart';
import 'package:image_picker/image_picker.dart';
import 'AdminPage/navigatorbarAdmin/NavigationBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white.withOpacity(0)));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC-lUm6MYg7RmzHqsH1EJdyzMSFWu12Uus",
          appId: "1:381417934476:android:09112624413e0a674375a9",
          messagingSenderId: "381417934476",
          projectId: "hayaprojectfinal"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                color: Color(0xFF2C2C2C),
                fontWeight: FontWeight.bold,
                fontFamily: 'UbuntuMED'),
            iconTheme: IconThemeData(color: Color(0xFF2C2C2C))),
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'UbuntuMED',
        textTheme:
            const TextTheme(bodyMedium: TextStyle(color: Color(0xFF2C2C2C))),
      ),
      home: SplashPage(), //MainScreenSpec("")
      //MainScreenAdmin()
      // widgetPage,
      // )
//      SplashPage()
      //IntroHome()
      // MedicalInfo(email: "", password: "", firstName: "", lastName: "", height: "", weight: "", date: "", gender: "", ImageUrl: "")
      //    const IntroHome(),

      // SpeAbout("", "Password", "Imgurl")

//Type=="User"?MainScreenUser(""):Type=="trainer"||Type=="nutritionist"?MainScreenSpec(""):MainScreenSpec(""):MainScreenSpec("")
      // MainScreenSpec("")
      //MainScreenSpec()      //SpeAbout("", "Password", "Imgurl")      //PdfHomePage()
      //eventpageAdmin()
      //View1("Breakfast")
      //test1()
      // MyEvents(),
      //FoodPage()
      // Sign_in(),
      //EMailVerify()
      //home:  type==admin ?MainScreenAdmin :type==user?MainScreenUser:type==spec?MainScreenSpec:introHome
      // isLogin == true ? test() : const log_in(),
      //const IntroHome()
      // SpecEventPage()
      //eventpage()
      //MainScreenAdmin()
    );
  }
}
  //  if (user == null) {
  //       /////////////////
  //       /*    for (int i = 0; i < All.length; i++) {
  //         db
  //             .collection('users')
  //             .doc('uFLtKHEgxxf7CGnu5sUy')
  //             .collection('my specialist')
  //             .doc('btw3B2u6Zy1u3tAJPjfZ')
  //             .collection('myWorkout')
  //             .doc('$i')
  //             .set({
  //           'name': '${All[i].name}',
  //           'subtext': '${All[i].subText}',
  //           'type': '${All[i].typeChar}',
  //           'image': 'asset/Images/Gif/${All[i].name}.gif',
  //           'imgtype': 'as'

  //           // db.collection('workout').doc('$i').set({
  //           //   'name': '${All[i].name}',
  //           //   'subtext': '${All[i].subText}',
  //           //   'type': '${All[i].typeChar}',
  //           //   'image': 'asset/Images/Gif/${All[i].name}.gif',
  //           //   'imgtype': 'as'
  //           // db.collection('foodplan').doc('$i').set({
  //           //   'name': '${allfood[i].name}',
  //           //   'cal': '${allfood[i].cal}',
  //           //   'type': '${allfood[i].type}',
  //           //  'image': 'asset/Images/Gif/${All[i].name}.gif',
  //           // 'imgtype': 'as'
  //         });
  //       }*/
  //       //////////////
  //       print('*****************************User is currently signed out!');
  //     } else {
  //       print('*****************************User is signed in!');
  //     }
  //   });

  //   super.initState();
  // }