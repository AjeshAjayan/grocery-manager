import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_manager/app/home_theme.dart';
import 'package:grocery_manager/app/models/user_model.dart';
import 'package:grocery_manager/app/shop_details.dart';
import 'package:grocery_manager/app/widgets/shop_card.dart';

class ShopListScreen extends StatefulWidget {
  ShopListScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;

  @override
  _ShopListScreenState createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  Animation<double> yAxisAnimation;
  Animation<double> gridOpacityAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  CollectionReference shopCollection =
      FirebaseFirestore.instance.collection('shop_users');

  TextEditingController shopFilterController = new TextEditingController();
  String shopFilterRegex = '';
  @override
  void initState() {
    shopFilterController.addListener(() {
      setState(() {
        shopFilterRegex = shopFilterController.text;
      });
    });

    yAxisAnimation =
        Tween<double>(begin: 40, end: 0).animate(widget.animationController);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );
    gridOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: widget.animationController,
          curve: Interval(0, 1, curve: Curves.fastOutSlowIn)),
    );

    scrollController.addListener(() {
      print('I m listening');
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeTheme.background,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              getMainGridViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getMainGridViewUI() {
    return AnimatedBuilder(
      animation: widget.animationController,
      child: Padding(
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height +
              MediaQuery.of(context).padding.top,
          bottom: 62 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                decoration: BoxDecoration(
                  color: HomeTheme.nearlyWhite,
                  boxShadow: HomeTheme.boxShadow,
                ),
                child: HomeTheme.buildBlueOutlinedInput(
                  labelText: 'Search shops',
                  textInputType: TextInputType.text,
                  controller: shopFilterController,
                  hintText: 'Eg: Trends, 691302, Thomas Villa',
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: this
                      .shopCollection
                      .where('subAdministrativeArea',
                          isEqualTo: AuthUser.district)
                      .get(),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.done &&
                        snapshots.data.docs.length == 0) {
                      return Stack(
                        children: [
                          Container(
                            child: Center(
                              child: Image(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/app_images/no_shops.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 80,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Text(
                                    'No shops found..!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return GridView.count(
                      controller: scrollController,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      crossAxisCount: 2,
                      children: getShopCards(snapshots),
                    );
                  }),
            ),
          ],
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: gridOpacityAnimation,
          child: Transform(
            transform: Matrix4.translationValues(0, yAxisAnimation.value, 0),
            child: child,
          ),
        );
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: HomeTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color:
                              HomeTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Shops',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: HomeTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: HomeTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  List<Widget> getShopCards(snapshots) {
    List<Widget> shopCards = [];
    String regex = shopFilterRegex.trim().toLowerCase();
    RegExp regExp = new RegExp("$regex");

    final dummyArray = [1, 2, 3, 4];

    // generate shop list
    for (var doc in snapshots.data != null ? snapshots.data.docs : dummyArray) {
      // check filter
      if (regex == '' ||
          regExp.hasMatch(doc.data()['shop_name'].toString().toLowerCase()) ||
          regExp.hasMatch(
              doc.data()['addressLineOne'].toString().toLowerCase()) ||
          regExp.hasMatch(
              doc.data()['addressLineTwo'].toString().toLowerCase()) ||
          regExp.hasMatch(doc.data()['postalCode'].toString().toLowerCase())) {
        shopCards.add(
          InkWell(
            onTap: () {
              // show dialog
              showDialog(
                context: context,
                child: AlertDialog(
                  content: ShopDetails(),
                ),
              );
            },
            splashColor: HomeTheme.primarySplashColor,
            child: ShopCard(
              connectionState: snapshots.connectionState,
              shop: snapshots.connectionState == ConnectionState.done
                  ? doc.data()
                  : '',
            ),
          ),
        );
      }
    }

    return shopCards;
  }
}
