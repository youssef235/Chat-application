import 'package:fst_flutter/screens/GroupChatHomeScreen.dart';
import 'package:fst_flutter/views/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helper/BottomNavBar.dart';
import 'notifications/notifications.dart';
import 'provider/my_provider.dart';
import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'userAuthentication/login.dart';
import 'userAuthentication/register.dart';
import 'firebase_options.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name:'fst_flutter',
    options: DefaultFirebaseOptions.currentPlatform,
  );  await notificationInitialization();
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  firebaseMessagingListener();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'start',
          routes: {
            'start': (context) => const SplashScreen(),
            'login': (context) =>const Login(),
            'register': (context) =>const Register(),
            'all_users': (context) =>  BottomNavBar(0),
            'chat': (context) =>  const ChatScreen(),
            'search': (context) =>  BottomNavBar(2),
            'groups': (context) =>  BottomNavBar(1),

          }
      ),
    );
  }
}


// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:fst_flutter/screens/home_screen.dart';
// import 'helper/BottomNavBar.dart';
// import 'helper/authenticate.dart';
// import 'helper/helperfunctions.dart';
// import 'firebase_options.dart';
//
//
//
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//
//     await Firebase.initializeApp(
//       name: 'chat_graduation_project',
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//   runApp(MyApp());
//   WidgetsFlutterBinding.ensureInitialized();
//   WidgetsFlutterBinding.ensureInitialized();
//
//
// }
//
// class MyApp extends StatefulWidget {
//   // This widget is the root of your application.
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late bool userIsLoggedIn = false;
//
//
//   @override
//   void initState() {
//     Firebase.initializeApp();
//     getLoggedInState();
//     super.initState();
//   }
//
//   getLoggedInState() async {
//     await HelperFunctions.getUserLoggedInSharedPreference().then((value){
//       setState(() {
//         userIsLoggedIn  = value!;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//
//       title: 'FlutterChat',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Color(0xff145C9E),
//         scaffoldBackgroundColor: Color(0xff1F1F1F),
//         accentColor: Color(0xff007EF4),
//
//         fontFamily: "OverpassRegular",
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home:
//    6   userIsLoggedIn != null ?  userIsLoggedIn ? Authenticate() :
//       HomeScreen()
//           : Container(
//         child: Center(
//           child: Authenticate(),
//         ),
//       ),
//     );
//   }
// }