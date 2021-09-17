import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_demo_firebase/app_setup/app_router.dart';
import 'package:new_demo_firebase/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userId = '';
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(size),
    );
  }

  Widget getAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(55),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Firebase Demo',
                style: TextStyle(fontFamily: 'pac', fontSize: 20),
              ),
              //IconButton(splashRadius: 15, icon: Icon(FontAwesome5Brands.facebook_messenger), onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody(size) {
    return ListView(
      children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('post').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: SizedBox.shrink());
              } else {
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text('No Data'),
                  );
                } else {
                  return Column(
                      children: List.generate(snapshot.data.docs.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(colors: bgStoryColors),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.3),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 1, color: bgWhite),
                                              image: DecorationImage(
                                                  image: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance.collection('user').doc(snapshot.data.docs[index].data()['userId']).get(),
                                        builder: (context, snap) {
                                          if (!snap.hasData) {
                                            return SizedBox.shrink();
                                          } else {
                                            if (snap.data == null) {
                                              return Center(
                                                child: SizedBox.shrink(),
                                              );
                                            } else {
                                              return Text(
                                                snap.data.data()['fName'],
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              );
                                            }
                                          }
                                        }),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          isDismissible: true,
                                          enableDrag: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 30), child: postDetailSheet());
                                          });
                                    },
                                    child: Icon(FontAwesome.ellipsis_v, size: 15)),
                              ],
                            ),
                          ),
                          Container(
                            height: 400,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(snapshot.data.docs[index].data()['image']), fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      splashRadius: 15,
                                      icon: true
                                          ? SvgPicture.asset(
                                              "assets/images/heart_red.svg",
                                              width: 25,
                                              height: 25,
                                            )
                                          : SvgPicture.asset(
                                              "assets/images/heart.svg",
                                              width: 25,
                                              height: 25,
                                            ),
                                      onPressed: () {},
                                    ),
                                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection('comment')
                                            .doc(snapshot.data.docs[index].id)
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, snapComment) {
                                          if (!snapComment.hasData) {
                                            return SizedBox.shrink();
                                          } else {
                                            if (snapComment.data.docs.length == 0) {
                                              return Center(
                                                child: SizedBox.shrink(),
                                              );
                                            } else {
                                              return IconButton(
                                                splashRadius: 15,
                                                icon: Icon(FontAwesome.comment_o, size: 25),
                                                onPressed: () {
                                                  Navigator.pushNamed(context, AppRouter.COMMENT_SCREEN,arguments: snapComment.data.docs);
                                                },
                                              );
                                            }
                                          }
                                        }),
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
                                IconButton(icon: Icon(Feather.bookmark), onPressed: () {})
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('comment')
                                        .doc(snapshot.data.docs[index].id)
                                        .collection('comments')
                                        .snapshots(),
                                    builder: (context, snapComment) {
                                      if (!snapComment.hasData) {
                                        return SizedBox.shrink();
                                      } else {
                                        if (snapComment.data.docs.length == 0) {
                                          return Center(
                                            child: SizedBox.shrink(),
                                          );
                                        } else {
                                          return Text(
                                            snapComment.data.docs.length.toString() + ' Comments',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          );
                                        }
                                      }
                                    }),
                                SizedBox(height: 5),
                                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                    future: FirebaseFirestore.instance.collection('user').doc(snapshot.data.docs[index].data()['userId']).get(),
                                    builder: (context, snap) {
                                      if (!snap.hasData) {
                                        return SizedBox.shrink();
                                      } else {
                                        if (snap.data == null) {
                                          return Center(
                                            child: SizedBox.shrink(),
                                          );
                                        } else {
                                          return Text.rich(TextSpan(
                                            children: [
                                              TextSpan(text: '${snap.data.data()['fName']} ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: snapshot.data.docs[index].data()['caption'], style: TextStyle(height: 1.5))
                                            ],
                                          ));
                                        }
                                      }
                                    }),
                                SizedBox(height: 8),
                                // Text(
                                //   newFeeds[index]['comments'],
                                //   style: TextStyle(color: textGrey),
                                // ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: (size.width - 30) * 0.7,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 28,
                                            width: 28,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 1, color: bgGrey),
                                                image: DecorationImage(
                                                    image: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                                                    fit: BoxFit.cover)),
                                          ),
                                          Container(
                                            height: 25,
                                            width: (size.width - 70) * 0.7,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                                              child: TextField(
                                                controller: commentController,
                                                cursorColor: textBlack.withOpacity(0.5),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Add a comment",
                                                    hintStyle: TextStyle(fontSize: 14, color: textBlack.withOpacity(0.5))),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: (size.width - 30) * 0.3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("🥰"),
                                          SizedBox(width: 8),
                                          Text("😎"),
                                          SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              if (commentController.text != '') {
                                                FirebaseFirestore.instance
                                                    .collection('comment')
                                                    .doc(snapshot.data.docs[index].id)
                                                    .collection('comments')
                                                    .doc()
                                                    .set({'userComment': commentController.text, 'userId': userId}).then((value) {
                                                  commentController.text = '';
                                                });
                                              } else {
                                                print('no comments');
                                              }
                                            },
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              size: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'date time',
                                  style: TextStyle(fontSize: 12, color: textGrey),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }));
                }
              }
            }),
      ],
    );
  }

  Widget postDetailSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            rowItems(FontAwesome.link, 'Link'),
            rowItems(FontAwesome.share, 'Share'),
            rowItems(FontAwesome.file, 'Report...'),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                'Hide',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'About This Account',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Unfollow',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowItems(IconData cog, String s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(cog),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(s)
      ],
    );
  }
}
