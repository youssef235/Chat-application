

import 'dart:io';
import '../helper/constants.dart';
import '../services/database.dart';
import '../widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat({required this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();



  Widget chatMessages(){
    final Size size = MediaQuery.of(context).size;

    return Container (
      height: size.height /1.36 ,
      width: size.width,


      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData ?
          Expanded(
              child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,

                  itemCount: snapshot.data.docs.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 20),
                  itemBuilder: (context, index){
                    return MessageTile(
                      message: snapshot.data.docs[index].data!()["message"],
                      sendByMe: Constants.myName == snapshot.data.docs[index].data()!["sendBy"],
                    );
                  }
              )

          )
              : Container();
        },
      ),


    );
  }


  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        "time": FieldValue.serverTimestamp(),

      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),backgroundColor: Colors.pink,
        title: Text(
          widget.chatRoomId
              .replaceAll("_", "")
              .replaceAll(Constants.myName, "")
          ,textAlign: TextAlign.start ,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400,color: Colors.white),),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue.shade50,
              height: size.height / 1.27,
              width: size.width,

              child: chatMessages(),

            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black45,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: messageEditingController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.photo),
                          ),
                          hintText: "Send Message",
                          border: InputBorder.none,

                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send), onPressed: addMessage
                  ),
                ],
              ),
            ),

          ],
        ),
      ),

    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});


  @override
  Widget build(BuildContext context) {

    return Container(

      padding: EdgeInsets.only(

          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),

            color: sendByMe ?
            Colors.pink.shade300
                :
            Colors.white

        ),
        child: Text(message,
          textAlign: TextAlign.start,

          style: TextStyle(fontSize: 15 , color: sendByMe? Colors.white : Colors.black54),
        ),
      ),
    );
  }
}
