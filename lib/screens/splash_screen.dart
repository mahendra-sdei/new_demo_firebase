import 'package:flutter/material.dart';
import 'package:new_demo_firebase/app_setup/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool status;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      checkStatus();
    });
  }

  Future<Null> checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getBool('status');
    if (status ?? false) {
        Navigator.pushReplacementNamed(context, AppRouter.HOME_SCREEN);
      }else{
      Navigator.pushReplacementNamed(context, AppRouter.LOGIN_SCREEN);
    }

    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text('Splash Screen'),
          ),
        ),
      )
    );
  }
}

