import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_manager/app/models/user_model.dart';
import 'package:grocery_manager/app/ui_view/area_list_view.dart';
import 'package:grocery_manager/app/ui_view/title_view.dart';
import 'package:grocery_manager/app/widgets/linear_progress_bar.dart';
import 'package:grocery_manager/app/widgets/profile_cards.dart';
import 'package:image_picker/image_picker.dart';

import 'home_theme.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  Future<QuerySnapshot> userQuery = FirebaseFirestore.instance
      .collection('managers')
      .where('uid', isEqualTo: AuthUser.user.uid)
      .get();
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  final imagePicker = ImagePicker();
  NetworkImage proPicProvider;
  Animation<double> _profilePictureAnimation;

  @override
  void initState() {
    this._profilePictureAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        widget.animationController
    );
    updateProPicState(AuthUser.user.photoURL);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
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
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(profilePicture());

    listViews.add(
      FutureBuilder<QuerySnapshot>(
        future: this.userQuery,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // TODO;
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data.docs.first.data();
            return ProfileCard(
              displayText: user['firstname'] + ' ' + user['lastname'],
              animationController: widget.animationController,
            );
          }

          return Container();
        },
      ),
    );

    listViews.add(
      FutureBuilder<QuerySnapshot>(
        future: this.userQuery,
        builder: (BuildContext builder, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // TODO
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data.docs.first.data();
            return ProfileCard(
                displayText: user['address'] + ', ' + user['contctno1'],
              animationController: widget.animationController,
            );
          }
          return Container();
        },
      ),
    );

    listViews.add(
      FutureBuilder<QuerySnapshot>(
        future: this.userQuery,
        builder: (BuildContext builder, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // TODO
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data.docs.first.data();
            return ProfileCard(
              displayText: user['district'] + ', ' + user['postal'].toString(),
              animationController: widget.animationController,
            );
          }
          return Container();
        },
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Reports',
        subTxt: '',
        showForwardArrow: false,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      AreaListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 5, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
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
                          color: HomeTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
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
                                  'Profile',
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

  Widget profilePicture() {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        if (proPicProvider == null) {
          return FadeTransition(
            opacity: _profilePictureAnimation,
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: HomeTheme.nearlyWhite,
                child: InkWell(
                  splashColor: HomeTheme.nearlyDarkBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: selectGalleryOrCamera,
                  child: Image(
                    image: AssetImage('assets/app_images/user.png'),
                  ),
                ),
              ),
            ),
          );
        } else {
          return FadeTransition(
            opacity: _profilePictureAnimation,
            child: Center(
              child: InkWell(
                splashColor: HomeTheme.nearlyDarkBlue,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: selectGalleryOrCamera,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: HomeTheme.nearlyWhite,
                  backgroundImage: proPicProvider,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void updateProPicState(imageUri) {
    if (proPicProvider == null) {
      setState(() {
        proPicProvider = NetworkImage(AuthUser.user.photoURL);
      });
    } else {
      proPicProvider.evict().then((bool success) {
        if (success) {
          print('Image removed');
          setState(() {
            proPicProvider =
                NetworkImage('https://static.toiimg.com/photo/72975551.cms');
          });
        }
      });
    }
  }

  void selectGalleryOrCamera() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  splashColor: HomeTheme.nearlyDarkBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: () async {
                    final imageUri = await getImage(ImageSource.camera);
                    updateProPicState(imageUri);
                  },
                  child: Image(
                    image: AssetImage('assets/app_images/camera.png'),
                  ),
                ),
                InkWell(
                  splashColor: HomeTheme.nearlyDarkBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: () async {
                    try {
                      final imageUri = await getImage(ImageSource.gallery);
                      updateProPicState(imageUri);
                    } catch (e) {
                      print('ERROR $e');
                    }
                  },
                  child: Image(
                    image: AssetImage('assets/app_images/gallery_2.png'),
                  ),
                )
              ],
            ),
          ),
          title: Text('Choose an action'),
        );
      },
    );
  }

  Future getImage(ImageSource source) async {
    try {
      String imageUri;
      LinearProgressBar.show.value = true;

      final pickedImage = await imagePicker.getImage(source: source);
      Navigator.pop(context);
      if (pickedImage != null) {
        // find extension
        RegExp exp = new RegExp(r"[^.]+$");
        String imageExtension = exp.stringMatch(pickedImage.path);

        final FirebaseStorage storage = FirebaseStorage.instance.ref().storage;
        final uploadTask = await storage
            .ref()
            .child('managers/profile_pictures/${AuthUser.user.uid}.$imageExtension')
            .putFile(File(pickedImage.path));
        imageUri = await uploadTask.ref.getDownloadURL();
        await FirebaseAuth.instance.currentUser.updateProfile(
          photoURL: imageUri,
        );
      }
      LinearProgressBar.show.value = false;
      return imageUri;
    } catch (e) {
      LinearProgressBar.show.value = false;
      print('ERROR: $e');
    }
  }
}
