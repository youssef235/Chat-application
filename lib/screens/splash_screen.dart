import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/BottomNavBar.dart';
import '../provider/my_provider.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2),(){
      if(Provider.of<MyProvider>(context,listen: false).auth.currentUser != null){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  BottomNavBar(0)),
        );
      }else{
        Navigator.pushReplacementNamed(
            context, 'login');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/logo.png'),
              SizedBox(height: 5,),
              const Text(
                'HTI Chat',
                style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                    color: Colors.black
                ),
              ),
              const CircularProgressIndicator()
            ],
          ),
        )
      ),
    );
  }
}
