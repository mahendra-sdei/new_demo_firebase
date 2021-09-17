import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_demo_firebase/app_setup/app_router.dart';
import 'package:new_demo_firebase/screens/home_screen.dart';
import 'package:new_demo_firebase/utils/firebase_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostAndDesc extends StatefulWidget {
  final File imageFile;
  const PostAndDesc({@required this.imageFile});

  @override
  _PostAndDescState createState() => _PostAndDescState();
}

class _PostAndDescState extends State<PostAndDesc> {
  final firebaseRepository = FirebaseRepository();
  TextEditingController captionController = TextEditingController();
  String userId = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          isLoading
              ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CupertinoActivityIndicator(),
              )
              : IconButton(
                  onPressed: () {
                    isLoading = true;
                    setState(() {});
                    firebaseRepository.uploadImageToStorage(file: widget.imageFile).then((value) {
                      FirebaseFirestore.instance
                          .collection('post')
                          .doc()
                          .set({'image': value, 'caption': captionController.text, 'userId': userId,'createAt':Timestamp.now()}).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context)
                            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
                      });
                    });
                  },
                  icon: Icon(
                    Icons.done,
                    color: Colors.blueAccent,
                  ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Row(
                children: [
                  Container(height: 70, width: 60, color: Colors.black, alignment: Alignment.center, child: Image.file(widget.imageFile)),
                  Expanded(
                    child: TextFormField(
                      controller: captionController,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: 'Write a caption...',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Text(
                'Tag People',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Text(
                'Add Location',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Text(
                'twitter',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Text(
                'Tumblr',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
              child: Text(
                'Advanced Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    setState(() {});
  }
}
