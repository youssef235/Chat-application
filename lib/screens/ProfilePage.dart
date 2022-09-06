import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

import 'edit_password.dart';
import 'edit_profile.dart';



class addimagetoSTORAGE{

  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  String? uid = FirebaseAuth.instance.currentUser?.uid;




  Future<void> uploadimage(
      String filepath,
      String filename
      )async {
    File file = File(filepath);
    try
    {
      TaskSnapshot taskSnapshot =  await storage.ref('test/$filename').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();




      await FirebaseFirestore.instance
          .collection('users').doc(uid)
          .update({"profileimage": downloadUrl});


    } on firebase_core.FirebaseApp catch(e){
      print(e);
    }

  }

}

String uid = FirebaseAuth.instance.currentUser!.uid;

class ProfilePage extends StatefulWidget {


  @override
  MapScreenState createState() => MapScreenState();

}


class MapScreenState extends State<ProfilePage>

    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String? Username = 'Loading ...';
  String? Useremail = 'Loading ...';
  bool IsAdoctor = false;
  String? docORstu = 'Loading ...';
  String? Studepartment = '';
  // bool myprofile = false;


  String? image = 'https://i.imgur.com/sUFH1Aq.png';

  final addimagetoSTORAGE storage = addimagetoSTORAGE();
  var CurrentUserEmail = FirebaseAuth.instance.currentUser!.email;


  @override
  void initState() {
    FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        Username = value.data()!["name"];
        Useremail = value.data()!["email"];
        IsAdoctor = value.data()!["Doctor"];
        Studepartment = value.data()!["StudintT"].toString().replaceAll("Type.", "");

        IsAdoctor? docORstu ="Doctor" : docORstu ="Student : "+Studepartment!;

      });
    });
    getUserdata();

   // getuser();
    super.initState();

  }

// getuser(){
//     String CurrentUserEmail = FirebaseAuth.instance.currentUser!.email.toString();
//    // String? UserEmail = Useremail;
//
//
//
// }


  getUserdata() async {

    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:
       image = data['profileimage'];
      HelperFunctions.saveUserImageSharedPreference(image!);

    }

    }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          automaticallyImplyLeading: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed:(){Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => BottomNavBar(2)));}
          ),
        ),
        body: new Container(
      color: Colors.white,
      child: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
//               new Container(
//                 height: 250.0,
//                 color: Colors.white,
//                 child: new Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.only(top: 20.0),
//                       child: new Stack(fit: StackFit.loose, children: <Widget>[
//                         new Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             // new Container(
//                             //     width: 140.0,
//                             //     height: 140.0,
//                             //     decoration: new BoxDecoration(
//                             //       shape: BoxShape.circle,
//                             //       image: new DecorationImage(
//                             //
//                             //         image: NetworkImage('https://i.imgur.com/sUFH1Aq.png'),
//                             //
//                             //         fit: BoxFit.cover,
//                             //       ),
//                             //     )
//                             // ),
//                           ],
//                         ),
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 90.0, right: 100.0),
// //                             child:  Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: <Widget>[
// //                                  CircleAvatar(
// //                                   backgroundColor: Colors.red,
// //                                   radius: 25.0,
// //                                   child:  IconButton(
// //                                     color: Colors.white,
// //                                     onPressed: () async {
// //
// //                                     //  uploadImage();
// //
// // final result =  await ImagePicker().pickImage(source: ImageSource.gallery,);
// //
// // if(result == null)
// //   {
// //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("No Image Selected")) );
// //     return null;
// //   }
// //
// // final path = result.path;
// // final imagename = result.name;
// //
// // addimagetoSTORAGE();
// //
// // log(path);
// // log(imagename);
// // storage.uploadimage(path, imagename).then((value) => log('Done'));
// //
// //
// //                                     },
// //                                     icon: Icon(Icons.camera_alt),
// //
// //                                   ),
// //                                 ),
// //
// //                               ],
// //                             )),
//                       ]),
//                     )
//                   ],
//                 ),
//               ),
              new Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // Row(
                                  //   children: [
                                  //     new Text(
                                  //       'Parsonal Information',
                                  //       style: TextStyle(
                                  //           fontSize: 18.0,
                                  //           fontWeight: FontWeight.bold),
                                  //     ),
                                  //     IconButton(onPressed: (){
                                  //       Navigator.pushReplacement(context,
                                  //           MaterialPageRoute(builder: (context) => EditProfile()));
                                  //     }, icon: Icon(Icons.edit))
                                  //   ],
                                  // ),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child:  Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                               Flexible(
                                child:  TextField(
                                  decoration:  InputDecoration(

                                    hintText: Username,//getUserName(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.white10),
                                      borderRadius: new BorderRadius.circular(25.7),
                                    ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(25.7),
                            ),


                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,

                                ),
                              ),
                            ],
                          )),
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
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  decoration:  InputDecoration(
                                      hintText:  Useremail
                                    ,),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Scientific standing',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  decoration:  InputDecoration(
                                      hintText: docORstu
                                  ),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          ),
        ),
                           _getActionButtons(),


                      //  !_status ? _getActionButtons() : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child:  Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child:  RaisedButton(
                child:  Text("Edit Your Name"),
                textColor: Colors.white,
                color:  Color(0xFF313246),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Edit Password"),
                textColor: Colors.white,
                color:  Color(0xFF313246),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditPass(),
                    ),
                  );
                  setState(() {
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: Visibility(
        visible: false,
        child: new CircleAvatar(
          backgroundColor: Colors.red,
          radius: 14.0,
          child: new Icon(
            Icons.edit,
            color: Colors.white,
            size: 16.0,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
