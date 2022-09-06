

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../helper/BottomNavBar.dart';
import '../helper/constants.dart';
import '../helper/helperfunctions.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_profile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  String email="";
  final emailEditingController =  TextEditingController();
  final nameEditingController =  TextEditingController();



  Future resetPassword() async {
  try {
     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailEditingController.text.trim());
    // log("Pass Change");
     emailEditingController.clear();
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       content: Text("Check your email inbox to change password"),
     ));
  } on FirebaseAuthException catch (e) {
    log(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("That is not your account email"),
    ));// showError(title: '...', error: e);
  }
}

  Future updateName() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'name': nameEditingController.text.trim()});

      // log("Pass Change");
      nameEditingController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Name Changed successfully"),
      ));
    }  catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));// showError(title: '...', error: e);
    }
  }



  @override
   initState()  {
    super.initState();

    // Add listeners to this class
  }

  @override
  void dispose() {
    emailEditingController.dispose();
    nameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          automaticallyImplyLeading: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed:(){
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => BottomNavBar(3)));
              }
          ),
        ),
        body: new Container(
          color: Colors.white,
          child:  ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Container(

                        color: Color(0xffFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Column(

                                    children: [
                                      Padding(

                                          padding: EdgeInsets.only(
                                              left: 25.0, right: 25.0, top: 25.0),
                                          child:  Row(

                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    'New account name',
                                                    style: TextStyle(
                                                        fontSize: 25.0,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),

                                      Padding(

                                          padding: EdgeInsets.only(
                                              left: 25.0, right: 25.0 , top: 10),
                                          child:  Row(

                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    'Enter your new account name',
                                                    style: TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      SizedBox(height: 35,),
                                      Padding(
                                          padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, ),
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new Flexible(
                                                child: new TextField(
                                                  style:
                                                  new TextStyle(fontSize: 15.0, color: Colors.black),

                                                  controller: nameEditingController,

                                                  decoration: new InputDecoration(
                                                    //          labelText: "Enter email",

                                                    filled: true,
                                                    fillColor: Color(0xFFEAEAEA),
                                                    hintText: 'Name',
                                                    hintStyle: TextStyle(fontSize: 15.0),
                                                    contentPadding: const EdgeInsets.only(
                                                        left: 14.0, bottom: 8.0, top: 8.0),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: new BorderSide(color: Colors.white10),
                                                      borderRadius: new BorderRadius.circular(25.7),
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: new BorderSide(color: Colors.white),
                                                      borderRadius: new BorderRadius.circular(25.7),
                                                    ),
                                                  ),

                                                  //  enabled: !_status,
                                                ),
                                              ),
                                            ],
                                          )),

                                      SizedBox(height: 50,),

                                    ],
                                  ),
                                ),
                              ),



                              //  !_status ? _getActionButtons() : new Container(),
                            ],

                          ),

                        ),

                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,

                children: [
                  Align(
                      alignment: Alignment.bottomRight,
                      child:
                      Padding(

                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(

                          onPressed: () {
                            updateName();
                          },
                          child: const Text("save"
                            ,            style: TextStyle(color: Colors.white, fontSize: 13 , fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50), // NEW
                            primary:  Color(0xFF313246),
                            //     fixedSize: const Size(300, 70),
                            //        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                          ),

                        ),
                      )


                  ),
                ],
              )
            ],

          ),
        ),


    );
  }
}
