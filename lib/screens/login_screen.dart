import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_demo_firebase/app_setup/app_router.dart';
import 'package:new_demo_firebase/utils/colors.dart';
import 'package:new_demo_firebase/utils/firebase_repository.dart';
import 'package:new_demo_firebase/widgets/common/custom_input_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final firebaseRepository = FirebaseRepository();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(width: 1, color: bgDark.withOpacity(0.1))),
            ),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Dont have an account ? ',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    TextSpan(
                        text: ' Sign up.',
                        style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, AppRouter.REGISTER_SCREEN);
                          }),
                  ],
                ),
              ),
            )),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'English (India)',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildForm()
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Firebase Demo',
              style: TextStyle(fontFamily: 'pac', fontSize: 35),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: emailTextController,
              keyboardType: TextInputType.text,
              decoration: CustomInputDecoration(
                labelText: "Email",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: passwordTextController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: CustomInputDecoration(
                labelText: "Password",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: MaterialButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final result = await InternetAddress.lookup('example.com');
                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                        firebaseRepository.login(email: emailTextController.text, password: passwordTextController.text).then((value) async {
                          print('check' + value.docs.length.toString());
                          try {
                            if (value.docs.length > 0) {
                              setState(() {
                                isLoading = false;
                              });
                              prefs.setBool('status', true);
                              prefs.setString('userId', value.docs[0].id);
                              Navigator.pushReplacementNamed(context, AppRouter.HOME_SCREEN);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } on Exception catch (e) {
                            print('=' + e.toString());
                            setState(() {
                              isLoading = false;
                            });
                          }
                        });
                      }
                    } on SocketException catch (_) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please check your internet connection')));
                    }
                  }
                },
                height: 55,
                minWidth: MediaQuery.of(context).size.width,
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: isLoading
                    ? CupertinoActivityIndicator()
                    : Text(
                        '  Log In  ',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Forgot your login details? ',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  TextSpan(
                      text: 'Get help logging in.',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, AppRouter.REGISTER_SCREEN);
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
