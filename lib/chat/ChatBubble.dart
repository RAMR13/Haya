import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String hour;
  final String minute;
  final Color color;
  final Color textColor;
  const ChatBubble(
      {required this.message,
      required this.hour,
      required this.minute,
      required this.color,
      required this.textColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      //width: message.length>30?width*0.7:width*0.3,
      width: message.length > 30 ? width * 0.7 : width * 0.3,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 75, 27, 0).withOpacity(0.3),
                blurRadius: 3,
                offset: Offset(0, 2)),
          ]),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${message}',
              style: TextStyle(
                fontSize: height * 0.019,
                color: textColor,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Text('${hour}:${minute}',
                style: TextStyle(
                  fontSize: height * 0.014,
                  color: textColor,
                  fontFamily: 'UbuntuREG',
                ),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
