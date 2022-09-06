import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fst_flutter/widget/messages_list_Group.dart';
import 'package:flutter/services.dart';
import '../widget/message_compose.dart';
import '../widget/message_compose_group.dart';
import 'GroupInfo.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';


class GroupChatRoom extends StatefulWidget {
  final String groupChatId, groupName;

  GroupChatRoom({required this.groupName, required this.groupChatId, Key? key})
      : super(key: key);

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}



class _GroupChatRoomState extends State<GroupChatRoom> {


  // Future<void> secureScreen() async {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
  //
  // @override
  // void initState() {
  //   secureScreen();
  //   super.initState();
  // }
  //
  // @override
  // Future<void> dispose() async {
  //   super.dispose();
  //   await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
    //    backgroundColor: Colors.pink.shade300,
        title: Text(widget.groupName),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GroupInfo(
                    groupName: widget.groupName,
                    groupId: widget.groupChatId,
                  ),
                ),
              ),
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children:const [
          Expanded(child: MessagesGroup()),
          MessagesComposeGroup()

        ],
      ),
    );
  }
}

