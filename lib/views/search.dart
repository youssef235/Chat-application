import '../Utils.dart';
import '../screens/ProfilePage.dart';
import '../screens/StrangerProfile.dart';
import '../screens/chat_screen.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import '../widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../provider/my_provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();

}

class _SearchState extends State<Search> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot? searchResultSnapshot;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  QueryDocumentSnapshot<Object?>? peerUserData;




  String Searchename="";

  bool isLoading = false;
  bool haveUserSearched = false;
  String uid ="";




  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
          Searchename = searchEditingController.text;

        });
      });
      searchEditingController.clear();

    }
  }

  Widget userList(){
    return haveUserSearched ? InkWell(

      child: ListView.builder(
          shrinkWrap: true,
          itemCount: searchResultSnapshot?.docs.length,
          itemBuilder: (context, index){
             uid =  searchResultSnapshot?.docs[index].get("userId");

            return userTile(
              searchResultSnapshot?.docs[index].get("name"),
              searchResultSnapshot?.docs[index].get("email"),
            );

          }

          ),

    )
        : Container();

  }




  Widget userTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Card(
        child: Row(
          children: [
            SizedBox(width: 4),

            Icon(Icons.person)
            ,
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  userName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                  ),
                )
              ],
            ),
            Spacer(),

          StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
    return const Text('Something went wrong');
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    }
    return Expanded(
        child: SizedBox(
          height:150.0,
          child:   Column(
            children: [
              SizedBox(height: 25),

              GestureDetector(
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StrangerProfile(uid)
                  ),
                );

        },  child: Container(
                width: 90,
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(24)
          ),
          child: Text("Profile",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),),)
        ),
SizedBox(height: 12),
              GestureDetector(
              onTap: (){

              Provider.of<MyProvider>(context,listen: false)
                  .usersClickListenerr(snapshot, context ,Searchename);

              },  child: Container(
                width: 90,

                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Text("Message",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                  ),),)
         ),
            ],
          ),
          ),
   );
  }

),
          ],
        ),
      ),
    );
  }


  getChatRoomId(String a, String b)
  {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


          appBar: AppBar(
            title: const Text("Search"),
            automaticallyImplyLeading: false,
        ),



      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :  Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color:Colors.white70,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                          hintText: "search username ...",
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.search),// Image.asset("assets/images/search_white.png",
                        //  height: 25, width: 25,)
                      ),
                  )
                ],
              ),
            ),
            userList()
          ],
        ),
      ),
    );
  }
}


