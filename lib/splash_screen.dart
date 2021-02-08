import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intership_task/display_data.dart';
import 'package:flutter_intership_task/screen_transition/page_transition_effect.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  {

  final splashDelay = 8;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
        Navigator.pushReplacement(context, FadeRoute(page: DisplayData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  "assets/gif/splash_screen_gif.gif",
                )
              )
            ],
          ),
        )
    );
  }
}
