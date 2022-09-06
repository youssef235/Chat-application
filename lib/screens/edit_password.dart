import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helper/BottomNavBar.dart';


class EditPass extends StatefulWidget {
  const EditPass({Key? key}) : super(key: key);

  @override
  State<EditPass> createState() => _EditPassState();
}

class _EditPassState extends State<EditPass> {

  final emailEditingController =  TextEditingController();


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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        automaticallyImplyLeading: true,
        leading:  IconButton(
            icon:  Icon(Icons.arrow_back, color: Colors.white),
            onPressed:(){
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BottomNavBar(3)));
            }
        ),
      ),
      body:  Container(
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
                                                    'Forgot password',
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
                                                    'Enter your email to reset password',
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

                                                  controller: emailEditingController,

                                                  decoration: new InputDecoration(
                                //          labelText: "Enter email",

                                          filled: true,
                                          fillColor: Color(0xFFEAEAEA),
                                          hintText: 'Email',
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
                             resetPassword();
                        },
                        child: const Text("Send"
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
