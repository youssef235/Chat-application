import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/GroupChatHomeScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../screens/ProfilePage.dart';
import '../screens/home_screen.dart';
import '../views/search.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';


int PageIndex = 0;
class BottomNavBar extends StatefulWidget {
 // const BottomNavBar(int pageIndex,  {Key? key}) : super(key: key);
  BottomNavBar(int pageIndex)
  {

     PageIndex = pageIndex;

  }

  @override
  _BottomNavBarState createState() => _BottomNavBarState();


}


class _BottomNavBarState extends State<BottomNavBar> {

  Future getPageindex()async{

    setState(() {
      PageIndex ;
    } );

    return PageIndex;

  }

  @override
  void initState() {
    PageIndex ;
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  BottomNavBar(0)),
      );    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
  }

class HomePage extends StatefulWidget {
  const HomePage( {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int pageIndex = 0;

  final pages = [
     HomeScreen() ,
     GroupChatHomeScreen(),
     Search(),
     ProfilePage(),

  ];

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: PageIndex,
            height: 60.0,
            items: <Widget>[
              Icon(Icons.chat, size: 30,color: Colors.white),
              Icon(Icons.groups, size: 30,color: Colors.white),
              Icon(Icons.search, size: 30,color: Colors.white),
              Icon(Icons.face, size: 30,color: Colors.white),

            ],
            color: Colors.blueAccent,
            buttonBackgroundColor: Colors.blueAccent,
            backgroundColor: Colors.white,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index) {
              setState(() {
                PageIndex = index;
              });
            },
            letIndexChange: (index) => true,
          ),
          body: pages[PageIndex]

      );
   // );
  }
}

