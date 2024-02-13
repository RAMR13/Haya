import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaproject/Chat/Message.dart';
import 'package:hayaproject/SharedPrefrences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// SEND MESSAGEs
  Future<void> sendMessage(
      String receiverId, String message, var MyId, var MyEmail) async {
// get current user info
    final String CurrentUserId = MyId;
    // _firebaseAuth.currentUser!.uid;
    final String CurrentUserEmail = MyEmail;
    //_firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    final Timestamp time = Timestamp.now();
// create a new message
    Message newMessage = Message(
        senderId: CurrentUserId,
        senderEmail: CurrentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
        time: time);
// constructer chat room id from current user id and receiver Id(sorted to ensure uniquness)
    List<String> ids = [CurrentUserId, receiverId];
    ids.sort(); // sort the ids (to ensure the chat room id is always the same for any pair)
    String chatRoomId = ids.join(
        "_"); // combine the ids into a single string to use as a chatroomId

// add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

//GET MESSAGES
  Stream<QuerySnapshot<Map<String, dynamic>>> getmessage(
      String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
