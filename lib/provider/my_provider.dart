import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/ProfilePage.dart';
import '../screens/chat_screen.dart';
import '../views/search.dart';

class MyProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  QueryDocumentSnapshot<Object?>? peerUserData;
String groupId = "";
String sendername = "";
  void usersClickListener(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index, BuildContext context){
    FirebaseFirestore.instance
        .collection('users')
        .where('userId',
        isEqualTo: snapshot.data!.docs[index]['userId'].toString())
        .get()
        .then((QuerySnapshot value) {
      peerUserData = value.docs[0];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        ),
      );
    });
    notifyListeners();
  }


  void usersClickListenerr(AsyncSnapshot<QuerySnapshot<Object?>> snapshot,  BuildContext context ,String searchedname){
    FirebaseFirestore.instance.collection('users').where('name' , isEqualTo: searchedname )
        .get()
        .then((QuerySnapshot value) {
      peerUserData = value.docs[0];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        ),
      );
    });
  }


  getUserImage(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index, BuildContext context) async {


    FirebaseFirestore.instance
        .collection('users')
        .where('userId',
        isEqualTo: snapshot.data!.docs[index]['messageReceiverId'].toString())
        .get()
        .then((QuerySnapshot value) {
      peerUserData = value.docs[0];

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const ChatScreen(),
      //   ),
      // );
    });

  }


  void recentChatClickListener(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index, BuildContext context){
    if(snapshot.data!.docs[index]['messageSenderId'].toString() ==
        Provider.of<MyProvider>(context, listen: false).auth.currentUser!.uid){
      FirebaseFirestore.instance
          .collection('users')
          .where('userId',
          isEqualTo: snapshot.data!.docs[index]['messageReceiverId'].toString())
          .get()
          .then((QuerySnapshot value) {
        peerUserData = value.docs[0];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
      });
      notifyListeners();
    }else{
      FirebaseFirestore.instance
          .collection('users')
          .where('userId',
          isEqualTo: snapshot.data!.docs[index]['messageSenderId'].toString())
          .get()
          .then((QuerySnapshot value) {
        peerUserData = value.docs[0];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
      });
      notifyListeners();
    }

  }



  String getChatId(BuildContext context){
    return Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid.hashCode <=
        Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"].hashCode ?
    "${Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid} - ${Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"]}" :
    "${Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"]} - ${Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid}";
  }

  void setGroupId(id){
    groupId = id;
    notifyListeners();
  }




}
