import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_demo_firebase/screens/comment_screen.dart';
import 'package:new_demo_firebase/screens/home_screen.dart';
import 'package:new_demo_firebase/screens/login_screen.dart';
import 'package:new_demo_firebase/screens/post_and_desc.dart';
import 'package:new_demo_firebase/screens/registration.dart';
import 'package:new_demo_firebase/screens/splash_screen.dart';

class AppRouter {
  static const String SPLASH = "/";
  static const String HOME_SCREEN = '/homeScreen';
  static const String REGISTER_SCREEN = '/registerScreen';
  static const String LOGIN_SCREEN = '/loginScreen';
  static const String POST_AND_DESC = '/postAndDesc';
  static const String COMMENT_SCREEN = '/commentScreen';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case REGISTER_SCREEN:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case SPLASH:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case LOGIN_SCREEN:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case POST_AND_DESC:
        File file = settings.arguments as File;
        return MaterialPageRoute(builder: (_) => PostAndDesc(imageFile:file));
      case COMMENT_SCREEN:
        List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshot = settings.arguments as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
        return MaterialPageRoute(builder: (_) => CommentScreen(snapshot));
    }
  }
}
