import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../Utils.dart';
import '../notifications/notifications.dart';
import '../provider/my_provider.dart';
import '../firebase_helper/fireBaseHelper.dart';
import '../serverFunctions/server_functions.dart';
import '../helper/constants.dart';
import '../services/database.dart';


class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat({required this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}


class _ChatState extends State<Chat> {

  Stream<QuerySnapshot>? chats;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isRecorderReady = false;
  bool sendChatButton = false;
  bool startVoiceMessage = false;
  final ImagePicker _picker = ImagePicker();
  final recorder = FlutterSoundRecorder();

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
        "email": _auth.currentUser!.email,


      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        _message.text = "";
      });
    }
  }
  Future<void> initRecording() async {
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  void uploadFile(String fileName,String fileType,UploadTask uploadTask, BuildContext context) {
    uploadTask.snapshotEvents.listen((event) {
      uploadingNotification(
          fileType,
          Provider.of<MyProvider>(context,listen: false).peerUserData!["name"],
          event.totalBytes,
          event.bytesTransferred,
          true
      );
    });
    uploadTask.whenComplete(() => {
      uploadingNotification(
          fileType,
          Provider.of<MyProvider>(context,listen: false).peerUserData!["name"],0, 0, false),

      notifyUser(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.displayName,
          "send to you $fileType",
          Provider.of<MyProvider>(context,listen: false).peerUserData!["email"],
          Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email),

      uploadTask.then((fileUrl) {
        fileUrl.ref.getDownloadURL().then((value) {
          FireBaseHelper().sendMessage(
              chatId : Provider.of<MyProvider>(context,listen: false).getChatId(context),
              senderId : Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid,
              sendername : Provider.of<MyProvider>(context,listen: false).sendername,
              receiverId : Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"],
              msgTime : FieldValue.serverTimestamp(),
              msgType : fileType,
              message : value,
              fileName: (fileType =="document")||(fileType =="audio")||(fileType =="voice message")? fileName:""
          );

          FireBaseHelper().updateLastMessage(
              chatId : Provider.of<MyProvider>(context,listen: false).getChatId(context),
              senderId : Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid,
              receiverId : Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"],
              receiverUsername : Provider.of<MyProvider>(context,listen: false).peerUserData!["name"],
              msgTime : FieldValue.serverTimestamp(),
              msgType : fileType,
              message : value,
              context: context
          );
        });
      })
    });
  }
  Future record() async{
    if(!isRecorderReady) return;
    await recorder.startRecorder(toFile: "voice.mp4");
  }

  Future stop() async{
    String voiceMessageName = "${DateTime.now().toString()}.mp4";
    if(!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    UploadTask uploadTask = FireBaseHelper().getRefrenceFromStorage(audioFile,voiceMessageName, context);
    uploadFile(voiceMessageName,"voice message",uploadTask, context);
  }

  void cancelRecord() {
    isRecorderReady = false;
    sendChatButton = false;
    startVoiceMessage = false;
    recorder.closeRecorder();
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

              height: size.height / 1.27,
              width: size.width,
              color: Colors.blue.shade50,

              child: StreamBuilder(
                stream:
                chats,


                builder: (BuildContext context,
                    AsyncSnapshot snapshot) {
                  List<MessageLine> messageWidggets = [];

                  if (snapshot.data != null) {
                    final messages = snapshot.data!.docs.reversed;
                    for (var message in messages) {
                      final messageText = message.get('message');
                      final messageSender = message.get('sendBy');
                       final messageEmailSender = message.get('email');
                      final currentUser = _auth.currentUser?.email;

                      final messageWidget = MessageLine(
                        sender: messageSender,
                        message: messageText,
                        itsme:  currentUser ==  messageEmailSender
                        ,);
                      messageWidggets.add(messageWidget);
                    }
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      children: messageWidggets,
                    ),
                  );
                },
              ),
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
                      padding: const EdgeInsets.only(top: 11),
                      child: TextField(

                        controller: _message,
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
                      onPressed: () async {
                        if (sendChatButton) {
                          //txt message
                          FireBaseHelper().sendMessage(
                              chatId : Provider.of<MyProvider>(context,listen: false).getChatId(context),
                              senderId : Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid,
                              sendername : Provider.of<MyProvider>(context,listen: false).sendername,
                              receiverId : Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"],
                              msgTime : FieldValue.serverTimestamp(),
                              msgType : "text",
                              message : _message.text.toString(),
                              fileName: ""
                          );

                          FireBaseHelper().updateLastMessage(
                              chatId : Provider.of<MyProvider>(context,listen: false).getChatId(context),
                              senderId : Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid,
                              receiverId : Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"],
                              receiverUsername : Provider.of<MyProvider>(context,listen: false).peerUserData!["name"],
                              msgTime : FieldValue.serverTimestamp(),
                              msgType : "text",
                              message : _message.text.toString(),
                              context: context
                          );
                          notifyUser(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.displayName,
                              _message.text.toString(),
                              Provider.of<MyProvider>(context,listen: false).peerUserData!["email"],
                              Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email);
                          _message.clear();
                          setState(() {
                            sendChatButton = false;
                          });
                        }
                        else{
                          final status = await Permission.microphone.request();
                          if(status !=PermissionStatus.granted) {
                            await initRecording();
                            if(recorder.isRecording){
                              await stop();
                              setState(() {
                                startVoiceMessage = false;
                              });
                            }else{
                              await record();
                              setState(() {
                                startVoiceMessage = true;
                              });
                            }
                          }else{
                            buildShowSnackBar(context, "You must enable record permission");
                          }
                          // voice message

                        }
                      },
                      icon: Icon(
                        sendChatButton ? Icons.send :startVoiceMessage==true?Icons.stop:Icons.mic,
                        color: Colors.black,
                      )),

                  // IconButton(
                  //     alignment: Alignment.bottomCenter,
                  //     icon: Icon(Icons.send), onPressed: onSendMessage
                  // ,),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}

class MessageLine extends StatelessWidget {
  const MessageLine({Key? key, this.message, required this.itsme, this.sender}) : super(key: key);

  final String? sender;
  final String? message;
  final bool itsme ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: itsme? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text('$sender'
          //   ,style: TextStyle(fontSize: 12 , color: Colors.yellow[900]),),
          Material(
              elevation: 5,
              borderRadius : itsme? BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)
              )
                  :
              BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)
              ),
              color: itsme? Colors.pink.shade300 : Colors.white,
              child:
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
                child: Text("$message",
                  style: TextStyle(fontSize: 15 , color: itsme? Colors.white : Colors.black54),
                ),
              )
          ),
        ],
      ),
    );
  }


}
