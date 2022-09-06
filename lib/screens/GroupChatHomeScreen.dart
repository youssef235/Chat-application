
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/BottomNavBar.dart';
import '../provider/my_provider.dart';
import 'Group/AddMembersInGroup.dart';
import 'GroupChatRoom.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];
  bool isDoctor = false;


  @override
  void initState() {
    super.initState();
    getAvailableGroups();
    loadUserdata();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });

    //
    // _firestore
    //     .collection('users')
    //     .doc(uid)
    //     .get()
    //     .then((value) {
    //   setState(() {
    //   //  isDoctor = value.data()!["Doctor"];
    //     prefs.setBool('isDoctor', value.data()!["Doctor"]);
    //   //  isDoctor = prefs.getBool('isDoctor')!;
    //
    //
    //   });
    // });

  }

  void loadUserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = _auth.currentUser!.uid;

    _firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
           isDoctor = value.data()!["Doctor"];
        //  isDoctor = prefs.getBool('isDoctor')!;
        //  prefs.setBool('isDoctor', isDoctorv);
      });

    //       setState(() {
    //   prefs.setBool('isDoctor', true);
    //   isDoctor = prefs.getBool('isDoctor')!;
    // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
       appBar: AppBar(
         title: const Text("Groups"),
         automaticallyImplyLeading: false,
         actions: [
           Visibility(
             visible: isDoctor,
             child: IconButton(

                 icon: const Icon(Icons.add),
               onPressed: () {
                 Navigator.pushReplacement(context,
                     MaterialPageRoute(builder: (context) => AddMembersInGroup()));
             },
             ),
           ),



         ],
       ),

      body: isLoading
          ? Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: groupList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(


              onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GroupChatRoom(
                            groupName: groupList[index]['name'],
                            groupChatId: groupList[index]['id'],
                          ),
                        ),
                      );
                      Provider.of<MyProvider>(context,listen: false).setGroupId( groupList[index]['id']);

              },
              leading: Icon(Icons.group),
              trailing:IconButton(onPressed:() async {

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Sure delete the group?"),
                    //  content: const Text('AlertDialog description'),
                    actions: <Widget>[
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {

                       _firestore.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("groups")
                          .doc(groupList[index]['id']).delete()
                          .then(

                            (doc) => log("Document deleted"),

                      );
                      setState(() {
                        groupList.removeAt(index);
                      });
                Navigator.pop(context, 'Continue');
                } ,
                            child: const Text('Continue'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ],

                  ),
                );

              },
                  icon: Icon(Icons.delete_forever_outlined)
              ), // for Left

              title: Text(groupList[index]['name'], overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),),
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.create),
      //   onPressed: () => Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) => AddMembersInGroup(),
      //     ),
      //   ),
      //   tooltip: "Create Group",
      // ),
    );
  }
}