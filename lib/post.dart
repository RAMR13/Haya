// import 'dart:convert';
// import 'dart:io';
//
// import 'package:provider/provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// class post {
//   var id;
//   var id_user;
//   var post_image;
//   var Des;
//
//   post(this.id, this.id_user, this.post_image, this.Des);
// }
//
// class image {
//   var Image;
//
//   image(this.Image);
// }
//
// class postprov extends ChangeNotifier {
//   List<post> list = [];
//   List<image> listimage = [];
//
//   getimage() async {
//     listimage = [];
//
//     final response = await http.get(
//       Uri.parse("http://192.168.1.135/mahmoud_idea/getimage.php"),
//     );
//
//     if (response.statusCode == 200) {
//       var jsonBody = jsonDecode(response.body);
//       var Images = jsonBody['Images'];
//       for (Map i in Images) {
//         listimage.add(image(i['images']));
//       }
//     }
//     notifyListeners();
//   }
//
//   uploadimage(File? file) async {
//     if (file == null) return;
//
//     String base64 = base64Encode(file.readAsBytesSync());
//     String imagename = file.path.split("/").last;
//
//     var data = {"imagename": imagename, "image64": base64};
//
//     final response = await http.post(
//         Uri.parse("http://192.168.1.135/mahmoud_idea/uploadimages.php"),
//         body: data);
//
//     if (response.statusCode == 200) {
//       jsonDecode(response.body);
//     }
//     getimage();
//     notifyListeners();
//   }
//
//   getItems() async {
//     list = [];
//     final response = await http.get(
//       Uri.parse("http://192.168.1.135/mahmoud_idea/getpostitems.php"),
//     );
//
//     if (response.statusCode == 200) {
//       var jsonBody = jsonDecode(response.body);
//       var Images = jsonBody['Images'];
//       for (Map i in Images) {
//         list.add(post(i['id'], i['id_user'], i['post_image'], i['Des']));
//       }
//     }
//     notifyListeners();
//   }
// }
//
// class test extends StatefulWidget {
//   const test({super.key});
//
//   @override
//   State<test> createState() => _testState();
// }
//
// class _testState extends State<test> {
//   File? _file;
//
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<postprov>(context, listen: false).uploadimage(_file);
//
//     Provider.of<postprov>(context, listen: false).getItems();
//     Provider.of<postprov>(context, listen: false).getimage();
//   }
//
//   Future pickercamera(ImageSource imageSource) async {
//     final myfile = await ImagePicker().pickImage(source: imageSource);
//     setState(() {
//       _file = File(myfile!.path);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Container(
//         height: height * 2,
//         child: ListView(
//           children: [
//             Container(
//                 height: height * 2,
//                 color: Colors.orange,
//                 width: width * 0.8,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: height * 0.1,
//                     ),
//                     Container(
//                       height: height * 0.2,
//                       width: width*0.6,
//                       child: Column(
//                         children: [
//                           Center(
//                             child: _file == null
//                                 ? IconButton(
//                                     onPressed: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return AlertDialog(
//                                             title: const Text("Select"),
//                                             actions: [
//                                               TextButton(
//                                                 onPressed: () {
//                                                   pickercamera(
//                                                       ImageSource.camera);
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: const Text("Camera"),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () {
//                                                   pickercamera(
//                                                       ImageSource.gallery);
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: const Text("Gal"),
//                                               )
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     },
//                                     icon: const Icon(Icons.camera))
//                                 : Container(
//                               height: height*0.1,
//                                   width: width*0.9,
//                                   child: Image.file(
//                                       _file!,
//                                     ),
//                                 ),
//                           ),
//
//
//                           Consumer<postprov>(builder: (context, value, child) {
//                             return TextButton(
//                                 onPressed: () {
//                                   value.uploadimage(_file);
//                                 },
//                                 child: const Text("Image upload"));
//                           }),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.center,
//                       color: Colors.cyan,
//                       height: height * 0.5,
//                       width: width * 0.9,
//                       child:
//                           Consumer<postprov>(builder: (context, value, child) {
//                         return Container(
//                           height: height * 0.4,
//                           width: width * 0.8,
//                           child: ListView.builder(
//                             itemBuilder: (context, index) {
//                               return Image.network(
//                                   value.listimage[index].Image);
//                             },
//                             itemCount: value.listimage.length,
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
