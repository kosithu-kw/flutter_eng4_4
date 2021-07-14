
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'home.dart';

void main(){
  runApp(
    MaterialApp(
      title: 'Eng4U',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {

        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => HomeApp(),
      },
    ),
  );
}

class ErrorApp extends StatefulWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  _ErrorAppState createState() => _ErrorAppState();
}

class _ErrorAppState extends State<ErrorApp> {

  bool _isLoading=false;
  String _tryText= "အင်တာနက်ဆက်သွယ်မှုများပြတ်တောက်နေပါသည်";

  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('raw.githubusercontent.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isLoading=false;
          _tryText="အင်တာနက်ဆက်သွယ်မှုများပြတ်တောက်နေပါသည်";
        });
        Navigator.pushNamed(context, '/home');
      }
    } on SocketException catch (_) {
      Timer(Duration(seconds: 3), (){
        setState(() {
          _isLoading=false;
          _tryText="အင်တာနက်ဆက်သွယ်မှုများပြတ်တောက်နေပါသည်";

        });
      });

      //Navigator.pushNamed(context, '/error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Error",
      home: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(_isLoading)
                Container(
                  padding: EdgeInsets.only(left: 100, right: 100, bottom: 30),
                  child: Center(
                    child: LinearProgressIndicator(
                      color: Colors.grey,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
              Container(
                child: Center(
                  child: Text(
                      _tryText
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: TextButton(
                    child: Text("Try Again", style: TextStyle(color: Colors.black),),
                    onPressed: (){
                      setState(() {
                        _isLoading=true;
                        _tryText="ပြန်လည်ချိတ်ဆက်နေသည်...";
                      });
                      checkConnection();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}