import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_manager/app/bottom_bar_view.dart';
import 'package:grocery_manager/app/models/tabIcon_data.dart';
import 'package:grocery_manager/app/models/user_model.dart';
import 'package:grocery_manager/app/my_dairy/dashboard.dart';
import 'package:grocery_manager/app/shop_list_screen.dart';
import 'package:grocery_manager/app/profile_home.dart';
import 'package:grocery_manager/app/widgets/linear_progress_bar.dart';
import '../login.dart';
import 'home_theme.dart';

class AppHomeScreen extends StatefulWidget {
  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: HomeTheme.background,
  );

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        final QuerySnapshot userSnap = await FirebaseFirestore.instance
            .collection('managers')
            .where('uid')
            .get();

        setState(() {
          AuthUser.user = user;
          AuthUser.district = userSnap.docs.first.data()['district']
            .toString();
        });
        print('sign in');
      } else {
        print('sign out');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Login(),
          ),
        );
      }
    });
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = Dashboard(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[tabBody, bottomBar(), LinearProgressBar()],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = Dashboard(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ShopListScreen(
                    animationController: animationController,
                  );
                });
              });
            } else if (index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ShopListScreen(
                    animationController: animationController,
                  );
                });
              });
            } else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ProfileHome(
                    animationController: animationController,
                  );
                });
              });
            }
          },
        ),
      ],
    );
  }
}
