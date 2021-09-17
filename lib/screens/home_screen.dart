import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_demo_firebase/screens/account_page.dart';
import 'package:new_demo_firebase/screens/activity_page.dart';
import 'package:new_demo_firebase/screens/dashboard_screen.dart';
import 'package:new_demo_firebase/screens/new_post_page.dart';
import 'package:new_demo_firebase/screens/search_screen.dart';
import 'package:new_demo_firebase/utils/bottom_navigation_bar_json.dart';
import 'package:new_demo_firebase/utils/colors.dart';
import 'package:photo_manager/photo_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: getBody(),
        bottomNavigationBar: getBottomNavigationBar(),
      ),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: indexPage,
      children: [
        DashboardScreen(),
        Gallery(),
        AccountPage(),
      ],
    );
  }

  Widget getBottomNavigationBar() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: bgLightGrey,
        border: Border(top: BorderSide(width: 1, color: bgDark.withOpacity(0.3))),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(icons.length, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    indexPage = index;
                  });
                },
                icon: SvgPicture.asset(
                  indexPage == index
                      ? icons[index]['active']
                      : icons[index]['inactive'],
                  width: 25,
                  height: 25,
                ),
              );
            })
        ),
      ),
    );
  }
}