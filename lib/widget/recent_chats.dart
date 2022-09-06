import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase_helper/fireBaseHelper.dart';
import '../provider/my_provider.dart';
import 'message_tile.dart';

class RecentChats extends StatefulWidget {



 const  RecentChats({Key? key, }) : super(key: key);

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseAuth.i

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: ClipRRect(
        borderRadius:const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0)
        ),
        child: StreamBuilder(
          stream: FireBaseHelper().getLastMessages(
              context,
              Provider.of<MyProvider>(context, listen: false)
                  .auth
                  .currentUser!
                  .uid),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                    return const Text('Something went wrong try again');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
            return snapshot.data!.size == 0?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  const [

                Center(child: Text('No messages start to chat with someone')),
              ],
            ):
            ListView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: (){
                      Provider.of<MyProvider>(context,listen: false).recentChatClickListener(snapshot, index, context);
                    },
                    child: Row(
                      children: [

                        MessageTile(snapshot.data!.docs[index]),
                        IconButton(onPressed:() async {

                          snapshot.data!.docs[index].reference.delete();
                        },
                            icon: Icon(Icons.delete_forever_outlined)
                        ),
                      ],

                    ),

                  );
                }
            );
          },
        )
      ),
    );
  }
}