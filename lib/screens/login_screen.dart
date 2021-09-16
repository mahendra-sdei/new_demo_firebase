import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_demo_firebase/app_setup/app_router.dart';
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
        bottomNavigationBar: Container(
            height: 55,
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Dont have an Account ? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                        text: ' Sign up',
                        style: TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.bold),
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
          title: Text(
            'Login',
            style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 60,
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: emailTextController,
              keyboardType: TextInputType.text,
              decoration: CustomInputDecoration(
                labelText: "Email Address",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.pink,
                ),
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
              height: 20,
            ),
            TextFormField(
              controller: passwordTextController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: CustomInputDecoration(
                labelText: "Password",
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.pink,
                ),
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
              height: 40,
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
                height: 35,
                minWidth: 80,
                color: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: isLoading
                    ? CupertinoActivityIndicator()
                    : Text(
                        '  LOGIN  ',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
