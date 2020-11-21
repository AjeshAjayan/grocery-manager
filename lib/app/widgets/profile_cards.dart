import 'package:flutter/material.dart';
import 'package:grocery_manager/app/home_theme.dart';


class ProfileCard extends StatefulWidget {
  ProfileCard({this.displayText, this.animationController});

  final String displayText;
  final AnimationController animationController;

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Animation<double> _transformAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    this._transformAnimation = Tween<double>(
        begin: 30.0, end: 0.0
    ).animate(widget.animationController);

    this._fadeAnimation = Tween(
      begin: 0.0, end: 1.0
    ).animate(widget.animationController);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 15),
        child: FractionallySizedBox(
          widthFactor: 0.92,
          child: Stack(
            overflow: Overflow.visible,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.nearlyWhite,
                  boxShadow: [
                    BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                height: 60,
                child: Row(
                  children: [
                    Flexible(flex: 1, child: Container()),
                    Flexible(
                      flex: 3,
                      child: Text(
                          widget.displayText,
                          style: FitnessAppTheme.commonTextStyle
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: -5,
                child: Image(
                  height: 100,
                  width: 100,
                  image: AssetImage('assets/app_images/breakfast.png'),
                ),
              ),
            ],
          ),
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: this._fadeAnimation,
          child: Transform(
            transform: Matrix4.translationValues(0, _transformAnimation.value, 0),
            child: child,
          ),
        );
      },
    );
  }
}
