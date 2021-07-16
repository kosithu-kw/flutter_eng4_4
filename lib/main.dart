
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'error.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'readme.dart';

void main(){
  runApp(
    MaterialApp(
      title: 'Eng4U',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
     // theme: ThemeData(fontFamily: 'uni'),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MainApp(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => HomeApp(),
        '/error' : (context) => ErrorApp(),
        '/readme':(context)=> ReadmeApp(),
      },
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MainApp> {



  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time
        Navigator.pushNamed(context, "/home");
        //print("Not first time");

    } else {// First time
      prefs.setBool('first_time', false);

        checkConnection();
        //print("first time");
    }
  }

  final String _title="Eng 4 U";

  final String _mTitle="သင့်အတွက်အင်္ဂလိပ်စာ";


  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('raw.githubusercontent.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.pushNamed(context, '/home');
      }
    } on SocketException catch (_) {
      Navigator.pushNamed(context, '/error');
    }
  }

  /*
   checkConnection() async{
    var res=await http.get(Uri.https('raw.githubusercontent.com', "kosithu-kw/flutter_mrtl_data/master/townships.json"));
    if(res.statusCode==200){
       Navigator.pushNamed(context, '/home');
    }else{
      print("Error");
    }
  }
     */

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () => startTime());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_title, style: TextStyle(color: Colors.blueAccent, fontSize: 30),),
                SizedBox(height: 10,),

                Text(_mTitle),

                Container(
                  padding: EdgeInsets.only(left: 150, right: 150, top: 150),
                  child: LinearProgressIndicator(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}