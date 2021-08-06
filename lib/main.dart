import 'package:eng_for_you/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(
      MaterialApp(
        home: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: Splash());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            home: HomeApp(),
          );
        }
      },
    );
  }
}

class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0x204665).withOpacity(1.0),
      body: Center(
          child: Stack(
            children: [
              Center(
                child: DefaultTextStyle(
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText('Eng 4 U'),
                      ],
                      isRepeatingAnimation: true,

                    )
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50, left: 180, right: 180),
                  child: LinearProgressIndicator(
                    color: Colors.amber[600],
                    backgroundColor: Colors.blue,
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(Duration(seconds: 3));
  }
}