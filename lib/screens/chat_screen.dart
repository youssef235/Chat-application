import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fst_flutter/screens/ProfilePage.dart';
import 'package:provider/provider.dart';
import '../firebase_helper/fireBaseHelper.dart';
import '../helper/BottomNavBar.dart';
import '../provider/my_provider.dart';
import '../serverFunctions/server_functions.dart';
import '../widget/message_compose.dart';
import '../widget/messages_list.dart';
import '../widget/sub_title_app_bar.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'StrangerProfile.dart';



class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver{
  late MyProvider _appProvider;
  bool isdoctor = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkDoctor();
  //  BackButtonInterceptor.add(myInterceptor);
    FireBaseHelper().updateUserStatus("Online",Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid);
    updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, Provider.of<MyProvider>(context,listen: false).peerUserData!["email"]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appProvider = Provider.of<MyProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  // BackButtonInterceptor.remove(myInterceptor);
    FireBaseHelper().updateUserStatus(FieldValue.serverTimestamp(),_appProvider.auth.currentUser!.uid);
    updatePeerDevice(_appProvider.auth.currentUser!.email, "0");
    super.dispose();
  }

void checkDoctor(){

    if(Provider.of<MyProvider>(context,listen: false).peerUserData!["Doctor"] == true)
      {
        setState(() {
          isdoctor = true;
        });
      }


}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state)
    {
      case AppLifecycleState.paused:
        FireBaseHelper().updateUserStatus(FieldValue.serverTimestamp(),Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid);
        updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.inactive:
        FireBaseHelper().updateUserStatus(FieldValue.serverTimestamp(),Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid);
        updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.detached:
        FireBaseHelper().updateUserStatus(FieldValue.serverTimestamp(),Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid);
        updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.resumed:
        FireBaseHelper().updateUserStatus("Online",Provider.of<MyProvider>(context,listen: false).auth.currentUser!.uid);
        updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, Provider.of<MyProvider>(context,listen: false).peerUserData!["email"]);
        break;
    }    super.didChangeAppLifecycleState(state);
  }
  
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  BottomNavBar(0)),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StrangerProfile(Provider.of<MyProvider>(context,listen: false).peerUserData!["userId"])
                    ),
                  );

                },
                child: Text(Provider.of<MyProvider>(context,listen: false).peerUserData!["name"],
                    style: const TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold)),
              ),
               subTitleAppBar(),
            ],
          ),

          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          // ],
        ),
        body:Column(
          children:  [
            Expanded(
              child: Messages(),
            ),
             Visibility(
               visible: !isdoctor ,
                 child: MessagesCompose()
             ),
            Visibility(
                visible: isdoctor ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Card(
                        child: Text("You Cant't Send Messages To Doctors"
                        ,),
                    ),
                    Icon(Icons.lock)

                  ],
                ),
            ),
          SizedBox(height: 7,)

          ],
        )

      ),
    );
  }

}

