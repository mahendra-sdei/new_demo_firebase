import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_demo_firebase/app_setup/app_router.dart';
import 'package:new_demo_firebase/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int selectedIndex = 0;

  String userId = '';
  bool _showPreview = false;
  String previewImage = '';

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    print('userId ******** $userId');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(children: [
        Scaffold(
          appBar: getAppBar(),
          body: getBody(size),
        ),
        if (_showPreview) ...[
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              height: double.infinity,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 1, color: bgGrey),
                                    image: DecorationImage(
                                        image: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                  future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox.shrink();
                                    } else {
                                      if (snapshot.data == null) {
                                        return Center(
                                          child: SizedBox.shrink(),
                                        );
                                      } else {
                                        return snapshot.data == null
                                            ? SizedBox.shrink()
                                            : Text(
                                                "${snapshot.data.data()['fName']} ${snapshot.data.data()['lName']}",
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              );
                                      }
                                    }
                                  }),
                            ],
                          )),
                      Image.network(
                        previewImage,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              splashRadius: 15,
                              icon: Icon(FontAwesome.heart_o, size: 25),
                              onPressed: () {},
                            ),
                            IconButton(
                              splashRadius: 15,
                              icon: Icon(FontAwesome.comment_o, size: 25),
                              onPressed: () {},
                            ),
                            IconButton(
                              splashRadius: 15,
                              icon: SvgPicture.asset(
                                "assets/images/share.svg",
                                width: 20,
                                height: 20,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      )
                    ],
                  ),
                )),
          )
        ]
      ]),
    );
  }

  Widget getAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(55),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                } else {
                  if (snapshot.data == null) {
                    return Center(
                      child: SizedBox.shrink(),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lock,
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            snapshot.data == null
                                ? SizedBox.shrink()
                                : Text(
                                    "${snapshot.data.data()['fName']} ${snapshot.data.data()['lName']}",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              splashRadius: 15,
                              icon: Icon(AntDesign.plus),
                              onPressed: () {},
                            ),
                            IconButton(
                              splashRadius: 15,
                              icon: Icon(FontAwesome.bars),
                              onPressed: () {
                                showModalBottomSheet(
                                    isDismissible: true,
                                    enableDrag: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            profileItems(FontAwesome.cog, 'Settings'),
                                            profileItems(FontAwesome.history, 'Archive'),
                                            profileItems(FontAwesome.h_square, 'Your Activity'),
                                            profileItems(FontAwesome.qrcode, 'QR Code'),
                                            profileItems(FontAwesome.bookmark, 'Saved'),
                                            profileItems(FontAwesome.users, 'Close Friends'),
                                            GestureDetector(
                                                onTap: () async {
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  prefs.clear();
                                                  Navigator.pushNamed(context, AppRouter.LOGIN_SCREEN);
                                                },
                                                child: profileItems(FontAwesome.sign_out, 'Logout')),
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }
              }),
        ),
      ),
    );
  }

  Widget getBody(size) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: (size.width - 20) * 0.3,
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: bgGrey),
                              image: DecorationImage(
                                  image: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'), fit: BoxFit.cover)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 25,
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: primary, border: Border.all(width: 1, color: bgWhite)),
                            child: Center(
                              child: Icon(Icons.add, color: bgWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (size.width - 20) * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "61",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Posts",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "117",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Followers",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "173",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Following",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox.shrink();
                    } else {
                      if (snapshot.data == null) {
                        return Center(
                          child: SizedBox.shrink(),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.data()['uName'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(snapshot.data.data()['bio']),
                          ],
                        );
                      }
                    }
                  }),
              SizedBox(height: 15),
              Container(
                height: 35,
                width: (size.width - 20),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: bgGrey),
                  borderRadius: BorderRadius.circular(5),
                  color: bgLightGrey,
                ),
                child: Center(
                  child: Text("Edit Profile"),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Story Highlights", style: TextStyle(fontWeight: FontWeight.bold)), Icon(FontAwesome.angle_down, size: 20)],
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 0.5,
          width: size.width,
          decoration: BoxDecoration(color: bgGrey.withOpacity(0.8)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Container(
                width: (size.width * 0.5),
                child: IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    FontAwesome.th,
                    color: selectedIndex == 0 ? textBlack : textBlack.withOpacity(0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
              ),
              Container(
                width: (size.width * 0.5),
                child: IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    FontAwesome.id_badge,
                    color: selectedIndex == 1 ? textBlack : textBlack.withOpacity(0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Container(
                  height: 1,
                  width: (size.width * 0.5),
                  decoration: BoxDecoration(color: selectedIndex == 0 ? bgDark : Colors.transparent),
                ),
                Container(
                  height: 1,
                  width: (size.width * 0.5),
                  decoration: BoxDecoration(color: selectedIndex == 1 ? bgDark : Colors.transparent),
                ),
              ],
            ),
            Container(
              height: 0.5,
              width: size.width,
              decoration: BoxDecoration(color: bgGrey.withOpacity(0.8)),
            ),
          ],
        ),
        SizedBox(height: 3),
        IndexedStack(
          index: selectedIndex,
          children: [
            getImages(size),
            getImageWithTags(size),
          ],
        ),
      ],
    );
  }

  Widget getImages(size) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('post').where('userId', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text('No Data'),
              );
            } else {
              return Wrap(
                  direction: Axis.horizontal,
                  spacing: 3,
                  runSpacing: 3,
                  children: List.generate(snapshot.data.docs.length, (index) {
                    return GestureDetector(
                      onLongPress: () {
                        previewImage = snapshot.data.docs[index].data()['image'];
                        _showPreview = true;
                        setState(() {});
                      },
                      onLongPressEnd: (details) {
                        _showPreview = false;
                        setState(() {});
                      },
                      child: Container(
                        height: 150,
                        width: (size.width - 6) / 3,
                        decoration:
                            BoxDecoration(image: DecorationImage(image: NetworkImage(snapshot.data.docs[index].data()['image']), fit: BoxFit.cover)),
                      ),
                    );
                  }));
            }
          }
        });
  }

  Widget getImageWithTags(size) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('post').where('userId', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text('No Data'),
              );
            } else {
              return Wrap(
                  children: List.generate(snapshot.data.docs.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onLongPress: () {
                      previewImage = snapshot.data.docs[index].data()['image'];
                      _showPreview = true;
                      setState(() {});
                    },
                    onLongPressEnd: (details) {
                      _showPreview = false;
                      setState(() {});
                    },
                    child: Container(
                      height: size.width,
                      width: size.width,
                      decoration:
                          BoxDecoration(image: DecorationImage(image: NetworkImage(snapshot.data.docs[index].data()['image']), fit: BoxFit.cover)),
                    ),
                  ),
                );
              }));
            }
          }
        });
  }

  Widget profileItems(IconData iconData, String text) {
    return Row(
      children: [IconButton(onPressed: () {}, icon: Icon(iconData)), Text(text)],
    );
  }
}
